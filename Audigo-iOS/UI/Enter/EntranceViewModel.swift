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

protocol EntranceViewModelOutputsType {
  var name: Observable<String> { get }
}

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
  var editPromiseDone: PublishSubject<String>
  
  // MARK: Outputs
  var pocketItems: Observable<[PocketSectionModel]>
  var name: Observable<String>
  var location: Observable<(latitude: Double, longitude: Double)>
  var timestamp: Observable<TimeInterval>
  var isOwner: Observable<Bool>
  
  var sessionOpened: PublishSubject<String>
  
  init(coordinator: SceneCoordinatorType) {
    sceneCoordinator = coordinator
    disposeBag = DisposeBag()
    
    sessionOpened = PublishSubject()
    
//    sessionOpened.subscribe(onNext: { [weak self] phone in
//      guard let strongSelf = self else { return }
//      strongSelf.updateCatchUpUser(phone: phone)
//    }).disposed(by: disposeBag)
    
    sessionOpened.asMaybe()
      .flatMap { [unowned self] (phone) -> PrimitiveSequence<MaybeTrait, UserInfo> in
        return self.loadCatchUpUser(phone: phone)
        
      }.flatMap { (userInfo) -> PrimitiveSequence<MaybeTrait, GetCatchUpUserQuery.Data> in
        return appSyncClient.rx.fetch(query: GetCatchUpUserQuery(id: userInfo.id), cachePolicy: .returnCacheDataElseFetch, queue: .global())
        
      }.flatMap { (data) in
        let phone = UserDefaults.standard.string(forKey: Define.keyPhoneNumber)
        
        if let user = data.getCatchUpUser, !user.id.isEmpty {
          return appSyncClient.rx.perform(mutation: UpdateCatchUpUserMutation(
            id: user.id,
            data: CatchUpUserInput(
              email: user.email,
              nickname: user.nickname,
              profileImagePath: user.profileImagePath,
              gender: user.gender,
              birthday: user.birthday,
              ageRange: user.ageRange,
              phone: phone,
              credit: user.credit
          )))
        } else {
          return appSyncClient.rx.perform(mutation: CreateCatchUpUserMutation(
            id: user.id,
            data: CatchUpUserInput(
              email: user.email,
              nickname: user.nickname,
              profileImagePath: user.profileImagePath,
              gender: user.gender,
              birthday: user.birthday,
              ageRange: user.ageRange,
              phone: phone,
              credit: user.credit
          )))
        }
      }.subscribe()
  }
  
  private func loadCatchUpUser(phone: String) -> Maybe<UserInfo> {
    return Maybe.create { maybe in
      KOSessionTask.userMeTask(completion: { (error, me) in
        if let error = error {
          maybe(.error(error))
        }
        
        let gender: String?
        let ageRange: String?
        
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
      let viewModel = MainViewModel(coordinator: strongSelf.sceneCoordinator, phone: phone)
      let scene = MainScene(viewModel: viewModel)
      return strongSelf.sceneCoordinator.transition(to: scene, type: .push(animated: true))
    }
  }()
  
  public enum SignInError: Error {
    case userIdNotFoundError(String)
  }
}

extension EntranceViewModel: EntranceViewModelInputsType, EntranceViewModelOutputsType, EntranceViewModelActionsType {}

