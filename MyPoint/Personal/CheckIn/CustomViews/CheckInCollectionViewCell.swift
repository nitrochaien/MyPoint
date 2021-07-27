//
//  CheckInCollectionViewCell.swift
//  MyPoint
//
//  Created by Nam Vu on 2/13/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class CheckInCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var imageHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var dayLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func setData(_ data: CheckInItem) {
        dayLabel.text = data.title
        imageHeightConstraint.constant = 40

        switch data.type {
        case .today:
            iconImageView.image = UIImage(named: "ic_checked-in-today")
        case .checkedIn:
            iconImageView.image = UIImage(named: "ic_checked-in")
        case .notCheckedIn:
            iconImageView.image = UIImage(named: "ic_not-checked-in")
            imageHeightConstraint.constant = 30
        }
    }

}
