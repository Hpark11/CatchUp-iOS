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
  // Mainly `Observable` here
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
  
  init(coordinator: SceneCoordinatorType, promiseId: String) {
    // Setup
    sceneCoordinator = coordinator
    disposeBag = DisposeBag()
    
    // Inputs
    
    // Outputs
    
    // ViewModel Life Cycle
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
