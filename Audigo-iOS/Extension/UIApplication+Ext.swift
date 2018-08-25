//
//  UIApplication+Ext.swift
//  Audigo-iOS
//
//  Created by hPark on 2018. 8. 25..
//  Copyright © 2018년 BlackBurn. All rights reserved.
//

import UIKit

extension UIApplication {
  var statusBarView: UIView? {
    return value(forKey: "statusBar") as? UIView
  }
}
