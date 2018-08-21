//
//  MemberSelectViewController.swift
//  Audigo-iOS
//
//  Created by hPark on 2018. 8. 14..
//  Copyright © 2018년 BlackBurn. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RealmSwift

class MemberSelectViewController: UIViewController {
  @IBOutlet weak var memberSelectTableView: UITableView!
  @IBOutlet weak var selectButton: UIButton!
  @IBOutlet weak var searchItemTextField: UITextField!
  
  private var items: Results<ContactItem>?
  private var itemsToken: NotificationToken?
  private var selectedSet = Set<String>()
  private let disposeBag = DisposeBag()
  private var memberSelectDone: PublishSubject<Set<String>>?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    items = ContactItem.all()
    // Do any additional setup after loading the view.
    
//    let results = searchItemTextField.rx.text.orEmpty
//      .throttle(0.5, scheduler: MainScheduler.instance)
//      .distinctUntilChanged()
//      .flatMapLatest { query -> Observable<[ContactItem]> in
//        if query.isEmpty {
//          return .empty()
//        }
//        return ApiController.shared.search(search: query)
//          .catchErrorJustReturn([])
//      }
//      .observeOn(MainScheduler.instance)
//
//    results
//      .bind(to: tableView.rx.items(cellIdentifier: R.reuseIdentifier.memberSelectTableViewCell.identifier, cellType: MemberSelectTableViewCell.self)) {
//                                    (index, nflPlayerStats: NflPlayerStats, cell) in
//                                    cell.setup(for: nflPlayerStats)
//      }
//      .disposed(by: disposeBag)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    itemsToken = items?.observe({ [weak memberSelectTableView] (changes) in
      guard let tableView = memberSelectTableView else { return }
      switch changes {
      case .initial:
        tableView.reloadData()
      case .update(_, let deletions, let insertions, let updates):
        tableView.applyChanges(deletions: deletions, insertions: insertions, updates: updates)
      case .error: break
      }
    })
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    itemsToken?.invalidate()
  }
  
  @IBAction func dismissScene(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func completeMemberSelect(_ sender: Any) {
    memberSelectDone?.onNext(selectedSet)
    dismiss(animated: true, completion: nil)
  }
}

extension MemberSelectViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.memberSelectTableViewCell.identifier, for: indexPath) as? MemberSelectTableViewCell,
      let item = items?[indexPath.row] else {
        return MemberSelectTableViewCell(frame: .zero)
    }
    
    cell.configure(item: item)
    if selectedSet.contains(item.phone) {
      cell.accessoryType = .checkmark
      cell.setSelected(true, animated: true)
    } else {
      cell.accessoryType = .none
      cell.setSelected(false, animated: true)
    }
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    if let cell = tableView.cellForRow(at: indexPath), let item = items?[indexPath.row]  {
      selectedSet.remove(item.phone)
      cell.accessoryType = .none
      selectButton.setTitle("\(selectedSet.count) 확인", for: .normal)
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let cell = tableView.cellForRow(at: indexPath), let item = items?[indexPath.row] {
      selectedSet.insert(item.phone)
      cell.accessoryType = .checkmark
      selectButton.setTitle("\(selectedSet.count) 확인", for: .normal)
    }
  }
}
