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
  dynamic var contacts: List<ContactItem> = List<ContactItem>()
  dynamic var owner: String = ""
  
  override static func primaryKey() -> String? {
    return PromiseItem.Property.id.rawValue
  }
}


