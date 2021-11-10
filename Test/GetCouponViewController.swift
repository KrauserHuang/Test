//
//  GetCouponViewController.swift
//  Test
//
//  Created by Tai Chin Huang on 2021/11/9.
//

import UIKit

protocol GetCouponViewControllerDelegate: AnyObject {
    func backAction(_ viewController: GetCouponViewController)
}

class GetCouponViewController: UIViewController {
    
    var tableView: UITableView!
    var couponLists = [Coupon]()
    
    weak var delegate: GetCouponViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "CouponTableViewCell", bundle: nil), forCellReuseIdentifier: "CouponTableViewCell")
    }
//    override func viewWillAppear(_ animated: Bool) {
//        navigationController?.isNavigationBarHidden = true
//    }
//    override func viewWillDisappear(_ animated: Bool) {
//        navigationController?.isNavigationBarHidden = false
//    }
}

extension GetCouponViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return couponLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CouponTableViewCell", for: indexPath) as? CouponTableViewCell else { fatalError("Can't dequeue CouponTableViewCell") }
        
        let coupon = couponLists[indexPath.row]
        cell.configure(coupon)
        
        return cell
    }
    
    
}
