//
//  PermissionsViewController.swift
//  Audigo-iOS
//
//  Created by hPark on 2018. 8. 4..
//  Copyright © 2018년 BlackBurn. All rights reserved.
//

import UIKit
import Permission
import RxSwift

class PermissionsViewController: UIViewController {
  
  let contacts: Permission = .contacts
  let location: Permission = .locationAlways
  let notifications: Permission = .notifications
  let disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  @IBAction func allowPermissions(_ sender: Any) {
    contacts.request { status in
      switch status {
      case .authorized:    print("authorized")
      case .denied:        print("denied")
      case .disabled:      print("disabled")
      case .notDetermined: print("not determined")
      }
      
      let permissionSet = PermissionSet([.notifications, .contacts, .locationAlways])
      if permissionSet.status == .authorized {
        self.startServices()
      }
    }
    
    location.request { status in
      switch status {
      case .authorized:    print("authorized")
      case .denied:        print("denied")
      case .disabled:      print("disabled")
      case .notDetermined: print("not determined")
      }
      
      let permissionSet = PermissionSet([.notifications, .contacts, .locationAlways])
      if permissionSet.status == .authorized {
        self.startServices()
      }
    }
    
    notifications.request { status in
      switch status {
      case .authorized:    print("authorized")
      case .denied:        print("denied")
      case .disabled:      print("disabled")
      case .notDetermined: print("not determined")
      }
      
      let permissionSet = PermissionSet([.notifications, .contacts, .locationAlways])
      if permissionSet.status == .authorized {
        self.startServices()
      }
    }
  }
  
  private func startServices() {
    LocationTrackingService.shared.startUpdatingLocation()
    self.dismiss(animated: true, completion: nil)
  }
}
