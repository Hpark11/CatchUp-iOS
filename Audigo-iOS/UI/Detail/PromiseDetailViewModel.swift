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

protocol PromiseDetailViewModelInputsType {
  // Mainly `PublishSubject` here
}

protocol PromiseDetailViewModelOutputsType {
  var promise: Observable<GetPromiseQuery.Data.Promise?> { get }
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
  
  var promise: Observable<GetPromiseQuery.Data.Promise?>
  private let promiseInfo: Variable<GetPromiseQuery.Data.Promise?>
  
  init(coordinator: SceneCoordinatorType, promiseId: String) {
    // Setup
    sceneCoordinator = coordinator
    disposeBag = DisposeBag()
    
    promiseInfo = Variable(nil)
    promise = promiseInfo.asObservable().share(replay: 1, scope: .whileConnected)
    
    // Inputs
    
    // Outputs
    apollo.watch(query: GetPromiseQuery(id: promiseId)) { [weak self] (result, error) in
      if let error = error {
        NSLog("Error while GetPromiseQuery: \(error.localizedDescription)")
        return
      }
      
      guard let strongSelf = self else { return }
      strongSelf.promiseInfo.value = result?.data?.promise
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
