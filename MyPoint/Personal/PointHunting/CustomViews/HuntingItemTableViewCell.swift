//
//  HuntingItemTableViewCell.swift
//  MyPoint
//
//  Created by Nam Vu on 2/15/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class HuntingItemTableViewCell: UITableViewCell {

    @IBOutlet private weak var headerLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!
    @IBOutlet private weak var huntButtonView: UIView!
    @IBOutlet private weak var pointLabel: UILabel!
    @IBOutlet private weak var huntButton: ResizableButton!
    @IBOutlet private weak var backgroundImageView: UIImageView!
    @IBOutlet private weak var iconImageView: UIImageView!
    
    var onHunt: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none

        huntButtonView.addShadow(ofColor: .lightGray,
                                 radius: 8,
                                 offset: .zero,
                                 opacity: 0.5)
    }

    func setData(_ model: AchievementModel) {
        headerLabel.text = model.title
        contentLabel.text = model.content
        huntButton.setTitle(model.buttonTitle, for: .normal)
        huntButton.sizeToFit()
        pointLabel.text = model.point.formattedWithSeparator
        backgroundImageView.setImage(withURL: model.background)

        if model.point == 0 {
            iconImageView.isHidden = true
            pointLabel.isHidden = true
        }
    }
    
    @IBAction func onHuntNow(_ sender: Any) {
        onHunt?()
    }
}
