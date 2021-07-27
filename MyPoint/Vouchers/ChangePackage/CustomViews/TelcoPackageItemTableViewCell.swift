//
//  TelcoPackageItemTableViewCell.swift
//  MyPoint
//
//  Created by Nam Vu on 1/20/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class TelcoPackageItemTableViewCell: UITableViewCell {

    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var headerLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!
    @IBOutlet private weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none

        containerView.layer.cornerRadius = 8
        containerView.layer.borderWidth = 1
    }

    func setData(_ data: TopUpValueModel) {
        iconImageView.setImage(withURL: data.icon)
        priceLabel.text = data.price
        headerLabel.text = data.header
        contentLabel.text = data.content

        if data.isSelected {
            updateSelection()
        } else {
            updateDeselection()
        }
    }

    private func updateSelection() {
        containerView.layer.borderColor = UIColor(hexString: "1EB36C")?.cgColor
    }

    private func updateDeselection() {
        containerView.layer.borderColor = UIColor(hexString: "F1F3F4")?.cgColor
    }
}
