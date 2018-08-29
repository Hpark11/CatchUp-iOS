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
  @IBOutlet weak var contentView: UIView!
  
  var confirmDone: PublishSubject<Void>?
  var isEditingPromise = false
  var dateTime = ""
  var location = ""
  var members = ""
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    contentView.layer.cornerRadius = 10
    confirmationLabel.text = "약속 \(isEditingPromise ? "편집" : "추가") 완료"
    dateTimeLabel.text = dateTime
    locationLabel.text = location
    membersLabel.text = members
  }
  
  @IBAction func checkedConfirmation(_ sender: Any) {
    let alert = UIAlertController(title: "이름 짓기", message: "생성할 약속의 이름을 입력해주세요", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: { _ in
      self.dismiss(animated: true) {
        self.confirmDone?.onNext(())
      }
    }))
    
    alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { action in
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
      
      self.dismiss(animated: true) {
        self.confirmDone?.onNext(())
      }
    }))
    
    self.present(alert, animated: true)
  }
}
