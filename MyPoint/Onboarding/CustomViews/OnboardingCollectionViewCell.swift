//
//  OnboardingCollectionViewCell.swift
//  MyPoint
//
//  Created by Nam Vu on 3/25/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

class OnboardingCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var contentImageView: UIImageView!
    @IBOutlet private weak var headerTitle: UILabel!
    @IBOutlet private weak var contentTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setData(data: OnboardingPresenter.OnboardingData) {
        let image = UIImage(named: data.image)
        guard let scaledImage = image else {
            contentImageView.image = nil
            return
        }
        contentImageView.image = scaledImage

        let descriptionText = data.descriptionText.localized
        let attribute = contentTitle.getAttributeSpacing(inputText: descriptionText, lineSpacing: 8.0)
        let maxRange = NSRange(location: 0, length: descriptionText.count)
        attribute?.addAttributes([.font: UIFont(name: AppFontName.regular, size: 14.0)!,
                                  .foregroundColor: UIColor(hexString: "2E5ECB")!],
                                 range: maxRange)
        contentTitle.attributedText = attribute
        headerTitle.text = data.headerText.localized
    }
}
