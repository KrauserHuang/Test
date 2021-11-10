//
//  LoginVC.swift
//  Test
//
//  Created by Tai Chin Huang on 2021/11/10.
//

import UIKit

protocol LoginVCDelegate: AnyObject {
    func loginAction(_ viewController: LoginVC, phoneNum: String, password: String)
    func registerAction(_ viewController: LoginVC)
    func termsAction(_ viewController: LoginVC)
}

class LoginVC: UIViewController {
    
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var termsLabel: UILabel!
    
    weak var delegate: LoginVCDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setCornerRadius()
    }
    
    func setCornerRadius() {
        loginButton.layer.cornerRadius = 5
        registerButton.layer.cornerRadius = 5
        registerButton.layer.borderWidth = 2
        registerButton.layer.borderColor = CGColor(red: 239/255, green: 127/255, blue: 72/255, alpha: 1)
    }
    
    func setTermsLabel() {
        termsLabel.isUserInteractionEnabled = true
        let gestureRecognizer = UIGestureRecognizer(target: self, action: #selector(termsLabelTap))
        termsLabel.addGestureRecognizer(gestureRecognizer)
    }
    @objc func termsLabelTap() {
        delegate?.termsAction(self)
    }
}
