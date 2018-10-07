//
//  PushMessageService.swift
//  Audigo-iOS
//
//  Created by hPark on 2018. 10. 6..
//  Copyright © 2018년 BlackBurn. All rights reserved.
//

import Foundation
import FirebaseFirestore

class PushMessageService {
  static let fieldTitle = "title"
  static let fieldMessage = "message"
  static let fieldPushTokens = "pushTokens"
  
  static let collectionMessages = "messages"
  
  static private var database: Firestore {
    let db = Firestore.firestore()
    let settings = db.settings
    settings.areTimestampsInSnapshotsEnabled = true
    db.settings = settings
    return db
  }
  
  static func sendPush(title: String, message: String, pushTokens: [String]) {
    let dataDictionary: [String: Any] = [
      fieldTitle: title,
      fieldMessage: message,
      fieldPushTokens: pushTokens
    ]
    
    database.collection(collectionMessages).document(UUID.init().uuidString).setData(dataDictionary) { err in
      if let err = err {
        print("Error writing document: \(err)")
      } else {
        print("Document successfully written!")
      }
    }
  }
}
