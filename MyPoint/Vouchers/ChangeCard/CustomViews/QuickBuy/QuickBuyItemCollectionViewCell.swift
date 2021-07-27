//
//  QuickBuyItemCollectionViewCell.swift
//  MyPoint
//
//  Created by Nam Vu on 1/19/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class QuickBuyItemCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var valueLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.layer.borderColor = UIColor(hexString: "#F1F3F4")?.cgColor
        containerView.layer.borderWidth = 0.5
        containerView.layer.cornerRadius = 8
        containerView.clipsToBounds = true
    }
    
    func setData(_ data: QuickBuyModel) {
        iconImageView.setImage(withURL: data.icon)
        valueLabel.text = data.value
        dateLabel.text = data.date
        nameLabel.text = data.name
    }
    
}
