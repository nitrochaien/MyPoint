//
//  TransactionRatingTableViewCell.swift
//  MyPoint
//
//  Created by Nam Vu on 2/23/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class TransactionRatingTableViewCell: UITableViewCell {

    @IBOutlet private weak var ratingView: CosmosView!
    @IBOutlet private weak var inputTextField: UITextField!

    var didFinishRating: ((_ rating: Double) -> Void)?
    var textDidChange: ((_ text: String?) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none

        configRatingStars()

        inputTextField.addTarget(self, action: #selector(onTextChanged), for: .editingChanged)
    }

    @objc private func onTextChanged(_ textField: UITextField) {
        textDidChange?(textField.text)
    }

    private func configRatingStars() {
        ratingView.rating = 5
        ratingView.filledImage = UIImage(named: "ic_star_filled")
        ratingView.emptyImage = UIImage(named: "ic_star_empty")
        ratingView.didFinishTouchingCosmos = { [weak self] rating in
            self?.didFinishRating?(rating)
        }
    }
}
