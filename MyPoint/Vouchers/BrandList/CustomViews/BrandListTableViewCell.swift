//
//  BrandListTableViewCell.swift
//  MyPoint
//
//  Created by Nam Vu on 2/10/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class BrandListTableViewCell: UITableViewCell {

    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var brandLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setData(_ item: BrandListPresenter.BrandItem) {
        if item.isLocalImage {
            iconImageView.image = UIImage(named: item.icon)
        } else {
            iconImageView.setImage(withURL: item.icon)
        }
        brandLabel.text = item.title
        brandLabel.textColor = item.isSelecting ? .red : UIColor(hexString: "032041")
    }
}
