//
//  EditSelectionTableViewCell.swift
//  MyPoint
//
//  Created by Nam Vu on 1/28/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class EditSelectionTableViewCell: UITableViewCell {

    var didSelectOption: (() -> Void)?

    @IBOutlet private weak var selectionView: BaseSelectionView!
    @IBOutlet private weak var trailingConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none

        selectionView.onTapSelection = { [weak self] in
            self?.didSelectOption?()
        }
        selectionView.update(font: UIFont.systemFont(ofSize: 14), textColor: "#000000")
    }

    func updateSection(at section: Int) {
        if section == EditProfileViewController.SectionType.gender .rawValue {
            trailingConstraint.constant = UIScreen.main.bounds.width * 2 / 3
        } else {
            trailingConstraint.constant = 16
        }
    }

    func updateFilterSection() {
        trailingConstraint.constant = UIScreen.main.bounds.width * 1 / 2
    }

    func setTitle(_ value: String, _ needsToReset: Bool = true) {
        selectionView.setTitle(value: value)

        if needsToReset {
            selectionView.resetTransformation()
        }
    }

    func setPlaceholder(_ value: String) {
        selectionView.setPlaceholder(value: value)
    }
}
