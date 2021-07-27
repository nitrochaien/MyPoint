//
//  NoDataVoucherTableViewCell.swift
//  MyPoint
//
//  Created by Nam Vu on 3/16/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class NoDataVoucherTableViewCell: UITableViewCell {

    @IBOutlet weak var emptyImageView: UIImageView!
    @IBOutlet weak var emptyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
}
