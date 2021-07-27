//
//  CashbackTransactionTableViewCell.swift
//  MyPoint
//
//  Created by Nam Vu on 7/19/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

class CashbackTransactionTableViewCell: UITableViewCell {

    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var brandNameLabel: UILabel!
    @IBOutlet weak var codeTitleLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var timeTitleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var valueTitleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var pointTitleLabel: UILabel!
    @IBOutlet weak var pointLabel: UILabel!
    @IBOutlet weak var pointContainerView: UIView!
    @IBOutlet weak var cancelledLabel: UILabel!

    static let cellId = "CashbackTransactionTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    func setData(_ data: CashbackTransaction?) {
        thumbnailImageView.setImage(withURL: data?.thumbnail)
        brandNameLabel.text = data?.brand
        codeTitleLabel.text = data?.codeTitle
        codeLabel.text = data?.code
        timeTitleLabel.text = data?.timeTitle
        timeLabel.text = data?.time
        valueTitleLabel.text = data?.valueTitle
        valueLabel.text = data?.value
        pointTitleLabel.text = data?.descTitle
        pointLabel.text = data?.desc

        let isCancelled = data?.type == .cancelled
        pointContainerView.isHidden = isCancelled
        cancelledLabel.isHidden = !isCancelled
    }
}
