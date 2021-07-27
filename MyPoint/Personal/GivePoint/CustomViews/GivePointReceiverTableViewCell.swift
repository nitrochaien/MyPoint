//
//  GivePointReceiverTableViewCell.swift
//  MyPoint
//
//  Created by Nam Vu on 2/14/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class GivePointReceiverTableViewCell: UITableViewCell {

    @IBOutlet private weak var placeholderText: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var phoneLabel: UILabel!
    @IBOutlet private weak var infoView: UIView!
    @IBOutlet private weak var containerView: UIView!

    var onPickReceiver: ((_ model: GivePointModel) -> Void)?

    var model: GivePointModel = .init() {
        didSet {
            infoView.isHidden = true
            placeholderText.isHidden = true

            nameLabel.text = model.name
            phoneLabel.text = model.phone

            if model.name.isEmpty {
                placeholderText.isHidden = false
            } else {
                infoView.isHidden = false
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(chooseReceiver))
        containerView.addGestureRecognizer(tapGesture)
    }

    @objc private func chooseReceiver() {
        onPickReceiver?(model)
    }
}
