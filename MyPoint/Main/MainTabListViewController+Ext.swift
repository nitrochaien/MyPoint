//
//  MainTabListViewController+Ext.swift
//  MyPoint
//
//  Created by Nam Vu on 4/16/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

extension MainTabListViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        print("Offset Y: \(offsetY)")
        statusBarView.isHidden = offsetY < 40

        if offsetY > 100 {
            simpleInfoView.show()
        } else {
            simpleInfoView.hide()
        }
    }

    func reloadData() {
        collectionView.reloadData()
        simpleInfoView.updateInfo()
    }
}

extension UITabBarController {
    open override var childForStatusBarStyle: UIViewController? {
        return selectedViewController?.childForStatusBarStyle ?? selectedViewController
    }
}

extension UINavigationController {
    open override var childForStatusBarStyle: UIViewController? {
        return topViewController?.childForStatusBarStyle ?? topViewController
    }
}
