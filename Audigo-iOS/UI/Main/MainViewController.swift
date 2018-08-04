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
    
    
  }

  func bindViewModel() {
    
  }

  @IBAction func signInWithKakao(_ sender: Any) {
    let session = KOSession.shared()
    
    if let s = session {
      if s.isOpen() {
        s.close()
      }
      
      s.open { (error) in
        if error == nil {
          print("No error")
          
          if s.isOpen() {
            print("Success")
          } else {
            print("Fail")
          }
        } else {
          print("Error Login: \(error!)")
        }
      }
      
    } else {
      print("Something wrong!")
    }
  }
}

