//
//  RegisterVC.swift
//  Test
//
//  Created by Tai Chin Huang on 2021/11/8.
//

import UIKit

protocol RegisterVCDelegate: AnyObject {
    func sendAction(_ viewController: RegisterVC, newUser: User)
}

class RegisterVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var firstPasswordTextField: UITextField!
    @IBOutlet weak var secondPasswordTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var termsLabel: UILabel!
    
    weak var delegate: RegisterVCDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "會員註冊"
        navigationItem.backButtonTitle = ""
        sendButton.layer.cornerRadius = 5
        nameTextField.delegate = self
        
        sendButton.addTarget(self, action: #selector(sendButtonClicked), for: .touchUpInside)
    }
    
    func setTermsLabel() {
        termsLabel.isUserInteractionEnabled = true
        // 透過UIGestureRecognizer讓termsLabel可以執行被點擊的動作
        let gestureRecognizer = UIGestureRecognizer(target: self, action: #selector(termsLabelTap))
        termsLabel.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func termsLabelTap() {
        // 點擊termsLabel可以跳轉到PrivacyVC頁面
        let privacyVC = storyboard?.instantiateViewController(withIdentifier: "PrivacyVC") as! PrivacyVC
        navigationController?.pushViewController(privacyVC, animated: true)
    }
    
    @objc func sendButtonClicked(_ sender: UIButton) {
        // 先檢查欄位不可留空
        guard nameTextField.text != "",
              phoneTextField.text != "",
              firstPasswordTextField.text != "",
              secondPasswordTextField.text != "" else {
            // guard沒過跳出alertController
            let alert = UIAlertController.simpleOKAlert(title: "", message: "欄位請勿留空", actionTitle: "確認", action: nil)
            present(alert, animated: true, completion: nil)
            return
        }
        // 驗證手機號碼格式??? -> NSPredicate是用來過濾獲取數據的類別，這裡檢查是否有符合手機號碼格式09[8位其他號碼]
        let predicate = NSPredicate(format: "SELF MATCHES %@", "^09[0-9]{8}$")
        // 檢查是否phoneTextField.text有符合predicate內容
        guard predicate.evaluate(with: phoneTextField.text) else {
            let alert = UIAlertController.simpleOKAlert(title: "", message: "請輸入正確的手機號碼格式", actionTitle: "確認", action: nil)
            present(alert, animated: true, completion: nil)
            return
        }
        //密碼驗證 8-16位英數字混合
        let predicate2 = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[0-9]).{8,16}$")
        guard predicate2.evaluate(with: firstPasswordTextField.text) else {
            let alert = UIAlertController.simpleOKAlert(title: "密碼格式錯誤", message: "格式為8-16碼英數字混合", actionTitle: "確認", action: nil)
            present(alert, animated: true, completion: nil)
            return
        }
        
        guard firstPasswordTextField.text == secondPasswordTextField.text else {
            let alert = UIAlertController.simpleOKAlert(title: "", message: "第一次跟第二次密碼不相同，請重新輸入", actionTitle: "確認", action: nil)
            present(alert, animated: true, completion: nil)
            return
        }
        let newUser = User()
        newUser.member_id = phoneTextField.text!
        newUser.member_pwd = firstPasswordTextField.text!
        newUser.member_name = nameTextField.text!
        delegate?.sendAction(self, newUser: newUser)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
