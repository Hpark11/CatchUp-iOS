//
//  String.swift
//  Audigo-iOS
//
//  Created by hPark on 2018. 10. 3..
//  Copyright © 2018년 BlackBurn. All rights reserved.
//

import Foundation
import AWSAppSync

extension String: AWSAPIKeyAuthProvider {
  public func getAPIKey() -> String {
    return self
  }
}
