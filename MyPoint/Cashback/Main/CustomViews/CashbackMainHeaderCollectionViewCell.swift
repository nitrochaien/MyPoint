//
//  CashbackMainHeaderCollectionViewCell.swift
//  MyPoint
//
//  Created by Nam Vu on 7/21/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class CashbackMainHeaderCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var pointLabel: UILabel!
    @IBOutlet private weak var pointView: UIView!
    @IBOutlet private weak var tutorialButton: UIButton!
    
    static let cellId = "CashbackMainHeaderCollectionViewCell"

    var showTutorial: (() -> Void)?
    var showTransaction: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()

        pointView.addShadow(ofColor: .lightGray,
                            radius: 8,
                            offset: .zero,
                            opacity: 0.5)

        let title = "Hoàn điểm thế nào?"
        tutorialButton.setAttributedTitle(title.underline, for: .normal)

        pointView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handlePointView)))
    }

    @objc private func handlePointView() {
        showTransaction?()
    }

    @IBAction private func onTapTutorial(_ sender: Any) {
        showTutorial?()
    }
    
    func setData(_ data: CashbackMainModel.Header?) {
        pointLabel.text = data?.point
    }
}
