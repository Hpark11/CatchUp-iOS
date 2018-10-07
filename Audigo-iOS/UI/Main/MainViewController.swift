//
//  ViewController.swift
//  Audigo-iOS
//
//  Created by hPark on 2018. 6. 7..
//  Copyright © 2018년 BlackBurn. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Permission
import RealmSwift
import SwiftyContacts
import GoogleMobileAds

class MainViewController: UIViewController, BindableType {
  @IBOutlet weak var promiseListTableView: UITableView!
  @IBOutlet weak var newPromiseButton: UIButton!
  @IBOutlet weak var monthSelectButton: UIButton!
  @IBOutlet weak var promiseGuide: UIImageView!
  @IBOutlet weak var creditButton: UIButton!
  
  var viewModel: MainViewModel!
  var needSignIn = false
  var isConfigured = false
  var current: (month: Int, year: Int)?
  
  let disposeBag = DisposeBag()
  
  lazy var configureCell: (TableViewSectionedDataSource<PromiseSectionModel>, UITableView, IndexPath, CatchUpPromise) -> UITableViewCell = { [weak self] data, tableView, indexPath, promise in
    guard let strongSelf = self else { return PromiseTableViewCell(frame: .zero) }
    
    let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.promiseTableViewCell, for: indexPath)
    cell?.configure(promise: promise)
    return cell!
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    UIApplication.shared.statusBarView?.backgroundColor = .white
    
    GADRewardBasedVideoAd.sharedInstance().delegate = self
    GADRewardBasedVideoAd.sharedInstance().load(GADRequest(), withAdUnitID: "ca-app-pub-1670879929355255/1884030453")
    GADRequest().testDevices = [ "4ee8d0026acfedbf7440a0750bce9c1b" ]
  }
  
  @IBAction func chargeCredit(_ sender: Any) {
    if GADRewardBasedVideoAd.sharedInstance().isReady == true {
      GADRewardBasedVideoAd.sharedInstance().present(fromRootViewController: self)
    }
  }
  
  func bindViewModel() {
    let dataSource = RxTableViewSectionedAnimatedDataSource<PromiseSectionModel>(configureCell: configureCell)
    
    viewModel.promiseItems
      .bind(to: promiseListTableView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
    
    viewModel.creditCount.subscribe(onNext: { [weak self] count in
      guard let strongSelf = self else { return }
      strongSelf.creditButton.setTitle("\(count) 크레딧", for: .normal)
    }).disposed(by: disposeBag)
    
    Observable.zip(promiseListTableView.rx.itemSelected, promiseListTableView.rx.modelSelected(CatchUpPromise.self)).bind { [weak self] indexPath, promise in
      guard let strongSelf = self else { return }
      strongSelf.promiseListTableView.deselectRow(at: indexPath, animated: true)
      strongSelf.viewModel.actions.pushPromiseDetailScene.execute(promise)
      strongSelf.navigationController?.navigationBar.backgroundColor = .darkSkyBlue
      strongSelf.navigationController?.navigationBar.barStyle = .blackOpaque
    }.disposed(by: disposeBag)
    
    viewModel.promiseItems.subscribe(onNext: { [weak self] sectionModel in
      guard let strongSelf = self else { return }
      if let items = sectionModel.first?.items, !items.isEmpty {
        strongSelf.promiseGuide.isHidden = true
      } else {
        strongSelf.promiseGuide.isHidden = false
      }
    }).disposed(by: disposeBag)
    
    viewModel.outputs.current.map { [weak self] (month, year) in
      if let strongSelf = self {
        strongSelf.current = (month: month, year: year)
      }
      
      let calendar = Calendar(identifier: .gregorian)
      let timeFormat = DateFormatter()
      timeFormat.dateFormat = "yyyy.MM"
      
      let dateTime = calendar.date(from: DateComponents(year: year, month: month, day: 1)) ?? Date()
      return timeFormat.string(from: dateTime)
      }.bind(to: monthSelectButton.rx.title())
      .disposed(by: disposeBag)
    
    newPromiseButton.rx.action = viewModel.actions.pushNewPromiseScene
  }
  
  @IBAction func selectMonth(_ sender: Any) {
    if let vc = R.storyboard.main.monthPopupViewController() {
      let dateFormatter = DateFormatter()
      let calendar = Calendar(identifier: .gregorian)
      dateFormatter.dateFormat = "yyyy.MM"
      
      if let date = dateFormatter.date(from: monthSelectButton.currentTitle ?? "") {
        vc.monthSelectDone = self.viewModel.monthSelectDone
        vc.month = calendar.component(.month, from: date)
        vc.year = calendar.component(.year, from: date)
        self.present(vc, animated: true, completion: nil)
      }
    }
  }
}

extension MainViewController: GADRewardBasedVideoAdDelegate {
  func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didRewardUserWith reward: GADAdReward) {
    print("Reward received with currency: \(reward.type), amount \(reward.amount).")
    viewModel.actions.chargeCredit.execute(Int(truncating: reward.amount))
  }
  
  func rewardBasedVideoAdDidReceive(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
    print("Reward based video ad is received.")
  }
  
  func rewardBasedVideoAdDidOpen(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
    print("Opened reward based video ad.")
  }
  
  func rewardBasedVideoAdDidStartPlaying(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
    print("Reward based video ad started playing.")
  }
  
  func rewardBasedVideoAdDidCompletePlaying(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
    print("Reward based video ad has completed.")
  }
  
  func rewardBasedVideoAdDidClose(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
    GADRewardBasedVideoAd.sharedInstance().load(GADRequest(), withAdUnitID: "ca-app-pub-1670879929355255/1884030453")
  }
  
  func rewardBasedVideoAdWillLeaveApplication(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
    print("Reward based video ad will leave application.")
  }
  
  func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didFailToLoadWithError error: Error) {
    print("Reward based video ad failed to load.")
  }
}

