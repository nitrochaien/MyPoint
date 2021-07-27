//
//  IntroductionItemTableViewCell.swift
//  MyPoint
//
//  Created by Nam Vu on 3/9/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class IntroductionItemTableViewCell: UITableViewCell {

    @IBOutlet private weak var headerLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    func setData(_ data: NewsModel) {
        headerLabel.text = data.contentText
        contentLabel.attributedText = data.subText
    }
}
