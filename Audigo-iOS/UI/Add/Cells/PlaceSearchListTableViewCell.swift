//
//  PlaceSearchListTableViewCell.swift
//  Audigo-iOS
//
//  Created by hPark on 2018. 10. 14..
//  Copyright © 2018년 BlackBurn. All rights reserved.
//

import UIKit
import MapKit

class PlaceSearchListTableViewCell: UITableViewCell {
  
  @IBOutlet weak var placeTitleLabel: UILabel!
  @IBOutlet weak var placeSubTitleLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  func configure(result: MKLocalSearchCompletion) {
    placeTitleLabel.text = result.title
    placeSubTitleLabel.text = result.subtitle
  }
  
}
