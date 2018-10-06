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
import AWSAppSync

enum CreatePromiseState {
  case normal
  case pending
  case completed(promise: CatchUpPromise)
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
  var editMode: Observable<Bool> { get }
}

protocol NewPromiseViewModelActionsType {
  var popScene: Action<CatchUpPromise?, Void> { get }
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
  fileprivate let apiClient: AWSAppSyncClient
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
  
  var addPromiseDone: PublishSubject<Void>?
  var editPromiseDone: PublishSubject<CatchUpPromise>?
  
  fileprivate var owner: Variable<String>
  fileprivate var dateComponents: Variable<DateComponents?>
  fileprivate var timeComponents: Variable<DateComponents?>
  fileprivate var promiseName: Variable<String?>
  fileprivate var address: Variable<String?>
  fileprivate var pockets: Variable<[String]>
  fileprivate var coordinate: Variable<(latitude: Double, longitude: Double)?>
  fileprivate var createPromiseState: Variable<CreatePromiseState>
  fileprivate var isEditMode: Variable<Bool>
  fileprivate var promiseId: Variable<String?>
  fileprivate var prevTimestamp: Variable<Int?>
  
  init(coordinator: SceneCoordinatorType, client: AWSAppSyncClient, ownerPhoneNumber: String, editMode: Bool = false) {
    // Setup
    sceneCoordinator = coordinator
    apiClient = client
    disposeBag = DisposeBag()
    
    dateComponents = Variable(nil)
    timeComponents = Variable(nil)
    promiseName = Variable(nil)
    address = Variable(nil)
    pockets = Variable([])
    coordinate = Variable(nil)
    promiseId = Variable(nil)
    prevTimestamp = Variable(nil)
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
    self.editMode = isEditMode.asObservable()
    
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
  
  func applyPreviousInfo(promise: CatchUpPromise) {
    let calendar = Calendar(identifier: .gregorian)
    let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: promise.dateTime)
    
    self.promiseId.value = promise.id
    self.promiseName.value = promise.name
    self.address.value = promise.address
    self.dateComponents.value = components
    self.timeComponents.value = components
    self.coordinate.value = (latitude: promise.latitude, longitude: promise.longitude)
    self.pockets.value = promise.contacts.filter { $0 != promise.owner }
  }
  
  lazy var popScene: Action<CatchUpPromise?, Void> = {
    return Action { [weak self] promiseData in
      guard let strongSelf = self else { return .empty() }
      if strongSelf.isEditMode.value {
        
        let viewModel = PromiseDetailViewModel(coordinator: strongSelf.sceneCoordinator, client: strongSelf.apiClient)
        if let promise = promiseData {
          strongSelf.editPromiseDone?.onNext(promise)
        }
        strongSelf.sceneCoordinator.transition(to: PromiseDetailScene(viewModel: viewModel), type: .pop(animated: true, level: .parent))
      } else {
        if promiseData != nil { strongSelf.addPromiseDone?.onNext(()) }
        let viewModel = MainViewModel(coordinator: strongSelf.sceneCoordinator, client: strongSelf.apiClient)
        strongSelf.sceneCoordinator.transition(to: MainScene(viewModel: viewModel), type: .pop(animated: true, level: .parent))
      }
      return .empty()
    }
  }()
  
  lazy var newPromiseCompleted: CocoaAction = {
    return Action { [weak self] _ in
      guard let strongSelf = self else { return .empty() }
      strongSelf.createPromiseState.value = .pending
      
      let isEdit = strongSelf.isEditMode.value
      let promiseId = strongSelf.promiseId.value ?? UUID().uuidString
      let calendar = Calendar(identifier: .gregorian)
      
      var components = strongSelf.dateComponents.value
      components?.hour = strongSelf.timeComponents.value?.hour
      components?.minute = strongSelf.timeComponents.value?.minute
      components?.second = strongSelf.timeComponents.value?.second
      
      guard let dateTimeComponents = components else { return .empty() }
      guard let owner = UserDefaultService.phoneNumber else { return .empty() }
      
      let promiseInput = CatchUpPromiseInput(
        owner: owner,
        dateTime: Formatter.iso8601.string(from: calendar.date(from: dateTimeComponents) ?? Date()),
        address: strongSelf.address.value,
        latitude: strongSelf.coordinate.value?.latitude,
        longitude: strongSelf.coordinate.value?.longitude,
        name: strongSelf.promiseName.value,
        contacts: strongSelf.pockets.value + [owner]
      )
      
      strongSelf.apiClient.rx.perform(
        mutation: UpdateCatchUpPromiseMutation(id: promiseId, data: promiseInput)
      ).subscribe(onSuccess: { data in
        if let promise = CatchUpPromise(promiseData: data.updateCatchUpPromise) {
            strongSelf.confirmAndNotify(promise: promise)
          }
        }, onError: { error in
          strongSelf.createPromiseState.value = .error(description: error.localizedDescription)
        }).disposed(by: strongSelf.disposeBag)
      
      return .empty()
    }
  }()
  
  private func confirmAndNotify(promise: CatchUpPromise) {
    let timeFormat = DateFormatter()
    timeFormat.dateFormat = "MM.dd (EEE) a hh시 mm분"
    timeFormat.locale = Locale.current
    let title = isEditMode.value ? "변경된 약속 알림" : "새로운 약속 알림"
    let dateTime = timeFormat.string(from: promise.dateTime)
    
    let tokens = promise.contacts.compactMap { phone in
      return ContactItem.find(phone: phone)?.pushToken
      }.filter { !$0.isEmpty }
    
    createPromiseState.value = .completed(promise: promise)
    PushMessageService.sendPush(title: title, message: "일시: \(dateTime), 장소: \(address)", pushTokens: tokens)
  }
}

extension NewPromiseViewModel: NewPromiseViewModelInputsType, NewPromiseViewModelOutputsType, NewPromiseViewModelActionsType {}
