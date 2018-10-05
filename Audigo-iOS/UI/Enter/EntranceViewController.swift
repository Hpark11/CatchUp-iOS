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
  private var signInDone: Bool = false
  private var phone: String?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let session = KOSession.shared()
    if let s = session, s.isOpen()  {
      signInDone = true
    }
  }
  
  @IBAction func login(_ sender: Any) {
    let session = KOSession.shared()
    
    session?.open { [unowned self] (error) in
      if let error = error {
        print("Error Sign In: \(error)")
      } else {
        if let s = session, let phone = self.phone, s.isOpen() {
          self.viewModel.inputs.sessionOpened.onNext(phone)
        } else {
          print("Open Session Failed")
        }
      }
    }
  }
  
  func bindViewModel() {}
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    let permissionSet = PermissionSet([.notifications, .contacts, .locationAlways])
    guard permissionSet.status != .authorized else {
      if let vc = R.storyboard.main.permissionsViewController() {
        present(vc, animated: true, completion: nil)
      }
      return
    }
    
    guard let phone = UserDefaults.standard.string(forKey: Define.keyPhoneNumber), !phone.isEmpty else {
      if let vc = R.storyboard.main.phoneCheckViewController() {
        present(vc, animated: true, completion: nil)
      }
      return
    }

    self.phone = phone
    if signInDone {
      viewModel.inputs.sessionOpened.onNext(phone)
    } else {
      loginButton.isHidden = false
    }
  }
}
