//
//  PromiseItem.swift
//  Audigo-iOS
//
//  Created by hPark on 20/10/2018.
//  Copyright © 2018 BlackBurn. All rights reserved.
//

import Foundation
import RealmSwift
import RxDataSources

@objcMembers class PromiseItem: Object {
  enum Property: String {
    case id, name, address, latitude, longitude, owner
  }
  
  dynamic var id: String = UUID().uuidString
  dynamic var name: String = ""
  dynamic var address: String = ""
  dynamic var latitude: Double = 0.0
  dynamic var longitude: Double = 0.0
  dynamic var dateTime: Date = Date.distantPast
  dynamic var owner: String = ""
  dynamic var isAllowed: Bool = false
  
  let contacts: List<String> = List<String>()
  
  override static func primaryKey() -> String? {
    return PromiseItem.Property.id.rawValue
  }
  
  convenience init?(promise: PromiseRepresentable?) {
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
    self.isAllowed = true
    self.contacts.append(objectsIn: contacts.compactMap { $0 })
  }
  
  convenience init(id: String, name: String) {
    self.init()
    self.id = id
    self.name = name
  }
}

extension PromiseItem {
  static func add(promise: PromiseRepresentable?, in realm: Realm = try! Realm()) {
    guard let item = PromiseItem(promise: promise) else { return }
    try! realm.write {
      realm.add(item)
    }
  }
  
  static func add(id: String, name: String, in realm: Realm = try! Realm()) {
    guard realm.object(ofType: PromiseItem.self, forPrimaryKey: id) == nil else { return }
    let item = PromiseItem(id: id, name: name)
    
    try! realm.write {
      realm.add(item)
    }
  }
  
  static func participate(id: String) {
    guard let realm = try? Realm(), let item = realm.object(ofType: self, forPrimaryKey: id) else { return }
    try! realm.write {
      item.isAllowed = true
    }
  }
  
  static func findNotAllowed() -> Results<PromiseItem> {
    let realm = try! Realm()
    return realm.objects(PromiseItem.self).filter("isAllowed = false")
  }
}

extension PromiseItem: IdentifiableType {
  public var identity: String { return id }
}

extension AddContactIntoPromiseMutation.Data.AddContactIntoPromise: PromiseRepresentable {}

extension ListCatchUpPromisesByContactQuery.Data.ListCatchUpPromisesByContact: PromiseRepresentable {}

extension UpdateCatchUpPromiseMutation.Data.UpdateCatchUpPromise: PromiseRepresentable {}

