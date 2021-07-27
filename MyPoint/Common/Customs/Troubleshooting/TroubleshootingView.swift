//
//  TroubleshootingView.swift
//  MyPoint
//
//  Created by Nam Vu on 8/12/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class TroubleshootingView: UIView {

    @IBOutlet private var containerView: UIView!
    @IBOutlet private weak var switcher: UISwitch!
    
    var didChangeSwitch: ((_ isOn: Bool) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    private func initialize() {
        Bundle.main.loadNibNamed("TroubleshootingView", owner: self, options: nil)
        guard let content = containerView else { return }
        content.frame = self.bounds
        content.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(content)
    }

    func show() {
        UIView.animate(withDuration: 0.2) {
            self.transform = .identity
        }
    }

    func hide() {
        transform = .init(translationX: 0, y: 100)
    }

    func updateSwitch(_ isOn: Bool) {
        switcher.isOn = isOn
    }

    @IBAction func onChangeSwitch(_ sender: UISwitch) {
        didChangeSwitch?(sender.isOn)
    }
    
}
