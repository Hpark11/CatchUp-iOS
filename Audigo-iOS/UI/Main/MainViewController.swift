//
//  ViewController.swift
//  Audigo-iOS
//
//  Created by hPark on 2018. 6. 7..
//  Copyright © 2018년 BlackBurn. All rights reserved.
//

import UIKit
import RxSwift

class MainViewController: UIViewController, BindableType {
  @IBOutlet weak var promiseListTableView: UITableView!
  
  var viewModel: MainViewModel!
  
  let disposeBag = DisposeBag()
  
  var needSignIn = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let session = KOSession.shared()
    guard let s = session, s.isOpen() else {
      needSignIn = true
      return
    }
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
  }
}
//
//extension MainViewController: UITableViewDelegate, UITableViewDataSource {
//  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    <#code#>
//  }
//  
//  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//    <#code#>
//  }
//}

