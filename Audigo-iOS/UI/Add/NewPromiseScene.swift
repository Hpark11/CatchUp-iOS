//
//  NewPromiseScene.swift
//  Audigo-iOS
//
//  Created by hPark on 2018. 8. 12..
//  Copyright © 2018년 BlackBurn. All rights reserved.
//

import Foundation

struct NewPromiseScene: SceneType, InstantiatableFromStoryboard {
  var viewModel: NewPromiseViewModel
  
  func instantiateFromStoryboard() -> UIViewController {
    guard let vc = R.storyboard.main.newPromiseViewController() else {
      fatalError("Unable to instantiate a view controller")
    }
    
    vc.bindViewModel(to: self.viewModel)
    return vc
  }
}
