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
  var addressConfirmed: PublishSubject<String>?
  
  private let placeSearchDone = PublishSubject<MKLocalSearchCompletion>()
  private let regionRadius: CLLocationDistance = 1000
  private let disposeBag = DisposeBag()
  
  private var address: String = ""
  private var coordinate = CLLocationCoordinate2D(latitude: 37.498095, longitude: 127.07610)
  
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
        if let placemark = response?.mapItems[0].placemark, let coordinate = placemark.location?.coordinate {
          self.coordinate = coordinate
          self.address = result.subtitle.isEmpty ? result.title : result.subtitle
          self.setNewLocation(title: result.title)
        }
      }
    }).disposed(by: disposeBag)
  }
  
  private func setNewLocation(title: String) {
    let coordinateRegion = MKCoordinateRegionMakeWithDistance(coordinate, regionRadius, regionRadius)
    mapView.setRegion(coordinateRegion, animated: true)
    mapView.removeAnnotations(self.mapView.annotations)
    mapView.addAnnotation(Destination(title: title, address: address, discipline: "", coordinate: coordinate))
  }
  
  @IBAction func comfirmPlace(_ sender: Any) {
    if !address.isEmpty {
      dismiss(animated: true) {
        self.placeConfirmed?.onNext(self.coordinate)
        self.addressConfirmed?.onNext(self.address)
      }
    }
  }
  
  @IBAction func searchPlace(_ sender: Any) {
    if let vc = R.storyboard.main.placeSearchListViewController() {
      vc.searchDone = placeSearchDone
      present(vc, animated: true, completion: nil)
    }
  }
}

