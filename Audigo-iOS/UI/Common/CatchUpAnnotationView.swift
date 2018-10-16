//
//  CatchUpAnnotationView.swift
//  Audigo-iOS
//
//  Created by hPark on 17/10/2018.
//  Copyright © 2018 BlackBurn. All rights reserved.
//

import UIKit
import MapKit

enum MarkerState {
  case arrived(imagePath: String)
  case moving(imagePath: String)
}

class CatchUpAnnotationView: MKAnnotationView {
  public static let reuseIdentifier: String = "CatchUpAnnotationView"
  
  @IBOutlet var contentView: UIView!
  @IBOutlet weak var profileImageView: UIImageView!
  
  override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
    super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    setupView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupView()
  }
  
  private func setupView() {
    contentView = R.nib.catchUpAnnotationView().instantiate(withOwner: self, options: nil)[0] as! UIView
    addSubview(contentView)
    contentView.frame = self.bounds
    contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    profileImageView.layer.cornerRadius = 16
  }
  
  var markerState: MarkerState = .moving(imagePath: "") {
    didSet {
      switch markerState {
      case .arrived(let path):
        profileImageView.image = R.image.image_marker_arrived()
        profileImageView.kf.setImage(with: URL(string: path))
      case .moving(let path):
        profileImageView.image = R.image.image_marker_moving()
        profileImageView.kf.setImage(with: URL(string: path))
      }
    }
  }
}
