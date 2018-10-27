//
//  MainViewModel.swift
//  Audigo-iOS
//
//  Created by hPark on 2018. 8. 4..
//  Copyright © 2018년 BlackBurn. All rights reserved.
//

import RxSwift
import RxDataSources
import Action
import SwiftyContacts
import AWSAppSync

typealias PromiseSectionModel = AnimatableSectionModel<String, PromiseItem>

protocol MainViewModelInputsType {
  var monthSelectDone: PublishSubject<(Int, Int)> { get }
  var addPromiseDone: PublishSubject<Void> { get }
  var hasPromiseBeenUpdated: PublishSubject<Bool> { get }
}

protocol MainViewModelOutputsType {
  var promiseItems: Observable<[PromiseSectionModel]> { get }
  var current: Observable<(Int, Int)> { get }
  var appVersion: Maybe<AppVersion> { get }
}

protocol MainViewModelActionsType {
  var pushNewPromiseScene: CocoaAction { get }
  var pushPromiseDetailScene: Action<PromiseItem, Void> { get }
}

protocol MainViewModelType {
  var inputs:  MainViewModelInputsType  { get }
  var outputs: MainViewModelOutputsType { get }
  var actions: MainViewModelActionsType { get }
}

class MainViewModel: MainViewModelType {
  var inputs:  MainViewModelInputsType  { return self }
  var outputs: MainViewModelOutputsType { return self }
  var actions: MainViewModelActionsType { return self }
  
  // MARK: Setup
  fileprivate var sceneCoordinator: SceneCoordinatorType
  fileprivate let apiClient: AWSAppSyncClient
  fileprivate let disposeBag = DisposeBag()
  
  // MARK: Inputs
  var monthSelectDone: PublishSubject<(Int, Int)>
  var addPromiseDone: PublishSubject<Void>
  var hasPromiseBeenUpdated: PublishSubject<Bool>
  
  // MARK: Outputs
  var promiseItems: Observable<[PromiseSectionModel]>
  var current: Observable<(Int, Int)>
  var appVersion: Maybe<AppVersion>
  
  private let userInfo: Variable<(id: String?, phone: String?, email: String?, nickname: String?, gender: String?, birthday: String?, ageRange: String?, profileImagePath: String?)>
  private let promiseList: Variable<[PromiseItem]>
  private let filteredList: Variable<[PromiseItem]>
  private let currentMonth: Variable<(Int, Int)>
  
  var phone: String = "" {
    didSet {
      if !phone.isEmpty {
        refreshPromiseList()
      }
    }
  }
  
  init(coordinator: SceneCoordinatorType, client: AWSAppSyncClient) {
    let calendar = Calendar(identifier: .gregorian)
    sceneCoordinator = coordinator
    apiClient = client
    
    monthSelectDone = PublishSubject()
    addPromiseDone = PublishSubject()
    hasPromiseBeenUpdated = PublishSubject()
    
    userInfo = Variable((id: nil, phone: nil, email: nil, nickname: nil, gender: nil, birthday: nil, ageRange: nil, profileImagePath: nil))
    promiseList = Variable([])
    filteredList = Variable([])
    currentMonth = Variable((calendar.component(.month, from: Date()), calendar.component(.year, from: Date())))
    
    promiseItems = filteredList.asObservable()
      .map({ (promiseList) in
        return [PromiseSectionModel(model: "", items: promiseList)]
      })
    
    current = currentMonth.asObservable()
    
    appVersion = apiClient.rx.fetch(query: CheckAppVersionQuery(platform: Define.platform), cachePolicy: .fetchIgnoringCacheData)
      .map { data -> AppVersion in
        return AppVersion(
          major: data.checkAppVersion.major ?? Define.majorVersion,
          minor: data.checkAppVersion.minor ?? Define.minorVersion,
          revision: data.checkAppVersion.revision ?? Define.revision
        )
    }
    
    // Inputs
    monthSelectDone.subscribe(onNext: { [weak self] (month, year) in
      guard let strongSelf = self else { return }
      strongSelf.filterPromisesByMonth(month: month, year: year)
      strongSelf.currentMonth.value = (month, year)
    }).disposed(by: disposeBag)
    
    addPromiseDone.subscribe(onNext: { [weak self] _ in
      guard let strongSelf = self else { return }
      strongSelf.refreshPromiseList()
    }).disposed(by: disposeBag)
    
    hasPromiseBeenUpdated.subscribe(onNext: { [weak self] hasUpdated in
      guard let strongSelf = self else { return }
      strongSelf.refreshPromiseList()
    }).disposed(by: disposeBag)
    
    // Location Tracking ---------------------------------------------------------------------------------------]
    LocationTrackingService.shared.startUpdatingLocation()
    
    // Contact Update ------------------------------------------------------------------------------------------]
    let backgroundScheduler = SerialDispatchQueueScheduler(qos: .default)
    rx_fetchContacts().map({ contacts in
      return contacts.compactMap {
        ($0.phoneNumbers.first?.value.stringValue ?? "", "\($0.familyName)\($0.givenName)")
      }
    }).subscribeOn(backgroundScheduler).map { contacts in
        return contacts.map { contact in
          return (
            contact.0.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: ""),
            contact.1
          )
        }.filter { contact in
          return contact.0.starts(with: Define.koreanNormalCellPhonePrefix)
        }
      }.do(onNext: { contacts in
        contacts.forEach { (phone, nickname) in
          ContactItem.add(phone, nickname: nickname)
        }
        
      }).flatMap({ contacts -> Observable<BatchGetCatchUpContactsQuery.Data> in
        let ops = contacts.map { contact in
          return contact.0
        }.chunked(into: Define.dynamoDbBatchLimit).compactMap { chunk in
          return client.rx.fetch(query: BatchGetCatchUpContactsQuery(ids: chunk), cachePolicy: .returnCacheDataAndFetch).asObservable()
        }
        
        return Observable.merge(ops)
      })
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { data in
        if let contacts = data.batchGetCatchUpContacts {
          contacts.forEach { contactData in
            if let contact = contactData {
              ContactItem.create(contact.phone, imagePath: contact.profileImagePath ?? "", pushToken: contact.pushToken ?? "")
            }
          }
        }
      }, onError: { (error) in
        print(error.localizedDescription)
      }).disposed(by: disposeBag)
  }
  
  private func filterPromisesByMonth(month: Int, year: Int) {
    let calendar = Calendar(identifier: .gregorian)
    if let start = calendar.date(from: DateComponents(year: year, month: month, day: 1)), let end = calendar.date(byAdding: .month, value: 1, to: start) {
      filteredList.value = promiseList.value.filter {
        let timeInMillis = $0.dateTime.timeInMillis
        return timeInMillis >= start.timeInMillis && timeInMillis < end.timeInMillis
      }
    }
  }
  
  private func refreshPromiseList() {
    apiClient.rx.watch(query: ListCatchUpPromisesByContactQuery(contact: phone))
      .subscribe(onNext: { [weak self] data in
        guard let strongSelf = self else { return }
        let now = Date().timeInMillis
        
        strongSelf.promiseList.value = data.listCatchUpPromisesByContact?.compactMap(PromiseItem.init).sorted {
          let lhs = $0.dateTime.timeInMillis
          let rhs = $1.dateTime.timeInMillis
          return (lhs + 3600000 > now ? lhs : lhs * 2) < (rhs + 3600000 > now ? rhs : rhs * 2)
          } ?? []
        
        let current = strongSelf.currentMonth.value
        strongSelf.filterPromisesByMonth(month: current.0, year: current.1)
      }).disposed(by: disposeBag)
  }
  
  lazy var pushNewPromiseScene: CocoaAction = {
    return Action { [weak self] in
      guard let strongSelf = self else { return .empty() }
      
      let viewModel = NewPromiseViewModel(
        coordinator: strongSelf.sceneCoordinator, client: strongSelf.apiClient,
        ownerPhoneNumber: strongSelf.userInfo.value.phone ?? ""
      )
      
      viewModel.addPromiseDone = strongSelf.addPromiseDone
      let scene = NewPromiseScene(viewModel: viewModel)
      return strongSelf.sceneCoordinator.transition(to: scene, type: .modal(animated: true))
    }
  }()
  
  lazy var pushPromiseDetailScene: Action<PromiseItem, Void> = {
    return Action { [weak self] promise in
      guard let strongSelf = self else { return .empty() }
      let viewModel = PromiseDetailViewModel(coordinator: strongSelf.sceneCoordinator, client: strongSelf.apiClient)
      viewModel.promise = promise
      viewModel.hasPromiseBeenUpdated = strongSelf.hasPromiseBeenUpdated
      let scene = PromiseDetailScene(viewModel: viewModel)
      return strongSelf.sceneCoordinator.transition(to: scene, type: .push(animated: true))
    }
  }()
}

extension MainViewModel: MainViewModelInputsType, MainViewModelOutputsType, MainViewModelActionsType {}


