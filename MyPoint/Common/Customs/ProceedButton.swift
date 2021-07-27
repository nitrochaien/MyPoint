//
//  ProceedButton.swift
//  MyPoint
//
//  Created by Nam Vu on 1/1/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

class ProceedButton: UIButton {

    enum ActiveState {
        case active
        case inactive
        case proceed
    }

    var activeState = ActiveState.active {
        willSet {
            switch newValue {
            case .inactive:
                setInActiveButton()
            case .active:
                setActiveButton()
            case .proceed:
                setProceedButton()
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        initButton()
    }

    func initButton() {
        layer.cornerRadius = 20
        contentHorizontalAlignment = .left
        contentEdgeInsets.left = 10
        setTitleColor(.white, for: .normal)
        tintColor = .white
        setImage(UIImage(named: "ic_arrow_right"), for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)

        translatesAutoresizingMaskIntoConstraints = false
        imageView?.translatesAutoresizingMaskIntoConstraints = false
        imageView?.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20.0).isActive = true
        imageView?.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0.0).isActive = true
    }

    private func setInActiveButton() {
        backgroundColor = #colorLiteral(red: 0.5725490196, green: 0.5764705882, blue: 0.662745098, alpha: 0.5)
        setBackgroundImage(nil, for: .normal)
        isUserInteractionEnabled = false
    }

    private func setActiveButton() {
        setBackgroundImage(UIImage(named: "btn_continue_background"), for: .normal)
        backgroundColor = .clear
        isUserInteractionEnabled = true
    }

    private func setProceedButton() {
        setBackgroundImage(UIImage(named: "btn_next_background"), for: .normal)
        backgroundColor = .clear
        isUserInteractionEnabled = true
    }
}
