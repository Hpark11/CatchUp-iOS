//
//  BindableTypes.swift
//  Audigo-iOS
//
//  Created by hPark on 2018. 8. 4..
//  Copyright © 2018년 BlackBurn. All rights reserved.
//

import Foundation
import UIKit

protocol BindableType: class {
  associatedtype ViewModelType
  
  var viewModel: ViewModelType! { get set }
  func bindViewModel()
}

extension BindableType where Self: UIViewController {
  func bindViewModel(to vm: Self.ViewModelType) {
    viewModel = vm
    loadViewIfNeeded()
    bindViewModel()
  }
}
