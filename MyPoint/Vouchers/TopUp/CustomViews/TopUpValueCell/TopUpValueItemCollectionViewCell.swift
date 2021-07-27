//
//  TopUpValueItemCollectionViewCell.swift
//  MyPoint
//
//  Created by Nam Vu on 1/17/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class TopUpValueItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var valueLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var pointView: UIView!
    @IBOutlet private weak var cashBackView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        containerView.layer.cornerRadius = 8
        containerView.layer.borderWidth = 1
    }

    func setData(_ data: TopUpValueModel) {
        valueLabel.textAlignment = .left
        valueLabel.text = data.value
        priceLabel.text = data.price

        if data.isTopup {
            pointView.isHidden = true
            cashBackView.isHidden = false
        } else {
            pointView.isHidden = false
            cashBackView.isHidden = true
        }

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
