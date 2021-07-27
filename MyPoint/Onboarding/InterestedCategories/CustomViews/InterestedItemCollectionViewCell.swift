//
//  InterestedItemCollectionViewCell.swift
//  MyPoint
//
//  Created by Nam Vu on 1/21/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class InterestedItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var itemLabel: UILabel!
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var selectionImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setData(_ data: InterestedItem) {
        itemLabel.text = data.title
        iconImageView.setImage(withURL: data.icon)
        selectionImageView.isHidden = !data.isSelected
    }
}
