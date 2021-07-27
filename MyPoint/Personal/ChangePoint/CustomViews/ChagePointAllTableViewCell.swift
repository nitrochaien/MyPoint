//
//  ChagePointAllTableViewCell.swift
//  MyPoint
//
//  Created by Nam Vu on 2/16/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class ChagePointAllTableViewCell: UITableViewCell {

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var pinImageView: UIImageView!
    @IBOutlet private weak var tickImageView: UIImageView!
    @IBOutlet private weak var changeView: UIView!
    @IBOutlet private weak var contentLabel: UILabel!
    
    var isChecked: Bool = true {
        didSet {
            if isChecked {
                containerView.layer.cornerRadius = 8
                containerView.layer.borderWidth = 0
                pinImageView.image = UIImage(named: "ic_dot")
                tickImageView.image = UIImage(named: "ic_tick_green")
                changeView.layer.borderColor = UIColor(hexString: "#1EB36C")?.cgColor
                contentLabel.textColor = UIColor(hexString: "#032041")

                containerView.addShadow(ofColor: .lightGray,
                                       radius: 8,
                                       offset: .zero,
                                       opacity: 0.5)
            } else {
                containerView.layer.cornerRadius = 8
                containerView.layer.borderWidth = 1
                containerView.layer.borderColor = UIColor(hexString: "#F1F3F4")?.cgColor
                pinImageView.image = nil
                tickImageView.image = nil
                changeView.layer.borderColor = UIColor(hexString: "#F1F3F4")?.cgColor
                contentLabel.textColor = UIColor(hexString: "#98A1AF")

                containerView.addShadow(ofColor: .white,
                                       radius: 0,
                                       offset: .zero,
                                       opacity: 0.0)
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
}
