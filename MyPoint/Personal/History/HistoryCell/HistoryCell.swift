//
//  HistoryCell.swift
//  MyPoint
//
//  Created by Hieu on 2/16/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

class HistoryCell: UITableViewCell {
    
    @IBOutlet weak var historyHeaderLabel: UILabel!
    @IBOutlet weak var branndLogoImageView: UIImageView!
    @IBOutlet weak var brandNameLabel: UILabel!
    @IBOutlet weak var historyTimeLabel: UILabel!
    @IBOutlet weak var pointLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    func setData(_ data: History?) {
        brandNameLabel.text = data?.displayName
        historyHeaderLabel.text = data?.transactionTagDescription
        branndLogoImageView.setImage(withURL: data?.brandLogo)
        historyTimeLabel.text = data?.dateDisplay
        pointLabel.text = data?.pointDisplay.0
        pointLabel.textColor = UIColor(hexString: data?.pointDisplay.1 ?? "")
    }
}
