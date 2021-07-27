//
//  CashbackTutorialTableViewCell.swift
//  MyPoint
//
//  Created by Nam Vu on 7/20/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class CashbackTutorialTableViewCell: UITableViewCell {

    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var stepLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!

    static let cellId = "CashbackTutorialTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    func setData(_ index: Int, content: String) {
        thumbnailImageView.image = UIImage(named: "ic_cashback_tuts_\(index)")
        stepLabel.text = "Bước \(index + 1)"
        contentLabel.text = content
    }
}
