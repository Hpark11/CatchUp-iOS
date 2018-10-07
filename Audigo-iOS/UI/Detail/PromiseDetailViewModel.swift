//
//  PromiseDetailViewModel.swift
//  Audigo-iOS
//
//  Created by hPark on 2018. 8. 18..
//  Copyright © 2018년 BlackBurn. All rights reserved.
//

import Foundation
import Action
import RxSwift
import RxDataSources
import AWSAppSync

typealias PocketSectionModel = AnimatableSectionModel<String, CatchUpContact>

protocol PromiseDetailViewModelInputsType {
  var editPromiseDone: PublishSubject<CatchUpPromise> { get }
}

protocol PromiseDetailViewModelOutputsType {
  var name: Observable<String> { get }
  var location: Observable<(latitude: Double, longitude: Double)> { get }
  var timestamp: Observable<TimeInterval> { get }
  var pocketItems: Observable<[PocketSectionModel]> { get }
  var isOwner: Observable<Bool> { get }
}

protocol PromiseDetailViewModelActionsType {
  var popScene: CocoaAction { get }
  var refresh: CocoaAction { get }
  var pushNewPromiseScene: CocoaAction { get }
}

protocol PromiseDetailViewModelType {
  var inputs:  PromiseDetailViewModelInputsType  { get }
  var outputs: PromiseDetailViewModelOutputsType { get }
  var actions: PromiseDetailViewModelActionsType { get }
}

class PromiseDetailViewModel: PromiseDetailViewModelType {
  var inputs:  PromiseDetailViewModelInputsType  { return self }
  var outputs: PromiseDetailViewModelOutputsType { return self }
  var actions: PromiseDetailViewModelActionsType { return self }
  
  // MARK: Setup
  fileprivate var sceneCoordinator: SceneCoordinatorType
  fileprivate let apiClient: AWSAppSyncClient
  fileprivate let disposeBag: DisposeBag
  
  // MARK: Inputs
  var editPromiseDone: PublishSubject<CatchUpPromise>
  
  // MARK: Outputs
  var pocketItems: Observable<[PocketSectionModel]>
  var name: Observable<String>
  var location: Observable<(latitude: Double, longitude: Double)>
  var timestamp: Observable<TimeInterval>
  var isOwner: Observable<Bool>

  var hasPromiseBeenUpdated: PublishSubject<Bool>?
  var sendMessage: PublishSubject<String>
  
  var promise: CatchUpPromise? {
    didSet {
      loadSinglePromise()
    }
  }
  
  private let promiseName: Variable<String>
  private let promiseLocation: Variable<(latitude: Double, longitude: Double)>
  private let promiseTimestamp: Variable<TimeInterval>
  private let pocketList: Variable<[CatchUpContact]>
  private let owner: Variable<String>
  private let address: Variable<String>
  
  init(coordinator: SceneCoordinatorType, client: AWSAppSyncClient) {
    sceneCoordinator = coordinator
    apiClient = client
    disposeBag = DisposeBag()
    
    editPromiseDone = PublishSubject()
    sendMessage = PublishSubject()
    
    pocketList = Variable([])
    promiseName = Variable("")
    promiseLocation = Variable((latitude: 0, longitude: 0))
    promiseTimestamp = Variable(0)
    owner = Variable("")
    address = Variable("")
    
    name = promiseName.asObservable()
    location = promiseLocation.asObservable()
    timestamp = promiseTimestamp.asObservable()
    isOwner = owner.asObservable().map { owner in
      return UserDefaultService.phoneNumber == owner
    }
    
    pocketItems = pocketList.asObservable()
      .map({ (pocketList) in
        return [PocketSectionModel(model: "", items: pocketList)]
      })
    
    editPromiseDone.subscribe(onNext: { [weak self] promise in
      guard let strongSelf = self else { return }
      strongSelf.promise = promise
    }).disposed(by: disposeBag)
  }
  
  private func loadSinglePromise() {
    guard let promise = promise else { return }
    owner.value = promise.owner
    address.value = promise.address
    promiseName.value = promise.name
    promiseTimestamp.value = TimeInterval(promise.dateTime.timeInMillis / 1000)
    promiseLocation.value = (latitude: promise.latitude, longitude: promise.longitude)
    
    apiClient.rx.fetch(query: BatchGetCatchUpContactsQuery(ids: promise.contacts), cachePolicy: .fetchIgnoringCacheData)
      .subscribe(onSuccess: { [weak self] data in
        guard let strongSelf = self else { return }
        strongSelf.pocketList.value = data.batchGetCatchUpContacts?.compactMap {
          CatchUpContact(dstLat: promise.latitude, dstLng: promise.longitude, contactData: $0)
          } ?? []
      }).disposed(by: disposeBag)
  }

  lazy var popScene: CocoaAction = {
    return Action { [weak self] _ in
      guard let strongSelf = self else { return .empty() }
      strongSelf.sceneCoordinator.transition(to: MainScene(viewModel: MainViewModel(coordinator: strongSelf.sceneCoordinator, client: strongSelf.apiClient)), type: .pop(animated: true, level: .parent))
      return .empty()
    }
  }()
  
  lazy var refresh: CocoaAction = {
    return Action { [weak self] _ in
      guard let strongSelf = self else { return .empty() }
      strongSelf.loadSinglePromise()
      return .empty()
    }
  }()
  
  lazy var pushNewPromiseScene: CocoaAction = {
    return Action { [weak self] in
      guard let strongSelf = self, let phone = UserDefaultService.phoneNumber, let promise = strongSelf.promise else { return .empty() }
      let viewModel = NewPromiseViewModel(coordinator: strongSelf.sceneCoordinator, client: strongSelf.apiClient, ownerPhoneNumber: phone, editMode: true)
      let calendar = Calendar(identifier: .gregorian)
      
      viewModel.editPromiseDone = strongSelf.editPromiseDone
      viewModel.applyPreviousInfo(promise: promise)
      
      let scene = NewPromiseScene(viewModel: viewModel)
      return strongSelf.sceneCoordinator.transition(to: scene, type: .modal(animated: true))
    }
  }()
}

extension PromiseDetailViewModel: PromiseDetailViewModelInputsType, PromiseDetailViewModelOutputsType, PromiseDetailViewModelActionsType {}


