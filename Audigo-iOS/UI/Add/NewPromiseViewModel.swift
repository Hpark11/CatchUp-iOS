//
//  NewPromiseViewModel.swift
//  Audigo-iOS
//
//  Created by hPark on 2018. 8. 12..
//  Copyright © 2018년 BlackBurn. All rights reserved.
//

import Foundation
import Action
import RxSwift

protocol NewPromiseViewModelInputsType {
  var dateSelectDone: PublishSubject<DateComponents> { get }
  var timeSelectDone: PublishSubject<DateComponents> { get }
}

protocol NewPromiseViewModelOutputsType {
  var dateItems: Observable<DateComponents> { get }
  var timeItems: Observable<DateComponents> { get }
}

protocol NewPromiseViewModelActionsType {
  var popScene: CocoaAction { get }
}

protocol NewPromiseViewModelType {
  var inputs:  NewPromiseViewModelInputsType  { get }
  var outputs: NewPromiseViewModelOutputsType { get }
  var actions: NewPromiseViewModelActionsType { get }
}

class NewPromiseViewModel: NewPromiseViewModelType {
  var inputs:  NewPromiseViewModelInputsType  { return self }
  var outputs: NewPromiseViewModelOutputsType { return self }
  var actions: NewPromiseViewModelActionsType { return self }
  
  // MARK: Setup
  fileprivate var sceneCoordinator: SceneCoordinatorType
  fileprivate let disposeBag: DisposeBag
  
  // MARK: Inputs
  var dateSelectDone: PublishSubject<DateComponents>
  var timeSelectDone: PublishSubject<DateComponents>
  
  fileprivate var dateComponents: Variable<DateComponents>
  fileprivate var timeComponents: Variable<DateComponents>
  
  // MARK: Outputs
  var dateItems: Observable<DateComponents>
  var timeItems: Observable<DateComponents>
  
  init(coordinator: SceneCoordinatorType) {
    // Setup
    sceneCoordinator = coordinator
    disposeBag = DisposeBag()
    
    dateComponents = Variable(Calendar.current.dateComponents([.year, .month, .day], from: Date()))
    timeComponents = Variable(Calendar.current.dateComponents([.hour, .minute], from: Date()))
    
    dateSelectDone = PublishSubject()
    timeSelectDone = PublishSubject()
    
    dateItems = dateComponents.asObservable()
    timeItems = timeComponents.asObservable()
    
    // Inputs
    dateSelectDone.subscribe(onNext: { [weak self] components in
      guard let strongSelf = self else { return }
      strongSelf.dateComponents.value = components
    }).disposed(by: disposeBag)
    
    timeSelectDone.subscribe(onNext: { [weak self] components in
      guard let strongSelf = self else { return }
      strongSelf.timeComponents.value = components
    }).disposed(by: disposeBag)
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

extension NewPromiseViewModel: NewPromiseViewModelInputsType, NewPromiseViewModelOutputsType, NewPromiseViewModelActionsType {}
