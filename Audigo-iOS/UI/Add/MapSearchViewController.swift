//
//  MapSearchViewController.swift
//  Audigo-iOS
//
//  Created by hPark on 2018. 10. 10..
//  Copyright © 2018년 BlackBurn. All rights reserved.
//

import UIKit
import MapKit

class MapSearchViewController: UIViewController {
  @IBOutlet weak var mapView: MKMapView!
  
  let regionRadius: CLLocationDistance = 1000
  
  override func viewDidLoad() {
    super.viewDidLoad()
    UIApplication.shared.statusBarView?.backgroundColor = .clear
  }
  
  func centerMapOnLocation(location: CLLocation) {
    let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
    mapView.setRegion(coordinateRegion, animated: true)
  }
}

