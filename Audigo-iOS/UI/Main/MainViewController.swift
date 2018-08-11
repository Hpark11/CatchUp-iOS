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
  var viewModel: MainViewModel!
  
  let disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if let vc = R.storyboard.main.entranceViewController() {
      vc.signInDone = viewModel.signInDone
      present(vc, animated: false, completion: nil)
    }
  }

  func bindViewModel() {
    viewModel.state.subscribe(onNext: { [weak self] (state) in
      guard let strongSelf = self else { return }
      switch state {
      case .completed:
        break
      case .phoneRequired:
        if let vc = R.storyboard.main.phoneCheckViewController() {
          strongSelf.present(vc, animated: false, completion: nil)
        }
        break
      case .failed:
        break
      }
    }).disposed(by: disposeBag)
  }

}

