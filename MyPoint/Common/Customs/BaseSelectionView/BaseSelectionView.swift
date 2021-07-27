//
//  BaseSelectionView.swift
//  MyPoint
//
//  Created by Nam Vu on 1/15/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

class BaseSelectionView: UIView {

    @IBOutlet var containerView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var tappableAreaView: UIView!

    var onTapSelection: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    private func initialize() {
        Bundle.main.loadNibNamed("BaseSelectionView", owner: self, options: nil)
        guard let content = containerView else { return }
        content.frame = self.bounds
        content.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(content)

        tappableAreaView.borderColor = UIColor(hexString: "#F1F3F4")
        tappableAreaView.cornerRadius = 8
        tappableAreaView.borderWidth = 1

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onSelect))
        tappableAreaView.addGestureRecognizer(tapGesture)
    }

    func update(font: UIFont, textColor: String) {
        titleLabel.font = font
        titleLabel.textColor = UIColor(hexString: textColor)
    }

    @objc private func onSelect() {
//        if iconImageView.transform == .identity {
//            UIView.animate(withDuration: 0.2,
//                           animations: {
//                            self.iconImageView.transform = .init(rotationAngle: CGFloat.pi)
//            }) { completed in
//                if completed {
//                    self.onTapSelection?()
//                }
//            }
//        } else {
//            UIView.animate(withDuration: 0.2,
//                           animations: {
//                            self.iconImageView.transform = .identity
//            }) { completed in
//                if completed {
//                    self.onTapSelection?()
//                }
//            }
//        }

        self.onTapSelection?()
    }

    func resetTransformation() {
        self.iconImageView.transform = .identity
    }

    func setTitle(value: String) {
        titleLabel.text = value
        titleLabel.textColor = .black
    }

    func setPlaceholder(value: String) {
        titleLabel.text = value
        titleLabel.textColor = UIColor(hexString: "#C7C7CD")
    }
}
