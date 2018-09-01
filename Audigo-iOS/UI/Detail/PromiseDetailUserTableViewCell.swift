//
//  PromiseDetailUserTableViewCell.swift
//  Audigo-iOS
//
//  Created by hPark on 2018. 8. 18..
//  Copyright © 2018년 BlackBurn. All rights reserved.
//

import UIKit
import Kingfisher

class PromiseDetailUserTableViewCell: UITableViewCell {

  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var memberNameLabel: UILabel!
  @IBOutlet weak var arrivalTimeLabel: UILabel!
  @IBOutlet weak var statusLabel: UILabel!
  @IBOutlet weak var itemView: UIView!
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    // Configure the view for the selected state
  }
  
  func configure(pocket: GetPromiseQuery.Data.Promise.Pocket) {
    
    if let nickname = pocket.nickname {
      memberNameLabel.text = nickname
    } else {
      let item = ContactItem.find(phone: pocket.phone)
      memberNameLabel.text = item?.nickname
    }
    
    profileImageView.layer.cornerRadius = 20
    let url = URL(string: pocket.profileImagePath ?? "")
    profileImageView.kf.setImage(with: url)
    
    itemView.layer.borderWidth = 1
    itemView.layer.borderColor = UIColor.paleGray.cgColor
    itemView.layer.cornerRadius = 5
  }
}
