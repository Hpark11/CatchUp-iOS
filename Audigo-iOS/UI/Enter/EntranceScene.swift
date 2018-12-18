//
//  EntranceScene.swift
//  Audigo-iOS
//
//  Created by hPark on 2018. 10. 4..
//  Copyright © 2018년 BlackBurn. All rights reserved.
//

import Foundation

struct EntranceScene: SceneType, InstantiatableFromStoryboard {
  var viewModel: EntranceViewModel
  
  func instantiateFromStoryboard() -> UIViewController {
    guard let vc = R.storyboard.main.entranceViewController() else {
      fatalError("Unable to instantiate a view controller")
    }
    
    vc.bindViewModel(to: self.viewModel)
    return vc
  }
}
