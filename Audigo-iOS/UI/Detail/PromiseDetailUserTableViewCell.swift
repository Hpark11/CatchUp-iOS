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
  
  func configure(promisePocket: PromisePocket, sendPush: PublishSubject<String>) {
    let pocket = promisePocket.pocket
    self.sendPush = sendPush
    self.pushToken = pocket.pushToken
    
    if let latitude = pocket.latitude, let longitude = pocket.longitude {
      let fromCoordinate = CLLocation(latitude: latitude, longitude: longitude)
      let destCoordinate = CLLocation(latitude: promisePocket.destLatitude, longitude: promisePocket.destLongitude)
      let distanceInMeters = fromCoordinate.distance(from: destCoordinate) / 1000.0
      
      if distanceInMeters >= 700 {
        arrivalTimeLabel.text = "GPS 차단 중"
        statusLabel.text = "행방불명"
      } else if distanceInMeters <= 0.15 {
        statusLabel.text = "도착"
        statusLabel.textColor = .warmPink
        arrivalTimeLabel.text = "약 \(round(distanceInMeters * 100) / 100) km"
      } else {
        statusLabel.text = "이동중"
        statusLabel.textColor = .warmBlue
        arrivalTimeLabel.text = "약 \(round(distanceInMeters * 100) / 100) km"
      }
    }
    
    if let nickname = pocket.nickname {
      memberNameLabel.text = nickname
    } else {
      let item = ContactItem.find(phone: pocket.phone)
      memberNameLabel.text = item?.nickname
    }
    
    profileImageView.layer.cornerRadius = 20
    let url = URL(string: pocket.profileImagePath ?? "")
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
