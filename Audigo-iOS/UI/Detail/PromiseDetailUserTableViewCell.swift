//
//  PromiseDetailUserTableViewCell.swift
//  Audigo-iOS
//
//  Created by hPark on 2018. 8. 18..
//  Copyright © 2018년 BlackBurn. All rights reserved.
//

import UIKit
import Kingfisher
import CoreLocation
import RxSwift
import MapKit

class PromiseDetailUserTableViewCell: UITableViewCell {

  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var memberNameLabel: UILabel!
  @IBOutlet weak var arrivalTimeLabel: UILabel!
  @IBOutlet weak var statusLabel: UILabel!
  @IBOutlet weak var itemView: UIView!
  var sendPush: PublishSubject<String>?
  var pushToken: String?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    itemView.layer.shadowColor = UIColor.paleGray.cgColor
    itemView.layer.shadowOpacity = 1
    itemView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
    itemView.layer.shadowRadius = 4
  }
  
  func configure(contact: CatchUpContact, sendPush: PublishSubject<String>) {
    self.sendPush = sendPush
    self.pushToken = contact.pushToken
    
    let fromCoordinate = CLLocation(latitude: contact.latitude ?? 0.0, longitude: contact.longitude ?? 0.0)
    let destCoordinate = CLLocation(latitude: contact.destLatitude, longitude: contact.destLongitude)
    
    let request: MKDirectionsRequest = MKDirectionsRequest()
    request.source = MKMapItem(placemark: MKPlacemark(coordinate: fromCoordinate.coordinate))
    request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destCoordinate.coordinate))
    request.requestsAlternateRoutes = true
    request.transportType = .any
  
    let directions = MKDirections(request: request)
    arrivalTimeLabel.text = "좌표 로드 실패"
    statusLabel.text = "행방불명"
    
    directions.calculate { [weak self] (response, error) in
      guard let `self` = self else { return }
      if let routeResponse = response?.routes {
        let quickestRoute: MKRoute? = routeResponse.sorted { $0.expectedTravelTime < $1.expectedTravelTime }.first
        if let route = quickestRoute {
          let calendar = Calendar(identifier: .gregorian)
          let timeComponents = calendar.dateComponents([.hour, .minute], from: Date(), to: Date(timeInterval: route.expectedTravelTime * 2, since: Date()))
          
          if route.distance < Define.distanceLowerBound {
            self.statusLabel.text = "도착 완료"
            self.statusLabel.textColor = .warmPink
            self.arrivalTimeLabel.text = ""
          } else if let hour = timeComponents.hour, let minute = timeComponents.minute {
            self.statusLabel.text = "이동 중"
            self.statusLabel.textColor = .warmBlue
            self.arrivalTimeLabel.text = "약 \(hour > 0 ? "\(hour)시간 " : "")\(minute > 0 ? "\(minute)분 " : "")남음"
          }
        }
      }
    }
    
    memberNameLabel.text = contact.nickname
    if let item = ContactItem.find(phone: contact.phone), !item.nickname.isEmpty {
      memberNameLabel.text = item.nickname
    }
    
    profileImageView.layer.cornerRadius = 20
    let url = URL(string: contact.profileImagePath ?? "")
    profileImageView.kf.setImage(with: url, placeholder: R.image.image_profile_default())
    
    itemView.layer.borderWidth = 1
    itemView.layer.borderColor = UIColor.paleGray.cgColor
    itemView.layer.cornerRadius = 5
  }
  
  @IBAction func notifyPromise(_ sender: Any) {
    if let token = pushToken {
      sendPush?.onNext(token)
    }
  }
}
