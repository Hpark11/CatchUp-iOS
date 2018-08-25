//
//  MonthPopupViewController.swift
//  Audigo-iOS
//
//  Created by hPark on 2018. 8. 25..
//  Copyright © 2018년 BlackBurn. All rights reserved.
//

import UIKit
import RxSwift

class MonthPopupViewController: UIViewController {
  @IBOutlet weak var monthPicker: MonthSelectPickerView!
  var monthSelectDone: PublishSubject<(Int, Int)>?
  var month = 1
  var year = 2018
  
  override func viewDidLoad() {
    super.viewDidLoad()
    monthPicker.month = month
    monthPicker.year = year
    
    monthPicker.onDateSelected = { (month, year) in
      self.month = month
      self.year = year
    }
  }
  
  @IBAction func selectMonth(_ sender: Any) {
    self.monthSelectDone?.onNext((month, year))
    self.dismiss(animated: true, completion: nil)
  }
}
