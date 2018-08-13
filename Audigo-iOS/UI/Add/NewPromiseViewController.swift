//
//  NewPromiseViewController.swift
//  Audigo-iOS
//
//  Created by hPark on 2018. 8. 12..
//  Copyright © 2018년 BlackBurn. All rights reserved.
//

import UIKit
import RxSwift
import RxGesture
import GooglePlaces
import GoogleMaps

class NewPromiseViewController: UIViewController, BindableType {
  var viewModel: NewPromiseViewModel!
  
  let disposeBag = DisposeBag()
  
  @IBOutlet weak var popButton: UIButton!
  @IBOutlet weak var promiseNameLabel: UILabel!
  @IBOutlet weak var promiseDateLabel: UILabel!
  @IBOutlet weak var promiseTimeLabel: UILabel!
  @IBOutlet weak var promiseAddressLabel: UILabel!
  @IBOutlet weak var promiseMembersLabel: UILabel!
  @IBOutlet weak var membersCollectionView: UICollectionView!
  
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
  }
  
  func bindViewModel() {
    popButton.rx.action = viewModel.actions.popScene
    
    promiseNameLabel.rx.tapGesture().when(.recognized).subscribe { _ in
      let alert = UIAlertController(title: "이름 짓기", message: "생성할 약속의 이름을 입력해주세요", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
      
      alert.addTextField(configurationHandler: { textField in
        textField.placeholder = "이름 입력"
      })
      
      alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { action in
        if let name = alert.textFields?.first?.text {
          
        }
      }))
      
      self.present(alert, animated: true)
    }.disposed(by: disposeBag)
    
    promiseAddressLabel.rx.tapGesture().when(.recognized).subscribe(onNext: { _ in
      let autocompleteController = GMSAutocompleteViewController()
      autocompleteController.delegate = self
      self.present(autocompleteController, animated: true, completion: nil)
    }).disposed(by: disposeBag)
  }
}

extension NewPromiseViewController: GMSAutocompleteViewControllerDelegate {

  func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
    print("Place name: \(place.name)")
    print("Place address: \(place.formattedAddress)")
    promiseAddressLabel.text = place.formattedAddress
    print("Place attributions: \(place.attributions)")
    dismiss(animated: true, completion: nil)
  }
  
  func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
    print("Error: ", error.localizedDescription)
  }
  
  func wasCancelled(_ viewController: GMSAutocompleteViewController) {
    dismiss(animated: true, completion: nil)
  }
  
  func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
  }
  
  func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = false
  }
}

