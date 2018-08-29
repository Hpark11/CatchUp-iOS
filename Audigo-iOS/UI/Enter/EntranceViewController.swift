//
//  EntranceViewController.swift
//  Audigo-iOS
//
//  Created by hPark on 2018. 8. 4..
//  Copyright © 2018년 BlackBurn. All rights reserved.
//

import UIKit
import RxSwift

class EntranceViewController: UIViewController {
  @IBOutlet weak var loginButton: UIButton!
  
  var signInDone: PublishSubject<Void>?

  @IBAction func login(_ sender: Any) {
    let session = KOSession.shared()
    
    session?.open { (error) in
      if error == nil {
        if let s = session, s.isOpen() {
          self.signInDone?.onNext(())
          self.dismiss(animated: false, completion: nil)
        } else {
          print("Fail")
        }
      } else {
        print("Error Login: \(error)")
      }
    }
  }
}
