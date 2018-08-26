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
  var memberSelectDone: PublishSubject<Set<String>> { get }
}

protocol NewPromiseViewModelOutputsType {
  var dateItems: Observable<DateComponents?> { get }
  var timeItems: Observable<DateComponents?> { get }
  var isEnabled: Observable<Bool> { get }
  var members: Observable<[String]> { get }
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
  var memberSelectDone: PublishSubject<Set<String>>
  
  fileprivate var owner: Variable<String>
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
  var members: Observable<[String]>
  
  init(coordinator: SceneCoordinatorType, ownerPhoneNumber: String) {
    // Setup
    sceneCoordinator = coordinator
    disposeBag = DisposeBag()
    
    dateComponents = Variable(nil)
    timeComponents = Variable(nil)
    name = Variable(nil)
    address = Variable(nil)
    pockets = Variable([])
    coordinate = Variable(nil)
    owner = Variable(ownerPhoneNumber)
    
    dateSelectDone = PublishSubject()
    timeSelectDone = PublishSubject()
    nameSetDone = PublishSubject()
    addressSetDone = PublishSubject()
    pocketSelectDone = PublishSubject()
    coordinateSetDone = PublishSubject()
    memberSelectDone = PublishSubject()
    
    dateItems = dateComponents.asObservable()
    timeItems = timeComponents.asObservable()
    members = pockets.asObservable()
    
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
    
    memberSelectDone.subscribe(onNext: { [weak self] memberSet in
      guard let strongSelf = self else { return }
      strongSelf.pockets.value = memberSet.map { $0 }
    }).disposed(by: disposeBag)
  }
  
  internal lazy var popScene: CocoaAction = {
    return Action { [weak self] _ in
      guard let strongSelf = self else { return .empty() }
      strongSelf.sceneCoordinator.transition(to: MainScene(viewModel: MainViewModel(coordinator: strongSelf.sceneCoordinator)), type: .pop(animated: true, level: .parent))
      return .empty()
    }
  }()
  
  internal lazy var newPromiseCompleted: CocoaAction = {
    return Action { [weak self] _ in
      guard let strongSelf = self else { return .empty() }
      let calendar = Calendar(identifier: .gregorian)
      
      var components = strongSelf.dateComponents.value
      components?.hour = strongSelf.timeComponents.value?.hour
      components?.minute = strongSelf.timeComponents.value?.minute
      components?.second = strongSelf.timeComponents.value?.second
      
      apollo.perform(mutation: AddPromiseMutation(
        owner: strongSelf.owner.value,
        name: strongSelf.name.value,
        address: strongSelf.address.value,
        latitude: strongSelf.coordinate.value?.latitude,
        longitude: strongSelf.coordinate.value?.longitude,
        timestamp: String(components?.date?.timeInMillis ?? 0),
        pockets: strongSelf.pockets.value)) { (result, error) in
          if let error = error {
            NSLog("Error while attempting to AddPromiseMutation: \(error.localizedDescription)")
          }
      }
      
      return .empty()
    }
  }()
}

extension NewPromiseViewModel: NewPromiseViewModelInputsType, NewPromiseViewModelOutputsType, NewPromiseViewModelActionsType {}
