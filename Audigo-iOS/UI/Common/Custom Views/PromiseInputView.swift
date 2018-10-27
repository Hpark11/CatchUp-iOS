//
//  PromiseInputView.swift
//  Audigo-iOS
//
//  Created by hPark on 2018. 8. 28..
//  Copyright © 2018년 BlackBurn. All rights reserved.
//

import UIKit

enum InputState {
  case applied(input: String)
  case search(title: String, input: String)
  case choice(title: String, input: String)
  case none(title: String, input: String)
}

class PromiseInputView: UIView {

  @IBOutlet var contentView: UIView!
  @IBOutlet weak var promiseLowerLine: UIView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var inputLabel: UILabel!
  @IBOutlet weak var subIconImageView: UIImageView!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupView()
  }
  
  private func setupView() {
    contentView = R.nib.promiseInputView().instantiate(withOwner: self, options: nil)[0] as! UIView
    addSubview(contentView)
    contentView.frame = self.bounds
    contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
  }
  
  var inputState: InputState = .none(title: "", input: "") {
    didSet {
      promiseLowerLine.backgroundColor = .paleGray
      inputLabel.textColor = .coolGrey
      
      switch inputState {
      case .applied(let input):
        subIconImageView.image = R.image.icon_ok()
        promiseLowerLine.backgroundColor = .darkSkyBlue
        inputLabel.textColor = .darkSkyBlue
        inputLabel.text = input
      case .search(let title, let input):
        titleLabel.text = title
        inputLabel.text = input
        subIconImageView.image = R.image.icon_search()
      case .choice(let title, let input):
        titleLabel.text = title
        inputLabel.text = input
        subIconImageView.image = R.image.icon_down()
      case .none(let title, let input):
        titleLabel.text = title
        inputLabel.text = input
        subIconImageView.image = nil
      }
    }
  }
}
