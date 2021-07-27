//
//  MyVoucherTableViewCell.swift
//  MyPoint
//
//  Created by Nam Vu on 1/15/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class MyVoucherTableViewCell: UITableViewCell {

    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var timeLeftLabel: UILabel!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var timeView: UIView!
    @IBOutlet private weak var timeBgImageView: UIImageView!
    @IBOutlet private weak var timeValueLabel: UILabel!
    @IBOutlet private weak var spacingConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    func setData(_ item: MyVoucherModel) {
        iconImageView.setImage(withURL: item.image)
        titleLabel.text = item.title
        timeLeftLabel.text = item.deadline

        switch item.type {
        case .readyToUse:
            timeView.isHidden = false
            statusLabel.isHidden = true
            spacingConstraint.constant = 0
            if let offset = item.expiredDate?.offset(from: Date()) {
                timeValueLabel.text = offset.dateString
                switch offset.type {
                case .days:
                    timeBgImageView.image = UIImage(named: "voucher_near_end_bg")
                case .hours:
                    timeBgImageView.image = UIImage(named: "voucher_ending_bg")
                default:
                    timeView.isHidden = true
                }
            } else {
                timeView.isHidden = true
            }
        case .used:
            if let offset = item.expiredDate?.offset(from: Date()) {
                timeValueLabel.text = offset.dateString
            } else {
                timeView.isHidden = true
            }
            spacingConstraint.constant = 8
            timeView.isHidden = true
            statusLabel.isHidden = false
            statusLabel.text = "voucher.used".localized
            statusLabel.textColor = UIColor(hexString: "#7493DB")
            statusLabel.backgroundColor = UIColor(hexString: "#CADAFF")
        case .outdate:
            if let offset = item.expiredDate?.offset(from: Date()) {
                timeValueLabel.text = offset.dateString
            } else {
                timeView.isHidden = true
            }
            spacingConstraint.constant = 0
            timeView.isHidden = true
            statusLabel.isHidden = false
            statusLabel.text = "voucher.outdated".localized
            statusLabel.textColor = UIColor(hexString: "#E71D28")
            statusLabel.backgroundColor = UIColor(hexString: "#FFBCC0")
        }
    }
}
