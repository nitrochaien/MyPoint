//
//  FrequencyCellTableViewCell.swift
//  MyPoint
//
//  Created by Nam Vu on 2/24/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class FrequencyCellTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
}
