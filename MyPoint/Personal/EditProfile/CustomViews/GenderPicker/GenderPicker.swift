//
//  GenderPicker.swift
//  MyPoint
//
//  Created by Nam Vu on 2/10/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

protocol GenderPickerDelegate: NSObjectProtocol {
    func didChoose(_ gender: PersonalGender)
    func didHide()
}

final class GenderPicker: UIView {

    @IBOutlet var containerView: UIView!
    @IBOutlet private weak var maleButton: UIButton!
    @IBOutlet private weak var femaleButton: UIButton!
    @IBOutlet private weak var otherButton: UIButton!
    
    weak var delegate: GenderPickerDelegate?

    var isShowing: Bool {
        return alpha == 1
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    private func initialize() {
        Bundle.main.loadNibNamed("GenderPicker", owner: self, options: nil)
        guard let content = containerView else { return }
        content.frame = self.bounds
        content.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(content)

        hide(animation: false)
    }

    func setData(_ gender: PersonalGender) {
        switch gender {
        case .male:
            selected(button: maleButton)
            unselected(button: femaleButton)
            unselected(button: otherButton)
        case .female:
            selected(button: femaleButton)
            unselected(button: maleButton)
            unselected(button: otherButton)
        case .unknown:
            selected(button: otherButton)
            unselected(button: femaleButton)
            unselected(button: maleButton)
        default:
            unselected(button: maleButton)
            unselected(button: femaleButton)
            unselected(button: otherButton)
        }
    }

    private func selected(button: UIButton) {
        let selectedColor = UIColor(hexString: "#032041")
        let selectedFont = UIFont.systemFont(ofSize: 14, weight: .medium)
        button.setTitleColor(selectedColor, for: .normal)
        button.titleLabel?.font = selectedFont
    }

    private func unselected(button: UIButton) {
        let unselectedColor = UIColor(hexString: "#727C88")
        let unselectedFont = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(unselectedColor, for: .normal)
        button.titleLabel?.font = unselectedFont
    }

    func hide(animation: Bool = true) {
        func translate() {
            transform = CGAffineTransform(translationX: 0, y: 100)
            alpha = 0
        }

        if animation {
            UIView.animate(withDuration: 0.2) {
                translate()
            }
        } else {
            translate()
        }
        delegate?.didHide()
    }

    func show() {
        UIView.animate(withDuration: 0.2) {
            self.transform = .identity
            self.alpha = 1
        }
    }

    @IBAction private func onDismiss(_ sender: Any) {
        hide()
    }

    @IBAction private func chooseMale(_ sender: Any) {
        delegate?.didChoose(.male)
        hide()
    }

    @IBAction private func chooseOther(_ sender: Any) {
        delegate?.didChoose(.unknown)
        hide()
    }

    @IBAction private func chooseFemale(_ sender: Any) {
        delegate?.didChoose(.female)
        hide()
    }
}
