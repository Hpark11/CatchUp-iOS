//
//  UITableView+Ext.swift
//  Audigo-iOS
//
//  Created by hPark on 2018. 8. 17..
//  Copyright © 2018년 BlackBurn. All rights reserved.
//

import UIKit

extension IndexPath {
  static func fromRow(_ row: Int) -> IndexPath {
    return IndexPath(row: row, section: 0)
  }
}

extension UITableView {
  func applyChanges(deletions: [Int], insertions: [Int], updates: [Int]) {
    beginUpdates()
    deleteRows(at: deletions.map(IndexPath.fromRow), with: .automatic)
    insertRows(at: insertions.map(IndexPath.fromRow), with: .automatic)
    reloadRows(at: updates.map(IndexPath.fromRow), with: .automatic)
    endUpdates()
  }
}
