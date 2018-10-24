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

struct PromiseDetailUserViewModel {
  let sendPush: PublishSubject<String>
  private let promise: CatchUpPromise
  private let contact: CatchUpContact
  
  init(promise: CatchUpPromise, contact: CatchUpContact, sendPush: PublishSubject<String>) {
    self.promise = promise
    self.contact = contact
    self.sendPush = sendPush
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
