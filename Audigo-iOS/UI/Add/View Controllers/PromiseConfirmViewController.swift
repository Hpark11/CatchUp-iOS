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
  @IBOutlet weak var contentView: UIView!
  
  var confirmDone: PublishSubject<PromiseItem?>?
  
  var isEditingPromise = false
  var promise: PromiseItem?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    contentView.layer.cornerRadius = 10
    confirmationLabel.text = "약속 \(isEditingPromise ? "수정" : "추가") 완료"
    
    let timeFormat = DateFormatter()
    timeFormat.dateFormat = "MM.dd (EEE) a hh시 mm분"
    timeFormat.locale = Locale.current
    
    if let promise = self.promise {
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
      let template = KMTLocationTemplate.sharePromiseTemplate(promise: promise)
      
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
