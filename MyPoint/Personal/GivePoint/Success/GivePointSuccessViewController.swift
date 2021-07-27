//
//  GivePointSuccessViewController.swift
//  MyPoint
//
//  Created by Nam Vu on 2/15/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class GivePointSuccessViewController: UIViewController {

    @IBOutlet private weak var contentLabel: UILabel!

    var transactionId = ""
    var model: GivePointModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)

        let name = model.isNotInContact ? model.phone : model.name

        let descriptionText = String(format: "give_point.success_format".localized, model.point, name)
        let attribute = contentLabel.getAttributeSpacing(inputText: descriptionText, lineSpacing: 8.0)
        let maxRange = NSRange(location: 0, length: descriptionText.count)
        attribute?.addAttributes([.font: UIFont(name: AppFontName.regular, size: 14.0)!,
                                  .foregroundColor: UIColor(hexString: "2E5ECB")!],
                                 range: maxRange)

        let hightlightedRange1 = (descriptionText as NSString).range(of: model.point)
        attribute?.addAttributes([.font: UIFont(name: AppFontName.medium, size: 14.0)!,
                                  .foregroundColor: UIColor(hexString: "36399C")!],
                                 range: hightlightedRange1)

        let hightlightedRange2 = (descriptionText as NSString).range(of: name)
        attribute?.addAttributes([.font: UIFont(name: AppFontName.medium, size: 14.0)!,
                                  .foregroundColor: UIColor(hexString: "36399C")!],
                                 range: hightlightedRange2)

        contentLabel.attributedText = attribute
    }

    func setData(model: GivePointModel) {
        self.model = model
    }

    @IBAction private func onConfirm(_ sender: Any) {
        model.reset()
        popToViewController(type: GivePointViewController.self)
    }

    @IBAction private func goToDetail(_ sender: Any) {
        model.reset()
        let vc = TransactionDetailViewController()
        vc.setId(transactionId)
        navigationController?.pushViewController(vc, animated: true)
    }
}
