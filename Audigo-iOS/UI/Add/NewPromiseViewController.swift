//
//  NewPromiseViewController.swift
//  Audigo-iOS
//
//  Created by hPark on 2018. 8. 12..
//  Copyright © 2018년 BlackBurn. All rights reserved.
//

import UIKit
import RxSwift
import RxGesture
import GooglePlaces
import GoogleMaps

class NewPromiseViewController: UIViewController, BindableType {
  
  @IBOutlet weak var newPromiseButton: UIButton!
  @IBOutlet weak var popButton: UIButton!
  @IBOutlet weak var promiseNameLabel: UILabel!
  @IBOutlet weak var promiseDateLabel: UILabel!
  @IBOutlet weak var promiseTimeLabel: UILabel!
  @IBOutlet weak var promiseAddressLabel: UILabel!
  @IBOutlet weak var promiseMembersLabel: UILabel!
  @IBOutlet weak var membersCollectionView: UICollectionView!
  
  var viewModel: NewPromiseViewModel!
  private var selectedMembers = [String]()
  
  let disposeBag = DisposeBag()

  func bindViewModel() {
    popButton.rx.action = viewModel.actions.popScene
    newPromiseButton.rx.action = viewModel.actions.newPromiseCompleted
    
    promiseNameLabel.rx.tapGesture().when(.recognized).subscribe { _ in
      let alert = UIAlertController(title: "이름 짓기", message: "생성할 약속의 이름을 입력해주세요", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
      
      alert.addTextField(configurationHandler: { textField in
        textField.placeholder = "이름 입력"
      })
      
      alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { action in
        if let name = alert.textFields?.first?.text {
          self.promiseNameLabel.text = name
          self.viewModel.inputs.nameSetDone.onNext(name)
        }
      }))
      
      self.present(alert, animated: true)
    }.disposed(by: disposeBag)
    
    promiseDateLabel.rx.tapGesture().when(.recognized).subscribe(onNext: { (_) in
      if let vc = R.storyboard.main.datePopupViewController() {
        vc.dateSelectDone = self.viewModel.dateSelectDone
        self.present(vc, animated: true, completion: nil)
      }
    }).disposed(by: disposeBag)
    
    promiseTimeLabel.rx.tapGesture().when(.recognized).subscribe(onNext: { (_) in
      if let vc = R.storyboard.main.timePopupViewController() {
        vc.timeSelectDone = self.viewModel.timeSelectDone
        self.present(vc, animated: true, completion: nil)
      }
    }).disposed(by: disposeBag)
    
    promiseAddressLabel.rx.tapGesture().when(.recognized).subscribe(onNext: { _ in
      let autocompleteController = GMSAutocompleteViewController()
      autocompleteController.delegate = self
      self.present(autocompleteController, animated: true, completion: nil)
    }).disposed(by: disposeBag)
    
    promiseMembersLabel.rx.tapGesture().when(.recognized).subscribe(onNext: { _ in
      if let vc = R.storyboard.main.memberSelectViewController() {
        vc.memberSelectDone = self.viewModel.inputs.memberSelectDone
        self.present(vc, animated: true, completion: nil)
      }
    }).disposed(by: disposeBag)
    
    viewModel.dateItems.subscribe(onNext: { components in
      if let cp = components, let year = cp.year, let month = cp.month, let day = cp.day {
        self.promiseDateLabel.text = "\(year)년 \(month)월 \(day)일"
      }
    }).disposed(by: disposeBag)
    
    viewModel.timeItems.subscribe(onNext: { components in
      let timeFormat = DateFormatter()
      timeFormat.dateFormat = "a hh시 mm분"
      if let cp = components, let time = Calendar.current.date(from: cp) {
        self.promiseTimeLabel.text = timeFormat.string(from: time)
      }
    }).disposed(by: disposeBag)
    
    viewModel.outputs.isEnabled.subscribe(onNext: { isEnabled in
      self.newPromiseButton.isEnabled = isEnabled
    }).disposed(by: disposeBag)
    
    viewModel.outputs.members.subscribe(onNext: { members in
      self.selectedMembers = members
      self.membersCollectionView.reloadData()
    }).disposed(by: disposeBag)
  }
}

extension NewPromiseViewController: GMSAutocompleteViewControllerDelegate {

  func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
    promiseAddressLabel.text = place.formattedAddress
    viewModel.inputs.addressSetDone.onNext(place.formattedAddress)
    viewModel.inputs.coordinateSetDone.onNext((latitude: place.coordinate.latitude, longitude: place.coordinate.longitude))
    print("Place attributions: \(place.attributions)")
    dismiss(animated: true, completion: nil)
  }
  
  func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
    print("Error: ", error.localizedDescription)
  }
  
  func wasCancelled(_ viewController: GMSAutocompleteViewController) {
    dismiss(animated: true, completion: nil)
  }
  
  func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
  }
  
  func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = false
  }
}

extension NewPromiseViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return selectedMembers.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.memberSelectedCollectionViewCell.identifier, for: indexPath) as! MemberSelectedCollectionViewCell
    cell.configure(phone: selectedMembers[indexPath.item])
    return cell
  }
}

