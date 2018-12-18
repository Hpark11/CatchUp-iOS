//
//  PromisePocket.swift
//  Audigo-iOS
//
//  Created by hPark on 2018. 9. 1..
//  Copyright © 2018년 BlackBurn. All rights reserved.
//

import Foundation
import RxDataSources

struct CatchUpContact {
  let destLatitude: Double
  let destLongitude: Double
  
  let phone: String
  let nickname: String?
  let profileImagePath: String?
  let latitude: Double?
  let longitude: Double?
  let pushToken: String?

  init?(dstLat: Double, dstLng: Double, contactData: BatchGetCatchUpContactsQuery.Data.BatchGetCatchUpContact?) {
    guard let contact = contactData else {
      return nil
    }
    
    destLatitude = dstLat
    destLongitude = dstLng
    phone = contact.phone
    nickname = contact.nickname
    profileImagePath = contact.profileImagePath
    latitude = contact.latitude
    longitude = contact.longitude
    pushToken = contact.pushToken
  }
  
  init?(dstLat: Double, dstLng: Double, contactData: GetCatchUpContactQuery.Data.GetCatchUpContact?) {
    guard let contact = contactData else {
      return nil
    }
    
    destLatitude = dstLat
    destLongitude = dstLng
    phone = contact.phone
    nickname = contact.nickname
    profileImagePath = contact.profileImagePath
    latitude = contact.latitude
    longitude = contact.longitude
    pushToken = contact.pushToken
  }
}

extension CatchUpContact: IdentifiableType, Equatable {
  public var identity: String {
    return phone
  }
  
  public static func ==(lhs: CatchUpContact, rhs: CatchUpContact) -> Bool {
    return lhs.phone == rhs.phone
  }
}
