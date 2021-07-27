//
//  DistrictCell.swift
//  MyPoint
//
//  Created by Hieu Nguyen on 2/5/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class ProvinceCell: UITableViewCell {

    @IBOutlet private weak var provinceNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    func setData(_ data: ProvinceSearchPresenter.DisplayItem) {
        provinceNameLabel.text = data.name
        provinceNameLabel.textColor = UIColor(hexString: data.isSelected ? "#032041": "#727C88")
        accessoryType = data.isSelected ? .checkmark : .none
    }
}
