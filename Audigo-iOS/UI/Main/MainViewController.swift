//
//  ViewController.swift
//  Audigo-iOS
//
//  Created by hPark on 2018. 6. 7..
//  Copyright © 2018년 BlackBurn. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, BindableType {
  var viewModel: MainViewModel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let vc = R.storyboard.main.entranceViewController() {
      present(vc, animated: false, completion: nil)
    }
    
//    present(R.storyboard.main., animated: <#T##Bool#>, completion: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>)
//
//
  }

  func bindViewModel() {
  }

}

