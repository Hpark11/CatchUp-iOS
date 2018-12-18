//
//  KMTLocationTemplate+Ext.swift
//  Audigo-iOS
//
//  Created by hPark on 28/10/2018.
//  Copyright © 2018 BlackBurn. All rights reserved.
//

import Foundation

extension KMTLocationTemplate {
  static func sharePromiseTemplate(promise: PromiseItem) -> KMTLocationTemplate {
    let timeFormat = DateFormatter()
    timeFormat.dateFormat = "MM.dd (EEE) a hh시 mm분"
    timeFormat.locale = Locale.current
    
    return KMTLocationTemplate.init { builder in
      builder.address = promise.address
      builder.addressTitle = promise.name
      builder.buttonTitle = "참여하기"
      
      builder.content = KMTContentObject.init(builderBlock: { contentBuilder in
        contentBuilder.title = promise.name
        contentBuilder.desc = "일시: \(timeFormat.string(from: promise.dateTime)) \n장소: \(promise.address)"
        contentBuilder.imageURL = Define.appStoreUrl
        contentBuilder.link = KMTLinkObject.init(builderBlock: { linkBuilder in
          linkBuilder.mobileWebURL = Define.appStoreUrl
          linkBuilder.androidExecutionParams = "param1=\(promise.id)&param2=\(promise.name)"
          linkBuilder.iosExecutionParams = "param1=\(promise.id)&param2=\(promise.name)"
        })
      })
      
      builder.social = KMTSocialObject.init(builderBlock: { socialBuilder in
        socialBuilder.likeCount = promise.contacts.count as NSNumber
      })
    }
  }
}
