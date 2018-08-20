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
  
  private var items: Results<ContactItem>?
  private var itemsToken: NotificationToken?
  private var selected = Set<String>()
  private let disposeBag = DisposeBag()
  private var memberSelectDone: PublishSubject<Set<String>>?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    items = ContactItem.all()
    // Do any additional setup after loading the view.
    //      let results = searchBar.rx.text.orEmpty
    //        .throttle(0.5, scheduler: MainScheduler.instance)
    //        .distinctUntilChanged()
    //        .flatMapLatest { query -> Observable<NflPlayerStats> in
    //          if query.isEmpty {
    //            return .just([])
    //          }
    //          return ApiController.shared.search(search: query)
    //            .catchErrorJustReturn([])
    //        }
    //        .observeOn(MainScheduler.instance)
    //
    //      results
    //        .bind(to: tableView.rx.items(cellIdentifier: "PlayerCell",
    //                                     cellType: PlayerCell.self)) {
    //                                      (index, nflPlayerStats: NflPlayerStats, cell) in
    //                                      cell.setup(for: nflPlayerStats)
    //        }
    //        .disposed(by: disposeBag)
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
    memberSelectDone?.onNext(selected)
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
    if selected.contains(item.phone) {
      cell.checkImageView.image = UIImage(resource: R.image.icon_ok)
    } else {
      cell.checkImageView.image = nil
    }
    
    cell.itemView.rx.tapGesture().when(.recognized).subscribe(onNext: { [weak self] _ in
      guard let strongSelf = self else { return }
      
      if strongSelf.selected.contains(item.phone) {
        strongSelf.selected.remove(item.phone)
        cell.checkImageView.image = nil
      } else {
        strongSelf.selected.insert(item.phone)
        cell.checkImageView.image = UIImage(resource: R.image.icon_ok)
      }
      
    }).disposed(by: disposeBag)
    return cell
  }
}
