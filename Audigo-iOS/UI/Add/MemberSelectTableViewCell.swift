//
//  MemberSelectTableViewCell.swift
//  Audigo-iOS
//
//  Created by hPark on 2018. 8. 14..
//  Copyright © 2018년 BlackBurn. All rights reserved.
//

import UIKit

class MemberSelectTableViewCell: UITableViewCell {
  
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var memberNameLabel: UILabel!
  @IBOutlet weak var checkImageView: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  func configure(item: ContactItem) {
    memberNameLabel.text = item.nickname
    
    
  }
}
