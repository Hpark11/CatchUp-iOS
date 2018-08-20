//
//  LocationTrackingService.swift
//  Audigo-iOS
//
//  Created by hPark on 2018. 8. 21..
//  Copyright © 2018년 BlackBurn. All rights reserved.
//

import Foundation
import CoreLocation

public class LocationTrackingService: NSObject, CLLocationManagerDelegate{
  
  public static var shared = LocationTrackingService()
  let locationManager: CLLocationManager
  
  override init() {
    locationManager = CLLocationManager()
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
    locationManager.requestAlwaysAuthorization()
    
    super.init()
    locationManager.delegate = self
  }
  
  public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let newLocation = locations.last {
      print("(\(newLocation.coordinate.latitude), \(newLocation.coordinate.latitude))")
    }
  }
}
