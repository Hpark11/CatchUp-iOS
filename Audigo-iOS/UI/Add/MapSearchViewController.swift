//
//  MapSearchViewController.swift
//  Audigo-iOS
//
//  Created by hPark on 2018. 10. 10..
//  Copyright © 2018년 BlackBurn. All rights reserved.
//

import UIKit
import MapKit
import RxSwift

class MapSearchViewController: UIViewController {
  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var searchBarButton: UIButton!
  
  var placeConfirmed: PublishSubject<CLLocationCoordinate2D>?
  
  private let placeSearchDone = PublishSubject<MKLocalSearchCompletion>()
  private let regionRadius: CLLocationDistance = 1000
  private let disposeBag = DisposeBag()

//  private var coordinate = CLLocationCoordinate2D(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    UIApplication.shared.statusBarView?.backgroundColor = .clear
    
    searchBarButton.layer.cornerRadius = 6
    searchBarButton.layer.shadowColor = UIColor.black.cgColor
    searchBarButton.layer.shadowOpacity = 0.4
    searchBarButton.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
    searchBarButton.layer.shadowRadius = 4
    
    placeSearchDone.subscribe(onNext: { [weak self] result in
      guard let `self` = self else { return }
      
      let searchRequest = MKLocalSearchRequest(completion: result)
      let search = MKLocalSearch(request: searchRequest)
      search.start { (response, error) in
//        print(response?.mapItems)
        if let placemark = response?.mapItems[0].placemark, let coordinate = placemark.location?.coordinate {
          let coordinateRegion = MKCoordinateRegionMakeWithDistance(coordinate, self.regionRadius, self.regionRadius)
          self.mapView.setRegion(coordinateRegion, animated: true)
          self.mapView.removeAnnotations(self.mapView.annotations)
          
          self.mapView.addAnnotation(Destination(title: result.title, address: result.subtitle, discipline: "", coordinate: coordinate))
        }
      }
    }).disposed(by: disposeBag)
  }
  
  @IBAction func comfirmPlace(_ sender: Any) {
    
  }
  
  @IBAction func searchPlace(_ sender: Any) {
    if let vc = R.storyboard.main.placeSearchListViewController() {
      vc.searchDone = placeSearchDone
      present(vc, animated: true, completion: nil)
    }
  }
}

