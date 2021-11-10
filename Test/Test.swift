//
//  Test.swift
//  Test
//
//  Created by Tai Chin Huang on 2021/11/9.
//

import Foundation
import UIKit
class TestViewController: UIViewController {
    
    
    
    func renderTextOnView(with: UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
