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
import CoreLocation

enum CreatePromiseState {
  case normal
  case pending
  case completed(promise: PromiseItem)
  case error(description: String)
}

protocol NewPromiseViewModelInputsType {
  var nameSetDone: PublishSubject<String> { get }
  var addressSetDone: PublishSubject<String> { get }
  var pocketSelectDone: PublishSubject<[String]> { get }
  var coordinateSetDone: PublishSubject<CLLocationCoordinate2D> { get }
  var dateSelectDone: PublishSubject<DateComponents> { get }
  var timeSelectDone: PublishSubject<DateComponents> { get }
}

protocol NewPromiseViewModelOutputsType {
  var dateItems: Observable<DateComponents?> { get }
  var timeItems: Observable<DateComponents?> { get }
  var isEnabled: Observable<Bool> { get }
  var name: Observable<String?> { get }
  var place: Observable<String?> { get }
  var state: Observable<CreatePromiseState> { get }
  var editMode: Observable<Bool> { get }
}

protocol NewPromiseViewModelActionsType {
  var popScene: Action<PromiseItem?, Void> { get }
  var newPromiseCompleted: Action<Void, String> { get }
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
  var addressSetDone: PublishSubject<String>
  var pocketSelectDone: PublishSubject<[String]>
  var coordinateSetDone: PublishSubject<CLLocationCoordinate2D>
  var memberSelectDone: PublishSubject<Set<String>>
  
  // MARK: Outputs
  var dateItems: Observable<DateComponents?>
  var timeItems: Observable<DateComponents?>
  var isEnabled: Observable<Bool>
  var state: Observable<CreatePromiseState>
  var name: Observable<String?>
  var place: Observable<String?>
  var editMode: Observable<Bool>
  
  var addPromiseDone: PublishSubject<Void>?
  var editPromiseDone: PublishSubject<PromiseItem>?
  
  fileprivate var owner: Variable<String>
  fileprivate var dateComponents: Variable<DateComponents?>
  fileprivate var timeComponents: Variable<DateComponents?>
  fileprivate var promiseName: Variable<String?>
  fileprivate var address: Variable<String?>
  fileprivate var coordinate: Variable<CLLocationCoordinate2D?>
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
    name = promiseName.asObservable()
    place = address.asObservable()
    self.editMode = isEditMode.asObservable()
    
    isEnabled = Observable.combineLatest(
      dateComponents.asObservable(),
      timeComponents.asObservable(),
      promiseName.asObservable(),
      address.asObservable(),
      coordinate.asObservable()
      ).map { (arg) -> Bool in
        let (dateComponents, timeComponents, name, address, coordinate) = arg
        guard let _ = dateComponents, let _ = timeComponents, let _ = coordinate, let _ = name, let _ = address else { return false }
        return true
    }
    
    state = createPromiseState.asObservable()
    
    // Inputs
    dateSelectDone.subscribe(onNext: { [weak self] components in
      guard let `self` = self else { return }
      self.dateComponents.value = components
    }).disposed(by: disposeBag)
    
    timeSelectDone.subscribe(onNext: { [weak self] components in
      guard let `self` = self else { return }
      self.timeComponents.value = components
    }).disposed(by: disposeBag)
    
    nameSetDone.subscribe(onNext: { [weak self] name in
      guard let `self` = self else { return }
      self.promiseName.value = name
    }).disposed(by: disposeBag)
    
    addressSetDone.subscribe(onNext: { [weak self] address in
      guard let `self` = self else { return }
      self.address.value = address
    }).disposed(by: disposeBag)
    
    coordinateSetDone.subscribe(onNext: { [weak self] coordinate in
      guard let `self` = self else { return }
      self.coordinate.value = coordinate
    }).disposed(by: disposeBag)
  }
  
  func applyPreviousInfo(promise: PromiseItem) {
    let calendar = Calendar(identifier: .gregorian)
    let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: promise.dateTime)
    
    self.promiseId.value = promise.id
    self.promiseName.value = promise.name
    self.address.value = promise.address
    self.dateComponents.value = components
    self.timeComponents.value = components
    self.coordinate.value = CLLocationCoordinate2D(latitude: promise.latitude, longitude: promise.longitude)
  }
  
  lazy var popScene: Action<PromiseItem?, Void> = {
    return Action { [weak self] promiseData in
      guard let `self` = self else { return .empty() }
      
      if self.isEditMode.value {
        let viewModel = PromiseDetailViewModel(coordinator: self.sceneCoordinator, client: self.apiClient)
        if let promise = promiseData { self.editPromiseDone?.onNext(promise) }
        self.sceneCoordinator.transition(to: PromiseDetailScene(viewModel: viewModel), type: .pop(animated: true, level: .parent))
        
      } else {
        if promiseData != nil { self.addPromiseDone?.onNext(()) }
        let viewModel = MainViewModel(coordinator: self.sceneCoordinator, client: self.apiClient)
        self.sceneCoordinator.transition(to: MainScene(viewModel: viewModel), type: .pop(animated: true, level: .parent))
      }
      return .empty()
    }
  }()
  
  lazy var newPromiseCompleted: Action<Void, String> = {
    return Action { [weak self] _ in
      guard let `self` = self else { return .just("") }
      self.createPromiseState.value = .pending
      
      let isEdit = self.isEditMode.value
      let promiseId = self.promiseId.value ?? UUID().uuidString
      let calendar = Calendar(identifier: .gregorian)
      
      var components = self.dateComponents.value
      components?.hour = self.timeComponents.value?.hour
      components?.minute = self.timeComponents.value?.minute
      components?.second = self.timeComponents.value?.second
      
      guard let dateTimeComponents = components else { return .just("일자 선정 오류") }
      guard let owner = UserDefaultService.phoneNumber else { return .just("핸드폰 번호 오류") }
      
      let promiseInput = CatchUpPromiseInput(
        owner: owner,
        dateTime: Formatter.iso8601.string(from: calendar.date(from: dateTimeComponents) ?? Date()),
        address: self.address.value,
        latitude: self.coordinate.value?.latitude,
        longitude: self.coordinate.value?.longitude,
        name: self.promiseName.value,
        contacts: [owner]
      )
      
      self.apiClient.rx.perform(mutation: UpdateCatchUpPromiseMutation(id: promiseId, data: promiseInput))
        .subscribe(onSuccess: { data in
          if let promise = PromiseItem(promise: data.updateCatchUpPromise) {
            self.confirmAndNotify(promise: promise)
          }
        }, onError: { error in
          self.createPromiseState.value = .error(description: error.localizedDescription)
        }).disposed(by: self.disposeBag)
      
      return .just("")
    }
  }()
  
  private func confirmAndNotify(promise: PromiseItem) {
    let timeFormat = DateFormatter()
    timeFormat.dateFormat = "MM.dd (EEE) a hh시 mm분"
    timeFormat.locale = Locale.current
    let title = isEditMode.value ? "변경된 약속 알림" : "새로운 약속 알림"
    let dateTime = timeFormat.string(from: promise.dateTime)
    
    let tokens = promise.contacts.compactMap { phone in
      return ContactItem.find(phone: phone)?.pushToken
    }.filter { !$0.isEmpty }
    
    createPromiseState.value = .completed(promise: promise)
    PushMessageService.sendPush(title: title, message: "일시: \(dateTime), 장소: \(address)", pushTokens: Array(tokens))
  }
}

extension NewPromiseViewModel: NewPromiseViewModelInputsType, NewPromiseViewModelOutputsType, NewPromiseViewModelActionsType {}
