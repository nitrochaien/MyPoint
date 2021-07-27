//
//  CheckinSuccessViewController.swift
//  MyPoint
//
//  Created by Nam Vu on 2/13/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class CheckinSuccessViewController: UIViewController {

    @IBOutlet private weak var headerLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!
    
    var didConfirm: (() -> Void)?

    enum ScreenType {
        case checkin, invite
    }

    var screenType = ScreenType.checkin
    var points = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        if screenType == .checkin {
            showHeaderCheckin()
        } else {
            showHeaderInvite()
        }
    }

    private func showHeaderInvite() {
        let contentText = "invite.success".localized
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8.0
        paragraphStyle.alignment = .center
        contentLabel.attributedText = NSMutableAttributedString(string: contentText)

        let descriptionText = String(format: "check-in.add_point".localized, points)
        let attribute = headerLabel.getAttributeSpacing(inputText: descriptionText, lineSpacing: 8.0)
        let maxRange = NSRange(location: 0, length: descriptionText.count)
        attribute?.addAttributes([.font: UIFont.systemFont(ofSize: 16, weight: .medium),
                                  .foregroundColor: UIColor(hexString: "#032041")!],
                                 range: maxRange)

        let hightlightedRange = (descriptionText as NSString).range(of: "+\(points)")
        attribute?.addAttributes([.font: UIFont.systemFont(ofSize: 24, weight: .medium),
                                  .foregroundColor: UIColor(hexString: "#2E51CB")!],
                                 range: hightlightedRange)

        headerLabel.attributedText = attribute
    }

    private func showHeaderCheckin() {
        let contentText = "check-in.success".localized
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8
        paragraphStyle.alignment = .center
        contentLabel.attributedText = NSMutableAttributedString(string: contentText)

        let descriptionText = String(format: "check-in.add_point".localized, points)
        let attribute = headerLabel.getAttributeSpacing(inputText: descriptionText, lineSpacing: 8.0)
        let maxRange = NSRange(location: 0, length: descriptionText.count)
        attribute?.addAttributes([.font: UIFont.systemFont(ofSize: 16, weight: .medium),
                                  .foregroundColor: UIColor(hexString: "#032041")!],
                                 range: maxRange)

        let hightlightedRange = (descriptionText as NSString).range(of: "+\(points)")
        attribute?.addAttributes([.font: UIFont.systemFont(ofSize: 24, weight: .medium),
                                  .foregroundColor: UIColor(hexString: "#E71D28")!],
                                 range: hightlightedRange)

        headerLabel.attributedText = attribute
    }

    @IBAction private func onConfirm(_ sender: Any) {
        dismiss(animated: true) { [weak self] in
            self?.didConfirm?()
        }
    }
}
