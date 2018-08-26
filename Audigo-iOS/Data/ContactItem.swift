//
//  ContactItem.swift
//  Audigo-iOS
//
//  Created by hPark on 2018. 8. 16..
//  Copyright © 2018년 BlackBurn. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class ContactItem: Object {
  enum Property: String {
    case phone, nickname, imagePath, pushToken
  }
  
  dynamic var phone: String = ""
  
  dynamic var nickname: String = ""
  dynamic var imagePath: String = ""
  dynamic var pushToken: String = ""
  
  override static func primaryKey() -> String? {
    return ContactItem.Property.phone.rawValue
  }
  
  convenience init(_ phone: String, nickname: String, imagePath: String, pushToken: String) {
    self.init()
    self.phone = phone
    self.nickname = nickname
    self.imagePath = imagePath
    self.pushToken = pushToken
  }
  
  convenience init(_ phone: String) {
    self.init()
    self.phone = phone
  }
}

extension ContactItem {
  static func all(in realm: Realm = try! Realm()) -> Results<ContactItem> {
    return realm.objects(ContactItem.self)
      .sorted(byKeyPath: ContactItem.Property.nickname.rawValue, ascending: true)
  }
  
  static func find(phone: String, in realm: Realm = try! Realm()) -> ContactItem? {
    return realm.object(ofType: ContactItem.self, forPrimaryKey: phone)
  }
  
  static func create(_ phone: String, nickname: String, imagePath: String, pushToken: String, in realm: Realm = try! Realm()) {
    try! realm.write {
      realm.create(ContactItem.self, value: [
        ContactItem.Property.phone.rawValue: phone,
        ContactItem.Property.nickname.rawValue: nickname,
        ContactItem.Property.imagePath.rawValue: imagePath,
        ContactItem.Property.pushToken.rawValue: pushToken
        ], update: true)
    }
  }
  
  static func create(_ phone: String, nickname: String, in realm: Realm = try! Realm()) {
    try! realm.write {
      realm.create(ContactItem.self, value: [ContactItem.Property.phone.rawValue: phone,
                                             ContactItem.Property.nickname.rawValue: nickname], update: true)
    }
  }
  
  @discardableResult
  static func add(_ phone: String, nickname: String, imagePath: String, pushToken: String, in realm: Realm = try! Realm())-> ContactItem {
    let item = ContactItem(phone, nickname: nickname, imagePath: imagePath, pushToken: pushToken)
    try! realm.write {
      realm.add(item)
    }
    return item
  }
  
  @discardableResult
  static func add(_ phone: String, in realm: Realm = try! Realm())-> ContactItem {
    let item = ContactItem(phone)
    try! realm.write {
      realm.add(item)
    }
    return item
  }
}
