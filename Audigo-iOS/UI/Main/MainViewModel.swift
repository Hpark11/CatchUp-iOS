//
//  MainViewModel.swift
//  Audigo-iOS
//
//  Created by hPark on 2018. 8. 4..
//  Copyright © 2018년 BlackBurn. All rights reserved.
//

import Foundation
import RxSwift
import Action

protocol MainViewModelInputsType {
  var updateUploadList: PublishSubject<Void> { get }
}

protocol MainViewModelOutputsType {
  // Mainly `Observable` here
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
  
  // MARK: Outputs
  
  init(coordinator: SceneCoordinatorType) {
    // Setup
    sceneCoordinator = coordinator
    
    
    
    
    // Inputs
    
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
