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
  
  var confirmDone: PublishSubject<CatchUpPromise?>?
  
  var isEditingPromise = false
  var promise: CatchUpPromise?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    contentView.layer.cornerRadius = 10
    confirmationLabel.text = "약속 \(isEditingPromise ? "수정" : "추가") 완료"
    
    let timeFormat = DateFormatter()
    timeFormat.dateFormat = "MM.dd (EEE) a hh시 mm분"
    timeFormat.locale = Locale.current
    
    if let promise = self.promise {
      let contacts = promise.contacts
      
      if !contacts.isEmpty {
        var members: String = ""
        
        if let member = ContactItem.find(phone: contacts.first ?? "None")?.nickname {
          if contacts.count > 1 {
            members = "\(member) 외 \(contacts.count - 1)명"
          } else {
            members = member
          }
        }
        
        membersLabel.text = members
      }
      
      dateTimeLabel.text = timeFormat.string(from: promise.dateTime)
      locationLabel.text = promise.address
    }
    
    contentView.layer.shadowColor = UIColor.marineBlue.cgColor
    contentView.layer.shadowOpacity = 0.7
    contentView.layer.shadowOffset = CGSize(width: 1.0, height: 4.0)
    contentView.layer.shadowRadius = 4
  }
  
  @IBAction func checkedConfirmation(_ sender: Any) {
    guard let promise = self.promise else { return }
    
    let alert = UIAlertController(title: "약속 정보 공유", message: "생성된 약속을 카카오톡으로 공유하시겠어요?", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: { _ in
      self.dismiss()
    }))
    
    alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { action in
      let template = KMTLocationTemplate.init { builder in
        builder.address = promise.address
        builder.addressTitle = promise.name
        builder.buttonTitle = "앱으로 보기"
        
        builder.content = KMTContentObject.init(builderBlock: { contentBuilder in
          contentBuilder.title = promise.name
          contentBuilder.desc = "일시: \(self.dateTimeLabel.text ?? "") \n장소: \(self.locationLabel.text ?? "") \n인원: \(self.membersLabel.text ?? "")"
          contentBuilder.imageURL = Define.appStoreUrl
          contentBuilder.link = KMTLinkObject.init(builderBlock: { linkBuilder in
            linkBuilder.mobileWebURL = Define.appStoreUrl
            linkBuilder.androidExecutionParams = "param1=\(promise.id)"
            linkBuilder.iosExecutionParams = "param1=\(promise.id)"
          })
        })
        
        builder.social = KMTSocialObject.init(builderBlock: { socialBuilder in
          socialBuilder.likeCount = promise.contacts.count as NSNumber
//          socialBuilder.commnentCount = 100
//          socialBuilder.sharedCount = 100
        })
      }
      
      KLKTalkLinkCenter.shared().sendDefault(with: template, success: { (warning, args) in
        self.dismiss()
      }) { (error) in
        print(error.localizedDescription)
      }
    }))
    
    self.present(alert, animated: true)
  }
  
  private func dismiss() {
    self.dismiss(animated: true) {
      self.confirmDone?.onNext(self.promise)
    }
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
}
