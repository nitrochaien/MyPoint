//
//  CashbackDetailCategoryItemCollectionViewCell.swift
//  MyPoint
//
//  Created by Nam Vu on 7/20/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class CashbackDetailCategoryItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var categoryNameLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet private weak var cashbackPercentageLabel: UILabel!

    static let cellId = "CashbackDetailCategoryItemCollectionViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.addShadow(ofColor: .lightGray,
                                radius: 4,
                                offset: .zero,
                                opacity: 0.5)
    }

    func setData(_ data: CashbackDetailModel.Category?) {
        categoryNameLabel.text = data?.title
        cashbackPercentageLabel.text = data?.percentage
    }

}
