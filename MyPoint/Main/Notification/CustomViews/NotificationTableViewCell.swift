//
//  NotificationTableViewCell.swift
//  MyPoint
//
//  Created by Nam Vu on 2/3/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class NotificationTableViewCell: UITableViewCell {

    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var bodyLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    func setData(_ data: NotificationItem) {
        iconImageView.setImage(withURL: data.icon)
        nameLabel.text = data.name
        bodyLabel.text = data.description
        backgroundColor = data.hasSeen ? .white : UIColor(hexString: "#E9EFFF")
    }
}
