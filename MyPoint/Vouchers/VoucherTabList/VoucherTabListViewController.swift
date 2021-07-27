//
//  VoucherTabListViewController.swift
//  MyPoint
//
//  Created by Nam Vu on 12/28/19.
//  Copyright © 2019 NamDV. All rights reserved.
//

import UIKit

final class VoucherTabListViewController: CategoryTabViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let storyboard = UIStoryboard(name: "Vouchers", bundle: nil)
        let categories = [
            CategoryTab(title: "voucher.available".localized,
                        viewController: storyboard
                            .instantiateViewController(withIdentifier: "MyVouchersViewController") as! MyVouchersViewController),
            CategoryTab(title: "voucher.used".localized,
            viewController: storyboard
                .instantiateViewController(withIdentifier: "UsedVoucherViewController") as! UsedVoucherViewController),
            CategoryTab(title: "voucher.outdated".localized,
            viewController: storyboard
                .instantiateViewController(withIdentifier: "ExpiredVoucherViewController") as! ExpiredVoucherViewController)
        ]

        setTitles(categoryTabs: categories, distribution: .segmented)
        initViewPager()
    }
}
