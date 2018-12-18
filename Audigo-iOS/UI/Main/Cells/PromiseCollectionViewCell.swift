//
//  PromiseCollectionViewCell.swift
//  Audigo-iOS
//
//  Created by hPark on 2018. 10. 7..
//  Copyright © 2018년 BlackBurn. All rights reserved.
//

import UIKit

class PromiseCollectionViewCell: UICollectionViewCell {
  
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
  private var viewModel: PromiseItemViewModel?
  
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
  
  func configure(viewModel: PromiseItemViewModel) {
    self.viewModel = viewModel
    itemView.alpha = viewModel.isPassedAway ? 0.4 : 1
    promiseTimeLabel.text = viewModel.timeText
    promiseTimeLeftLabel.text = viewModel.timeLeftText
    promiseTimeLeftLabel.textColor = viewModel.timeLeftColor
    promiseDateLabel.text = viewModel.dateText
    promiseDayLabel.text = viewModel.dayText
    promiseNameLabel.text = viewModel.name
    promiseAddressLabel.text = viewModel.address
    
    itemDateView.backgroundColor = viewModel.dateColor
    itemPanelView.backgroundColor = viewModel.panelColor
    
    promiseMembersCollectionView.reloadData()
  }
}

extension PromiseCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel?.members.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: R.reuseIdentifier.memberCollectionViewCell.identifier,
      for: indexPath
    ) as! MemberCollectionViewCell
    
    cell.configure(member: viewModel?.members[indexPath.item] ?? "")
    return cell
  }
}
