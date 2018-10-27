//
//  Define.swift
//  Audigo-iOS
//
//  Created by hPark on 2018. 10. 3..
//  Copyright © 2018년 BlackBurn. All rights reserved.
//

import Foundation
import AWSAppSync

struct Define {
  static let appsyncRegion: AWSRegionType = .APNortheast2
  static let appsyncEndpointURL: URL = URL(string: "https://f3auk6pacreq7fpn7wpky2rvhm.appsync-api.ap-northeast-2.amazonaws.com/graphql")!
  static let appsyncLocalDB: String = "appsync-catchup-db"
  static let appsyncKeyAPI: String = "da2-gp5jgpzvkfdnhfcjp3amglzbee"
  static let appUrl: URL = URL(string: "https://itunes.apple.com/us/app/%EC%BA%90%EC%B9%98%EC%97%85/id1435071896?l=ko&ls=1&mt=8")!
  
  static let keyGMSService: String = "AIzaSyDP-770UOi6uLfb7QlIlWK5r-hMYUrRihE"
  static let keyGMSPlace: String = "AIzaSyDP-770UOi6uLfb7QlIlWK5r-hMYUrRihE"
  static let idGADMobileAds: String = "ca-app-pub-1670879929355255~4408167733"
  static let idGADMobileAdsCredit: String = "ca-app-pub-1670879929355255/1884030453"
  
  static let keyPhoneNumber: String = "phoneNumber"
  static let keyPushToken: String = "pushToken"
  static let keyCredit: String = "credit"
  static let keyUserId: String = "userId"
  static let keyUserNickname: String = "userNickname"
  
  static let initCredit: Int = 25
  static let dynamoDbBatchLimit: Int = 50
  
  static let koreanNormalCellPhonePrefix: String = "010"
  static let ko_KR: String = "+82"
  static let platform: String = "ios"
  
  static let queueLabelCreatePromise = "queue.create.promise"
  static let queueLabelListPromises = "queue.list.promises"
  
  static let appStoreUrl = URL(string: "https://itunes.apple.com/us/app/%EC%BA%90%EC%B9%98%EC%97%85/id1435071896?l=ko&ls=1&mt=8")!
  
  static let distanceUpperBound = 700.0
  static let distanceLowerBound = 0.25
  
  static let majorVersion = 1
  static let minorVersion = 0
  static let revision = 12
  
  static let rlmFileUrlPathPromises = "promises.realm"
  static let rlmManagePromises = "ManagePromises"
  
  struct NotificationName {
    static let didUpdateLocation = Notification.Name(rawValue: "didUpdateLocation")
    static let didParticipate = Notification.Name(rawValue: "didParticipate")
  }
}
