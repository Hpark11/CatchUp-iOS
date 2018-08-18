//
//  PromiseDetailScene.swift
//  Audigo-iOS
//
//  Created by hPark on 2018. 8. 18..
//  Copyright © 2018년 BlackBurn. All rights reserved.
//

import Foundation

struct PromiseDetailScene: SceneType, InstantiatableFromStoryboard {
  var viewModel: PromiseDetailViewModel
  
  func instantiateFromStoryboard() -> UIViewController {
    guard let vc = R.storyboard.main.promiseDetailViewController() else {
      fatalError("Unable to instantiate a view controller")
    }
    
    vc.bindViewModel(to: self.viewModel)
    return vc
  }
}
