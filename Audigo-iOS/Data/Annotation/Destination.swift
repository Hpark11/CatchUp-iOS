//
//  Destination.swift
//  Audigo-iOS
//
//  Created by hPark on 2018. 10. 15..
//  Copyright © 2018년 BlackBurn. All rights reserved.
//

import Foundation
import MapKit

class Destination: NSObject, MKAnnotation {
  let title: String?
  let address: String
  let discipline: String
  let coordinate: CLLocationCoordinate2D
  
  init(title: String, address: String, discipline: String, coordinate: CLLocationCoordinate2D) {
    self.title = title
    self.address = address
    self.discipline = discipline
    self.coordinate = coordinate
    super.init()
  }
  
  var subtitle: String? {
    return address
  }
}

