//
//  CounterView.swift
//  MyPoint
//
//  Created by Nam Vu on 2/8/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class CounterView: UIView {

    @IBOutlet var containerView: UIView!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var redeemButton: UIButton!

    var onRedeem: ((_ points: Int) -> Void)?
    var onRemoveAll: (() -> Void)?

    private var counter = 0 {
        didSet {
            newPoints = points * counter
            let format = counter == 0 ? "%01d" : "%02d"
            counterLabel.text = String(format: format, counter)
            let pointDisplay = Double(newPoints).formattedWithSeparator
            redeemButton.setTitle(String(format: "voucher.exchange_with_point".localized, pointDisplay),
                                  for: .normal)
        }
    }
    private var points = 0
    private var newPoints = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    func setPoints(_ value: Int) {
        points = value
        newPoints = value
        counter = 1
    }

    private func initialize() {
        Bundle.main.loadNibNamed("CounterView", owner: self, options: nil)
        guard let content = containerView else { return }
        content.frame = self.bounds
        content.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(content)
    }

    @IBAction private func onDecrease(_ sender: Any) {
        counter = max(0, counter - 1)
        if counter == 0 {
            onRemoveAll?()
        }
    }

    @IBAction private func onIncrease(_ sender: Any) {
        counter += 1
    }

    @IBAction private func onRedeem(_ sender: Any) {
        onRedeem?(newPoints)
    }
}
