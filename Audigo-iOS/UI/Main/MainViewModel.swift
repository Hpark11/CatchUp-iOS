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
import AWSAppSync

typealias PromiseSectionModel = AnimatableSectionModel<String, GetUserWithPromisesQuery.Data.User.Pocket.PromiseList>

protocol MainViewModelInputsType {
  var monthSelectDone: PublishSubject<(Int, Int)> { get }
  var addPromiseDone: PublishSubject<Void> { get }
  var hasPromiseBeenUpdated: PublishSubject<Bool> { get }
}

protocol MainViewModelOutputsType {
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
  fileprivate let apiClient: AWSAppSyncClient
  fileprivate let disposeBag = DisposeBag()
  
  // MARK: Inputs
  var monthSelectDone: PublishSubject<(Int, Int)>
  var addPromiseDone: PublishSubject<Void>
  var hasPromiseBeenUpdated: PublishSubject<Bool>
  
  // MARK: Outputs
  var promiseItems: Observable<[PromiseSectionModel]>
  var current: Observable<(Int, Int)>
  
  private let userInfo: Variable<(id: String?, phone: String?, email: String?, nickname: String?, gender: String?, birthday: String?, ageRange: String?, profileImagePath: String?)>
  private let promiseList: Variable<[GetUserWithPromisesQuery.Data.User.Pocket.PromiseList]>
  private let filteredList: Variable<[GetUserWithPromisesQuery.Data.User.Pocket.PromiseList]>
  private let currentMonth: Variable<(Int, Int)>
  
  var phone: String = ""
  
  init(coordinator: SceneCoordinatorType, client: AWSAppSyncClient) {
    let calendar = Calendar(identifier: .gregorian)
    sceneCoordinator = coordinator
    apiClient = client
    
    monthSelectDone = PublishSubject()
    addPromiseDone = PublishSubject()
    hasPromiseBeenUpdated = PublishSubject()
    
    userInfo = Variable((id: nil, phone: nil, email: nil, nickname: nil, gender: nil, birthday: nil, ageRange: nil, profileImagePath: nil))
    promiseList = Variable([])
    filteredList = Variable([])
    currentMonth = Variable((calendar.component(.month, from: Date()), calendar.component(.year, from: Date())))
    
    promiseItems = filteredList.asObservable()
      .map({ (promiseList) in
        return [PromiseSectionModel(model: "", items: promiseList)]
      })
    
    current = currentMonth.asObservable()
    
    // Inputs
    monthSelectDone.subscribe(onNext: { [weak self] (month, year) in
      guard let strongSelf = self else { return }
      strongSelf.filterPromisesByMonth(month: month, year: year)
      strongSelf.currentMonth.value = (month, year)
    }).disposed(by: disposeBag)
    
    addPromiseDone.subscribe(onNext: { [weak self] _ in
      guard let strongSelf = self else { return }
//      strongSelf.watcher?.refetch()
    }).disposed(by: disposeBag)
    
    hasPromiseBeenUpdated.subscribe(onNext: { [weak self] hasUpdated in
      guard let strongSelf = self else { return }
//      strongSelf.watcher?.refetch()
    }).disposed(by: disposeBag)
    
    // Location Tracking ---------------------------------------------------------------------------------------]
    LocationTrackingService.shared.startUpdatingLocation()
    
    // Contact Update ------------------------------------------------------------------------------------------]
    let backgroundScheduler = SerialDispatchQueueScheduler(qos: .default)
    rx_fetchContacts().map({ contacts in
      return contacts.compactMap {
        ($0.phoneNumbers.first?.value.stringValue ?? "", "\($0.familyName)\($0.givenName)")
      }
    }).subscribeOn(backgroundScheduler)
      .map { contacts in
        return contacts.filter { contact in
          return contact.0.starts(with: Define.koreanNormalCellPhonePrefix)
        }.map { contact in
          return (
            contact.0.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: ""),
            contact.1
          )
        }
        
      }.do(onNext: { contacts in
        contacts.forEach { (phone, nickname) in
          ContactItem.add(phone, nickname: nickname)
        }
        
      }).flatMap({ contacts -> Observable<BatchGetCatchUpContactsQuery.Data> in
        let ops = contacts.map { contact in
          return contact.0
        }.chunked(into: Define.dynamoDbBatchLimit).compactMap({ chunk in
          return client.rx.fetch(query: BatchGetCatchUpContactsQuery(ids: chunk)).asObservable()
        })
  
        return Observable.merge(ops)
      })
      .observeOn(MainScheduler.instance)
      .subscribe{ (data) in
        if let contacts = data.element?.batchGetCatchUpContacts {
          contacts.forEach { contactData in
            if let contact = contactData {
              ContactItem.create(contact.phone, imagePath: contact.profileImagePath ?? "", pushToken: contact.pushToken ?? "")
            }
          }
        }
      }.disposed(by: disposeBag)
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
    
    apollo?.perform(mutation: UpsertUserMutation(id: id, email: info.email, nickname: info.nickname, gender: info.gender, birthday: info.birthday, ageRange: info.ageRange, profileImagePath: info.profileImagePath, phone: phone)) { [weak self] (result, error) in
      guard let strongSelf = self else { return }
      
      if let error = error {
        NSLog("Error while attempting to UpsertUserMutation: \(error.localizedDescription)")
      }
      
      apollo?.fetch(query: GetUserWithPromisesQuery(id: id), resultHandler: { (result, error) in
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
          
          let current = strongSelf.currentMonth.value
          strongSelf.filterPromisesByMonth(month: current.0, year: current.1)
        }
      })
    }
  }
  
  lazy var pushNewPromiseScene: CocoaAction = {
    return Action { [weak self] in
      guard let strongSelf = self else { return .empty() }
      
      let viewModel = NewPromiseViewModel(
        coordinator: strongSelf.sceneCoordinator, client: strongSelf.apiClient,
        ownerPhoneNumber: strongSelf.userInfo.value.phone ?? ""
      )
      
      viewModel.addPromiseDone = strongSelf.addPromiseDone
      let scene = NewPromiseScene(viewModel: viewModel)
      return strongSelf.sceneCoordinator.transition(to: scene, type: .modal(animated: true))
    }
  }()
  
  lazy var pushPromiseDetailScene: Action<String, Void> = {
    return Action { [weak self] promiseId in
      guard let strongSelf = self else { return .empty() }
      let viewModel = PromiseDetailViewModel(coordinator: strongSelf.sceneCoordinator, client: strongSelf.apiClient, promiseId: promiseId)
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
