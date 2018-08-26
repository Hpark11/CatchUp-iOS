//
//  MemberSelectTableViewCell.swift
//  Audigo-iOS
//
//  Created by hPark on 2018. 8. 14..
//  Copyright © 2018년 BlackBurn. All rights reserved.
//

import UIKit
import Kingfisher

class MemberSelectTableViewCell: UITableViewCell {
  
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var memberNameLabel: UILabel!
  @IBOutlet weak var checkImageView: UIImageView!
  @IBOutlet weak var itemView: UIView!
  
  func configure(item: ContactItem) {
    profileImageView.layer.cornerRadius = 21
    profileImageView.kf.setImage(with: URL(string: item.imagePath))
    memberNameLabel.text = item.nickname
  }
  
  override func prepareForReuse() {
    accessoryType = .none
    setSelected(false, animated: false)
  }
}
