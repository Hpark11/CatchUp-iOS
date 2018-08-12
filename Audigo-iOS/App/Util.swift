//
//  Util.swift
//  Audigo-iOS
//
//  Created by hPark on 2018. 8. 12..
//  Copyright © 2018년 BlackBurn. All rights reserved.
//

import Foundation

extension Date {
  var timeInMillis: UInt64 {
    return UInt64(self.timeIntervalSince1970 * 1000)
  }
}
