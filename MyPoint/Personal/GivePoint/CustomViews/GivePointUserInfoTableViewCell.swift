//
//  GivePointUserInfoTableViewCell.swift
//  MyPoint
//
//  Created by Nam Vu on 2/14/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class GivePointUserInfoTableViewCell: UITableViewCell {

    @IBOutlet private weak var pointLabel: UILabel!
    @IBOutlet private weak var userInfoView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none

        userInfoView.addShadow(ofColor: .lightGray,
                               radius: 8,
                               offset: .zero,
                               opacity: 0.5)
    }

    func updateData() {
        let userData = Storage.shared.loginData
        pointLabel.text = userData?.workingSite?.customerBalance?.amountActiveDisplay
    }
}
