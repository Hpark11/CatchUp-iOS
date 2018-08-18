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

enum SignInState {
  case failed
  case phoneRequired
  case completed
}

typealias PromiseSectionModel = AnimatableSectionModel<String, GetUserWithPromisesQuery.Data.User.Pocket.PromiseList>

extension GetUserWithPromisesQuery.Data.User.Pocket.PromiseList: IdentifiableType, Equatable {
  public var identity: String {
    return id!
  }
  
  public static func ==(lhs: GetUserWithPromisesQuery.Data.User.Pocket.PromiseList,
                        rhs: GetUserWithPromisesQuery.Data.User.Pocket.PromiseList) -> Bool {
    return lhs.id == rhs.id
  }
}

protocol MainViewModelInputsType {
  var signInDone: PublishSubject<Void> { get }
  var phoneCertifyDone: PublishSubject<String> { get }
}

protocol MainViewModelOutputsType {
  var state: Observable<SignInState> { get }
  var promiseItems: Observable<[PromiseSectionModel]> { get }
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
  
  // MARK: Outputs
  var state: Observable<SignInState>
  var promiseItems: Observable<[PromiseSectionModel]>
  
  private let userInfo: Variable<(id: String?, phone: String?, email: String?, nickname: String?, gender: String?, birthday: String?, ageRange: String?, profileImagePath: String?)>
  private let promiseList: Variable<[GetUserWithPromisesQuery.Data.User.Pocket.PromiseList]>
  private let disposeBag = DisposeBag()
  
  init(coordinator: SceneCoordinatorType) {
    
    sceneCoordinator = coordinator
    signInDone = PublishSubject()
    phoneCertifyDone = PublishSubject()
    
    userInfo = Variable((id: nil, phone: nil, email: nil, nickname: nil, gender: nil, birthday: nil, ageRange: nil, profileImagePath: nil))
    promiseList = Variable([])
    
    state = userInfo.asObservable().map({ userInfo in
      guard let _ = userInfo.id else { return .failed }
      guard let _ = userInfo.phone else { return .phoneRequired }
      return .completed
    }).share(replay: 1, scope: .whileConnected)
    
    promiseItems = promiseList.asObservable()
      .map({ (promiseList) in
        return [PromiseSectionModel(model: "", items: promiseList)]
      })
    
    // Inputs
    signInDone.subscribe(onNext: { _ in
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
          phoneNumber = nil
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
    }).disposed(by: disposeBag)
    
    phoneCertifyDone.subscribe(onNext: { [weak self] (phone) in
      guard let strongSelf = self else { return }
      var userInfoValue = strongSelf.userInfo.value
      userInfoValue.phone = phone
      strongSelf.userInfo.value = userInfoValue
    }).disposed(by: disposeBag)
  }
  
  func configureUser() {
    let info = userInfo.value
    guard let id = info.id, let phone = info.phone else { return }
    
    apollo.perform(mutation: UpsertUserMutation(id: id, email: info.email, nickname: info.nickname, gender: info.gender, birthday: info.birthday, ageRange: info.ageRange, profileImagePath: info.profileImagePath, phone: phone)) { (result, error) in
      if let error = error {
        NSLog("Error while attempting to UpsertUserMutation: \(error.localizedDescription)")
      }
      
      _ = apollo.watch(query: GetUserWithPromisesQuery(id: id), resultHandler: { (result, error) in
        if let error = error {
          NSLog("Error while GetUserWithPromisesQuery: \(error.localizedDescription)")
          return
        }
        
        if let list = result?.data?.user?.pocket.promiseList {
          self.promiseList.value = list.compactMap { $0 }
        }
      })
    }
  }
  
  lazy var pushNewPromiseScene: CocoaAction = {
    return Action { [weak self] in
      guard let strongSelf = self else { return .empty() }
      let viewModel = NewPromiseViewModel(coordinator: strongSelf.sceneCoordinator)
      let scene = NewPromiseScene(viewModel: viewModel)
      return strongSelf.sceneCoordinator.transition(to: scene, type: .modal(animated: false))
    }
  }()
  
  lazy var pushPromiseDetailScene: Action<String, Void> = {
    return Action { [weak self] promiseId in
      guard let strongSelf = self else { return .empty() }
      let viewModel = PromiseDetailViewModel(coordinator: strongSelf.sceneCoordinator, promiseId: promiseId)
      let scene = PromiseDetailScene(viewModel: viewModel)
      return strongSelf.sceneCoordinator.transition(to: scene, type: .push(animated: true))
    }
  }()
}

extension MainViewModel: MainViewModelInputsType, MainViewModelOutputsType, MainViewModelActionsType {}
