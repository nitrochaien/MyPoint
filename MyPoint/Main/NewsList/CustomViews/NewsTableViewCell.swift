//
//  NewsTableViewCell.swift
//  MyPoint
//
//  Created by Nam Vu on 1/9/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var headerLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    func setData(from model: NewsModel) {
        thumbnailImageView.setImage(withURL: model.contentCaption)
        headerLabel.text = model.contentText
        contentLabel.attributedText = model.subText
    }
}
