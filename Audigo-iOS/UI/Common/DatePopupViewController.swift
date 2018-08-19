//
//  DatePopupViewController.swift
//  Audigo-iOS
//
//  Created by hPark on 2018. 8. 13..
//  Copyright © 2018년 BlackBurn. All rights reserved.
//

import UIKit
import RxSwift

class DatePopupViewController: UIViewController {
  @IBOutlet weak var datePicker: UIDatePicker!
  var dateSelectDone: PublishSubject<DateComponents>?
  
  @IBAction func selectDate(_ sender: Any) {
    let components = datePicker.calendar.dateComponents([.year, .month, .day], from: datePicker.date)
    dateSelectDone?.onNext(components)
    dismiss(animated: true, completion: nil)
  }
}
