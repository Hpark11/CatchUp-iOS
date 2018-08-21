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

typealias PocketSectionModel = AnimatableSectionModel<String, GetPromiseQuery.Data.Promise.Pocket>

protocol PromiseDetailViewModelInputsType {

}

protocol PromiseDetailViewModelOutputsType {
  var name: Observable<String> { get }
  var location: Observable<(latitude: Double, longitude: Double)> { get }
  var timestamp: Observable<TimeInterval> { get }
  var pocketItems: Observable<[PocketSectionModel]> { get }
}

protocol PromiseDetailViewModelActionsType {
  var popScene: CocoaAction { get }
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
  
  // MARK: Outputs
  var pocketItems: Observable<[PocketSectionModel]>
  var name: Observable<String>
  var location: Observable<(latitude: Double, longitude: Double)>
  var timestamp: Observable<TimeInterval>
  
  private let promiseName: Variable<String>
  private let promiseLocation: Variable<(latitude: Double, longitude: Double)>
  private let promiseTimestamp: Variable<TimeInterval>
  private let pocketList: Variable<[GetPromiseQuery.Data.Promise.Pocket]>
  
  init(coordinator: SceneCoordinatorType, promiseId: String) {
    sceneCoordinator = coordinator
    disposeBag = DisposeBag()
    
    pocketList = Variable([])
    promiseName = Variable("")
    promiseLocation = Variable((latitude: 0, longitude: 0))
    promiseTimestamp = Variable(0)
    
    name = promiseName.asObservable()
    location = promiseLocation.asObservable()
    timestamp = promiseTimestamp.asObservable()
    
    pocketItems = pocketList.asObservable()
      .map({ (pocketList) in
        return [PocketSectionModel(model: "", items: pocketList)]
      })
    
    _ = apollo.watch(query: GetPromiseQuery(id: promiseId)) { [weak self] (result, error) in
      if let error = error {
        NSLog("Error while GetPromiseQuery: \(error.localizedDescription)")
        return
      }
      
      guard let strongSelf = self else { return }
      
      if let pockets = result?.data?.promise?.pockets as? [GetPromiseQuery.Data.Promise.Pocket] {
        strongSelf.pocketList.value = pockets
      }
      
      if let name = result?.data?.promise?.name {
        strongSelf.promiseName.value = name
      }
      
      if let latitude = result?.data?.promise?.latitude, let longitude = result?.data?.promise?.longitude {
        strongSelf.promiseLocation.value = (latitude: latitude, longitude: longitude)
      }
      
      if let timestamp = UInt64(result?.data?.promise?.timestamp ?? "1") {
        strongSelf.promiseTimestamp.value = TimeInterval(timestamp / 1000)
      }
    }
  }

  internal lazy var popScene: CocoaAction = {
    return Action { [weak self] _ in
      guard let strongSelf = self else { return .empty() }
      strongSelf.sceneCoordinator.transition(to: MainScene(viewModel: MainViewModel(coordinator: strongSelf.sceneCoordinator)), type: .pop(animated: true, level: .parent))
      return .empty()
    }
  }()
}

extension PromiseDetailViewModel: PromiseDetailViewModelInputsType, PromiseDetailViewModelOutputsType, PromiseDetailViewModelActionsType {}

extension GetPromiseQuery.Data.Promise.Pocket: IdentifiableType, Equatable {
  public var identity: String {
    return phone
  }
  
  public static func ==(lhs: GetPromiseQuery.Data.Promise.Pocket,
                        rhs: GetPromiseQuery.Data.Promise.Pocket) -> Bool {
    return lhs.phone == rhs.phone
  }
}
