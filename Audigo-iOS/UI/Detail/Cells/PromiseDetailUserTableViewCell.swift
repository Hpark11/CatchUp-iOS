//
//  PromiseDetailUserTableViewCell.swift
//  Audigo-iOS
//
//  Created by hPark on 2018. 8. 18..
//  Copyright © 2018년 BlackBurn. All rights reserved.
//

import UIKit
import Kingfisher
import CoreLocation
import RxSwift
import MapKit
import RxCocoa

class PromiseDetailUserTableViewCell: UITableViewCell {

  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var memberNameLabel: UILabel!
  @IBOutlet weak var arrivalTimeLabel: UILabel!
  @IBOutlet weak var statusLabel: UILabel!
  @IBOutlet weak var itemView: UIView!
  
  private var viewModel: PromiseDetailUserViewModel?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    itemView.layer.shadowColor = UIColor.paleGray.cgColor
    itemView.layer.shadowOpacity = 1
    itemView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
    itemView.layer.shadowRadius = 4
    
    itemView.layer.borderWidth = 1
    itemView.layer.borderColor = UIColor.paleGray.cgColor
    itemView.layer.cornerRadius = 5
    
    profileImageView.layer.cornerRadius = 20
  }
  
  func configure(viewModel: PromiseDetailUserViewModel) {
    self.viewModel = viewModel
    
    arrivalTimeLabel.text = viewModel.distance
    statusLabel.text = viewModel.status
    statusLabel.textColor = viewModel.statusColor
    memberNameLabel.text = viewModel.nickname
    profileImageView.kf.setImage(with: viewModel.imagePath, placeholder: R.image.image_profile_default())
  }
  
  @IBAction func notifyPromise(_ sender: Any) {
    viewModel?.sendPushToMember()
  }
}
