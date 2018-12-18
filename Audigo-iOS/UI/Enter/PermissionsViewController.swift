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
  
  @IBAction func allowPermissions(_ sender: Any) {
    location.request { _ in
      self.startServices()
    }
    
    notifications.request { _ in
      self.startServices()
    }
  }
  
  private func startServices() {
    let permissionSet = PermissionSet([.notifications, .locationAlways])
    if permissionSet.status == .authorized {
      dismiss(animated: true, completion: nil)
    }
  }
}
