//
//  PromiseItem.swift
//  Audigo-iOS
//
//  Created by hPark on 20/10/2018.
//  Copyright © 2018 BlackBurn. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class PromiseItem: Object {
  enum Property: String {
    case id, nickname, imagePath, pushToken
  }
  
  dynamic var id: String = UUID().uuidString
  dynamic var name: String = ""
  dynamic var address: String = ""
  dynamic var latitude: Double = 0.0
  dynamic var longitude: Double = 0.0
  dynamic var dateTime: Date = Date()
  dynamic var owner: String = ""
  let contacts: List<String> = List<String>()
  
  override static func primaryKey() -> String? {
    return PromiseItem.Property.id.rawValue
  }
  
  convenience init(promise: ListCatchUpPromisesByContactQuery.Data.ListCatchUpPromisesByContact?) {
//    guard let id = promise?.id =
    self.init()
  }
  
  convenience init?(promise: AddContactIntoPromiseMutation.Data.AddContactIntoPromise?) {
    guard let promise = promise,
      let name = promise.name,
      let address = promise.address,
      let latitude = promise.latitude,
      let longitude = promise.longitude,
      let date = promise.dateTime,
      let dateTime = Formatter.iso8601.date(from: date),
      let owner = promise.owner,
      let contacts = promise.contacts else {
      return nil
    }
    self.init()
    self.id = promise.id
    self.name = name
    self.address = address
    self.latitude = latitude
    self.longitude = longitude
    self.dateTime = dateTime
    self.owner = owner
    self.contacts.append(objectsIn: contacts.compactMap { $0 })
  }
}

extension PromiseItem {
  static func add(promise: AddContactIntoPromiseMutation.Data.AddContactIntoPromise?, in realm: Realm = try! Realm()) {
    guard let item = PromiseItem(promise: promise) else { return }
    try! realm.write {
      realm.add(item)
    }
  }
  
}


