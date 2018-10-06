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
  var editMode: Observable<Bool> { get }
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
  var editPromiseDone: PublishSubject<String>?
  
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
  
  func applyPreviousInfo(id: String, prevTimestamp: Int, name: String, address: String, datetime: DateComponents, latitude: Double, longitude: Double, pockets: [String]) {
    self.promiseId.value = id
    self.prevTimestamp.value = prevTimestamp
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
      if strongSelf.isEditMode.value, let promiseId = strongSelf.promiseId.value {
        strongSelf.editPromiseDone?.onNext(promiseId)
        let viewModel = PromiseDetailViewModel(coordinator: strongSelf.sceneCoordinator, client: strongSelf.apiClient, promiseId: promiseId)
        strongSelf.sceneCoordinator.transition(to: PromiseDetailScene(viewModel: viewModel), type: .pop(animated: true, level: .parent))
      } else {
        strongSelf.addPromiseDone?.onNext(())
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
      
      let backgroundScheduler = SerialDispatchQueueScheduler(qos: .default)
      let calendar = Calendar(identifier: .gregorian)
      
      var components = strongSelf.dateComponents.value
      components?.hour = strongSelf.timeComponents.value?.hour
      components?.minute = strongSelf.timeComponents.value?.minute
      components?.second = strongSelf.timeComponents.value?.second
      
      guard let dateTimeComponents = components else { return .empty() }
      guard let owner = UserDefaultService.phoneNumber else { return .empty() }
      
      let tokens = strongSelf.pockets.value.compactMap { phone in
        return ContactItem.find(phone: phone)?.pushToken
      }
      
      let promiseInput = CatchUpPromiseInput(
        owner: owner,
        dateTime: Formatter.iso8601.string(from: calendar.date(from: dateTimeComponents) ?? Date()),
        address: strongSelf.address.value,
        latitude: strongSelf.coordinate.value?.latitude,
        longitude: strongSelf.coordinate.value?.longitude,
        name: strongSelf.promiseName.value,
        contacts: strongSelf.pockets.value
      )
      
      let timeFormat = DateFormatter()
      timeFormat.dateFormat = "MM.dd (EEE) a hh시 mm분"
      
      
      if strongSelf.isEditMode.value {
        if let id = strongSelf.promiseId.value, let prevTimestamp = strongSelf.prevTimestamp.value {
          apollo?.perform(mutation: UpdatePromiseMutation(
            id: id,
            prevTimestamp: String(prevTimestamp),
            owner: strongSelf.owner.value,
            name: strongSelf.promiseName.value,
            address: strongSelf.address.value,
            latitude: strongSelf.coordinate.value?.latitude,
            longitude: strongSelf.coordinate.value?.longitude,
            timestamp: String(calendar.date(from: dateTimeComponents)?.timeInMillis ?? 0),
            pockets: strongSelf.pockets.value
          )) { (result, error) in
            
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
              
              apollo?.fetch(query: SendPushQuery(pushTokens: tokens, title: "새로운 약속 일정 알림", body: "일시: \(dateTime), 장소: \(location)", scheduledTime: "\(Date().timeInMillis)"))
            }
            
            if let id = result?.data?.updatePromise?.id {
              strongSelf.promiseId.value = id
            }
          }
        }
      } else {
        strongSelf.apiClient.rx.perform(
          mutation: UpdateCatchUpPromiseMutation(id: UUID().uuidString, data: promiseInput),
          queue: DispatchQueue(label: Define.queueLabelCreatePromise)
        ).subscribeOn(backgroundScheduler)
          .observeOn(MainScheduler.instance)
          .subscribe(onSuccess: { data in
            if let promise = data.updateCatchUpPromise, let date = calendar.date(from: dateTimeComponents), let address = promise.address, let contacts = promise.contacts {
              let dateTime = timeFormat.string(from: date)
              strongSelf.formatPromiseConfirm(dateTime: dateTime, address: address, contacts: contacts)
              PushMessageService.sendPush(title: "새로운 약속 알림", message: "일시: \(dateTime), 장소: \(address)", pushTokens: tokens)
            }
          }, onError: { error in
            print(error)
            print(error.localizedDescription)
            strongSelf.createPromiseState.value = .error(description: error.localizedDescription)
          }).disposed(by: strongSelf.disposeBag)
      }
      
      return .empty()
    }
  }()
  
  private func formatPromiseConfirm(dateTime: String?, address: String?, contacts: [String?]?) {
    if let dateTime = dateTime, let address = address, let contacts = contacts?.compactMap({ $0 }), !contacts.isEmpty {
      var members: String = ""
      
      if let member = ContactItem.find(phone: contacts.first ?? "None")?.nickname {
        if contacts.count > 1 {
          members = "\(member) 외 \(contacts.count - 1)명"
        } else {
          members = member
        }
      }
      
      createPromiseState.value = .completed(dateTime: dateTime, location: address, members: members)
    }
  }
}

extension NewPromiseViewModel: NewPromiseViewModelInputsType, NewPromiseViewModelOutputsType, NewPromiseViewModelActionsType {}
