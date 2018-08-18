//
//  PromiseDetailViewController.swift
//  Audigo-iOS
//
//  Created by hPark on 2018. 8. 13..
//  Copyright © 2018년 BlackBurn. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

class PromiseDetailViewController: UIViewController, BindableType {
  @IBOutlet weak var pocketListTableView: UITableView!
  
  var viewModel: PromiseDetailViewModel!
  
  let disposeBag = DisposeBag()
  
  lazy var configureCell: (TableViewSectionedDataSource<PocketSectionModel>, UITableView, IndexPath, GetPromiseQuery.Data.Promise.Pocket) -> UITableViewCell = { [weak self] data, tableView, indexPath, pocket in
    guard let strongSelf = self else { return PromiseDetailUserTableViewCell(frame: .zero) }
    
    let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.promiseDetailUserTableViewCell, for: indexPath)
    cell?.configure(pocket: pocket)
    
//    cell?.itemView.rx.tapGesture().when(.recognized).subscribe(onNext: { _ in
//      strongSelf.viewModel.actions.pushPromiseDetailScene.execute(promise.id ?? "")
//    }).disposed(by: strongSelf.disposeBag)
    return cell!
  }
  
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
  
  func bindViewModel() {
//    navigationItem.t
    
//    viewModel.outputs.promise.subscribe(onNext: { promise in
//      guard let promise = promise else { return }
//
//    }).disposed(by: disposeBag)
    
    viewModel.pocketItems
      .bind(to: pocketListTableView.rx.items(dataSource: RxTableViewSectionedAnimatedDataSource<PocketSectionModel>(configureCell: configureCell)))
      .disposed(by: disposeBag)
  }
  
  
}

