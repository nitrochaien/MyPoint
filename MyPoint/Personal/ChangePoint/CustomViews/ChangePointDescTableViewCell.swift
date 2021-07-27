//
//  ChangePointDescTableViewCell.swift
//  MyPoint
//
//  Created by Nam Vu on 2/16/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

class ChangePointDescTableViewCell: UITableViewCell {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionLabel2: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    func config() {
        setTextForFirstDescription()
        setTextForSecondDescription()
    }

    private func setTextForFirstDescription() {
        let points = "493"
        let campaign = "Kết Nối Dài Lâu"
        let merchant = "MobiFone"
        let descriptionText = String(format: "change_point.desc1".localized, points, campaign, merchant)

        let attribute = descriptionLabel.getAttributeSpacing(inputText: descriptionText, lineSpacing: 8.0)
        let maxRange = NSRange(location: 0, length: descriptionText.count)
        attribute?.addAttributes([.font: UIFont.systemFont(ofSize: 16),
                                  .foregroundColor: UIColor(hexString: "#032041")!],
                                 range: maxRange)

        let hightlightedRange = (descriptionText as NSString).range(of: String(points))
        attribute?.addAttributes([.font: UIFont.systemFont(ofSize: 16, weight: .medium),
                                  .foregroundColor: UIColor(hexString: "#F15757")!],
                                 range: hightlightedRange)

        let hightlightedRange1 = (descriptionText as NSString).range(of: String(campaign))
        attribute?.addAttributes([.font: UIFont.systemFont(ofSize: 16, weight: .medium),
                                  .foregroundColor: UIColor(hexString: "#1556FC")!],
                                 range: hightlightedRange1)
        let hightlightedRange2 = (descriptionText as NSString).range(of: String(merchant))
        attribute?.addAttributes([.font: UIFont.systemFont(ofSize: 16, weight: .medium),
                                  .foregroundColor: UIColor(hexString: "#1556FC")!],
                                 range: hightlightedRange2)

        descriptionLabel.attributedText = attribute
    }

    private func setTextForSecondDescription() {
        let name = "MyPoint"
        let descriptionText = String(format: "change_point.desc2".localized, name)

        let attribute = descriptionLabel2.getAttributeSpacing(inputText: descriptionText, lineSpacing: 8.0)
        let maxRange = NSRange(location: 0, length: descriptionText.count)
        attribute?.addAttributes([.font: UIFont.systemFont(ofSize: 16),
                                  .foregroundColor: UIColor(hexString: "#032041")!],
                                 range: maxRange)

        let hightlightedRange = (descriptionText as NSString).range(of: String(name))
        attribute?.addAttributes([.font: UIFont.systemFont(ofSize: 16, weight: .medium),
                                  .foregroundColor: UIColor.black],
                                 range: hightlightedRange)

        descriptionLabel2.attributedText = attribute
    }
    
    @IBAction func onSeeMore(_ sender: Any) {
    }
}
