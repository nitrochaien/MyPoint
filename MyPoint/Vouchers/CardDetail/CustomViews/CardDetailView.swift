//
//  CardDetailView.swift
//  MyPoint
//
//  Created by Nam Vu on 11/11/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class CardDetailView: UIView {

    @IBOutlet var containerView: UIView!
    @IBOutlet private weak var thumbnail: UIImageView!
    @IBOutlet private weak var valueLabel: UILabel!
    @IBOutlet private weak var brandNameLabel: UILabel!
    @IBOutlet private weak var statusButton: ResizableButton!
    @IBOutlet private weak var phoneLabel: UILabel!
    @IBOutlet private weak var seriesLabel: UILabel!

    var onChangeCardStatus: ((_ used: Bool) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    private func initialize() {
        Bundle.main.loadNibNamed("CardDetailView", owner: self, options: nil)
        guard let content = containerView else { return }
        content.frame = self.bounds
        content.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(content)
    }

    @IBAction private func onTapCopy(_ sender: Any) {
        UIPasteboard.general.string = valueLabel.text
    }

    @IBAction private func onTapUse(_ sender: Any) {
        var isUsed: Bool
        if statusButton.tag == 1 { // used
            // change to unuse
            isUsed = false
        } else {
            isUsed = true
        }
        setStatus(used: isUsed)
        onChangeCardStatus?(isUsed)
    }
    
    func setData(_ card: CardDetailPresenter.Card) {
        thumbnail.setImage(withURL: card.thumbnail)
        valueLabel.text = card.value
        brandNameLabel.text = card.brandName
        phoneLabel.text = card.code
        seriesLabel.text = card.series

        setStatus(used: card.used)
    }

    private func setStatus(used: Bool) {
        if used {
            statusButton.tag = 1
            statusButton.setImage(UIImage(named: "ic_card_used"), for: .normal)
        } else {
            statusButton.tag = 2
            statusButton.setImage(UIImage(named: "ic_card_unused"), for: .normal)
        }
    }
}
