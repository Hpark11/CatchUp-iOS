//
//  Formatter.swift
//  Audigo-iOS
//
//  Created by hPark on 2018. 10. 6..
//  Copyright © 2018년 BlackBurn. All rights reserved.
//

import Foundation

extension Formatter {
  static let iso8601: ISO8601DateFormatter = {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withInternetDateTime]
    return formatter
  }()
}
