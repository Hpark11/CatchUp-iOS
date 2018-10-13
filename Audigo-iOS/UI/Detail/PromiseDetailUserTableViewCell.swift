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
  
  func configure(contact: CatchUpContact, sendPush: PublishSubject<String>) {
    self.sendPush = sendPush
    self.pushToken = contact.pushToken
    
    let fromCoordinate = CLLocation(latitude: contact.latitude ?? 0.0, longitude: contact.longitude ?? 0.0)
    let destCoordinate = CLLocation(latitude: contact.destLatitude, longitude: contact.destLongitude)
    let distanceInKMeters = fromCoordinate.distance(from: destCoordinate) / 1000.0
    
    if distanceInKMeters >= Define.distanceUpperBound {
      arrivalTimeLabel.text = "좌표 로드 실패"
      statusLabel.text = "행방불명"
    } else if distanceInKMeters < Define.distanceLowerBound {
      statusLabel.text = "도착"
      statusLabel.textColor = .warmPink
      arrivalTimeLabel.text = "약 \(round(distanceInKMeters * 100) / 100) km"
    } else {
      statusLabel.text = "이동중"
      statusLabel.textColor = .warmBlue
      arrivalTimeLabel.text = "약 \(round(distanceInKMeters * 100) / 100) km"
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
