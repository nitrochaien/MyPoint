//
//  TelcoSelectionItemCollectionViewCell.swift
//  MyPoint
//
//  Created by Nam Vu on 1/19/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class TelcoSelectionItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var telcoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        containerView.layer.cornerRadius = 8
        containerView.layer.borderWidth = 1
    }

    func setData(_ data: TelcoSelectionModel) {
        telcoImageView.setImage(withURL: data.image)

        if data.isSelected {
            updateSelection()
        } else {
            updateDeselection()
        }

        if data.isEnable {
            telcoImageView.alpha = 1.0
        } else {
            telcoImageView.alpha = 0.5
        }
    }

    private func updateSelection() {
        containerView.layer.borderColor = UIColor(hexString: "1EB36C")?.cgColor
    }

    private func updateDeselection() {
        containerView.layer.borderColor = UIColor(hexString: "F1F3F4")?.cgColor
    }
}
