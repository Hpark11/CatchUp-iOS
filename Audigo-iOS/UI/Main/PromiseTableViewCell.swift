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
    
    promiseMembersCollectionView.delegate = self
    promiseMembersCollectionView.dataSource = self
  }
  
  func configure(promise: GetUserWithPromisesQuery.Data.User.Pocket.PromiseList) {
    let calendar = Calendar(identifier: .gregorian)
    let timestamp = UInt64(promise.timestamp ?? "1000")!
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
    
    if let gapByDay = calendar.dateComponents([.day], from: now, to: dateTime).day {
      switch gapByDay {
      case 0:
        itemDateView.backgroundColor = .darkSkyBlue
      case 1...Int.max:
        itemDateView.backgroundColor = .darkSoftSkyBlue
      default:
        itemDateView.backgroundColor = .silver
        itemPanelView.backgroundColor = .paleSoftGray
      }
    }
    
    memberList = promise.pockets?.compactMap { pocket in
      return pocket?.profileImagePath
    } ?? []
    
    promiseMembersCollectionView.reloadData()
  }
}

extension PromiseTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return memberList.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.memberCollectionViewCell.identifier, for: indexPath) as! MemberCollectionViewCell
    cell.configure(imagePath: memberList[indexPath.item])
    return cell
  }
}
