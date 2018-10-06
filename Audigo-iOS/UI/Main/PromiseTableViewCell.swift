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
  @IBOutlet weak var itemDateView: UIView!
  
  private var memberList = [String]()
  
  override func awakeFromNib() {
    super.awakeFromNib()
    itemPanelView.layer.borderColor = UIColor.paleGray.cgColor
    itemPanelView.layer.borderWidth = 1
    itemPanelView.layer.cornerRadius = 5
    itemPanelView.backgroundColor = .white
    itemDateView.layer.cornerRadius = 5
    
    itemPanelView.layer.shadowColor = UIColor.paleGray.cgColor
    itemPanelView.layer.shadowOpacity = 1
    itemPanelView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
    itemPanelView.layer.shadowRadius = 4
    
    promiseMembersCollectionView.delegate = self
    promiseMembersCollectionView.dataSource = self
  }
  
  func configure(promise: CatchUpPromise) {
    let calendar = Calendar(identifier: .gregorian)
    let timestamp = promise.dateTime.timeInMillis
    let now = Date()
    
    itemView.alpha = timestamp >= now.timeInMillis ? 1 : 0.4
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
    
    let gap = calendar.dateComponents([.day, .hour, .minute], from: now, to: dateTime)
    
    if now.timeIntervalSince1970 > dateTime.timeIntervalSince1970 {
      itemDateView.backgroundColor = .silver
      itemPanelView.backgroundColor = .paleSoftGray
      promiseTimeLeftLabel.text = "지난 약속"
      promiseTimeLeftLabel.textColor = .stale
    } else if let dayGap = gap.day, let hourGap = gap.hour, let minuteGap = gap.minute {
      switch dayGap {
      case 0:
        itemDateView.backgroundColor = .darkSkyBlue
        if hourGap >= 1 {
          promiseTimeLeftLabel.text = "\(hourGap)시간 전"
          promiseTimeLeftLabel.textColor = .warmBlue
        } else {
          promiseTimeLeftLabel.text = "\(minuteGap)분 전"
          promiseTimeLeftLabel.textColor = .darkSkyBlue
        }
      case 1...Int.max:
        promiseTimeLeftLabel.text = "D - \(dayGap)"
        itemDateView.backgroundColor = .darkSoftSkyBlue
        promiseTimeLeftLabel.textColor = .stale
      default:
        itemDateView.backgroundColor = .silver
        itemPanelView.backgroundColor = .paleSoftGray
      }
    }
    
    memberList = promise.contacts
    promiseMembersCollectionView.reloadData()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    itemPanelView.backgroundColor = .white
  }
}

extension PromiseTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return memberList.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.memberCollectionViewCell.identifier, for: indexPath) as! MemberCollectionViewCell
    cell.configure(member: memberList[indexPath.item])
    return cell
  }
}
