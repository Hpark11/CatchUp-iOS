//
//  UIColor+Ext.swift
//  Audigo-iOS
//
//  Created by hPark on 2018. 8. 25..
//  Copyright © 2018년 BlackBurn. All rights reserved.
//

import UIKit

extension UIColor {
  convenience init(red: Int, green: Int, blue: Int) {
    assert(red >= 0 && red <= 255, "Invalid red component")
    assert(green >= 0 && green <= 255, "Invalid green component")
    assert(blue >= 0 && blue <= 255, "Invalid blue component")
    self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
  }
  
  convenience init(hex: Int) {
    self.init(red:(hex >> 16) & 0xff, green:(hex >> 8) & 0xff, blue:hex & 0xff)
  }
}

extension UIColor {
  static let paleGray = UIColor(hex: 0xe5eced)
  static let paleSoftGray = UIColor(hex: 0xf6f8f9)
  static let darkSkyBlue = UIColor(hex: 0x4974e1)
  static let darkSoftSkyBlue = UIColor(hex: 0x2eb8dc)
  static let silver = UIColor(hex: 0xcdd3d9)
  static let stale = UIColor(hex: 0x3c5063)
  static let coolGrey = UIColor(hex: 0xacb6c0)
  static let warmPink = UIColor(hex: 0xf85e83)
  static let warmBlue = UIColor(hex: 0x759bfa)
  static let marineBlue = UIColor(hex: 0x7f002073)
  
  struct Flat {
    struct Green {
      static let fern = UIColor(hex: 0x6ABB72)
      static let mountain = UIColor(hex: 0x3ABB9D)
      static let chateau = UIColor(hex: 0x4DA664)
      static let persian = UIColor(hex: 0x2CA786)
    }
    
    struct Blue {
      static let picton = UIColor(hex: 0x5CADCF)
      static let mariner = UIColor(hex: 0x3585C5)
      static let curious = UIColor(hex: 0x4590B6)
      static let denim = UIColor(hex: 0x2F6CAD)
      static let chambray = UIColor(hex: 0x485675)
      static let whale = UIColor(hex: 0x29334D)
    }
    
    struct Violet {
      static let wisteria = UIColor(hex: 0x9069B5)
      static let gem = UIColor(hex: 0x533D7F)
    }
    
    struct Yellow {
      static let energy = UIColor(hex: 0xF2D46F)
      static let turbo = UIColor(hex: 0xF7C23E)
    }
    
    struct Orange {
      static let neon = UIColor(hex: 0xF79E3D)
      static let sun = UIColor(hex: 0xEE7841)
    }
    
    struct Red {
      static let terra = UIColor(hex: 0xE66B5B)
      static let valencia = UIColor(hex: 0xCC4846)
      static let cinnabar = UIColor(hex: 0xDC5047)
      static let well = UIColor(hex: 0xB33234)
    }
    
    struct Gray {
      static let almond = UIColor(hex: 0xA28F85)
      static let smoke = UIColor(hex: 0xEFEFEF)
      static let iron = UIColor(hex: 0xD1D5D8)
      static let ironGray = UIColor(hex: 0x75706B)
    }
  }
}
