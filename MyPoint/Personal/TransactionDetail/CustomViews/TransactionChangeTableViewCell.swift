//
//  TransactionChangeTableViewCell.swift
//  MyPoint
//
//  Created by Nam Vu on 2/23/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class TransactionChangeTableViewCell: UITableViewCell {

    @IBOutlet weak var pointLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
}
