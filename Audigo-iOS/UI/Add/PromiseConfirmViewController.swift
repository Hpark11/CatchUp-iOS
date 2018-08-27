//
//  PromiseConfirmViewController.swift
//  Audigo-iOS
//
//  Created by hPark on 2018. 8. 26..
//  Copyright © 2018년 BlackBurn. All rights reserved.
//

import UIKit
import RxSwift

class PromiseConfirmViewController: UIViewController {
  
  @IBOutlet weak var confirmationLabel: UILabel!
  @IBOutlet weak var dateTimeLabel: UILabel!
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var membersLabel: UILabel!
  
  var confirmDone: PublishSubject<Void>?
  var isEditingPromise = false
  var dateTime = ""
  var location = ""
  var members = ""
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    confirmationLabel.text = "약속 \(isEditingPromise ? "편집" : "추가") 완료"
    dateTimeLabel.text = dateTime
    locationLabel.text = location
    membersLabel.text = members
  }
  
  @IBAction func checkedConfirmation(_ sender: Any) {
    dismiss(animated: true) {
      self.confirmDone?.onNext(())
    }
    
    let template = KMTLocationTemplate.init { builder in
      builder.address = ""
      builder.addressTitle = ""
      
      builder.content = KMTContentObject.init(builderBlock: { contentBuilder in
        contentBuilder.title = ""
        contentBuilder.desc = ""
        contentBuilder.imageURL = URL.init(string: "")!
        contentBuilder.link = KMTLinkObject.init(builderBlock: { linkBuilder in
          linkBuilder.mobileWebURL = URL.init(string: "")!
        })
        
      })
      
      builder.social = KMTSocialObject.init(builderBlock: { socialBuilder in
        socialBuilder.likeCount = 100
        socialBuilder.commnentCount = 100
        socialBuilder.sharedCount = 100
      })
    }
    
    KLKTalkLinkCenter.shared().sendDefault(with: template, success: { (warning, args) in
      
    }) { (error) in
      print(error.localizedDescription)
    }
  }
}
