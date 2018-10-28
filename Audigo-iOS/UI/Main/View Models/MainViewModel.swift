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
import AWSAppSync
import RealmSwift

typealias PromiseSectionModel = AnimatableSectionModel<String, PromiseItem>

protocol MainViewModelInputsType {
  var monthSelectDone: PublishSubject<(Int, Int)> { get }
  var addPromiseDone: PublishSubject<Void> { get }
  var hasPromiseBeenUpdated: PublishSubject<Bool> { get }
  var leftPromise: PublishSubject<PromiseItem> { get }
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
  var leftPromise: PublishSubject<PromiseItem>
  
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
  
  private var token: NotificationToken? = nil
  
  init(coordinator: SceneCoordinatorType, client: AWSAppSyncClient) {
    let calendar = Calendar(identifier: .gregorian)
    sceneCoordinator = coordinator
    apiClient = client
    
    monthSelectDone = PublishSubject()
    addPromiseDone = PublishSubject()
    hasPromiseBeenUpdated = PublishSubject()
    leftPromise = PublishSubject()
    
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
    
    token = PromiseItem.all().observe { [weak self] change in
      guard let `self` = self else { return }
      switch change {
      case .initial(let items):
        self.promiseList.value = self.sortedPromiseList(items: items)
      case .update(let items, _, _, _):
        self.promiseList.value = self.sortedPromiseList(items: items)
      case .error(let error):
        print(error.localizedDescription)
      }
      
      let current = self.currentMonth.value
      self.filterPromisesByMonth(month: current.0, year: current.1)
    }
    
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
    
    leftPromise
      .flatMapLatest { promise -> PrimitiveSequence<MaybeTrait, RemoveContactIntoPromiseMutation.Data> in
        guard let userId = UserDefaultService.userId else {
          fatalError("There is No User Id")
        }
      
        return self.apiClient.rx.perform(mutation: RemoveContactIntoPromiseMutation(id: promise.id, phone: userId))
      }.subscribe (onNext: { data in
        if let promiseId = data.removeContactIntoPromise?.id {
          PromiseItem.leave(id: promiseId)
        }
      }).disposed(by: disposeBag)
    
    // Location Tracking ---------------------------------------------------------------------------------------]
    LocationTrackingService.shared.startUpdatingLocation()
  }
  
  deinit {
    token?.invalidate()
  }
  
  private func filterPromisesByMonth(month: Int, year: Int) {
    let calendar = Calendar(identifier: .gregorian)
    if let start = calendar.date(from: DateComponents(year: year, month: month, day: 1)),
      let end = calendar.date(byAdding: .month, value: 1, to: start) {
      filteredList.value = promiseList.value.filter {
        let timeInMillis = $0.dateTime.timeInMillis
        return timeInMillis >= start.timeInMillis && timeInMillis < end.timeInMillis
      }
    }
  }
  
  private func sortedPromiseList(items: Results<PromiseItem>) -> [PromiseItem] {
    let now = Date().timeInMillis
    return items.sorted {
      let lhs = $0.dateTime.timeInMillis
      let rhs = $1.dateTime.timeInMillis
      return (lhs + 3600000 > now ? lhs : lhs * 2) < (rhs + 3600000 > now ? rhs : rhs * 2)
    }
  }
  
  private func refreshPromiseList() {
    apiClient.rx.watch(query: ListCatchUpPromisesByContactQuery(contact: phone))
      .subscribe(onNext: { data in
        PromiseItem.addAll(promises: data.listCatchUpPromisesByContact ?? [])
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


