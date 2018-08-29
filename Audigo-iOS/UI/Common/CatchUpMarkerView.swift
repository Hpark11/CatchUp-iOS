//
//  CatchUpMarkerView.swift
//  Audigo-iOS
//
//  Created by hPark on 2018. 8. 29..
//  Copyright © 2018년 BlackBurn. All rights reserved.
//

import UIKit
import Kingfisher

enum MarkerState {
  case arrived(imagePath: String)
  case moving(imagePath: String)
}

class CatchUpMarkerView: UIView {

  @IBOutlet var contentView: UIView!
  @IBOutlet weak var markerImageView: UIImageView!
  @IBOutlet weak var profileImageView: UIImageView!

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupView()
  }
  
  private func setupView() {
    contentView = R.nib.catchUpMarkerView().instantiate(withOwner: self, options: nil)[0] as! UIView
    addSubview(contentView)
    contentView.frame = self.bounds
    contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
  }
  
  var markerState: MarkerState = .moving(imagePath: "") {
    didSet {
      switch markerState {
      case .arrived(let path):
        profileImageView.image = R.image.image_marker_arrived()
        profileImageView.kf.setImage(with: URL(string: path ?? ""))
      case .moving(let path):
        profileImageView.image = R.image.image_marker_moving()
        profileImageView.kf.setImage(with: URL(string: path ?? ""))
      }
    }
  }
}
