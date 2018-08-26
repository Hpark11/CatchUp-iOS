//
//  MemberSelectedCollectionViewCell.swift
//  Audigo-iOS
//
//  Created by hPark on 2018. 8. 26..
//  Copyright © 2018년 BlackBurn. All rights reserved.
//

import UIKit

class MemberSelectedCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var memberImageView: UIImageView!
  @IBOutlet weak var memberNameLabel: UILabel!
  
  func configure(phone: String) {
    memberImageView.layer.cornerRadius = 16
    
    if let info = ContactItem.find(phone: phone) {
      memberNameLabel.text = info.nickname
      let url = URL(string: info.imagePath)
      memberImageView.kf.setImage(with: url)
    }
  }
}
