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
  @IBOutlet weak var promiseCollectionView: UICollectionView!
  @IBOutlet weak var newPromiseButton: UIButton!
  @IBOutlet weak var monthSelectButton: UIButton!
  @IBOutlet weak var promiseGuide: UIImageView!
  
  var viewModel: MainViewModel!
  var needSignIn = false
  var isConfigured = false
  var current: (month: Int, year: Int)?
  
  let disposeBag = DisposeBag()
  
  lazy var configureCell: (CollectionViewSectionedDataSource<PromiseSectionModel>, UICollectionView, IndexPath, CatchUpPromise) -> UICollectionViewCell = { [weak self] data, collectionView, indexPath, promise in
    guard let strongSelf = self else { return PromiseCollectionViewCell(frame: .zero) }
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.promiseCollectionViewCell, for: indexPath)
    cell?.configure(promise: promise)
    return cell!
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    GADRewardBasedVideoAd.sharedInstance().delegate = self
    GADRewardBasedVideoAd.sharedInstance().load(GADRequest(), withAdUnitID: Define.idGADMobileAdsCredit)
  }
  
  @IBAction func chargeCredit(_ sender: Any) {
    if GADRewardBasedVideoAd.sharedInstance().isReady == true {
      GADRewardBasedVideoAd.sharedInstance().present(fromRootViewController: self)
    }
  }
  
  func bindViewModel() {
    if let layout = promiseCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
      layout.scrollDirection = .vertical
      layout.minimumLineSpacing = 0
      layout.itemSize = CGSize(width: view.frame.width, height: 160)
    }
    
    let dataSource = RxCollectionViewSectionedAnimatedDataSource<PromiseSectionModel>(configureCell: configureCell, configureSupplementaryView: {data, collectionView, text, indexPath in
      return UICollectionReusableView()
    })
    
    viewModel.appVersion.subscribe(onSuccess: { [weak self] version in
      guard let strongSelf = self else { return }
      
      if version.major > Define.majorVersion || version.minor > Define.minorVersion || version.revision > Define.revision {
        let alert = UIAlertController(title: "최신 버전 업데이트", message: "새로운 버전(\(version.major).\(version.minor).\(version.revision))이 출시되었습니다. 업데이트 하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { action in
          if UIApplication.shared.canOpenURL(Define.appStoreUrl) {
            UIApplication.shared.open(Define.appStoreUrl, options: [:], completionHandler: nil)
          }
        }))
    
        strongSelf.present(alert, animated: true)
      }
      
    }).disposed(by: disposeBag)
    
    viewModel.promiseItems
      .bind(to: promiseCollectionView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
    
    Observable.zip(promiseCollectionView.rx.itemSelected, promiseCollectionView.rx.modelSelected(CatchUpPromise.self)).bind { [weak self] indexPath, promise in
      guard let strongSelf = self else { return }
      strongSelf.promiseCollectionView.deselectItem(at: indexPath, animated: true)
      strongSelf.viewModel.actions.pushPromiseDetailScene.execute(promise)
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
    GADRewardBasedVideoAd.sharedInstance().load(GADRequest(), withAdUnitID: Define.idGADMobileAdsCredit)
  }
  
  func rewardBasedVideoAdWillLeaveApplication(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
    print("Reward based video ad will leave application.")
  }
  
  func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didFailToLoadWithError error: Error) {
    print("Reward based video ad failed to load.")
  }
}

