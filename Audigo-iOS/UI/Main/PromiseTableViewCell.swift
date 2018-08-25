//
//  PromiseTableViewCell.swift
//  Audigo-iOS
//
//  Created by hPark on 2018. 8. 11..
//  Copyright © 2018년 BlackBurn. All rights reserved.
//

import UIKit

class PromiseTableViewCell: UITableViewCell {
  
  @IBOutlet weak var promiseDateLabel: UILabel!
  @IBOutlet weak var promiseDayLabel: UILabel!
  @IBOutlet weak var promiseNameLabel: UILabel!
  @IBOutlet weak var promiseTimeLeftLabel: UILabel!
  @IBOutlet weak var promiseTimeLabel: UILabel!
  @IBOutlet weak var promiseAddressLabel: UILabel!
  @IBOutlet weak var promiseMembersCollectionView: UICollectionView!
  @IBOutlet weak var itemView: UIView!
  @IBOutlet weak var itemPanelView: UIView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    itemPanelView.layer.borderColor = UIColor.paleGray.cgColor
    itemPanelView.layer.borderWidth = 1
    itemPanelView.layer.cornerRadius = 5
  }
  
  func configure(promise: GetUserWithPromisesQuery.Data.User.Pocket.PromiseList) {
    let timestamp = UInt64(promise.timestamp ?? "1000")!
    let now = Date().timeInMillis
    
    itemView.alpha = timestamp >= now ? 1 : 0.4
    promiseNameLabel.text = promise.name
    promiseAddressLabel.text = promise.address
    
    let timeFormat = DateFormatter()
    timeFormat.dateFormat = "a hh시 mm분"
    
    let dateFormat = DateFormatter()
    dateFormat.dateFormat = "dd"
    
    let dayFormat = DateFormatter()
    dayFormat.dateFormat = "EEEE"

    let dateTime = Date(timeIntervalSince1970: TimeInterval(timestamp / 1000))
    
    promiseTimeLabel.text = timeFormat.string(from: dateTime)
    promiseDateLabel.text = dateFormat.string(from: dateTime)
    promiseDayLabel.text = dayFormat.string(from: dateTime)
    
    // 오늘일 경우
    // 오늘은 아니지만 아직 남은경우
    // 지난 경우
  }
}
