//
//  PageVoucherTableViewCell.swift
//  MyPoint
//
//  Created by Nam Vu on 2/17/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class PageVoucherTableViewCell: UITableViewCell {

    @IBOutlet private weak var confirmButton: UIButton!

    var openVoucher: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    func setData(_ item: NewsDetailPresenter.GeneralPage) {
        confirmButton.setTitle(item.contentCaption, for: .normal)
    }
  
    func setData(_ item: NewMerchantInfoViewController.GeneralPage) {
        confirmButton.setTitle(item.contentCaption, for: .normal)
    }
    
    @IBAction private func onConfirm(_ sender: Any) {
        openVoucher?()
    }
}
