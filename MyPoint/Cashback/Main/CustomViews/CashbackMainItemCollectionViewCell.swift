//
//  CashbackMainItemCollectionViewCell.swift
//  MyPoint
//
//  Created by Nam Vu on 7/21/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class CashbackMainItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var brandNameLabel: UILabel!
    @IBOutlet private weak var cashbackPercentageLabel: UILabel!
    @IBOutlet private weak var pointLabel: UILabel!
    @IBOutlet private weak var containerView: UIView!
    
    static let cellId = "CashbackMainItemCollectionViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()

        containerView.addShadow(ofColor: .lightGray,
                                radius: 4,
                                offset: .zero,
                                opacity: 0.5)
    }

    func setData(_ data: CashbackMainModel.Item?) {
        thumbnailImageView.setImage(withURL: data?.thumbnail)
        brandNameLabel.text = data?.brandName
        cashbackPercentageLabel.text = data?.percentage
        pointLabel.text = data?.point
    }
}
