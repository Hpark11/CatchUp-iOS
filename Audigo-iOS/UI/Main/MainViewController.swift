//
//  ViewController.swift
//  Audigo-iOS
//
//  Created by hPark on 2018. 6. 7..
//  Copyright © 2018년 BlackBurn. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

class MainViewController: UIViewController, BindableType {
  @IBOutlet weak var promiseListTableView: UITableView!
  @IBOutlet weak var newPromiseButton: UIButton!
  
  var viewModel: MainViewModel!
  
  let disposeBag = DisposeBag()
  let dataSource = RxTableViewSectionedAnimatedDataSource<PromiseSectionModel>(configureCell: { data, tableView, indexPath, promise in
    let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.promiseTableViewCell, for: indexPath)
    cell?.configure(promise: promise)
    return cell!
  })
  
  var needSignIn = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let session = KOSession.shared()
    guard let s = session, s.isOpen() else {
      needSignIn = true
      return
    }
    
    viewModel.promiseItems
      .bind(to: promiseListTableView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    if needSignIn {
      if let vc = R.storyboard.main.entranceViewController() {
        vc.signInDone = viewModel.signInDone
        present(vc, animated: false, completion: nil)
        needSignIn = false
      }
    } else {
      viewModel.signInDone.onNext(())
    }
  }

  func bindViewModel() {
    viewModel.state.subscribe(onNext: { [weak self] (state) in
      guard let strongSelf = self else { return }
      switch state {
      case .completed:
        strongSelf.viewModel.configureUser()
        break
      case .phoneRequired:
        if let vc = R.storyboard.main.phoneCheckViewController() {
          vc.phoneCertifyDone = strongSelf.viewModel.phoneCertifyDone
          strongSelf.present(vc, animated: false, completion: nil)
        }
        break
      case .failed:
        break
      }
    }).disposed(by: disposeBag)
    
    newPromiseButton.rx.action = viewModel.actions.pushNewPromiseScene
  }
}

