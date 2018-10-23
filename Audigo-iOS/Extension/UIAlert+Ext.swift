//
//  UIAlert+Ext.swift
//  Audigo-iOS
//
//  Created by hPark on 23/10/2018.
//  Copyright © 2018 BlackBurn. All rights reserved.
//

import Foundation

extension UIAlertController {
  static func simpleAlert<T: UIViewController>(_ vc: T, title: String, message: String, callback: ((UIAlertAction) -> ())? = nil) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: callback))
    vc.present(alert, animated: true, completion: nil)
  }
  
  static func simpleCancelAlert<T: UIViewController>(_ vc: T, title: String, message: String, callback: ((UIAlertAction) -> ())? = nil) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "확인", style: .default, handler: callback))
    alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
    vc.present(alert, animated: true, completion: nil)
  }
  
  static func inputAlert<T: UIViewController>(_ vc: T, title: String, message: String, placeholder: String, callback: @escaping (String) -> Void) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
    
    alert.addTextField(configurationHandler: { textField in
      textField.placeholder = placeholder
    })
    
    alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { action in
      if let text = alert.textFields?.first?.text {
        callback(text)
      }
    }))
    
    vc.present(alert, animated: true)
  }
}
