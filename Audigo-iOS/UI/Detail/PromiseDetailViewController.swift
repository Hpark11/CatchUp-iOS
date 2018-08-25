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
  @IBOutlet weak var membersMapView: GMSMapView!
  @IBOutlet weak var panelChangeButton: UIButton!
  
  var viewModel: PromiseDetailViewModel!
  let disposeBag = DisposeBag()
  
  lazy var configureCell: (TableViewSectionedDataSource<PocketSectionModel>, UITableView, IndexPath, GetPromiseQuery.Data.Promise.Pocket) -> UITableViewCell = { [weak self] data, tableView, indexPath, pocket in
    guard let strongSelf = self else { return PromiseDetailUserTableViewCell(frame: .zero) }
    
    let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.promiseDetailUserTableViewCell, for: indexPath)
    cell?.configure(pocket: pocket)
  
    return cell!
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.leftBarButtonItem?.buttonGroup?.barButtonItems = [
      UIBarButtonItem(title: "Park", style: .plain, target: nil, action: nil)
    ]
  }
  
  @IBAction func changeMapVisibility(_ sender: Any) {
    membersMapView.isHidden = !membersMapView.isHidden
  }
  
  func bindViewModel() {
    viewModel.outputs.name.subscribe(onNext: { name in
      self.navigationItem.title = name
    }).disposed(by: disposeBag)
    
    viewModel.outputs.location.subscribe(onNext: { (latitude, longitude) in
      self.membersMapView.animate(to: GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 14.0))
      let marker = GMSMarker()
      marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
      marker.title = "Park"
      marker.snippet = "Hyunsoo"
      marker.map = self.membersMapView
    }).disposed(by: disposeBag)
    
    viewModel.outputs.timestamp.subscribe(onNext: { (timestamp) in
      let timeFormat = DateFormatter()
      timeFormat.dateFormat = "MM.dd (EEE) a hh시 mm분"
      
      let dateTime = Date(timeIntervalSince1970: timestamp)
      self.promisedDateLabel.text = timeFormat.string(from: dateTime)
    }).disposed(by: disposeBag)
    
    let dataSource = RxTableViewSectionedAnimatedDataSource<PocketSectionModel>(configureCell: configureCell)
    
    viewModel.pocketItems
      .bind(to: pocketListTableView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
  }
}

