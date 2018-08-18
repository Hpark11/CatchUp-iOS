//
//  PromiseDetailViewController.swift
//  Audigo-iOS
//
//  Created by hPark on 2018. 8. 13..
//  Copyright © 2018년 BlackBurn. All rights reserved.
//

import UIKit
import RxSwift

class PromiseDetailViewController: UIViewController, BindableType {
  var viewModel: PromiseDetailViewModel!
  
  let disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //    // Create a GMSCameraPosition that tells the map to display the
    //    // coordinate -33.86,151.20 at zoom level 6.
    //    let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
    //    let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
    //    view = mapView
    //
    //    // Creates a marker in the center of the map.
    //    let marker = GMSMarker()
    //    marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
    //    marker.title = "Sydney"
    //    marker.snippet = "Australia"
    //    marker.map = mapView
    
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func bindViewModel() {
    viewModel.outputs.promise.subscribe(onNext: { promise in
      guard let promise = promise else { return }
      
    }).disposed(by: disposeBag)
  }
  
}
