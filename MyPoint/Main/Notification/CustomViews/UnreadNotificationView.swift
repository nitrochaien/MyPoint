//
//  UnreadNotificationView.swift
//  MyPoint
//
//  Created by Nam Vu on 1/9/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class UnreadNotificationView: UIView {

    @IBOutlet var containerView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    private func initialize() {
        Bundle.main.loadNibNamed("UnreadNotificationView", owner: self, options: nil)
        guard let content = containerView else { return }
        content.frame = self.bounds
        content.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(content)
    }

    func setTitle(_ text: String) {
        titleLabel.text = text
    }
}
