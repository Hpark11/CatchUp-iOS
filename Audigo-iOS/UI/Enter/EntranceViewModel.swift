//
//  EntranceViewModel.swift
//  Audigo-iOS
//
//  Created by hPark on 2018. 10. 4..
//  Copyright © 2018년 BlackBurn. All rights reserved.
//

import Foundation
import Action
import RxSwift
import AWSAppSync

protocol EntranceViewModelInputsType {
  var sessionOpened: PublishSubject<String> { get }
}

protocol EntranceViewModelOutputsType {}

protocol EntranceViewModelActionsType {
  var pushMainScene: Action<String, Void> { get }
}

protocol EntranceViewModelType {
  var inputs:  EntranceViewModelInputsType  { get }
  var outputs: EntranceViewModelOutputsType { get }
  var actions: EntranceViewModelActionsType { get }
}

class EntranceViewModel: EntranceViewModelType {
  var inputs:  EntranceViewModelInputsType  { return self }
  var outputs: EntranceViewModelOutputsType { return self }
  var actions: EntranceViewModelActionsType { return self }
  
  // MARK: Setup
  fileprivate var sceneCoordinator: SceneCoordinatorType
  fileprivate let disposeBag: DisposeBag
  
  // MARK: Inputs
  var sessionOpened: PublishSubject<String>
  
  // MARK: Outputs

  init(coordinator: SceneCoordinatorType) {
    sceneCoordinator = coordinator
    disposeBag = DisposeBag()
    
    sessionOpened = PublishSubject()
    
    sessionOpened.asMaybe()
      .flatMap { [unowned self] (phone) -> PrimitiveSequence<MaybeTrait, UserInfo> in
        return self.loadCatchUpUser(phone: phone)
        
      }.flatMap { (userInfo) -> PrimitiveSequence<MaybeTrait, UpdateCatchUpUserMutation.Data> in
        return appSyncClient.rx.perform(mutation: UpdateCatchUpUserMutation(
          id: userInfo.id,
          data: CatchUpUserInput(
            email: userInfo.email,
            nickname: userInfo.nickname,
            profileImagePath: userInfo.profileImagePath,
            gender: userInfo.gender,
            birthday: userInfo.birthday,
            ageRange: userInfo.ageRange,
            phone: userInfo.phone)
        ))
      }.subscribe(onSuccess: { [unowned self] data in
        if let phone = data.updateCatchUpUser?.phone {
          self.pushMainScene.execute(phone)
        }
      }, onError: { (error) in
        fatalError(error.localizedDescription)
      }).disposed(by: disposeBag)
  }
  
  private func loadCatchUpUser(phone: String) -> Maybe<UserInfo> {
    return Maybe.create { maybe in
      KOSessionTask.userMeTask(completion: { (error, me) in
        if let error = error {
          maybe(.error(error))
        }
        
        var gender: String? = nil
        var ageRange: String? = nil
        
        if let genderCode = me?.account?.gender {
          switch genderCode {
          case .female: gender = "여성"
          case .male: gender = "남성"
          default: break
          }
        }
        
        if let ageCode = me?.account?.ageRange {
          switch ageCode {
          case .type15: ageRange = "15세 ~ 19세"
          case .type20: ageRange = "20세 ~ 29세"
          case .type30: ageRange = "30세 ~ 39세"
          case .type40: ageRange = "40세 ~ 49세"
          case .type50: ageRange = "50세 ~ 59세"
          case .type60: ageRange = "60세 ~ 69세"
          case .type70: ageRange = "70세 ~ 79세"
          case .type80: ageRange = "80세 ~ 89세"
          case .type90: ageRange = "90세 이상"
          default: break
          }
        }
        
        if let id = me?.id, !phone.isEmpty {
          maybe(.success(UserInfo(
            id: id,
            phone: phone,
            email: me?.account?.email,
            nickname: me?.nickname,
            birthday: me?.account?.birthday,
            profileImagePath: me?.profileImageURL?.absoluteString,
            gender: gender,
            ageRange: ageRange
          )))
        } else {
          maybe(.error(SignInError.userIdNotFoundError("NO USER ID")))
        }
      })
      
      return Disposables.create()
    }
  }
  
  lazy var pushMainScene: Action<String, Void> = {
    return Action { [weak self] phone in
      guard let strongSelf = self else { return .empty() }
      let viewModel = MainViewModel(coordinator: strongSelf.sceneCoordinator)
      viewModel.phone = phone
      let scene = MainScene(viewModel: viewModel)
      return strongSelf.sceneCoordinator.transition(to: scene, type: .push(animated: true))
    }
  }()
  
  public enum SignInError: Error {
    case userIdNotFoundError(String)
  }
}

extension EntranceViewModel: EntranceViewModelInputsType, EntranceViewModelOutputsType, EntranceViewModelActionsType {}

