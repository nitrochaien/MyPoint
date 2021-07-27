//
//  CashbackPointTableViewCell.swift
//  MyPoint
//
//  Created by Nam Vu on 7/19/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class CashbackPointTableViewCell: UITableViewCell {

    @IBOutlet private weak var headerLabel: UILabel!
    @IBOutlet private weak var pointLabel: UILabel!

    static let cellId = "CashbackPointTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    func setData(_ data: CashbackTransactionModel?) {
        headerLabel.text = data?.pointTitle
        pointLabel.text = data?.point
    }
}
