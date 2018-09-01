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
import Apollo
import RealmSwift

class MainViewController: UIViewController, BindableType {
  @IBOutlet weak var promiseListTableView: UITableView!
  @IBOutlet weak var newPromiseButton: UIButton!
  @IBOutlet weak var monthSelectButton: UIButton!
  @IBOutlet weak var promiseGuide: UIImageView!
  
  var viewModel: MainViewModel!
  var needSignIn = false
  var isConfigured = false
  
  let disposeBag = DisposeBag()
  
  lazy var configureCell: (TableViewSectionedDataSource<PromiseSectionModel>, UITableView, IndexPath, GetUserWithPromisesQuery.Data.User.Pocket.PromiseList) -> UITableViewCell = { [weak self] data, tableView, indexPath, promise in
    guard let strongSelf = self else { return PromiseTableViewCell(frame: .zero) }
    
    let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.promiseTableViewCell, for: indexPath)
    cell?.configure(promise: promise)
    
    cell?.itemView.rx.tapGesture().when(.recognized).subscribe(onNext: { _ in
      strongSelf.viewModel.actions.pushPromiseDetailScene.execute(promise.id ?? "")
      
      strongSelf.navigationController?.navigationBar.backgroundColor = .darkSkyBlue
      strongSelf.navigationController?.navigationBar.barStyle = .blackOpaque
    }).disposed(by: strongSelf.disposeBag)
    return cell!
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    UIApplication.shared.statusBarView?.backgroundColor = .white
    
    let session = KOSession.shared()
    guard let s = session, s.isOpen() else {
      needSignIn = true
      return
    }
  }

  func bindViewModel() {
    viewModel.state.subscribe(onNext: { [weak self] (state) in
      guard let strongSelf = self else { return }
      switch state {
        case .completed:
          let permissionSet = PermissionSet([.notifications, .contacts, .locationAlways])
          if let vc = R.storyboard.main.permissionsViewController(), permissionSet.status != .authorized {
            strongSelf.present(vc, animated: true, completion: nil)
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
    
    viewModel.promiseItems
      .bind(to: promiseListTableView.rx.items(dataSource: RxTableViewSectionedAnimatedDataSource<PromiseSectionModel>(configureCell: configureCell)))
      .disposed(by: disposeBag)
    
    viewModel.promiseItems.subscribe(onNext: { sectionModel in
      if let items = sectionModel.first?.items, !items.isEmpty {
        self.promiseGuide.isHidden = true
      } else {
        self.promiseGuide.isHidden = false
      }
    }).disposed(by: disposeBag)
    
    viewModel.outputs.current.map { (month, year) in
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

