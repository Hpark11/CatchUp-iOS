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
  var sessionOpened: PublishSubject<Void> { get }
  var creditCheck: PublishSubject<UserInfo> { get }
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
  fileprivate let apiClient: AWSAppSyncClient
  fileprivate let disposeBag: DisposeBag
  
  // MARK: Inputs
  var sessionOpened: PublishSubject<Void>
  var creditCheck: PublishSubject<UserInfo>
  
  // MARK: Outputs
  init(coordinator: SceneCoordinatorType, client: AWSAppSyncClient) {
    sceneCoordinator = coordinator
    apiClient = client
    disposeBag = DisposeBag()
    
    sessionOpened = PublishSubject()
    creditCheck = PublishSubject()
    
    sessionOpened
      .flatMapLatest { [unowned self] _ -> PrimitiveSequence<MaybeTrait, UserInfo> in
        return self.loadCatchUpUser
        
      }.do(onNext: { (userInfo) in
        UserDefaultService.userId = userInfo.id
        UserDefaultService.nickname = userInfo.nickname
        UserDefaultService.phoneNumber = userInfo.id
        ContactItem.create(userInfo.id, imagePath: userInfo.profileImagePath ?? "", pushToken: "")

      }).flatMapLatest { (userInfo) -> PrimitiveSequence<MaybeTrait, UpdateCatchUpUserMutation.Data> in
        return client.rx.perform(mutation: UpdateCatchUpUserMutation(
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
      }.flatMapLatest({ data -> PrimitiveSequence<MaybeTrait, UpdateCatchUpContactMutation.Data> in
        guard let user = data.updateCatchUpUser, let phone = user.phone else {
          throw SignInError.phoneNotFoundError("NO CELL PHONE NUMBER")
        }
        
        return client.rx.perform(mutation: UpdateCatchUpContactMutation(phone: phone, contact: ContactUpdateInput(
          nickname: user.nickname,
          profileImagePath: user.profileImagePath,
          pushToken: UserDefaultService.pushToken,
          osType: Define.platform)
        ))
      }).subscribe(onNext: { [unowned self] data in
        if let phone = data.updateCatchUpContact?.phone {
          self.pushMainScene.execute(phone)
        }
      }, onError: { error in
        fatalError(error.localizedDescription)
      }).disposed(by: disposeBag)
  }
  
  private var loadCatchUpUser: Maybe<UserInfo> {
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
          case .type15: ageRange = "15~19"
          case .type20: ageRange = "20~29"
          case .type30: ageRange = "30~39"
          case .type40: ageRange = "40~49"
          case .type50: ageRange = "50~59"
          case .type60: ageRange = "60~69"
          case .type70: ageRange = "70~79"
          case .type80: ageRange = "80~89"
          case .type90: ageRange = "90~"
          default: break
          }
        }
        
        if let id = me?.id {
          maybe(.success(UserInfo(
            id: id,
            phone: id,
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
      guard let `self` = self else { return .empty() }
      let viewModel = MainViewModel(coordinator: self.sceneCoordinator, client: self.apiClient)
      viewModel.phone = phone
      let scene = MainScene(viewModel: viewModel)
      return self.sceneCoordinator.transition(to: scene, type: .modal(animated: true))
    }
  }()
  
  public enum SignInError: Error {
    case userIdNotFoundError(String)
    case phoneNotFoundError(String)
  }
}

extension EntranceViewModel: EntranceViewModelInputsType, EntranceViewModelOutputsType, EntranceViewModelActionsType {}

