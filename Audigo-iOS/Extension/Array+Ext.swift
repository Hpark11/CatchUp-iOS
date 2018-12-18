//
//  Array+Ext.swift
//  Audigo-iOS
//
//  Created by hPark on 2018. 10. 5..
//  Copyright © 2018년 BlackBurn. All rights reserved.
//

import Foundation

extension Array {
  func chunked(into size: Int) -> [[Element]] {
    return stride(from: 0, to: count, by: size).map {
      Array(self[$0 ..< Swift.min($0 + size, count)])
    }
  }
}
