//
//  InfoTableViewCell.swift
//  MyPoint
//
//  Created by Nam Vu on 1/28/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class InfoTableViewCell: UITableViewCell {

    @IBOutlet private weak var infoLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    func setInfo(_ input: String?) {
        infoLabel.text = input
    }
}
