//
//  CouponModel.swift
//  Test
//
//  Created by Tai Chin Huang on 2021/11/9.
//

import Foundation
import UIKit

enum CouponStatus {
    case Available, Used, OutDate, Unavailable
}

enum CellType {
    case List, Lottery, Canuse, Used
}

class Coupon {
    let cid: String
    let pid: String
    let mid: String
    let sid: String
    let coupon_no: String
    let coupon_id: String
    let coupon_name: String
    let coupon_type: String
    let coupon_description: String
    let coupon_startdate: String
    let coupon_enddate: String
    let coupon_status: String
    let coupon_rule: String
    let coupon_discount: String
    let discount_amount: String
    let coupon_storeid: String
    let coupon_for: String
    let using_flag: String
    let using_date: String
    let mycoupon_created_at: String
    let store_name: String
    let store_address: String
    let store_status: String
    let shopping_area: String
    let mycoupon_trash: String
    var coupon_picture: UIImage? {
        didSet{
            renewImage?()
            renewImage = nil
        }
    }
    var renewImage: (() -> ())?
    let isLottery: Bool
    
    init(with dict: [String: Any]) {
        let temp = dict.castToDictionary()
        
        self.cid = temp["cid"] ?? ""
        self.pid = temp["pid"] ?? ""
        self.mid = temp["mid"] ?? ""
        self.sid = temp["sid"] ?? ""
        self.coupon_no = temp["coupon_no"] ?? ""
        self.coupon_id = temp["coupon_id"] ?? ""
        self.coupon_name = temp["coupon_name"] ?? ""
        self.coupon_type = temp["coupon_type"] ?? ""
        self.coupon_description = temp["coupon_description"] ?? ""
        self.coupon_startdate = temp["coupon_startdate"] ?? ""
        self.coupon_enddate = temp["coupon_enddate"] ?? ""
        self.coupon_status = temp["coupon_status"] ?? ""
        self.coupon_rule = temp["coupon_rule"] ?? ""
        self.coupon_discount = temp["coupon_discount"] ?? ""
        self.discount_amount = temp["discount_amount"] ?? ""
        self.coupon_storeid = temp["coupon_storeid"] ?? ""
        self.coupon_for = temp["coupon_for"] ?? ""
        self.using_flag = temp["using_flag"] ?? ""
        self.using_date = temp["using_date"] ?? ""
        self.mycoupon_created_at = temp["mycoupon_created_at"] ?? ""
        self.store_name = temp["store_name"] ?? ""
        self.store_address = temp["store_address"] ?? ""
        self.store_status = temp["store_status"] ?? ""
        self.shopping_area = temp["shopping_area"] ?? ""
        self.mycoupon_trash = temp["mycoupon_trash"] ?? ""
        self.isLottery = self.coupon_name.contains("抽獎券")
        
        let coupon_picture = temp["coupon_picture"] ?? ""
        WebAPI.shared.requestImage(urlString: ROOT_URL + coupon_picture) { image in
            self.coupon_picture = image
        }
    }
    
    func checkAvailable() -> CouponStatus {
        if using_flag == "1" {
            return .Used
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-DD"
        let start = dateFormatter.date(from: coupon_startdate)
        var end = dateFormatter.date(from: coupon_enddate)
        end?.addTimeInterval(60*60*24-1)
        if let start = start,
           let end = end,
           Date() < start,
           Date() > end {
            return .OutDate
        }
        if coupon_status == "2" {
            return .Unavailable
        }
        return .Available
    }
}
