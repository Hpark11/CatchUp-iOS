//
//  PromisePocket.swift
//  Audigo-iOS
//
//  Created by hPark on 2018. 9. 1..
//  Copyright © 2018년 BlackBurn. All rights reserved.
//

import Foundation
import RxDataSources

struct PromisePocket {
  let destLatitude: Double
  let destLongitude: Double
  let pocket: GetPromiseQuery.Data.Promise.Pocket
}

extension PromisePocket: IdentifiableType, Equatable {
  public var identity: String {
    return pocket.phone
  }
  
  public static func ==(lhs: PromisePocket, rhs: PromisePocket) -> Bool {
    return lhs.pocket.phone == rhs.pocket.phone
  }
}
