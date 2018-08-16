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
  
  private var items: Results<ContactItem>?
  @IBOutlet weak var memberSelectTableView: UITableView!
  
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
    return cell
  }
}
