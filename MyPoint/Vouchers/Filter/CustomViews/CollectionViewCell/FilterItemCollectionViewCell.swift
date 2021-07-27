//
//  FilterItemCollectionViewCell.swift
//  MyPoint
//
//  Created by Nam Vu on 2/2/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class FilterItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet private weak var backgroundImageView: UIImageView!

    class FilterItem: Equatable {
        let id: Int
        let name: String
        var isSelected: Bool

        init(id: Int, name: String, isSelected: Bool) {
            self.id = id
            self.name = name
            self.isSelected = isSelected
        }

        static func == (lhs: FilterItem, rhs: FilterItem) -> Bool {
            return rhs.id == lhs.id
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setData(_ item: ProvinceSearchPresenter.DisplayItem) {
        nameLabel.text = item.name

        if item.isSelected {
            active()
        } else {
            inactive()
        }
    }

    func active() {
        backgroundImageView.isHidden = false
        nameLabel.textColor = .white
    }

    func inactive() {
        backgroundImageView.isHidden = true
        nameLabel.textColor = UIColor(hexString: "#98A1AF")
    }
}
