//
//  MonthSelectPickerView.swift
//  Audigo-iOS
//
//  Created by hPark on 2018. 8. 25..
//  Copyright © 2018년 BlackBurn. All rights reserved.
//

import UIKit

class MonthSelectPickerView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
  
  var months: [String]!
  var years: [Int]!
  
  var month = Calendar.current.component(.month, from: Date()) {
    didSet {
      selectRow(month - 1, inComponent: 1, animated: false)
    }
  }
  
  var year = Calendar.current.component(.year, from: Date()) {
    didSet {
      selectRow(years.index(of: year)!, inComponent: 0, animated: true)
    }
  }
  
  var onDateSelected: ((_ month: Int, _ year: Int) -> Void)?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.commonSetup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.commonSetup()
  }
  
  func commonSetup() {
    // population years
    var years: [Int] = []
    if years.count == 0 {
      var year = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!.component(.year, from: Date())
      for _ in 1...15 {
        years.append(year)
        year += 1
      }
    }
    self.years = years
    
    // population months with localized names
    var months: [String] = []
    var month = 0
    for _ in 1...12 {
      months.append(DateFormatter().monthSymbols[month].capitalized)
      month += 1
    }
    self.months = months
    
    self.delegate = self
    self.dataSource = self
    
    let currentMonth = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!.component(.month, from: Date())
    self.selectRow(currentMonth - 1, inComponent: 1, animated: false)
  }
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 2
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    switch component {
    case 0:
      return "\(years[row])"
    case 1:
      return months[row]
    default:
      return nil
    }
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    switch component {
    case 0:
      return years.count
    case 1:
      return months.count
    default:
      return 0
    }
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    let year = years[self.selectedRow(inComponent: 0)]
    let month = self.selectedRow(inComponent: 1) + 1
    if let block = onDateSelected {
      block(month, year)
    }
    
    self.month = month
    self.year = year
  }
}
