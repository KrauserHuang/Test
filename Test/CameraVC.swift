//
//  CameraVC.swift
//  Test
//
//  Created by Tai Chin Huang on 2021/11/8.
//

import UIKit

protocol CameraVCDelegate: AnyObject {
    
}

class CameraVC: UIViewController {
    
    weak var delegate: CameraVCDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}
