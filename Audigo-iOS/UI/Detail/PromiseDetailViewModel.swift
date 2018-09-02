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
import Apollo

typealias PocketSectionModel = AnimatableSectionModel<String, PromisePocket>

protocol PromiseDetailViewModelInputsType {
  var editPromiseDone: PublishSubject<String> { get }
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
  fileprivate let disposeBag: DisposeBag
  
  // MARK: Inputs
  var editPromiseDone: PublishSubject<String>
  
  // MARK: Outputs
  var pocketItems: Observable<[PocketSectionModel]>
  var name: Observable<String>
  var location: Observable<(latitude: Double, longitude: Double)>
  var timestamp: Observable<TimeInterval>
  var isOwner: Observable<Bool>

  var hasPromiseBeenUpdated: PublishSubject<Bool>?
  
  private var watcher: GraphQLQueryWatcher<GetPromiseQuery>?
  private var promiseId: String
  
  private let promiseName: Variable<String>
  private let promiseLocation: Variable<(latitude: Double, longitude: Double)>
  private let promiseTimestamp: Variable<TimeInterval>
  private let pocketList: Variable<[PromisePocket]>
  private let owner: Variable<String>
  private let address: Variable<String>
  
  init(coordinator: SceneCoordinatorType, promiseId: String) {
    sceneCoordinator = coordinator
    self.promiseId = promiseId
    disposeBag = DisposeBag()
    
    editPromiseDone = PublishSubject()
    
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
      guard let phone = UserDefaults.standard.string(forKey: "phoneNumber") else { return false }
      return phone == owner
    }
    
    pocketItems = pocketList.asObservable()
      .map({ (pocketList) in
        return [PocketSectionModel(model: "", items: pocketList)]
      })
    
    editPromiseDone.subscribe(onNext: { [weak self] id in
      guard let strongSelf = self else { return }
      
      if id != strongSelf.promiseId {
        strongSelf.hasPromiseBeenUpdated?.onNext(true)
      }
      
      strongSelf.promiseId = id
      strongSelf.loadSinglePromise()
    }).disposed(by: disposeBag)
    
    loadSinglePromise()
  }
  
  private func loadSinglePromise() {
    apollo.fetch(query: GetPromiseQuery(id: promiseId)) { [weak self] (result, error) in
      if let error = error {
        NSLog("Error while GetPromiseQuery: \(error.localizedDescription)")
        return
      }
      
      guard let strongSelf = self else { return }
      
      if let owner = result?.data?.promise?.owner {
        strongSelf.owner.value = owner
      }
      
      if let address = result?.data?.promise?.address {
        strongSelf.address.value = address
      }
      
      if let name = result?.data?.promise?.name {
        strongSelf.promiseName.value = name
      }
      
      if let pockets = result?.data?.promise?.pockets as? [GetPromiseQuery.Data.Promise.Pocket], let latitude = result?.data?.promise?.latitude, let longitude = result?.data?.promise?.longitude {
        strongSelf.promiseLocation.value = (latitude: latitude, longitude: longitude)
        strongSelf.pocketList.value = pockets.map { PromisePocket(destLatitude: latitude, destLongitude: longitude, pocket: $0) }
      }
      
      if let timestamp = UInt64(result?.data?.promise?.timestamp ?? "1") {
        strongSelf.promiseTimestamp.value = TimeInterval(timestamp / 1000)
      }
    }
  }

  lazy var popScene: CocoaAction = {
    return Action { [weak self] _ in
      guard let strongSelf = self else { return .empty() }
      strongSelf.sceneCoordinator.transition(to: MainScene(viewModel: MainViewModel(coordinator: strongSelf.sceneCoordinator)), type: .pop(animated: true, level: .parent))
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
      guard let strongSelf = self, let phone = UserDefaults.standard.string(forKey: "phoneNumber") else { return .empty() }
      let viewModel = NewPromiseViewModel(coordinator: strongSelf.sceneCoordinator, ownerPhoneNumber: phone, editMode: true)
      let calendar = Calendar(identifier: .gregorian)
      
      viewModel.editPromiseDone = strongSelf.editPromiseDone
      
      viewModel.applyPreviousInfo(
        id: strongSelf.promiseId,
        prevTimestamp: Int(strongSelf.promiseTimestamp.value * 1000),
        name: strongSelf.promiseName.value,
        address: strongSelf.address.value,
        datetime: calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date(timeIntervalSince1970: strongSelf.promiseTimestamp.value)),
        latitude: strongSelf.promiseLocation.value.latitude,
        longitude: strongSelf.promiseLocation.value.longitude,
        pockets: strongSelf.pocketList.value.compactMap { promisePocket in phone == promisePocket.pocket.phone ? nil : promisePocket.pocket.phone }
      )
      
      let scene = NewPromiseScene(viewModel: viewModel)
      return strongSelf.sceneCoordinator.transition(to: scene, type: .modal(animated: true))
    }
  }()
}

extension PromiseDetailViewModel: PromiseDetailViewModelInputsType, PromiseDetailViewModelOutputsType, PromiseDetailViewModelActionsType {}


