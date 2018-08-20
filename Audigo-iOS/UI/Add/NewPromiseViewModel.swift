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
  var nameSetDone: PublishSubject<String> { get }
  var addressSetDone: PublishSubject<String?> { get }
  var pocketSelectDone: PublishSubject<[String]> { get }
  var coordinateSetDone: PublishSubject<(latitude: Double, longitude: Double)> { get }
  var dateSelectDone: PublishSubject<DateComponents> { get }
  var timeSelectDone: PublishSubject<DateComponents> { get }
}

protocol NewPromiseViewModelOutputsType {
  var dateItems: Observable<DateComponents?> { get }
  var timeItems: Observable<DateComponents?> { get }
  var isEnabled: Observable<Bool> { get }
}

protocol NewPromiseViewModelActionsType {
  var popScene: CocoaAction { get }
  var newPromiseCompleted: CocoaAction { get }
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
  var nameSetDone: PublishSubject<String>
  var addressSetDone: PublishSubject<String?>
  var pocketSelectDone: PublishSubject<[String]>
  var coordinateSetDone: PublishSubject<(latitude: Double, longitude: Double)>
  
  fileprivate var dateComponents: Variable<DateComponents?>
  fileprivate var timeComponents: Variable<DateComponents?>
  fileprivate var name: Variable<String?>
  fileprivate var address: Variable<String?>
  fileprivate var pockets: Variable<[String]>
  fileprivate var coordinate: Variable<(latitude: Double, longitude: Double)?>
  
  // MARK: Outputs
  var dateItems: Observable<DateComponents?>
  var timeItems: Observable<DateComponents?>
  var isEnabled: Observable<Bool>
  
  init(coordinator: SceneCoordinatorType) {
    // Setup
    sceneCoordinator = coordinator
    disposeBag = DisposeBag()
    
    dateComponents = Variable(nil)
    timeComponents = Variable(nil)
    name = Variable(nil)
    address = Variable(nil)
    pockets = Variable([])
    coordinate = Variable(nil)
    
    dateSelectDone = PublishSubject()
    timeSelectDone = PublishSubject()
    nameSetDone = PublishSubject()
    addressSetDone = PublishSubject()
    pocketSelectDone = PublishSubject()
    coordinateSetDone = PublishSubject()
    
    dateItems = dateComponents.asObservable()
    timeItems = timeComponents.asObservable()
    
    isEnabled = Observable.combineLatest(
      dateComponents.asObservable(),
      timeComponents.asObservable(),
      name.asObservable(),
      address.asObservable(),
      pockets.asObservable(),
      coordinate.asObservable()
      ).map { (arg) -> Bool in
        let (dateComponents, timeComponents, name, address, pockets, coordinate) = arg
        guard let _ = dateComponents, let _ = timeComponents, let _ = coordinate, let _ = name, let _ = address, !pockets.isEmpty else { return false }
        return true
    }
    
    // Inputs
    dateSelectDone.subscribe(onNext: { [weak self] components in
      guard let strongSelf = self else { return }
      strongSelf.dateComponents.value = components
    }).disposed(by: disposeBag)
    
    timeSelectDone.subscribe(onNext: { [weak self] components in
      guard let strongSelf = self else { return }
      strongSelf.timeComponents.value = components
    }).disposed(by: disposeBag)
    
    nameSetDone.subscribe(onNext: { [weak self] name in
      guard let strongSelf = self else { return }
      strongSelf.name.value = name
    }).disposed(by: disposeBag)
    
    addressSetDone.subscribe(onNext: { [weak self] address in
      guard let strongSelf = self else { return }
      strongSelf.address.value = address
    }).disposed(by: disposeBag)
    
    pocketSelectDone.subscribe(onNext: { [weak self] pockets in
      guard let strongSelf = self else { return }
      strongSelf.pockets.value = pockets
    }).disposed(by: disposeBag)
    
    coordinateSetDone.subscribe(onNext: { [weak self] coordinate in
      guard let strongSelf = self else { return }
      strongSelf.coordinate.value = coordinate
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
  
  lazy var newPromiseCompleted: CocoaAction = {
    return Action { [weak self] _ in
//      apollo.perform(mutation: AddPromiseMutation(owner: <#T##String?#>, name: name, address: <#T##String?#>, latitude: <#T##Double?#>, longitude: <#T##Double?#>, timestamp: <#T##String?#>, pockets: <#T##[String?]?#>))
      return .empty()
    }
  }()
}

extension NewPromiseViewModel: NewPromiseViewModelInputsType, NewPromiseViewModelOutputsType, NewPromiseViewModelActionsType {}
