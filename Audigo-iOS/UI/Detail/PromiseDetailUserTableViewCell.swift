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
  @IBOutlet weak var notifyImageView: UIImageView!
  @IBOutlet weak var memberNameLabel: UILabel!
  @IBOutlet weak var arrivalTimeLabel: UILabel!
  @IBOutlet weak var statusLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    // Configure the view for the selected state
  }
  
  func configure(pocket: GetPromiseQuery.Data.Promise.Pocket) {
    memberNameLabel.text = pocket.nickname
    
    
  }
}
