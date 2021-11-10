//
//  MyCouponViewController.swift
//  Test
//
//  Created by Tai Chin Huang on 2021/11/9.
//

import UIKit

class MyCouponViewController: UITabBarController {
    // Cannot override with a stored property 'viewControllers'
    override var viewControllers: [UIViewController]? {
        didSet {
            guard viewControllers != nil else { return }
            setTabBarItemText()
            setSelectionIndicator()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setTabBar()
    }
    func setTabBar() {
        tabBar.frame = CGRect(x: 0, y: 0, width: tabBar.frame.size.width, height: 44)
    }
    func setSelectionIndicator() {
        let indicatorWidth = tabBar.frame.width / CGFloat(tabBar.items!.count)
        tabBar.selectionIndicatorImage = createSelectionIndicator(color: Theme.orangeColor, size: CGSize(width: indicatorWidth, height: tabBar.frame.height), lineWidth: 2)
    }
    func createSelectionIndicator(color: UIColor, size: CGSize, lineWidth: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(CGRect(x: 15, y: size.height-10, width: size.width-10, height: lineWidth))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    func setTabBarItemText() {
        guard let items = tabBar.items else { return }
        tabBar.tintColor = .black
        tabBar.unselectedItemTintColor = .gray
        for item in items {
            item.setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: "Arial", size: 16)!], for: [])
            item.titlePositionAdjustment.vertical = -10
        }
    }
    
}
