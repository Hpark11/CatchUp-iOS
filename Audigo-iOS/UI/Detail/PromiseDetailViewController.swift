//
//  PromiseDetailViewController.swift
//  Audigo-iOS
//
//  Created by hPark on 2018. 8. 13..
//  Copyright © 2018년 BlackBurn. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import GoogleMaps

class PromiseDetailViewController: UIViewController, BindableType {
  @IBOutlet weak var pocketListTableView: UITableView!
  @IBOutlet weak var promisedDateLabel: UILabel!
  
  var viewModel: PromiseDetailViewModel!
  let disposeBag = DisposeBag()
  
  lazy var configureCell: (TableViewSectionedDataSource<PocketSectionModel>, UITableView, IndexPath, GetPromiseQuery.Data.Promise.Pocket) -> UITableViewCell = { [weak self] data, tableView, indexPath, pocket in
    guard let strongSelf = self else { return PromiseDetailUserTableViewCell(frame: .zero) }
    
    let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.promiseDetailUserTableViewCell, for: indexPath)
    cell?.configure(pocket: pocket)
  
    return cell!
  }
  
  var mapView: GMSMapView?
  
  let button: UIButton = {
    return UIButton()
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
    let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
    mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 200, width: 200, height: 200), camera: camera)
    if let mapView = mapView {
      view.addSubview(mapView)
    }
    
    navigationItem.leftBarButtonItem?.buttonGroup?.barButtonItems = [
      UIBarButtonItem(title: "Park", style: .plain, target: nil, action: nil)
    ]
  }
  
  func bindViewModel() {
    viewModel.outputs.name.subscribe(onNext: { name in
      self.navigationItem.title = name
    }).disposed(by: disposeBag)
    
    viewModel.outputs.location.subscribe(onNext: { (latitude, longitude) in
      self.mapView?.animate(to: GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 6.0))
      let marker = GMSMarker()
      marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
      marker.title = "Park"
      marker.snippet = "Hyunsoo"
      if let mapView = self.mapView {
        marker.map = mapView
      }
    }).disposed(by: disposeBag)
    
    viewModel.outputs.timestamp.subscribe(onNext: { (timestamp) in
      let timeFormat = DateFormatter()
      timeFormat.dateFormat = "MM.dd (EEEE) a hh시 mm분"
      
      let dateTime = Date(timeIntervalSince1970: timestamp)
      self.promisedDateLabel.text = timeFormat.string(from: dateTime)
    }).disposed(by: disposeBag)
    
    viewModel.pocketItems
      .bind(to: pocketListTableView.rx.items(dataSource: RxTableViewSectionedAnimatedDataSource<PocketSectionModel>(configureCell: configureCell)))
      .disposed(by: disposeBag)
  }
}

