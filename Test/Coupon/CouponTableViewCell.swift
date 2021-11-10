//
//  CouponTableViewCell.swift
//  Test
//
//  Created by Tai Chin Huang on 2021/11/9.
//

import UIKit

protocol CouponTableViewCellDelegate: AnyObject {
    func useAction(_ model: Coupon)
}

class CouponTableViewCell: UITableViewCell {
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var shopAddressLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var useButton: UIButton!
    
    var coupon: Coupon?
    var cellType: CellType = .List
    
    weak var delegate: CouponTableViewCellDelegate?
    
    @IBAction func useAction(_ sender: UIButton) {
        guard let coupon = coupon else { return }
        delegate?.useAction(coupon)
    }
    
    func configure(_ coupon: Coupon) {
        self.coupon = coupon
        // For label
        titleLabel.text = coupon.coupon_name
        if coupon.isLottery {
            descriptionLabel.text = "序號： \(coupon.coupon_no)"
            shopAddressLabel.text = "取得日期： \(coupon.mycoupon_created_at)"
            dateLabel.text        = "抽獎日期： \(coupon.coupon_enddate)"
        } else if cellType == .List {
            descriptionLabel.text = coupon.coupon_description
            shopAddressLabel.text = "地址： \(coupon.store_address)"
            dateLabel.text        = "使用期限： \(coupon.coupon_startdate) ~ \(coupon.coupon_enddate)"
        } else {
            descriptionLabel.text = coupon.coupon_description
            shopAddressLabel.text = "地址： \(coupon.store_address)"
            dateLabel.text        = "使用期限： \(coupon.coupon_startdate) ~ \(coupon.coupon_enddate)"
        }
        // For image
        if let image = coupon.coupon_picture {
            itemImageView.image = image
        } else {
            coupon.renewImage = {
                self.itemImageView.image = coupon.coupon_picture
            }
        }
        // For button
        switch cellType {
        case .List:
            useButton.isHidden = true
        case .Lottery:
            useButton.setTitle("抽獎規則", for: .normal)
            useButton.backgroundColor = Theme.blueColor
        case .Canuse:
            useButton.setTitle("使用", for: .normal)
            useButton.backgroundColor = Theme.orangeColor
        case .Used:
            var title = "已失效"
            switch coupon.checkAvailable() {
            case .Available:
                return
            case .Used:
                title = "已使用"
            case .OutDate:
                title = "已過期"
            case .Unavailable:
                return
            }
            useButton.setTitle(title, for: .disabled)
            useButton.backgroundColor = .gray
            useButton.isEnabled = false
        }
    }
    
    func prepeareForReuse() {
        itemImageView.image   = UIImage(systemName: "applelogo")
        titleLabel.text       = ""
        descriptionLabel.text = ""
        shopAddressLabel.text = ""
        dateLabel.text        = ""
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
