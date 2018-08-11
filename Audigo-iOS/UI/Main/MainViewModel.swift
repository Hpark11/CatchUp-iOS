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
  var phoneCertifyDone: PublishSubject<String> { get }
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
  var phoneCertifyDone: PublishSubject<String>

  // MARK: Outputs
  var state: Observable<SignInState>
  
  private let userInfo: Variable<(id: String?, phone: String?, email: String?, nickname: String?, gender: String?, birthday: String?, ageRange: String?, profileImagePath: String?)>
  
  init(coordinator: SceneCoordinatorType) {
    // Setup
    sceneCoordinator = coordinator
    signInDone = PublishSubject()
    phoneCertifyDone = PublishSubject()
    
    userInfo = Variable((id: nil, phone: nil, email: nil, nickname: nil, gender: nil, birthday: nil, ageRange: nil, profileImagePath: nil))
  
    state = userInfo.asObservable().map({ userInfo in
        guard let id = userInfo.id else { return .failed }
        guard let phone = userInfo.phone else { return .phoneRequired }
        
        apollo.perform(mutation: UpsertUserMutation(id: id, email: userInfo.email, nickname: userInfo.nickname, gender: userInfo.gender, birthday: userInfo.birthday, ageRange: userInfo.ageRange, profileImagePath: userInfo.profileImagePath, phone: phone)) { (result, error) in
          if let error = error {
            NSLog("Error while attempting to UpsertUserMutation: \(error.localizedDescription)")
          }
        }
        
        return .completed
      }).share(replay: 1, scope: .whileConnected)
    
    super.init()
    
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
    })
    .disposed(by: disposeBag)
    
    phoneCertifyDone.subscribe(onNext: { [weak self] (phone) in
      guard let strongSelf = self else { return }
      var userInfoValue = strongSelf.userInfo.value
      userInfoValue.phone = phone
      strongSelf.userInfo.value = userInfoValue
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
