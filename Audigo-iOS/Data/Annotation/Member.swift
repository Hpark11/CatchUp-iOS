//
//  Member.swift
//  Audigo-iOS
//
//  Created by hPark on 17/10/2018.
//  Copyright © 2018 BlackBurn. All rights reserved.
//

import Foundation
import MapKit

class Member: NSObject, MKAnnotation {
  let name: String
  let phone: String
  let discipline: String
  let imagePath: String
  let coordinate: CLLocationCoordinate2D
  
  init(name: String, phone: String, imagePath: String, discipline: String, coordinate: CLLocationCoordinate2D) {
    self.name = name
    self.phone = phone
    self.discipline = discipline
    self.coordinate = coordinate
    self.imagePath = imagePath
    super.init()
  }
  
  var title: String? {
    return name
  }
  
  var subtitle: String? {
    return phone
  }
}
