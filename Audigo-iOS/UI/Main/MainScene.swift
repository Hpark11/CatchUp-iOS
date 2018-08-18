//
//  MainScene.swift
//  Audigo-iOS
//
//  Created by hPark on 2018. 8. 4..
//  Copyright © 2018년 BlackBurn. All rights reserved.
//

import Foundation
import UIKit.UINib
import UIKit.UIViewController

struct MainScene: SceneType, InstantiatableFromStoryboard {
  var viewModel: MainViewModel
  
  func instantiateFromStoryboard() -> UIViewController {
    guard let nc = R.storyboard.main.mainNavigationController() else {
      fatalError("Unable to instantiate a view controller")
    }

    guard let vc = nc.viewControllers.first as? MainViewController else {
      fatalError("Unable to instantiate a view controller")
    }

    vc.bindViewModel(to: self.viewModel)
    return nc
  }
}

