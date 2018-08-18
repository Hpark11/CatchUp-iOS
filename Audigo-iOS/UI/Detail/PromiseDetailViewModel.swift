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
  // Mainly `PublishSubject` here
}

protocol PromiseDetailViewModelOutputsType {
  var promiseItem: Observable<GetPromiseQuery.Data.Promise?> { get }
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
  var promiseItem: Observable<GetPromiseQuery.Data.Promise?>
  var pocketItems: Observable<[PocketSectionModel]>
  
  private let promiseInfo: Variable<GetPromiseQuery.Data.Promise?>
  private let pocketList: Variable<[GetPromiseQuery.Data.Promise.Pocket]>
  
  init(coordinator: SceneCoordinatorType, promiseId: String) {
    // Setup
    sceneCoordinator = coordinator
    disposeBag = DisposeBag()
    
    promiseInfo = Variable(nil)
    pocketList = Variable([])
    promiseItem = promiseInfo.asObservable().share(replay: 1, scope: .whileConnected)
    
    // Inputs
    
    // Outputs
    pocketItems = pocketList.asObservable()
      .map({ (pocketList) in
        return [PocketSectionModel(model: "", items: pocketList)]
      })
    
    apollo.watch(query: GetPromiseQuery(id: promiseId)) { [weak self] (result, error) in
      if let error = error {
        NSLog("Error while GetPromiseQuery: \(error.localizedDescription)")
        return
      }
      
      guard let strongSelf = self else { return }
      strongSelf.promiseInfo.value = result?.data?.promise
      
      if let pockets = result?.data?.promise?.pockets as? [GetPromiseQuery.Data.Promise.Pocket] {
        strongSelf.pocketList.value = pockets
      }
    }
  }
  
  // MARK: Actions
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
