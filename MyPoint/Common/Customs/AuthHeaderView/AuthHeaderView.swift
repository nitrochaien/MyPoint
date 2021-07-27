//
//  AuthHeaderView.swift
//  MyPoint
//
//  Created by Nam Vu on 1/4/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

protocol AuthHeaderViewDelegate: NSObjectProtocol {
    func onBack()
    func onHelp()
}

extension AuthHeaderViewDelegate where Self: UIViewController {
    func onBack() {
        navigationController?.popViewController()
    }

    func onHelp() {
        if let url = URL(string: "tel://\(Defines.hotline)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}

final class AuthHeaderView: UIView {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet private weak var backButton: UIButton!
    
    weak var delegate: AuthHeaderViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    private func initialize() {
        Bundle.main.loadNibNamed("AuthHeaderView", owner: self, options: nil)
        guard let content = containerView else { return }
        content.frame = self.bounds
        content.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(content)
    }

    @IBAction private func onPressBack(_ sender: Any) {
        delegate?.onBack()
    }

    @IBAction private func onPressHelp(_ sender: Any) {
        delegate?.onHelp()
    }

    func hideBackButton() {
        backButton.isHidden = true
    }
}
