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
  static let appsyncKeyAPI: String = "da2-36apfe4xbzhjfjpz4iwim47ezi"
}
