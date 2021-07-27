//
//  PageTextTableViewCell.swift
//  MyPoint
//
//  Created by Nam Vu on 2/17/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class PageTextTableViewCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
//    @IBOutlet private weak var contentLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    func setData(_ data: NewsDetailPresenter.GeneralPage) {
        titleLabel.text = data.contentCaption
        contentTextView.attributedText = data.htmlString
    }
  
    func setData(_ data: NewMerchantInfoViewController.GeneralPage) {
        titleLabel.text = data.contentCaption
        contentTextView.attributedText = data.htmlString
    }
}
