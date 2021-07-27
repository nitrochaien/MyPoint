//
//  SimpleUserInfoView.swift
//  MyPoint
//
//  Created by Nam Vu on 4/16/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class SimpleUserInfoView: UIView {

    @IBOutlet private var containerView: UIView!
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var pointLabel: UILabel!
    @IBOutlet private weak var infoView: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    private func initialize() {
        Bundle.main.loadNibNamed("SimpleUserInfoView", owner: self, options: nil)
        guard let content = containerView else { return }
        content.frame = self.bounds
        content.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(content)

        containerView.addShadow(ofColor: .lightGray,
                                radius: 8,
                                offset: .zero,
                                opacity: 0.5)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showMembership))
        infoView.addGestureRecognizer(tapGesture)
    }

    @objc private func showMembership() {
        let storyboard = UIStoryboard(name: "MemberShipLevel", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "MemberShipLevelViewController") as! MemberShipLevelViewController
        let tabbarViewController = UIApplication.shared.topViewController as? UINavigationController
        tabbarViewController?.navigationBar.isHidden = false
        tabbarViewController?.pushViewController(viewController, animated: true)
    }

    func updateInfo() {
        let userData = Storage.shared.loginData
        usernameLabel.text = userData?.workerSite?.usernameDisplay
        pointLabel.text = userData?.workingSite?.customerBalance?.simpleAmountDisplay
    }

    func show() {
        UIView.animate(withDuration: 0.4) {
            self.transform = .identity
            self.alpha = 1
        }
    }

    func hide() {
        UIView.animate(withDuration: 0.4) {
            self.transform = .init(translationX: 0, y: -120)
            self.alpha = 0
        }
    }
}
