//
//  LoginFlowNavigation.swift
//  Test
//
//  Created by Tai Chin Huang on 2021/11/8.
//

import Foundation
import UIKit

class LoginFlowNavigation: UINavigationController {
    // 判斷要送去哪個頁面
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let controller = storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        controller.delegate = self
        self.pushViewController(controller, animated: true)
    }
    
}

extension LoginFlowNavigation: LoginVCDelegate {
    // 登入動作
    func loginAction(_ viewController: LoginVC, phoneNum: String, password: String) {
        print("##phoneNum: \(phoneNum)")
        print("##password: \(password)")
        
        UserService.shared.logIn(account: phoneNum, password: password) { isSuccess, message in
            if isSuccess {
                
            } else {
                let alert = UIAlertController.simpleOKAlert(title: "無法登入", message: message, actionTitle: "確認", action: nil)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    // 註冊動作
    func registerAction(_ viewController: LoginVC) {
        guard let registerVC = storyboard?.instantiateViewController(withIdentifier: "RegisterVC") as? RegisterVC else { return }
        registerVC.delegate = self
        self.pushViewController(registerVC, animated: true)
    }
    // 使用者條款動作
    func termsAction(_ viewController: LoginVC) {
        guard let privacyVC = storyboard?.instantiateViewController(withIdentifier: "PrivacyVC") as? PrivacyVC else { return }
        self.pushViewController(privacyVC, animated: true)
    }
}

extension LoginFlowNavigation: RegisterVCDelegate {
    // 串接註冊API
    func sendAction(_ viewController: RegisterVC, newUser: User) {
        UserService.shared.signUp(newUser) { isSuccess, message in
            if isSuccess {
                
            } else {
                let alert = UIAlertController.simpleOKAlert(title: "無法註冊", message: message, actionTitle: "確認", action: nil)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
}
