//
//  ViewController.swift
//  MyPoint
//
//  Created by Nam Vu on 12/28/19.
//  Copyright © 2019 NamDV. All rights reserved.
//

import UIKit

final class TabbarViewController: UITabBarController, UITabBarControllerDelegate {

    /// Index of tab before user tap Scanner
    /// Purpose: To change back to that tab when user dismiss Scanner
    private var indexBeforeScanner = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.unselectedItemTintColor = UIColor(hexString: "#032041", transparency: 0.5)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(navigateToPreviousTab),
                                               name: NotificationName.dismissScanner,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(navigateToMerchantProfile),
                                               name: NotificationName.goToMerchantProfile,
                                               object: nil)

        delegate = self
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func navigateToPreviousTab() {
        selectedIndex = indexBeforeScanner
    }
  
    @objc private func navigateToMerchantProfile() {
        selectedIndex = 3
        NotificationCenter.default.post(name: NotificationName.goToMerchantProfileFromStore, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if tabBarController.selectedIndex != 2 {
            // If not Scanner
            indexBeforeScanner = tabBarController.selectedIndex
        }
        
        switch tabBarController.selectedIndex {
        case 1:
            // Tap voucher
            NotificationCenter.default.post(name: NotificationName.didTapVoucher, object: nil)
        default:
            break
        }
    }
}
