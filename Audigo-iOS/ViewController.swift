//
//  ViewController.swift
//  Audigo-iOS
//
//  Created by hPark on 2018. 6. 7..
//  Copyright © 2018년 BlackBurn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
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

