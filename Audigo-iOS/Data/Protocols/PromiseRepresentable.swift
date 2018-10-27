//
//  PromiseRepresentable.swift
//  Audigo-iOS
//
//  Created by hPark on 27/10/2018.
//  Copyright © 2018 BlackBurn. All rights reserved.
//

import Foundation

protocol PromiseRepresentable {
  var id: String { get }
  var name: String? { get }
  var address: String? { get }
  var latitude: Double? { get }
  var longitude: Double? { get }
  var dateTime: String? { get }
  var owner: String? { get }
  var contacts: [String?]? { get }
}
