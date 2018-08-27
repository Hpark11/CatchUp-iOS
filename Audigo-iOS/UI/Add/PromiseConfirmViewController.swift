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
  }
}
