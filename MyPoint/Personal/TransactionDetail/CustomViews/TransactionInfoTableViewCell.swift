//
//  TransactionInfoTableViewCell.swift
//  MyPoint
//
//  Created by Nam Vu on 2/23/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class TransactionInfoTableViewCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    func setData(_ value: TransactionDetailPresenter.Value) {
        titleLabel.text = value.title
        contentLabel.text = value.content
    }
    
}
