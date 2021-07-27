//
//  ChangePointHeaderTableViewCell.swift
//  MyPoint
//
//  Created by Nam Vu on 2/16/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class ChangePointHeaderTableViewCell: UITableViewCell {

    @IBOutlet private weak var cardView: UIView!
    @IBOutlet private weak var cardImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none

//        cardView.addShadow(ofColor: .lightGray,
//                           radius: 8,
//                           offset: .zero,
//                           opacity: 0.5)
    }

    func setData(_ url: String?) {
        cardImageView.setImage(withURL: url)
    }
}
