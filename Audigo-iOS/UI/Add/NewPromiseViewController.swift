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

class NewPromiseViewController: UIViewController, BindableType {
  
  @IBOutlet weak var newPromiseButton: UIButton!
  @IBOutlet weak var popButton: UIButton!
  @IBOutlet weak var titleLabel: UILabel!
  
  @IBOutlet weak var promiseNameInputView: PromiseInputView!
  @IBOutlet weak var promiseDateInputView: PromiseInputView!
  @IBOutlet weak var promiseTimeInputView: PromiseInputView!
  @IBOutlet weak var promiseAddressInputView: PromiseInputView!
  
  var viewModel: NewPromiseViewModel!
  var isEditingPromise = false
  
  private let disposeBag = DisposeBag()
  private let confirmDone = PublishSubject<PromiseItem?>()

  override func viewDidLoad() {
    super.viewDidLoad()

    promiseNameInputView.inputState = .none(title: "약속명", input: "약속명을 입력해주세요")
    promiseDateInputView.inputState = .choice(title: "언제", input: "0000월 00월 00일")
    promiseTimeInputView.inputState = .choice(title: "몇시", input: "오후 00시 00분")
    promiseAddressInputView.inputState = .search(title: "어디서", input: "장소를 검색해주세요")
  }
  
  @IBAction func addNewPromise(_ sender: Any) {
    _ = viewModel.actions.newPromiseCompleted.execute(()).subscribe(onNext: { [weak self] errorMessage in
      guard let strongSelf = self else { return }
      if !errorMessage.isEmpty {
        UIAlertController.simpleAlert(strongSelf, title: "약속 에러 발생", message: errorMessage)
      }
    })
  }
  
  func bindViewModel() {
    popButton.rx.bind(to: viewModel.actions.popScene, input: nil)
  
    promiseNameInputView.rx.tapGesture().when(.recognized).subscribe { _ in
      UIAlertController.inputAlert(self, title: "이름 짓기", message: "생성할 약속의 이름을 입력해주세요", placeholder: "이름 입력") { name in
        self.viewModel.inputs.nameSetDone.onNext(name)
      }
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
    
    promiseAddressInputView.rx.tapGesture().when(.recognized).subscribe(onNext: { [weak self] _ in
      guard let `self` = self else { return }
      if let vc = R.storyboard.main.mapSearchViewController() {
        vc.addressConfirmed = self.viewModel.inputs.addressSetDone
        vc.placeConfirmed = self.viewModel.inputs.coordinateSetDone
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
  
    viewModel.outputs.state.subscribe(onNext: { [weak self] state in
      guard let strongSelf = self else { return }
      switch state {
        case .normal:
          break
        case .pending:
          strongSelf.newPromiseButton.isEnabled = false
          break
        case .completed(let promise):
          if let vc = R.storyboard.main.promiseConfirmViewController() {
            vc.confirmDone = strongSelf.confirmDone
            vc.promise = promise
            vc.isEditingPromise = strongSelf.isEditingPromise
            strongSelf.present(vc, animated: true, completion: nil)
          }
        case .error:
          strongSelf.newPromiseButton.isEnabled = true
      }
    }).disposed(by: disposeBag)
    
    viewModel.outputs.editMode.subscribe(onNext: { isEditMode in
      self.titleLabel.text = isEditMode ? "약속 수정" : "약속 추가"
      self.isEditingPromise = isEditMode
      self.newPromiseButton.setImage(isEditMode ? R.image.image_button_promise_edit() : R.image.image_button_promise_add(), for: .normal)
    }).disposed(by: disposeBag)
    
    confirmDone.subscribe(onNext: { [weak self] promise in
      guard let strongSelf = self else { return }
      strongSelf.viewModel.actions.popScene.execute(promise)
    }).disposed(by: disposeBag)
  }
}

