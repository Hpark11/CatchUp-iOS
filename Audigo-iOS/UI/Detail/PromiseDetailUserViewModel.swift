//
//  PromiseDetailUserTableViewModel.swift
//  Audigo-iOS
//
//  Created by hPark on 24/10/2018.
//  Copyright © 2018 BlackBurn. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources
import CoreLocation

struct PromiseDetailUserViewModel {
  static let notnow = "기다려"
  static let missing = "행방불명"
  static let arrived = "도착"
  static let moving = "이동중"
  
  let sendPush: PublishSubject<String>
  let fromLocation: CLLocation
  let toLocation: CLLocation
  let distanceInKMeters: CLLocationDistance
  
  private let promise: PromiseItem
  private let contact: CatchUpContact
  
  init(promise: PromiseItem, contact: CatchUpContact, sendPush: PublishSubject<String>) {
    self.promise = promise
    self.contact = contact
    self.sendPush = sendPush
    
    fromLocation = CLLocation(latitude: contact.latitude ?? 0.0, longitude: contact.longitude ?? 0.0)
    toLocation = CLLocation(latitude: promise.latitude, longitude: promise.longitude)
    distanceInKMeters = fromLocation.distance(from: toLocation) / 1000.0
  }
  
  var isActiveTime: Bool {
    let current = Date().timeInMillis
    let promisedAt = promise.dateTime.timeInMillis
    return promisedAt + 3600000 >= current && current >= promisedAt - 7200000
  }
  
  var distance: String {
    if !isActiveTime {
      return "활성화 시간 아님"
    } else if distanceInKMeters >= Define.distanceUpperBound {
      return "좌표 로드 실패"
    } else {
      return "약 \(round(distanceInKMeters * 100) / 100) km"
    }
  }
    
  var status: String {
    if !isActiveTime {
      return PromiseDetailUserViewModel.notnow
    } else if distanceInKMeters >= Define.distanceUpperBound {
      return PromiseDetailUserViewModel.missing
    } else if distanceInKMeters < Define.distanceLowerBound {
      return PromiseDetailUserViewModel.arrived
    } else {
      return PromiseDetailUserViewModel.moving
    }
  }
  
  var statusColor: UIColor {
    if !isActiveTime {
      return UIColor.paleGray
    } else if distanceInKMeters >= Define.distanceUpperBound {
      return UIColor.Flat.Red.terra
    } else if distanceInKMeters < Define.distanceLowerBound {
      return UIColor.warmPink
    } else {
      return UIColor.warmBlue
    }
  }
  
  var nickname: String {
    if let item = ContactItem.find(phone: contact.phone), !item.nickname.isEmpty {
      return item.nickname
    } else {
      return contact.nickname ?? "미가입자"
    }
  }
  
  var imagePath: URL? {
    return URL(string: contact.profileImagePath ?? "")
  }
  
  var memberAnnotation: Member {
    return Member(name: contact.nickname ?? "미가입자",
                  phone: contact.phone,
                  imagePath: contact.profileImagePath ?? "",
                  discipline: "",
                  coordinate: fromLocation.coordinate,
                  pushToken: contact.pushToken ?? ""
    )
  }
  
  func sendPushToMember() {
    if let token = contact.pushToken {
      sendPush.onNext(token)
    }
  }
}

extension PromiseDetailUserViewModel: IdentifiableType, Equatable {
  public var identity: String {
    return contact.phone
  }
  
  public static func ==(lhs: PromiseDetailUserViewModel, rhs: PromiseDetailUserViewModel) -> Bool {
    return lhs.contact.phone == rhs.contact.phone
  }
}
