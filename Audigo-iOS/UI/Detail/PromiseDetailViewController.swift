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
import MapKit
import ToastKit

class PromiseDetailViewController: UIViewController, BindableType {
  @IBOutlet weak var pocketListTableView: UITableView!
  @IBOutlet weak var promisedDateLabel: UILabel!
  @IBOutlet weak var detailMapView: MKMapView!
  @IBOutlet weak var panelChangeButton: UIButton!
  @IBOutlet weak var refreshButton: UIButton!
  @IBOutlet weak var editPromiseButton: UIButton!
  
  var viewModel: PromiseDetailViewModel!
  let disposeBag = DisposeBag()
  private var destMarker: Destination?
  private var markers: [Member]? = []
  private var currentMarker: Member?
  private var imagePath: String = ""
  private let sendPush = PublishSubject<String>()
  
  private lazy var configureCell: (TableViewSectionedDataSource<PocketSectionModel>, UITableView, IndexPath, CatchUpContact) -> UITableViewCell = { [weak self] data, tableView, indexPath, pocket in
    guard let strongSelf = self else { return PromiseDetailUserTableViewCell(frame: .zero) }
    
    let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.promiseDetailUserTableViewCell, for: indexPath)
    cell?.configure(contact: pocket, sendPush: strongSelf.sendPush)
  
    return cell!
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    pocketListTableView.rowHeight = 85
    navigationItem.leftBarButtonItems = [UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)]
    navigationItem.leftBarButtonItem?.image = UIImage(named: R.image.icon_back.name)
    navigationItem.leftBarButtonItem?.tintColor = .white
    navigationItem.leftBarButtonItem?.rx.action = viewModel.actions.popScene
    
    sendPush.subscribe(onNext: { [weak self] (pushToken) in
      guard let strongSelf = self else { return }
      strongSelf.openPushDialog(pushToken: pushToken)
    }).disposed(by: disposeBag)
    
    if let phone = UserDefaultService.phoneNumber {
      imagePath = ContactItem.find(phone: phone)?.imagePath ?? ""
    }
  }
  
  @objc func updateSelfLocation(_ notification: Notification) {
    if let data = notification.userInfo as? [String: Any], let location = data["location"] as? CLLocation, let nickname = UserDefaultService.nickname, let phone = UserDefaultService.phoneNumber {
      if let current = currentMarker {
        detailMapView.removeAnnotation(current)
      }
      
      let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
      let current = Member(name: nickname, phone: phone, imagePath: imagePath, discipline: "Member", coordinate: coordinate)
      currentMarker = current
      detailMapView.addAnnotation(current)
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.barStyle = .blackOpaque
    NotificationCenter.default.addObserver(self, selector: #selector(updateSelfLocation(_:)), name: NSNotification.Name(rawValue: "didUpdateLocation"), object: nil)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.navigationBar.barStyle = .default
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "didUpdateLocation"), object: nil)
  }
  
  @IBAction func changeMapVisibility(_ sender: Any) {
    detailMapView.isHidden = !detailMapView.isHidden
    panelChangeButton.setImage(detailMapView.isHidden ? R.image.icon_map() : R.image.icon_list(), for: .normal)
  }
  
  private func openPushDialog(pushToken: String) {
    let alert = UIAlertController(title: "메세지 보내기", message: "유저에게 보낼 메세지를 입력하세요", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
    alert.addTextField(configurationHandler: { textField in textField.placeholder = "메세지 입력" })
    alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { action in
      if let text = alert.textFields?.first?.text, let from = UserDefaultService.nickname {
        PushMessageService.sendPush(title: "\(from)님의 메세지", message: text, pushTokens: [pushToken])
        Toast.makeText(self, text: "알림 메세지를 보냈어요")
      }
    }))
    
    present(alert, animated: true)
  }
  
  func bindViewModel() {
    editPromiseButton.rx.action = viewModel.actions.pushNewPromiseScene
    refreshButton.rx.action = viewModel.actions.refresh
    
    viewModel.outputs.name.subscribe(onNext: { [weak self] name in
      guard let strongSelf = self else { return }
      strongSelf.navigationItem.title = name
    }).disposed(by: disposeBag)
    
    viewModel.outputs.location.subscribe(onNext: { [weak self] (latitude, longitude) in
      guard latitude >= 33.0 && latitude <= 43.0 && longitude >= 124.0 && longitude <= 132.0 else { return }
      guard let `self` = self else { return }
      let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
      
      if let destination = self.destMarker {
        self.detailMapView.removeAnnotation(destination)
        self.destMarker = nil
      } else {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(coordinate, 1000, 1000)
        self.detailMapView.setRegion(coordinateRegion, animated: true)
      }
      
      let annotation = Destination(title: "목적지", address: self.viewModel.promise?.address ?? "", discipline: "", coordinate: coordinate)
      self.detailMapView.addAnnotation(annotation)
      self.destMarker = annotation
    }).disposed(by: disposeBag)
    
    viewModel.outputs.timestamp.subscribe(onNext: { (timestamp) in
      let timeFormat = DateFormatter()
      timeFormat.dateFormat = "MM.dd (EEE) a hh시 mm분"
      
      let dateTime = Date(timeIntervalSince1970: timestamp)
      self.promisedDateLabel.text = timeFormat.string(from: dateTime)
    }).disposed(by: disposeBag)
    
    let dataSource = RxTableViewSectionedAnimatedDataSource<PocketSectionModel>(configureCell: configureCell)
    
    viewModel.outputs.pocketItems.subscribe(onNext: { [weak self] sectionModel in
      guard let `self` = self else { return }
      self.detailMapView.removeAnnotations(self.markers ?? [])
      
      let promiseDateTime = self.viewModel.promise?.dateTime.timeInMillis ?? Date().timeInMillis
      let current = Date().timeInMillis

      guard promiseDateTime + 3600000 >= current && current >= promiseDateTime - 7200000 else {
        UIAlertController.simpleAlert(self, title: "알림", message: "약속 활성화 시간(2시간 전)이 아니어서 위치정보는 볼 수 없어요")
        return
      }
      
      let userNumber = UserDefaultService.phoneNumber ?? ""
    
      sectionModel.first?.items.forEach { contact in
        guard let latitude = contact.latitude,
          let longitude = contact.longitude,
          latitude >= 33.0 && latitude <= 43.0 && longitude >= 124.0 && longitude <= 132.0
          else { return }
        
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let annotation = Member(name: contact.nickname ?? "미가입자", phone: contact.phone, imagePath: contact.profileImagePath ?? "", discipline: "Member", coordinate: coordinate, pushToken: contact.pushToken ?? "")
        if contact.phone == userNumber {
          self.currentMarker = annotation
        } else {
          self.markers?.append(annotation)
        }
        
        self.detailMapView.addAnnotation(annotation)
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

extension PromiseDetailViewController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    var annotationView: CatchUpAnnotationView?
    guard let annotation = annotation as? Member else { return nil }
    
    if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: CatchUpAnnotationView.reuseIdentifier) as? CatchUpAnnotationView {
      annotationView = dequeuedAnnotationView
      annotationView?.annotation = annotation
    } else {
      annotationView = CatchUpAnnotationView(annotation: annotation, reuseIdentifier: CatchUpAnnotationView.reuseIdentifier)
      annotationView?.rightCalloutAccessoryView = UIButton(type: .contactAdd)
    }
//    annotation.coordinate
    annotationView?.markerState = .moving(imagePath: annotation.imagePath)
    if let annotationView = annotationView {
      annotationView.canShowCallout = true
      annotationView.image = nil
    }
    
    return annotationView
  }
  
  func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    if let member = view.annotation as? Member {
      openPushDialog(pushToken: member.pushToken)
    }
  }
}
