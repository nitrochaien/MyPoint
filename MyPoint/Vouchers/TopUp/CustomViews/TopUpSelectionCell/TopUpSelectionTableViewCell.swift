//
//  TopUpSelectionTableViewCell.swift
//  MyPoint
//
//  Created by Nam Vu on 1/17/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class TopUpSelectionTableViewCell: UITableViewCell {

    @IBOutlet private weak var placeholderLabel: UILabel!
    @IBOutlet private weak var selectionView: UIView!
    @IBOutlet private weak var bankIconImageView: UIImageView!
    @IBOutlet private weak var bankNameLabel: UILabel!
    @IBOutlet private weak var containerView: UIView!
    
    var onTapBankSelection: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onSelect))
        containerView.addGestureRecognizer(tapGesture)
    }

    @objc private func onSelect() {
        onTapBankSelection?()
    }

    func setData(_ bank: ChooseBankPresenter.BankModel?) {
        guard let bank = bank else {
            placeholderLabel.isHidden = false
            selectionView.isHidden = true
            return
        }

        placeholderLabel.isHidden = true
        selectionView.isHidden = false
        bankIconImageView.image = UIImage(named: bank.icon)
        bankNameLabel.text = bank.name
    }
}
