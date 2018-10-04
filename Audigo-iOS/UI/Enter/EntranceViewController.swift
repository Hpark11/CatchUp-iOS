//
//  EntranceViewController.swift
//  Audigo-iOS
//
//  Created by hPark on 2018. 8. 4..
//  Copyright © 2018년 BlackBurn. All rights reserved.
//

import UIKit
import RxSwift
import Permission

class EntranceViewController: UIViewController, BindableType {
  @IBOutlet weak var loginButton: UIButton!

  var viewModel: EntranceViewModel!
  var signInDone: Bool = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let session = KOSession.shared()
    if let s = session, s.isOpen()  {
      signInDone = true
      return
    }
  }
  
  @IBAction func login(_ sender: Any) {
    let session = KOSession.shared()
    
    session?.open { (error) in
      if let error = error {
        print("Error Sign In: \(error)")
      } else {
        if let s = session, s.isOpen() {
          
        } else {
          print("SessionFail")
        }
      }
    }
  }
  
  func bindViewModel() {
    loginButton.rx.bind(to: viewModel.actions.pushMainScene, input: "")
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    let permissionSet = PermissionSet([.notifications, .contacts, .locationAlways])
    guard permissionSet.status != .authorized else {
      if let vc = R.storyboard.main.permissionsViewController() {
        present(vc, animated: true, completion: nil)
      }
      return
    }
    
    guard let phoneNumber = UserDefaults.standard.string(forKey: Define.keyPhoneNumber), !phoneNumber.isEmpty else {
      if let vc = R.storyboard.main.phoneCheckViewController() {
        present(vc, animated: true, completion: nil)
      }
      return
    }

    if signInDone {
      viewModel.actions.pushMainScene.execute(phoneNumber)
    } else {
      loginButton.isHidden = false
    }
  }
}
