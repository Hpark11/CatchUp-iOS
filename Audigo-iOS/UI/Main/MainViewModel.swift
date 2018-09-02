//
//  MainViewModel.swift
//  Audigo-iOS
//
//  Created by hPark on 2018. 8. 4..
//  Copyright © 2018년 BlackBurn. All rights reserved.
//

import RxSwift
import RxDataSources
import Action
import SwiftyContacts
import Apollo

enum SignInState {
  case failed
  case phoneRequired
  case completed
}

typealias PromiseSectionModel = AnimatableSectionModel<String, GetUserWithPromisesQuery.Data.User.Pocket.PromiseList>

protocol MainViewModelInputsType {
  var signInDone: PublishSubject<Void> { get }
  var phoneCertifyDone: PublishSubject<String> { get }
  var monthSelectDone: PublishSubject<(Int, Int)> { get }
  var addPromiseDone: PublishSubject<Void> { get }
  var contactAuthorized: PublishSubject<Bool> { get }
  var hasPromiseBeenUpdated: PublishSubject<Bool> { get }
}

protocol MainViewModelOutputsType {
  var state: Observable<SignInState> { get }
  var promiseItems: Observable<[PromiseSectionModel]> { get }
  var current: Observable<(Int, Int)> { get }
}

protocol MainViewModelActionsType {
  var pushNewPromiseScene: CocoaAction { get }
  var pushPromiseDetailScene: Action<String, Void> { get }
}

protocol MainViewModelType {
  var inputs:  MainViewModelInputsType  { get }
  var outputs: MainViewModelOutputsType { get }
  var actions: MainViewModelActionsType { get }
}

class MainViewModel: MainViewModelType {
  var inputs:  MainViewModelInputsType  { return self }
  var outputs: MainViewModelOutputsType { return self }
  var actions: MainViewModelActionsType { return self }
  
  // MARK: Setup
  fileprivate var sceneCoordinator: SceneCoordinatorType
  
  // MARK: Inputs
  var signInDone: PublishSubject<Void>
  var phoneCertifyDone: PublishSubject<String>
  var monthSelectDone: PublishSubject<(Int, Int)>
  var addPromiseDone: PublishSubject<Void>
  var contactAuthorized: PublishSubject<Bool>
  var hasPromiseBeenUpdated: PublishSubject<Bool>
  
  // MARK: Outputs
  var state: Observable<SignInState>
  var promiseItems: Observable<[PromiseSectionModel]>
  var current: Observable<(Int, Int)>
  
  private var watcher: GraphQLQueryWatcher<GetUserWithPromisesQuery>?
  
  private let userInfo: Variable<(id: String?, phone: String?, email: String?, nickname: String?, gender: String?, birthday: String?, ageRange: String?, profileImagePath: String?)>
  private let promiseList: Variable<[GetUserWithPromisesQuery.Data.User.Pocket.PromiseList]>
  private let filteredList: Variable<[GetUserWithPromisesQuery.Data.User.Pocket.PromiseList]>
  private let currentMonth: Variable<(Int, Int)>
  private let disposeBag = DisposeBag()
  
  init(coordinator: SceneCoordinatorType) {
    let calendar = Calendar(identifier: .gregorian)
    sceneCoordinator = coordinator
    signInDone = PublishSubject()
    phoneCertifyDone = PublishSubject()
    monthSelectDone = PublishSubject()
    addPromiseDone = PublishSubject()
    contactAuthorized = PublishSubject()
    hasPromiseBeenUpdated = PublishSubject()
    
    userInfo = Variable((id: nil, phone: nil, email: nil, nickname: nil, gender: nil, birthday: nil, ageRange: nil, profileImagePath: nil))
    promiseList = Variable([])
    filteredList = Variable([])
    currentMonth = Variable((calendar.component(.month, from: Date()), calendar.component(.year, from: Date())))
    
    state = userInfo.asObservable().map({ userInfo in
      guard let _ = userInfo.id else { return .failed }
      guard let _ = userInfo.phone else { return .phoneRequired }
      return .completed
    })
    
    promiseItems = filteredList.asObservable()
      .map({ (promiseList) in
        return [PromiseSectionModel(model: "", items: promiseList)]
      })
    
    current = currentMonth.asObservable()
    
    // Inputs
    signInDone.subscribe(onNext: { [weak self]  _ in
      guard let strongSelf = self else { return }
      strongSelf.getUserInfoFromKakaoSDK()
    }).disposed(by: disposeBag)
    
    phoneCertifyDone.subscribe(onNext: { [weak self] (phone) in
      guard let strongSelf = self else { return }
      var userInfoValue = strongSelf.userInfo.value
      userInfoValue.phone = phone
      strongSelf.userInfo.value = userInfoValue
    }).disposed(by: disposeBag)
    
    monthSelectDone.subscribe(onNext: { [weak self] (month, year) in
      guard let strongSelf = self else { return }
      strongSelf.filterPromisesByMonth(month: month, year: year)
      strongSelf.currentMonth.value = (month, year)
    }).disposed(by: disposeBag)
    
    addPromiseDone.subscribe(onNext: { [weak self] _ in
      guard let strongSelf = self else { return }
      strongSelf.watcher?.refetch()
    }).disposed(by: disposeBag)
    
    hasPromiseBeenUpdated.subscribe(onNext: { [weak self] hasUpdated in
      guard let strongSelf = self else { return }
      strongSelf.watcher?.refetch()
    }).disposed(by: disposeBag)
    
    contactAuthorized.subscribe(onNext: { [weak self] authorized in
      guard let strongSelf = self, authorized else { return }
      LocationTrackingService.shared.startUpdatingLocation()
      
      let backgroundScheduler = SerialDispatchQueueScheduler(qos: .default)
      
      rx_fetchContacts().map({ contacts in
        return contacts.compactMap {
          ($0.phoneNumbers.first?.value.stringValue ?? "", "\($0.familyName)\($0.givenName)")
        }
      }).subscribeOn(backgroundScheduler)
        .observeOn(MainScheduler.instance)
        .subscribe(onNext: { (contacts) in
          contacts.forEach { contact in
            if contact.0.starts(with: "010") {
              let phone = contact.0
                .components(separatedBy:CharacterSet.decimalDigits.inverted)
                .joined(separator: "")
              
              let nickname = contact.1
              
              apollo.fetch(query: GetPocketQuery(phone: phone)) { result, error in
                guard error != nil else {
                  ContactItem.create(phone, nickname: nickname)
                  return
                }
                
                if let pocket = result?.data?.pocket {
                  ContactItem.create(pocket.phone, nickname: pocket.nickname ?? "", imagePath: pocket.profileImagePath ?? "", pushToken: pocket.pushToken ?? "")
                }
              }
            }
          }
        }).disposed(by: strongSelf.disposeBag)
    }).disposed(by: disposeBag)
  }
  
  private func getUserInfoFromKakaoSDK() {
    KOSessionTask.userMeTask(completion: { [unowned self] (error, me) in
      if let error = error {
        fatalError(error.localizedDescription)
      }
      
      let gender: String?
      let ageRange: String?
      let phoneNumber: String?
      
      if let genderCode = me?.account?.gender {
        switch genderCode {
        case .female:
          gender = "여성"
        case .male:
          gender = "남성"
        default:
          gender = nil
        }
      } else {
        gender = nil
      }
      
      if let ageCode = me?.account?.ageRange {
        switch ageCode {
        case .type15:
          ageRange = "15세 ~ 19세"
        case .type20:
          ageRange = "20세 ~ 29세"
        case .type30:
          ageRange = "30세 ~ 39세"
        case .type40:
          ageRange = "40세 ~ 49세"
        case .type50:
          ageRange = "50세 ~ 59세"
        case .type60:
          ageRange = "60세 ~ 69세"
        case .type70:
          ageRange = "70세 ~ 79세"
        case .type80:
          ageRange = "80세 ~ 89세"
        case .type90:
          ageRange = "90세 이상"
        default:
          ageRange = nil
        }
      } else {
        ageRange = nil
      }
      
      if let number = UserDefaults.standard.string(forKey: "phoneNumber") {
        phoneNumber = number
      } else if let number = me?.account?.phoneNumber {
        phoneNumber = number
      } else {
        phoneNumber = "01074372330"
        UserDefaults.standard.set(phoneNumber, forKey: "phoneNumber")
        UserDefaults.standard.synchronize()
      }
      
      self.userInfo.value = (
        id: me?.id,
        phone: phoneNumber,
        email: me?.account?.email,
        nickname: me?.nickname,
        birthday: me?.account?.birthday,
        profileImagePath: me?.profileImageURL?.absoluteString,
        gender: gender,
        ageRange: ageRange
      )
    })
  }
  
  private func filterPromisesByMonth(month: Int, year: Int) {
    let calendar = Calendar(identifier:  .gregorian)
    if let start = calendar.date(from: DateComponents(year: year, month: month, day: 1)), let end = calendar.date(byAdding: .month, value: 1, to: start) {
      filteredList.value = promiseList.value.filter {
        let timeInMillis = (UInt64($0.timestamp ?? "0") ?? 0)
        return timeInMillis >= start.timeInMillis && timeInMillis < end.timeInMillis
      }
    }
  }
  
  func configureUser() {
    let info = userInfo.value
    guard let id = info.id, let phone = info.phone else { return }
    
    apollo.perform(mutation: UpsertUserMutation(id: id, email: info.email, nickname: info.nickname, gender: info.gender, birthday: info.birthday, ageRange: info.ageRange, profileImagePath: info.profileImagePath, phone: phone)) { [weak self] (result, error) in
      guard let strongSelf = self else { return }
      
      if let error = error {
        NSLog("Error while attempting to UpsertUserMutation: \(error.localizedDescription)")
      }
      
      strongSelf.watcher = apollo.watch(query: GetUserWithPromisesQuery(id: id), resultHandler: { (result, error) in
        if let error = error {
          NSLog("Error while GetUserWithPromisesQuery: \(error.localizedDescription)")
          return
        }
        
        if let list = result?.data?.user?.pocket.promiseList {
          let now = Date().timeInMillis
          
          strongSelf.promiseList.value = list.compactMap { $0 }.sorted {
            let lhs = UInt64($0.timestamp ?? "") ?? Date().timeInMillis
            let rhs = UInt64($1.timestamp ?? "") ?? Date().timeInMillis
            return (lhs > now ? lhs : lhs * 2) < (rhs > now ? rhs : rhs * 2)
          }
          strongSelf.promiseList.value.forEach {
            print($0.id)
          }
          
          let current = strongSelf.currentMonth.value
          strongSelf.filterPromisesByMonth(month: current.0, year: current.1)
        }
      })
    }
  }
  
  lazy var pushNewPromiseScene: CocoaAction = {
    return Action { [weak self] in
      guard let strongSelf = self else { return .empty() }
      let viewModel = NewPromiseViewModel(coordinator: strongSelf.sceneCoordinator, ownerPhoneNumber: strongSelf.userInfo.value.phone ?? "")
      viewModel.addPromiseDone = strongSelf.addPromiseDone
      let scene = NewPromiseScene(viewModel: viewModel)
      return strongSelf.sceneCoordinator.transition(to: scene, type: .modal(animated: true))
    }
  }()
  
  lazy var pushPromiseDetailScene: Action<String, Void> = {
    return Action { [weak self] promiseId in
      guard let strongSelf = self else { return .empty() }
      let viewModel = PromiseDetailViewModel(coordinator: strongSelf.sceneCoordinator, promiseId: promiseId)
      viewModel.hasPromiseBeenUpdated = strongSelf.hasPromiseBeenUpdated
      let scene = PromiseDetailScene(viewModel: viewModel)
      return strongSelf.sceneCoordinator.transition(to: scene, type: .push(animated: true))
    }
  }()
}

extension MainViewModel: MainViewModelInputsType, MainViewModelOutputsType, MainViewModelActionsType {}

extension GetUserWithPromisesQuery.Data.User.Pocket.PromiseList: IdentifiableType, Equatable {
  public var identity: String {
    return id!
  }
  
  public static func ==(lhs: GetUserWithPromisesQuery.Data.User.Pocket.PromiseList,
                        rhs: GetUserWithPromisesQuery.Data.User.Pocket.PromiseList) -> Bool {
    return lhs.id == rhs.id
  }
}
