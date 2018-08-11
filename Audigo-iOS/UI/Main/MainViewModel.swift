//
//  MainViewModel.swift
//  Audigo-iOS
//
//  Created by hPark on 2018. 8. 4..
//  Copyright © 2018년 BlackBurn. All rights reserved.
//

//import Foundation
import RxSwift
import Action
//import Apollo

enum SignInState {
  case failed
  case completed
  case phoneRequired
}

protocol MainViewModelInputsType {
  var signInDone: PublishSubject<Void> { get }
}

protocol MainViewModelOutputsType {
  var state: Observable<SignInState> { get }
}

protocol MainViewModelActionsType {
  // Mainly `Actions` here
}

protocol MainViewModelType {
  var inputs:  MainViewModelInputsType  { get }
  var outputs: MainViewModelOutputsType { get }
  var actions: MainViewModelActionsType { get }
}

class MainViewModel: BaseViewModel, MainViewModelType {
  var inputs:  MainViewModelInputsType  { return self }
  var outputs: MainViewModelOutputsType { return self }
  var actions: MainViewModelActionsType { return self }
  
  // MARK: Setup
  fileprivate var sceneCoordinator: SceneCoordinatorType
  
  // MARK: Inputs
  var signInDone: PublishSubject<Void>

  // MARK: Outputs
  var state: Observable<SignInState>
  
  private let userId: Variable<String?>
  private let phone: Variable<String?>
  private let email: Variable<String?>
  private let nickname: Variable<String?>
  private let gender: Variable<String?>
  private let birthday: Variable<String?>
  private let ageRange: Variable<String?>
  private let profileImagePath: Variable<String?>
  
  init(coordinator: SceneCoordinatorType) {
    // Setup
    sceneCoordinator = coordinator
    signInDone = PublishSubject()
    
    userId = Variable(nil)
    phone = Variable(nil)
    email = Variable(nil)
    nickname = Variable(nil)
    gender = Variable(nil)
    birthday = Variable(nil)
    ageRange = Variable(nil)
    profileImagePath = Variable(nil)
  
    state = Observable.combineLatest(
      userId.asObservable(),
      phone.asObservable(),
      email.asObservable(),
      nickname.asObservable(),
      gender.asObservable(),
      birthday.asObservable(),
      ageRange.asObservable(),
      profileImagePath.asObservable()
//      resultSelector: { (userId, phone, email, nickname, gender, birthday, ageRange, profileImagePath) in
//        return (userId, phone, email, nickname, gender, birthday, ageRange, profileImagePath)
//      }
      ).map({ (id, phone, email, nickname, gender, birthday, ageRange, profileImagePath) in
        guard let id = id else { return .failed }
        guard let phone = phone else { return .phoneRequired }
        
        apollo.perform(mutation: UpsertUserMutation(id: id, email: email, nickname: nickname, gender: gender, birthday: birthday, ageRange: ageRange, profileImagePath: profileImagePath, phone: phone)) { (result, error) in
          if let error = error {
            NSLog("Error while attempting to UpsertUserMutation: \(error.localizedDescription)")
          }
        }
        
        return .completed
      }).share()
    
    super.init()
    
    // Inputs
    signInDone.subscribe(onNext: { _ in
      KOSessionTask.userMeTask(completion: { [unowned self] (error, me) in
        if let error = error {
          fatalError(error.localizedDescription)
        }

        self.userId.value = me?.id
        self.phone.value = me?.account?.phoneNumber
        self.email.value = me?.account?.email
        self.nickname.value = me?.nickname
        self.birthday.value = me?.account?.birthday
        self.profileImagePath.value = me?.profileImageURL?.absoluteString
        
        if let genderCode = me?.account?.gender {
          switch genderCode {
          case .female:
            self.gender.value = "여성"
          case .male:
            self.gender.value = "남성"
          default:
            break
          }
        }
        
        if let ageCode = me?.account?.ageRange {
          switch ageCode {
          case .type15:
            self.ageRange.value = "15세 ~ 19세"
          case .type20:
            self.ageRange.value = "20세 ~ 29세"
          case .type30:
            self.ageRange.value = "30세 ~ 39세"
          case .type40:
            self.ageRange.value = "40세 ~ 49세"
          case .type50:
            self.ageRange.value = "50세 ~ 59세"
          case .type60:
            self.ageRange.value = "60세 ~ 69세"
          case .type70:
            self.ageRange.value = "70세 ~ 79세"
          case .type80:
            self.ageRange.value = "80세 ~ 89세"
          case .type90:
            self.ageRange.value = "90세 이상"
          default:
            break
          }
        }
      })
    })
    .disposed(by: disposeBag)
    
    // Outputs
    
    // ViewModel Life Cycle
  }
  
//  public func configureViewControllers() -> [UIViewController] {
//    let titles = ["홈", "커뮤니티", "히어로 분석", "더보기"]
//    let imageNames = ["", "", "", "", ""]
//
//    let viewControllers = [
//      HomeScene(viewModel: HomeViewModel(coordinator: sceneCoordinator)).instantiateFromStoryboard(),
//      CommunityScene(viewModel: CommunityViewModel(coordinator: sceneCoordinator)).instantiateFromNIB(),
//      ChampionsScene(viewModel: ChampionsViewModel(coordinator: sceneCoordinator)).instantiateFromNIB(),
//      MoreScene(viewModel: MoreViewModel(coordinator: sceneCoordinator)).instantiateFromNIB(),
//      ]
//
//    return viewControllers.enumerated().map { offset, element in
//      element.title = titles[offset]
//      element.tabBarItem.image = UIImage(named: imageNames[offset])
//      return element
//    }
//  }
  
  // MARK: Actions
}

extension MainViewModel: MainViewModelInputsType, MainViewModelOutputsType, MainViewModelActionsType {}
