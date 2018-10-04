//
//  ViewController.swift
//  Audigo-iOS
//
//  Created by hPark on 2018. 6. 7..
//  Copyright © 2018년 BlackBurn. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Permission
import RealmSwift
import SwiftyContacts

class MainViewController: UIViewController, BindableType {
  @IBOutlet weak var promiseListTableView: UITableView!
  @IBOutlet weak var newPromiseButton: UIButton!
  @IBOutlet weak var monthSelectButton: UIButton!
  @IBOutlet weak var promiseGuide: UIImageView!
  
  var viewModel: MainViewModel!
  var needSignIn = false
  var isConfigured = false
  var current: (month: Int, year: Int)?
  
  let disposeBag = DisposeBag()
  
  lazy var configureCell: (TableViewSectionedDataSource<PromiseSectionModel>, UITableView, IndexPath, GetUserWithPromisesQuery.Data.User.Pocket.PromiseList) -> UITableViewCell = { [weak self] data, tableView, indexPath, promise in
    guard let strongSelf = self else { return PromiseTableViewCell(frame: .zero) }
    
    let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.promiseTableViewCell, for: indexPath)
    cell?.configure(promise: promise)
    return cell!
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    UIApplication.shared.statusBarView?.backgroundColor = .white
  }
  
  func bindViewModel() {
    viewModel.state.subscribe(onNext: { [weak self] (state) in
      guard let strongSelf = self else { return }
      switch state {
      case .completed:
        let permissionSet = PermissionSet([.notifications, .contacts, .locationAlways])
        if let vc = R.storyboard.main.permissionsViewController(), permissionSet.status != .authorized {
          vc.contactAuthorized = strongSelf.viewModel.contactAuthorized
          strongSelf.present(vc, animated: true, completion: nil)
        } else {
          strongSelf.viewModel.contactAuthorized.onNext(true)
        }
        strongSelf.viewModel.configureUser()
        strongSelf.isConfigured = true
      case .phoneRequired:
        if let vc = R.storyboard.main.phoneCheckViewController() {
          vc.phoneCertifyDone = strongSelf.viewModel.phoneCertifyDone
          strongSelf.present(vc, animated: true, completion: nil)
        }
      case .failed:
        break
      }
    }).disposed(by: disposeBag)
    
    let dataSource = RxTableViewSectionedAnimatedDataSource<PromiseSectionModel>(configureCell: configureCell)
    
    viewModel.promiseItems
      .bind(to: promiseListTableView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
    
    Observable.zip(promiseListTableView.rx.itemSelected, promiseListTableView.rx.modelSelected(GetUserWithPromisesQuery.Data.User.Pocket.PromiseList.self)).bind { [weak self] indexPath, promise in
      guard let strongSelf = self else { return }
      strongSelf.promiseListTableView.deselectRow(at: indexPath, animated: true)
      strongSelf.viewModel.actions.pushPromiseDetailScene.execute(promise.id ?? "")
      
      strongSelf.navigationController?.navigationBar.backgroundColor = .darkSkyBlue
      strongSelf.navigationController?.navigationBar.barStyle = .blackOpaque
    }.disposed(by: disposeBag)
    
    viewModel.promiseItems.subscribe(onNext: { [weak self] sectionModel in
      guard let strongSelf = self else { return }
      if let items = sectionModel.first?.items, !items.isEmpty {
        strongSelf.promiseGuide.isHidden = true
      } else {
        strongSelf.promiseGuide.isHidden = false
      }
    }).disposed(by: disposeBag)
    
    viewModel.outputs.current.map { [weak self] (month, year) in
      if let strongSelf = self {
        strongSelf.current = (month: month, year: year)
      }
      
      let calendar = Calendar(identifier: .gregorian)
      let timeFormat = DateFormatter()
      timeFormat.dateFormat = "yyyy.MM"
      
      let dateTime = calendar.date(from: DateComponents(year: year, month: month, day: 1)) ?? Date()
      return timeFormat.string(from: dateTime)
      }.bind(to: monthSelectButton.rx.title())
      .disposed(by: disposeBag)
    
    newPromiseButton.rx.action = viewModel.actions.pushNewPromiseScene
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if needSignIn {
      if let vc = R.storyboard.main.entranceViewController() {
        vc.signInDone = viewModel.signInDone
        present(vc, animated: true, completion: nil)
        needSignIn = false
      }
    } else if !isConfigured {
      viewModel.signInDone.onNext(())
    }
  }
  
  @IBAction func selectMonth(_ sender: Any) {
    if let vc = R.storyboard.main.monthPopupViewController() {
      let dateFormatter = DateFormatter()
      let calendar = Calendar(identifier: .gregorian)
      dateFormatter.dateFormat = "yyyy.MM"
      
      if let date = dateFormatter.date(from: monthSelectButton.currentTitle ?? "") {
        vc.monthSelectDone = self.viewModel.monthSelectDone
        vc.month = calendar.component(.month, from: date)
        vc.year = calendar.component(.year, from: date)
        self.present(vc, animated: true, completion: nil)
      }
    }
  }
}

