//
//  LocationTrackingService.swift
//  Audigo-iOS
//
//  Created by hPark on 2018. 8. 21..
//  Copyright © 2018년 BlackBurn. All rights reserved.
//

import Foundation
import CoreLocation

public class LocationTrackingService: NSObject, CLLocationManagerDelegate {
  
  public static var shared = LocationTrackingService()
  let locationManager: CLLocationManager
  
  override init() {
    locationManager = CLLocationManager()
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
    locationManager.allowsBackgroundLocationUpdates = true
    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
    locationManager.distanceFilter = 8
    locationManager.requestAlwaysAuthorization()

    super.init()
    locationManager.delegate = self
  }
  
  func startUpdatingLocation() {
    if CLLocationManager.locationServicesEnabled() {
      locationManager.startUpdatingLocation()
    }
  }
  
  public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let newLocation = locations.last {
      guard let phone = UserDefaultService.phoneNumber else { return }
      
      if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
        appDelegate.appSyncClient?.perform(mutation: RelocateCatchUpContactMutation(phone: phone, latitude: newLocation.coordinate.latitude, longitude: newLocation.coordinate.longitude))
      }
    }
  }

  public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    if (error as NSError).domain == kCLErrorDomain && (error as NSError).code == CLError.Code.denied.rawValue{
//      showTurnOnLocationServiceAlert()
    }
  }
  
  public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    if status == .authorizedWhenInUse {
    }
  }
  
//  func showTurnOnLocationServiceAlert(){
//    NotificationCenter.default.post(name: Notification.Name(rawValue:"showTurnOnLocationServiceAlert"), object: nil)
//  }
//
//  func notifiyDidUpdateLocation(newLocation:CLLocation){
//    NotificationCenter.default.post(name: Notification.Name(rawValue:"didUpdateLocation"), object: nil, userInfo: ["location" : newLocation])
//  }
}
