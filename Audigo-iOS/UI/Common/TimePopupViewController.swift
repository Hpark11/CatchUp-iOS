//
//  TimePopupViewController.swift
//  Audigo-iOS
//
//  Created by hPark on 2018. 8. 13..
//  Copyright © 2018년 BlackBurn. All rights reserved.
//

import UIKit
import RxSwift

class TimePopupViewController: UIViewController {
  @IBOutlet weak var timePicker: UIDatePicker!
  var timeSelectDone: PublishSubject<DateComponents>?
  
  @IBAction func selectTime(_ sender: Any) {
    let components = timePicker.calendar.dateComponents([.hour, .minute, .second], from: timePicker.date)
    timeSelectDone?.onNext(components)
    dismiss(animated: true, completion: nil)
  }
}
