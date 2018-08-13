//
//  MemberSelectViewController.swift
//  Audigo-iOS
//
//  Created by hPark on 2018. 8. 14..
//  Copyright © 2018년 BlackBurn. All rights reserved.
//

import UIKit

class MemberSelectViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
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
