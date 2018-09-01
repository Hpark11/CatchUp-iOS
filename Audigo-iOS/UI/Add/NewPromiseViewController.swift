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
  @IBOutlet weak var membersCollectionView: UICollectionView!
  @IBOutlet weak var titleLabel: UILabel!
  
  @IBOutlet weak var promiseNameInputView: PromiseInputView!
  @IBOutlet weak var promiseDateInputView: PromiseInputView!
  @IBOutlet weak var promiseTimeInputView: PromiseInputView!
  @IBOutlet weak var promiseAddressInputView: PromiseInputView!
  @IBOutlet weak var promiseMembersInputView: PromiseInputView!
  
  var viewModel: NewPromiseViewModel!
  var isEditingPromise = false
  private var selectedMembers = [String]()
  
  let disposeBag = DisposeBag()
  
  private let confirmDone = PublishSubject<Void>()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    promiseNameInputView.inputState = .none(title: "약속명", input: "약속명을 입력해주세요")
    promiseDateInputView.inputState = .choice(title: "언제", input: "0000월 00월 00일")
    promiseTimeInputView.inputState = .choice(title: "몇시", input: "오후 00시 00분")
    promiseAddressInputView.inputState = .search(title: "어디서", input: "장소를 검색해주세요")
    promiseMembersInputView.inputState = .search(title: "누구랑", input: "구성원을 검색해주세요")
  }
  
  func bindViewModel() {
    popButton.rx.action = viewModel.actions.popScene
    newPromiseButton.rx.action = viewModel.actions.newPromiseCompleted
    
    promiseNameInputView.rx.tapGesture().when(.recognized).subscribe { _ in
      let alert = UIAlertController(title: "이름 짓기", message: "생성할 약속의 이름을 입력해주세요", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
      
      alert.addTextField(configurationHandler: { textField in
        textField.placeholder = "이름 입력"
      })
      
      alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { action in
        if let name = alert.textFields?.first?.text {
          self.viewModel.inputs.nameSetDone.onNext(name)
        }
      }))
      
      self.present(alert, animated: true)
    }.disposed(by: disposeBag)
    
    promiseDateInputView.rx.tapGesture().when(.recognized).subscribe(onNext: { (_) in
      if let vc = R.storyboard.main.datePopupViewController() {
        vc.dateSelectDone = self.viewModel.dateSelectDone
        self.present(vc, animated: true, completion: nil)
      }
    }).disposed(by: disposeBag)
    
    promiseTimeInputView.rx.tapGesture().when(.recognized).subscribe(onNext: { (_) in
      if let vc = R.storyboard.main.timePopupViewController() {
        vc.timeSelectDone = self.viewModel.timeSelectDone
        self.present(vc, animated: true, completion: nil)
      }
    }).disposed(by: disposeBag)
    
    promiseAddressInputView.rx.tapGesture().when(.recognized).subscribe(onNext: { _ in
      let autocompleteController = GMSAutocompleteViewController()
      autocompleteController.delegate = self
      self.present(autocompleteController, animated: true, completion: nil)
    }).disposed(by: disposeBag)
    
    promiseMembersInputView.rx.tapGesture().when(.recognized).subscribe(onNext: { _ in
      if let vc = R.storyboard.main.memberSelectViewController() {
        vc.memberSelectDone = self.viewModel.inputs.memberSelectDone
        vc.selectedSet = Set(self.selectedMembers)
        self.present(vc, animated: true, completion: nil)
      }
    }).disposed(by: disposeBag)
    
    viewModel.outputs.name.subscribe(onNext: { promiseName in
      guard let name = promiseName, !name.isEmpty else { return }
      self.promiseNameInputView.inputState = .applied(input: name)
    }).disposed(by: disposeBag)
    
    viewModel.outputs.place.subscribe(onNext: { promiseAddress in
      guard let address = promiseAddress, !address.isEmpty else { return }
      self.promiseAddressInputView.inputState = .applied(input: address)
    }).disposed(by: disposeBag)
    
    viewModel.dateItems.subscribe(onNext: { components in
      if let cp = components, let year = cp.year, let month = cp.month, let day = cp.day {
        self.promiseDateInputView.inputState = .applied(input: "\(year)년 \(month)월 \(day)일")
      }
    }).disposed(by: disposeBag)
    
    viewModel.timeItems.subscribe(onNext: { components in
      let timeFormat = DateFormatter()
      timeFormat.dateFormat = "a hh시 mm분"
      if let cp = components, let time = Calendar.current.date(from: cp) {
        self.promiseTimeInputView.inputState = .applied(input: timeFormat.string(from: time))
      }
    }).disposed(by: disposeBag)
    
    viewModel.outputs.isEnabled.subscribe(onNext: { isEnabled in
      self.newPromiseButton.isEnabled = isEnabled
    }).disposed(by: disposeBag)
    
    viewModel.outputs.members.subscribe(onNext: { members in
      self.selectedMembers = members
      if let member = members.first, let nickname = ContactItem.find(phone: member)?.nickname {
        self.promiseMembersInputView.inputState = .applied(input: "\(nickname) 외 \(members.count)명")
      }
      
      self.membersCollectionView.reloadData()
    }).disposed(by: disposeBag)
    
    viewModel.outputs.state.subscribe(onNext: { [weak self] state in
      guard let strongSelf = self else { return }
      switch state {
        case .normal:
          break
        case .pending:
          strongSelf.newPromiseButton.isEnabled = false
          break
        case .completed(let dateTime, let location, let members):
          if let vc = R.storyboard.main.promiseConfirmViewController() {
            vc.confirmDone = strongSelf.confirmDone
            vc.dateTime = dateTime
            vc.location = location
            vc.members = members
            vc.isEditingPromise = strongSelf.isEditingPromise
            strongSelf.present(vc, animated: true, completion: nil)
          }
        case .error:
          strongSelf.newPromiseButton.isEnabled = true
      }
    }).disposed(by: disposeBag)
    
    viewModel.outputs.editMode.subscribe(onNext: { isEditMode in
      self.titleLabel.text = isEditMode ? "약속 수정" : "약속 추가"
      
//      self.newPromiseButton.set
    }).disposed(by: disposeBag)
    
    confirmDone.subscribe(onNext: { [weak self] _ in
      guard let strongSelf = self else { return }
      strongSelf.dismiss(animated: true, completion: nil)
    }).disposed(by: disposeBag)
  }
}

extension NewPromiseViewController: GMSAutocompleteViewControllerDelegate {

  func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
    promiseAddressInputView.inputState = .applied(input: place.formattedAddress ?? "")
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

