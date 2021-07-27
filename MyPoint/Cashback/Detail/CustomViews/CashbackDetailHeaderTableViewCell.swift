//
//  CashbackDetailHeaderTableViewCell.swift
//  MyPoint
//
//  Created by Nam Vu on 7/20/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class CashbackDetailHeaderTableViewCell: UITableViewCell {

    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var brandNameLabel: UILabel!
    @IBOutlet private weak var pointLabel: UILabel!

    static let cellId = "CashbackDetailHeaderTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    func setData(_ data: CashbackDetailModel.Header?) {
        thumbnailImageView.setImage(withURL: data?.thumbnail)
        brandNameLabel.text = data?.brandName
        pointLabel.text = data?.point
    }
}
