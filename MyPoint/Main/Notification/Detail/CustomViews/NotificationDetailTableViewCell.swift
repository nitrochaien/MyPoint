//
//  NotificationDetailTableViewCell.swift
//  MyPoint
//
//  Created by Nam Vu on 3/27/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

class NotificationDetailTableViewCell: UITableViewCell {

    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        iconImageView.image = UIImage(named: "AppIcon")
    }

    func setData(_ title: String?, content: String?) {
        if let newContent = content {
            let attribute = contentLabel.getAttributeSpacing(inputText: newContent,
                                                             lineSpacing: 8.0)
            let maxRange = NSRange(location: 0, length: newContent.count)
            attribute?.addAttributes([.font: UIFont(name: AppFontName.regular, size: 14.0)!,
                                      .foregroundColor: UIColor(hexString: "#787878")!],
                                     range: maxRange)
            contentLabel.attributedText = attribute
        }

        if let newTitle = title {
            let attribute = titleLabel.getAttributeSpacing(inputText: newTitle,
                                                             lineSpacing: 8.0)
            let maxRange = NSRange(location: 0, length: newTitle.count)
            attribute?.addAttributes([.font: UIFont(name: AppFontName.medium, size: 16.0)!,
                                      .foregroundColor: UIColor(hexString: "#032041")!],
                                     range: maxRange)
            titleLabel.attributedText = attribute
        }
    }
}
