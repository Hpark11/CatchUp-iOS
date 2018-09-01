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

enum CreatePromiseState {
  case normal
  case pending
  case completed(dateTime: String, location: String, members: String)
  case error(description: String)
}

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
  var name: Observable<String?> { get }
  var place: Observable<String?> { get }
  var state: Observable<CreatePromiseState> { get }
  var editMode: Observable<Bool>
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
  
  // MARK: Outputs
  var dateItems: Observable<DateComponents?>
  var timeItems: Observable<DateComponents?>
  var isEnabled: Observable<Bool>
  var members: Observable<[String]>
  var state: Observable<CreatePromiseState>
  var name: Observable<String?>
  var place: Observable<String?>
  var editMode: Observable<Bool>
  
  fileprivate var owner: Variable<String>
  fileprivate var dateComponents: Variable<DateComponents?>
  fileprivate var timeComponents: Variable<DateComponents?>
  fileprivate var promiseName: Variable<String?>
  fileprivate var address: Variable<String?>
  fileprivate var pockets: Variable<[String]>
  fileprivate var coordinate: Variable<(latitude: Double, longitude: Double)?>
  fileprivate var createPromiseState: Variable<CreatePromiseState>
  fileprivate var isEditMode: Variable<Bool>
  
  init(coordinator: SceneCoordinatorType, ownerPhoneNumber: String, editMode: Bool = false) {
    // Setup
    sceneCoordinator = coordinator
    disposeBag = DisposeBag()
    
    dateComponents = Variable(nil)
    timeComponents = Variable(nil)
    promiseName = Variable(nil)
    address = Variable(nil)
    pockets = Variable([])
    coordinate = Variable(nil)
    owner = Variable(ownerPhoneNumber)
    createPromiseState = Variable(.normal)
    isEditMode = Variable(editMode)
    
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
    name = promiseName.asObservable()
    place = address.asObservable()
    editMode = isEditMode.asObservable()
    
    isEnabled = Observable.combineLatest(
      dateComponents.asObservable(),
      timeComponents.asObservable(),
      promiseName.asObservable(),
      address.asObservable(),
      pockets.asObservable(),
      coordinate.asObservable()
      ).map { (arg) -> Bool in
        let (dateComponents, timeComponents, name, address, pockets, coordinate) = arg
        guard let _ = dateComponents, let _ = timeComponents, let _ = coordinate, let _ = name, let _ = address, !pockets.isEmpty else { return false }
        return true
    }
    
    state = createPromiseState.asObservable()
    
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
      strongSelf.promiseName.value = name
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
  
  func applyPreviousInfo(name: String, address: String, datetime: DateComponents, latitude: Double, longitude: Double, pockets: [String]) {
    self.promiseName.value = name
    self.address.value = address
    self.dateComponents.value = datetime
    self.timeComponents.value = datetime
    self.coordinate.value = (latitude: latitude, longitude: longitude)
    self.pockets.value = pockets
  }
  
  lazy var popScene: CocoaAction = {
    return Action { [weak self] _ in
      guard let strongSelf = self else { return .empty() }
      strongSelf.sceneCoordinator.transition(to: MainScene(viewModel: MainViewModel(coordinator: strongSelf.sceneCoordinator)), type: .pop(animated: true, level: .parent))
      return .empty()
    }
  }()
  
  lazy var newPromiseCompleted: CocoaAction = {
    return Action { [weak self] _ in
      guard let strongSelf = self else { return .empty() }
      strongSelf.createPromiseState.value = .pending
      let calendar = Calendar(identifier: .gregorian)
      
      var components = strongSelf.dateComponents.value
      components?.hour = strongSelf.timeComponents.value?.hour
      components?.minute = strongSelf.timeComponents.value?.minute
      components?.second = strongSelf.timeComponents.value?.second
      
      guard let dateTimeComponents = components else { return .empty() }
      
      
      apollo.perform(mutation: AddPromiseMutation(
        owner: strongSelf.owner.value,
        name: strongSelf.promiseName.value,
        address: strongSelf.address.value,
        latitude: strongSelf.coordinate.value?.latitude,
        longitude: strongSelf.coordinate.value?.longitude,
        timestamp: String(calendar.date(from: dateTimeComponents)?.timeInMillis ?? 0),
        pockets: strongSelf.pockets.value
        )) { (result, error) in
          
          let timeFormat = DateFormatter()
          timeFormat.dateFormat = "MM.dd (EEE) a hh시 mm분"
          
          if let error = error {
            strongSelf.createPromiseState.value = .error(description: error.localizedDescription)
            return
          }
          
          if let date = calendar.date(from: dateTimeComponents),
            let location = strongSelf.address.value,
            let member = ContactItem.find(phone: strongSelf.pockets.value.first ?? "")?.nickname {
            let dateTime = timeFormat.string(from: date)
            let members = "\(member) 외 \(strongSelf.pockets.value.count - 1)명"
            strongSelf.createPromiseState.value = .completed(dateTime: dateTime, location: location, members: members)
          }
      }
      return .empty()
    }
  }()
}

extension NewPromiseViewModel: NewPromiseViewModelInputsType, NewPromiseViewModelOutputsType, NewPromiseViewModelActionsType {}
