//
//  FilterPartnerItemCollectionViewCell.swift
//  MyPoint
//
//  Created by Nam Vu on 2/2/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class FilterPartnerItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setData(_ item: FilterPresenter.Category) {
        iconImageView.setImage(withURL: item.icon)
        nameLabel.text = item.title

//        if item.isSelected {
//            gradientImageView.isHidden = false
//        } else {
//            gradientImageView.isHidden = true
//        }
    }
}
