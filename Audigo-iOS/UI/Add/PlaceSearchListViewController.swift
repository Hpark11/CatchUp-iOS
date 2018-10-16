//
//  PlaceSearchListViewController.swift
//  Audigo-iOS
//
//  Created by hPark on 2018. 10. 14..
//  Copyright © 2018년 BlackBurn. All rights reserved.
//

import UIKit
import MapKit
import RxSwift
import RxCocoa

class PlaceSearchListViewController: UIViewController {
  var searchDone: PublishSubject<MKLocalSearchCompletion>?
  
  @IBOutlet weak var searchTextField: UITextField!
  @IBOutlet weak var searchResultsTableView: UITableView!
  
  private let disposeBag = DisposeBag()
  private var searchCompleter = MKLocalSearchCompleter()
  private var searchResults = [MKLocalSearchCompletion]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    searchCompleter.delegate = self
    searchTextField.rx.text
      .orEmpty
      .debounce(0.4, scheduler: MainScheduler.instance)
      .distinctUntilChanged()
      .filter { !$0.isEmpty }
      .subscribe(onNext: { text in
        self.searchCompleter.queryFragment = text
      }).disposed(by: disposeBag)
  }
  
  @IBAction func dismissSearch(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    self.searchTextField.becomeFirstResponder()
  }
}

extension PlaceSearchListViewController: MKLocalSearchCompleterDelegate {
  func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
    searchResults = completer.results.filter { result in
      return result.subtitle != "주변 검색"
    }
    searchResultsTableView.reloadData()
  }
  
  func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
  }
}

extension PlaceSearchListViewController: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return searchResults.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.placeSearchListTableViewCell, for: indexPath) as! PlaceSearchListTableViewCell
    cell.configure(result: searchResults[indexPath.row])
    return cell
  }
}

extension PlaceSearchListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    dismiss(animated: true) {
      self.searchDone?.onNext(self.searchResults[indexPath.row])
    }
  }
}
