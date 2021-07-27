//
//  ChooseBankTableViewCell.swift
//  MyPoint
//
//  Created by Nam Vu on 2/8/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class ChooseBankTableViewCell: UITableViewCell {

    @IBOutlet private weak var bankImageView: UIImageView!
    @IBOutlet private weak var bankNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    func setData(_ data: ChooseBankPresenter.BankModel) {
        bankImageView.image = UIImage(named: data.icon)
        bankNameLabel.text = data.name
        bankNameLabel.textColor = UIColor(hexString: "#032041")
        accessoryType = data.isSelected ? .checkmark : .none
    }
}
