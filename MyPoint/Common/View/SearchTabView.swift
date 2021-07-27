//
//  SearchTabView.swift
//  MyPoint
//
//  Created by Nam Vu on 3/21/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class SearchTabView: UIView {

    @IBOutlet var containerView: UIView!
    @IBOutlet private weak var allView: UIView!
    @IBOutlet private weak var nearbyView: UIView!
    @IBOutlet private weak var allLabel: UILabel!
    @IBOutlet private weak var allUnderView: UIView!
    @IBOutlet private weak var nearbyLabel: UILabel!
    @IBOutlet private weak var nearbyUnderView: UIView!
    @IBOutlet private weak var contentView: UIView!

    private var currentType = SelectionType.nearby

    var didSelected: ((_ type: SelectionType) -> Void)?

    enum SelectionType {
        case all, nearby
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
        Bundle.main.loadNibNamed("SearchTabView", owner: self, options: nil)
        guard let content = containerView else { return }
        content.frame = self.bounds
        content.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(content)

        initView()
    }

    private func initView() {
        active(type: .all)
        contentView.addShadow(ofColor: .lightGray,
                              radius: 2,
                              offset: .zero,
                              opacity: 0.5)

        allView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapAll)))
        nearbyView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapNearby)))
    }

    @objc private func onTapAll() {
        active(type: .all)
        didSelected?(.all)
    }

    @objc private func onTapNearby() {
        active(type: .nearby)
        didSelected?(.nearby)
    }

    func active(type: SelectionType) {
        if currentType == type { return }
        currentType = type

        let activeTextColor = UIColor(hexString: "#2E51CB")
        let activeBarColor = UIColor(hexString: "#2E51CB")
        let inactiveTextColor = UIColor(hexString: "#727C88")
        let inactiveBarColor = UIColor.white

        if type == .all {
            UIView.animate(withDuration: 0.2) {
                self.allLabel.textColor = activeTextColor
                self.allUnderView.backgroundColor = activeBarColor

                self.nearbyLabel.textColor = inactiveTextColor
                self.nearbyUnderView.backgroundColor = inactiveBarColor
            }
        } else {
            UIView.animate(withDuration: 0.2) {
                self.allLabel.textColor = inactiveTextColor
                self.allUnderView.backgroundColor = inactiveBarColor

                self.nearbyLabel.textColor = activeTextColor
                self.nearbyUnderView.backgroundColor = activeBarColor
            }
        }
    }
}
