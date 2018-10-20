//
//  MemberCollectionViewCell.swift
//  Audigo-iOS
//
//  Created by hPark on 2018. 8. 11..
//  Copyright © 2018년 BlackBurn. All rights reserved.
//

import UIKit
import Kingfisher
import RealmSwift

class MemberCollectionViewCell: UICollectionViewCell {
  @IBOutlet weak var memberImageView: UIImageView!
  
  func configure(member: String) {
    let contact = ContactItem.find(phone: member)
    let url = URL(string: contact?.imagePath ?? "")
    self.memberImageView.kf.setImage(with: url, placeholder: R.image.image_profile_default())
    
    memberImageView.layer.cornerRadius = 15
    memberImageView.layer.borderWidth = 1
    memberImageView.layer.borderColor = UIColor.paleGray.cgColor
  }
}
