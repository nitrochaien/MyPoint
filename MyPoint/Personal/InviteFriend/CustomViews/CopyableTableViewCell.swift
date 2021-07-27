//
//  CopyableTableViewCell.swift
//  MyPoint
//
//  Created by Nam Vu on 2/15/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class CopyableTableViewCell: UITableViewCell {

    @IBOutlet private weak var contentLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    func setText(_ text: String?) {
        contentLabel.text = text
    }
    
    @IBAction func onCopy(_ sender: Any) {
        UIPasteboard.general.string = contentLabel.text
    }
}
