//
//  CouponTableViewController.swift
//  Test
//
//  Created by Tai Chin Huang on 2021/11/9.
//

import UIKit

protocol CouponTableViewControllerDelegate: AnyObject {
    func useButton(_ viewController: CouponTableViewController, coupon: Coupon)
}

class CouponTableViewController: UITableViewController {
    
    var couponLists = [Coupon]() {
        didSet {
            loadViewIfNeeded()
            tableView.reloadData()
        }
    }
    var cellType: CellType = .Lottery
    
    weak var delegate: CouponTableViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "CouponTableViewCell", bundle: nil), forCellReuseIdentifier: "CouponTableViewCell")
        tableView.allowsSelection = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // 讓tableView跟tabBar距離隔開不要重疊
        guard let tabBarHeight = tabBarController?.tabBar.frame.height else { return }
        additionalSafeAreaInsets.top = tabBarHeight
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return couponLists.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CouponTableViewCell", for: indexPath) as? CouponTableViewCell else {  return UITableViewCell() }
        
        let coupon = couponLists[indexPath.row]
        cell.configure(coupon)
        
        return cell
    }
}

extension CouponTableViewController: CouponTableViewCellDelegate {
    func useAction(_ model: Coupon) {
        if cellType == .Lottery {
            let alert = UIAlertController.simpleOKAlert(title: "", message: model.coupon_description, actionTitle: "確認", action: nil)
            present(alert, animated: true, completion: nil)
        } else {
            delegate?.useButton(self, coupon: model)
        }
    }
    
    
}
