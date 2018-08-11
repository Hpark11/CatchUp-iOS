//
//  MemberCollectionViewCell.swift
//  Audigo-iOS
//
//  Created by hPark on 2018. 8. 11..
//  Copyright © 2018년 BlackBurn. All rights reserved.
//

import UIKit

class MemberCollectionViewCell: UICollectionViewCell {
  
  
  
  @IBOutlet weak var memberImageView: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    
    memberImageView.layer.cornerRadius = memberImageView.frame.size.width / 2
  }
  
  
}
