//
//  MemberSelectViewController.swift
//  Audigo-iOS
//
//  Created by hPark on 2018. 8. 14..
//  Copyright © 2018년 BlackBurn. All rights reserved.
//

import UIKit
import RxSwift
import RealmSwift

class MemberSelectViewController: UIViewController {
  @IBOutlet weak var memberSelectTableView: UITableView!
  @IBOutlet weak var selectButton: UIButton!
  @IBOutlet weak var searchItemTextField: UITextField!
  
  private var originalItems: Results<ContactItem>?
  private var items = [ContactItem]()
  
  private var selectedSet = Set<String>()
  private let disposeBag = DisposeBag()
  var memberSelectDone: PublishSubject<Set<String>>?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    originalItems = ContactItem.all()
    if let items = originalItems {
      self.items = items.map { $0 }
    }
  }
  
  @IBAction func dismissScene(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func completeMemberSelect(_ sender: Any) {
    memberSelectDone?.onNext(selectedSet)
    dismiss(animated: true, completion: nil)
  }

  @IBAction func whileChanged(_ sender: UITextField) {
    if let text = sender.text, let result = originalItems {
      items = result.filter({ (contact) -> Bool in
        return text.isEmpty || contact.nickname.contains(text)
      })
      memberSelectTableView.reloadData()
    }
  }
}

extension MemberSelectViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.memberSelectTableViewCell.identifier, for: indexPath) as? MemberSelectTableViewCell else {
        return MemberSelectTableViewCell(frame: .zero)
    }
    
    cell.configure(item: items[indexPath.row])
    
    if selectedSet.contains(items[indexPath.row].phone) {
      cell.accessoryType = .checkmark
      cell.setSelected(true, animated: true)
    } else {
      cell.accessoryType = .none
      cell.setSelected(false, animated: true)
    }
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    if let cell = tableView.cellForRow(at: indexPath) {
      selectedSet.remove(items[indexPath.row].phone)
      cell.accessoryType = .none
      selectButton.setTitle("\(selectedSet.count) 확인", for: .normal)
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let cell = tableView.cellForRow(at: indexPath) {
      selectedSet.insert(items[indexPath.row].phone)
      cell.accessoryType = .checkmark
      selectButton.setTitle("\(selectedSet.count) 확인", for: .normal)
    }
  }
}
