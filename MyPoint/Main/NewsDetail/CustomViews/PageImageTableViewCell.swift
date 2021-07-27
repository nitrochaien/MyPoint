//
//  PageImageTableViewCell.swift
//  MyPoint
//
//  Created by Nam Vu on 2/17/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class PageImageTableViewCell: UITableViewCell {

    @IBOutlet private weak var thumbnailImage: ScaledHeightImageView!
    @IBOutlet private weak var contentLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    func setData(_ data: NewsDetailPresenter.GeneralPage) {
        thumbnailImage.image = data.convertedImage
        contentLabel.text = data.contentCaption
    }
  
    func setData(_ data: NewMerchantInfoViewController.GeneralPage) {
        thumbnailImage.setImage(withURL: data.contentText)
        contentLabel.text = data.contentCaption
    }
}

class ScaledHeightImageView: UIImageView {

    override var intrinsicContentSize: CGSize {

        if let myImage = self.image {
            let myImageWidth = myImage.size.width
            let myImageHeight = myImage.size.height
            let myViewWidth = self.frame.size.width

            let ratio = myViewWidth/myImageWidth
            let scaledHeight = myImageHeight * ratio

            return CGSize(width: myViewWidth, height: scaledHeight)
        }

        return CGSize(width: -1.0, height: -1.0)
    }

}
