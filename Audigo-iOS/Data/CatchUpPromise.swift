//
//  CatchUpPromise.swift
//  Audigo-iOS
//
//  Created by hPark on 2018. 10. 6..
//  Copyright © 2018년 BlackBurn. All rights reserved.
//

import Foundation
import RxDataSources

struct CatchUpPromise {
  let id: String
  let name: String
  let address: String
  let latitude: Double
  let longitude: Double
  let dateTime: Date
  let contacts: [String]
  let owner: String
  
  init?(promiseData: ListCatchUpPromisesByContactQuery.Data.ListCatchUpPromisesByContact?) {
    guard let promise = promiseData,
      let name = promise.name,
      let address = promise.address,
      let latitude = promise.latitude,
      let longitude = promise.longitude,
      let date = promise.dateTime,
      let dateTime = Formatter.iso8601.date(from: date),
      let contacts = promise.contacts?.compactMap({$0}),
      let owner = promise.owner else {
      return nil
    }
    
    self.id = promise.id
    self.name = name
    self.address = address
    self.latitude = latitude
    self.longitude = longitude
    self.dateTime = dateTime
    self.contacts = contacts
    self.owner = owner
  }
}

extension CatchUpPromise: IdentifiableType, Equatable {
  public var identity: String { return id }
  
  public static func ==(lhs: CatchUpPromise, rhs: CatchUpPromise) -> Bool {
    return lhs.id == rhs.id
  }
}
