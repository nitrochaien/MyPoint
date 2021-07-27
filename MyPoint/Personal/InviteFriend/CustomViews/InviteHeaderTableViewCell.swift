//
//  InviteHeaderTableViewCell.swift
//  MyPoint
//
//  Created by Nam Vu on 2/15/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class InviteHeaderTableViewCell: UITableViewCell {

    @IBOutlet private weak var contentLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    func update() {
        let person = "invite.person".localized
        let appName = "invite.app".localized
        let descriptionText = String(format: "invite.content".localized, person, appName)
        let attribute = contentLabel.getAttributeSpacing(inputText: descriptionText, lineSpacing: 8.0)
        let maxRange = NSRange(location: 0, length: descriptionText.count)
        attribute?.addAttributes([.font: UIFont(name: AppFontName.regular, size: 14.0)!,
                                  .foregroundColor: UIColor(hexString: "#032041")!],
                                 range: maxRange)

        let hightlightedRange1 = (descriptionText as NSString).range(of: person)
        attribute?.addAttributes([.font: UIFont(name: AppFontName.medium, size: 14.0)!,
                                  .foregroundColor: UIColor(hexString: "#2E51CB")!],
                                 range: hightlightedRange1)

        let hightlightedRange2 = (descriptionText as NSString).range(of: appName)
        attribute?.addAttributes([.font: UIFont(name: AppFontName.medium, size: 14.0)!,
                                  .foregroundColor: UIColor(hexString: "#FF2828")!],
                                 range: hightlightedRange2)

        contentLabel.attributedText = attribute
    }
}
