//
//  InterestedItemHeaderCollectionViewCell.swift
//  MyPoint
//
//  Created by Nam Vu on 1/21/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

class InterestedItemHeaderCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var contentLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        let descriptionText = "onboarding.interested_desc".localized
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8.0
        paragraphStyle.lineBreakMode = .byWordWrapping

        let attributedString = NSMutableAttributedString(string: descriptionText)

        // (Swift 4.2 and above) Line spacing attribute
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle,
                                      value: paragraphStyle,
                                      range: NSRange(location: 0, length: attributedString.length))
        let maxRange = NSRange(location: 0, length: descriptionText.count)
        attributedString.addAttributes([.font: UIFont(name: AppFontName.regular, size: 16.0)!,
                                  .foregroundColor: UIColor(hexString: "#032041")!],
                                 range: maxRange)

        contentLabel.attributedText = attributedString
//        contentLabel.text = descriptionText
    }
}
