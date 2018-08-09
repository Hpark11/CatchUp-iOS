//
//  EntranceViewController.swift
//  Audigo-iOS
//
//  Created by hPark on 2018. 8. 4..
//  Copyright © 2018년 BlackBurn. All rights reserved.
//

import UIKit

class EntranceViewController: UIViewController {
  @IBOutlet weak var loginButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()

    let marginX = 32
    let width = view.frame.size.width - CGFloat(marginX * 2)
    let height = 42
    let marginBottom = 25
    loginButton.frame = CGRect(x: marginX, y: view.frame.size.height - marginBottom - height, width: width, height: height)
    
    let session = KOSession.shared()
    if let s = session {
      if s.isOpen() {
        dismiss(animated: false, completion: nil)
      }
    }
  }
  
  @IBAction func login(_ sender: Any) {
    let session = KOSession.shared()
    
    session?.open { (error) in
      if error == nil {
        if let s = session, s.isOpen() {
          print("Success")
          session?.userMe
        } else {
          print("Fail")
        }
      } else {
        print("Error Login: \(error)")
      }
    }
  }
}
