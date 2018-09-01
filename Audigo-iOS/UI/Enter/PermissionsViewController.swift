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
import SwiftyContacts

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
    
    let backgroundScheduler = SerialDispatchQueueScheduler(qos: .default)
    
    rx_fetchContacts().map({ contacts in
      return contacts.compactMap {
        ($0.phoneNumbers.first?.value.stringValue ?? "", "\($0.familyName)\($0.givenName)")
      }
    }).subscribeOn(backgroundScheduler)
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { (contacts) in
        contacts.forEach { contact in
          if contact.0.starts(with: "010") {
            let phone = contact.0
              .components(separatedBy:CharacterSet.decimalDigits.inverted)
              .joined(separator: "")
            
            let nickname = contact.1
            
            apollo.fetch(query: GetPocketQuery(phone: phone)) { result, error in
              guard error != nil else {
                ContactItem.create(phone, nickname: nickname)
                return
              }
              
              if let pocket = result?.data?.pocket {
                ContactItem.create(pocket.phone, nickname: pocket.nickname ?? "", imagePath: pocket.profileImagePath ?? "", pushToken: pocket.pushToken ?? "")
              }
            }
          }
        }
      })
      .disposed(by: disposeBag)
  }
}
