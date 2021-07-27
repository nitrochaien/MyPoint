//
//  FilterCategoryCollectionViewCell.swift
//  MyPoint
//
//  Created by Nam Vu on 3/20/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class FilterCategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var categoryLabel: UILabel!
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var dataView: UIView!
    
    var onRemove: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    func setData(_ data: FilterPresenter.Category) {
        if data.isFiltering {
            categoryLabel.textColor = .white
            dataView.backgroundColor = UIColor(hexString: "#1556FC")
            cancelButton.setImage(UIImage(named: "filter_cancel_selected"), for: .normal)
        } else {
            categoryLabel.textColor = UIColor(hexString: "#98A1AF")
            dataView.backgroundColor = UIColor(hexString: "#F1F3F4")
            cancelButton.setImage(UIImage(named: "filter_cancel_unselected"), for: .normal)
        }
        categoryLabel.text = data.title
    }

    @IBAction private func onRemove(_ sender: Any) {
        onRemove?()
    }
}
