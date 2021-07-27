//
//  PageHeaderTableViewCell.swift
//  MyPoint
//
//  Created by Nam Vu on 2/17/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class PageHeaderTableViewCell: UITableViewCell {

    @IBOutlet private weak var bigImageView: ScaledHeightImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!

    var imageContentMode: UIView.ContentMode = .scaleAspectFill

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    func setData(_ data: NewsDetailPresenter.Header) {
        bigImageView.image = data.convertedImage
        titleLabel.text = data.contentCaption
        dateLabel.text = data.contentText.dateToString(fromFormat: DateFormat.server,
                                                       DateFormat.page)
        bigImageView.contentMode = imageContentMode
    }
  
    func setData(_ data: NewMerchantInfoViewController.Header) {
//        bigImageView.setImage(withURL: data.thumbnail)
        titleLabel.text = data.contentCaption
        dateLabel.text = data.contentText.dateToString(fromFormat: DateFormat.server,
                                                       DateFormat.page)
    }
}
