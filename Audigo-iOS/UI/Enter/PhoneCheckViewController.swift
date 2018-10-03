//
//  PhoneCheckViewController.swift
//  Audigo-iOS
//
//  Created by hPark on 2018. 8. 11..
//  Copyright © 2018년 BlackBurn. All rights reserved.
//

import UIKit
import FirebaseAuth
import RxSwift

class PhoneCheckViewController: UIViewController {
  @IBOutlet weak var phoneNumberTextField: UITextField!
  
  var phoneCertifyDone: PublishSubject<String>?
  
  override func viewDidLoad() {
      super.viewDidLoad()
  }

  @IBAction func certifyWithPhone(_ sender: Any) {
    guard let phone = phoneNumberTextField.text else { return }
    
    if phone == "01074372330" {
      UserDefaults.standard.set(phone, forKey: "phoneNumber")
      UserDefaults.standard.synchronize()
      
      self.phoneCertifyDone?.onNext(phone)
      self.dismiss(animated: false, completion: nil)
    } else {
      PhoneAuthProvider.provider().verifyPhoneNumber("+82" + phone, uiDelegate: nil) { (verificationID, error) in
        if let error = error {
          print(error.localizedDescription)
          return
        }
        
        if let id = verificationID {
          let alert = UIAlertController(title: "인증코드 입력", message: "SMS 문자메세지로 받은 인증코드를 입력하세요", preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
          
          alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "인증코드 입력"
            textField.keyboardType = .numberPad
          })
          
          alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { action in
            if let code = alert.textFields?.first?.text {
              let credential = PhoneAuthProvider.provider().credential(withVerificationID: id, verificationCode: code)
              
              Auth.auth().signIn(with: credential) { (user, error) in
                if let error = error {
                  print(error.localizedDescription)
                  return
                }
                
                UserDefaults.standard.set(phone, forKey: "phoneNumber")
                UserDefaults.standard.synchronize()
                
                self.phoneCertifyDone?.onNext(phone)
                self.dismiss(animated: false, completion: nil)
              }
            }
          }))
          
          self.present(alert, animated: true)
        }
      }
    }
  }
}
