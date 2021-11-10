//
//  UIAlertController+Extension.swift
//  Test
//
//  Created by Tai Chin Huang on 2021/11/8.
//

import Foundation
import UIKit

extension UIAlertController {
    static func simpleOKAlert(title: String, message: String, actionTitle: String, action: ((UIAlertAction) -> ())?) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: actionTitle, style: .default, handler: action)
        alert.addAction(action)
        return alert
    }
    
}
