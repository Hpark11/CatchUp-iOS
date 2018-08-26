//
//  MemberCollectionViewCell.swift
//  Audigo-iOS
//
//  Created by hPark on 2018. 8. 11..
//  Copyright © 2018년 BlackBurn. All rights reserved.
//

import UIKit
import Kingfisher

class MemberCollectionViewCell: UICollectionViewCell {
  @IBOutlet weak var memberImageView: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()    
  }
  
  func configure(imagePath: String) {
    let url = URL(string: imagePath)
    memberImageView.kf.setImage(with: url)
    memberImageView.layer.cornerRadius = 15
  }
}
