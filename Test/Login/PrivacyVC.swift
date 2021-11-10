//
//  PrivacyVC.swift
//  Test
//
//  Created by Tai Chin Huang on 2021/11/8.
//

import UIKit

class PrivacyVC: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "使用者條款及隱私權條款"
        scrollView.layer.cornerRadius = 15
        alignContentLabel()
    }
    
    func alignContentLabel() {
        let paragraphStyle = NSMutableParagraphStyle()
        // alignment -> left(對齊左)/right(對齊右)/center(對齊中間)/natural(自然對齊)/justified(展開對齊)
        paragraphStyle.alignment = NSTextAlignment.justified
        let contentStr: NSMutableAttributedString = NSMutableAttributedString(string: contentLabel.text!)
        contentStr.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, contentLabel.text!.count))
        // 設定contentLabel的attributedText
        contentLabel.attributedText = contentStr
    }
}
