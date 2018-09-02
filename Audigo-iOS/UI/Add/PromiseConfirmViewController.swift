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
    confirmationLabel.text = "약속 \(isEditingPromise ? "수정" : "추가") 완료"
    dateTimeLabel.text = dateTime
    locationLabel.text = location
    membersLabel.text = members
    
    contentView.layer.shadowColor = UIColor.marineBlue.cgColor
    contentView.layer.shadowOpacity = 0.7
    contentView.layer.shadowOffset = CGSize(width: 1.0, height: 4.0)
    contentView.layer.shadowRadius = 4
  }
  
  @IBAction func checkedConfirmation(_ sender: Any) {
    let alert = UIAlertController(title: "약속 정보 공유", message: "생성된 약속을 카카오톡으로 공유하시겠어요?", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: { _ in
      self.dismiss(animated: true) {
        self.confirmDone?.onNext(())
      }
    }))
    
    alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { action in
      let template = KMTLocationTemplate.init { builder in
        builder.address = self.location
        builder.addressTitle = "테스트"
        builder.buttonTitle = "앱으로 보기"
        
        builder.content = KMTContentObject.init(builderBlock: { contentBuilder in
          contentBuilder.title = "테스트"
          contentBuilder.desc = "테스트"
          contentBuilder.imageURL = URL.init(string: "www.naver.com")!
          contentBuilder.link = KMTLinkObject.init(builderBlock: { linkBuilder in
            linkBuilder.mobileWebURL = URL.init(string: "www.naver.com")!
          })
        })
        
        builder.social = KMTSocialObject.init(builderBlock: { socialBuilder in
          socialBuilder.likeCount = 100
          socialBuilder.commnentCount = 100
          socialBuilder.sharedCount = 100
        })
      }
      
      KLKTalkLinkCenter.shared().sendDefault(with: template, success: { (warning, args) in
        self.dismiss(animated: true) {
          self.confirmDone?.onNext(())
        }
      }) { (error) in
        print(error.localizedDescription)
      }
    }))
    
    self.present(alert, animated: true)
  }
}
