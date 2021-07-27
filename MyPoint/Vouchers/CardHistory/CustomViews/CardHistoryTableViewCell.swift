//
//  CardHistoryTableViewCell.swift
//  MyPoint
//
//  Created by Nam Vu on 1/20/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class CardHistoryTableViewCell: UITableViewCell {

    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var valueLabel: UILabel!
    @IBOutlet private weak var telcoLabel: UILabel!
    @IBOutlet private weak var phoneLabel: UILabel!
    @IBOutlet private weak var serialLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction private func onTapPayAgain(_ sender: Any) {
    }
    
    @IBAction private func onTapCopy(_ sender: Any) {
        UIPasteboard.general.string = phoneLabel.text
    }

    func setData(_ data: CardHistoryModel) {
        iconImageView.setImage(withURL: data.icon)
        valueLabel.text = data.value
        telcoLabel.text = data.telco
        phoneLabel.text = data.phone
        serialLabel.text = data.serial
        dateLabel.text = data.date
    }
}
