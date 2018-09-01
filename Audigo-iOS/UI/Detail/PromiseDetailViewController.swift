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
  @IBOutlet weak var refreshButton: UIButton!
  @IBOutlet weak var editPromiseButton: UIButton!
  
  var viewModel: PromiseDetailViewModel!
  let disposeBag = DisposeBag()
  private var markers: [GMSMarker]? = []
  
  lazy var configureCell: (TableViewSectionedDataSource<PocketSectionModel>, UITableView, IndexPath, GetPromiseQuery.Data.Promise.Pocket) -> UITableViewCell = { [weak self] data, tableView, indexPath, pocket in
    guard let strongSelf = self else { return PromiseDetailUserTableViewCell(frame: .zero) }
    
    let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.promiseDetailUserTableViewCell, for: indexPath)
    cell?.configure(pocket: pocket)
  
    return cell!
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    pocketListTableView.rowHeight = 85
    
    navigationController?.navigationBar.barStyle = .blackOpaque
    navigationItem.leftBarButtonItems = [UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)]
    navigationItem.leftBarButtonItem?.image = UIImage(named: R.image.icon_back.name)
    navigationItem.leftBarButtonItem?.tintColor = .white
    navigationItem.leftBarButtonItem?.rx.action = viewModel.actions.popScene
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    UIApplication.shared.statusBarView?.backgroundColor = .darkSkyBlue
    navigationController?.navigationBar.backgroundColor = .darkSkyBlue
    navigationController?.navigationBar.barStyle = .blackOpaque
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    UIApplication.shared.statusBarView?.backgroundColor = .white
    navigationController?.navigationBar.backgroundColor = .white
    navigationController?.navigationBar.barStyle = .default
  }
  
  @IBAction func changeMapVisibility(_ sender: Any) {
    membersMapView.isHidden = !membersMapView.isHidden
  }
  
  func bindViewModel() {
    editPromiseButton.rx.action = viewModel.actions.pushNewPromiseScene
    refreshButton.rx.action = viewModel.actions.refresh
    
    viewModel.outputs.name.subscribe(onNext: { name in
      self.navigationItem.title = name
    }).disposed(by: disposeBag)
    
    viewModel.outputs.location.subscribe(onNext: { (latitude, longitude) in
      self.membersMapView.animate(to: GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 14.0))
      let marker = GMSMarker()
      marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
      marker.title = "목적지"
      marker.snippet = "도착 장소"
      
      marker.map = self.membersMapView
    }).disposed(by: disposeBag)
    
    viewModel.outputs.timestamp.subscribe(onNext: { (timestamp) in
      let timeFormat = DateFormatter()
      timeFormat.dateFormat = "MM.dd (EEE) a hh시 mm분"
      
      let dateTime = Date(timeIntervalSince1970: timestamp)
      self.promisedDateLabel.text = timeFormat.string(from: dateTime)
    }).disposed(by: disposeBag)
    
    let dataSource = RxTableViewSectionedAnimatedDataSource<PocketSectionModel>(configureCell: configureCell)
    
    viewModel.outputs.pocketItems.subscribe(onNext: { [weak self] sectionModel in
      guard let strongSelf = self else { return }
      strongSelf.markers = strongSelf.markers?.compactMap { marker in
        marker.map = nil
        return nil
      }
      
      strongSelf.markers = sectionModel.first?.items.compactMap { pocket in
        guard let latitude = pocket.latitude, let longitude = pocket.longitude else { return nil }
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        marker.title = pocket.nickname ?? ""
        marker.snippet = pocket.phone
        let markerView = CatchUpMarkerView(frame: CGRect(x: 0, y: 0, width: 48, height: 58))
        markerView.markerState = .moving(imagePath: pocket.profileImagePath ?? "")
        marker.iconView = markerView
        marker.map = strongSelf.membersMapView
        return marker
      }
    }).disposed(by: disposeBag)
    
    viewModel.pocketItems
      .bind(to: pocketListTableView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
    
    viewModel.outputs.isOwner.subscribe(onNext: { (isOwner) in
      self.editPromiseButton.isHidden = !isOwner
    }).disposed(by: disposeBag)
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
}

