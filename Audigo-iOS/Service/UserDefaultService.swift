//
//  UserDefaultService.swift
//  Audigo-iOS
//
//  Created by hPark on 2018. 10. 6..
//  Copyright © 2018년 BlackBurn. All rights reserved.
//

import Foundation

class UserDefaultService {
  static var userId: String? {
    get {
      return UserDefaults.standard.string(forKey: Define.keyUserId)
    }
    set {
      UserDefaults.standard.set(newValue, forKey: Define.keyUserId)
      UserDefaults.standard.synchronize()
    }
  }
  
  static var credit: Int? {
    get {
      return UserDefaults.standard.integer(forKey: Define.keyCredit)
    }
    set {
      UserDefaults.standard.set(newValue, forKey: Define.keyCredit)
      UserDefaults.standard.synchronize()
    }
  }
  
  static var pushToken: String? {
    get {
      return UserDefaults.standard.string(forKey: Define.keyPushToken)
    }
    set {
      UserDefaults.standard.set(newValue, forKey: Define.keyPushToken)
      UserDefaults.standard.synchronize()
    }
  }
  
  static var phoneNumber: String? {
    get {
      return UserDefaults.standard.string(forKey: Define.keyPhoneNumber)
    }
    set {
      UserDefaults.standard.set(newValue, forKey: Define.keyPhoneNumber)
      UserDefaults.standard.synchronize()
    }
  }
  
  static var nickname: String? {
    get {
      return UserDefaults.standard.string(forKey: Define.keyUserNickname)
    }
    set {
      UserDefaults.standard.set(newValue, forKey: Define.keyUserNickname)
      UserDefaults.standard.synchronize()
    }
  }
}
