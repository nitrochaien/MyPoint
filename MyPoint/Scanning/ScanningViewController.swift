//
//  ScanningViewController.swift
//  MyPoint
//
//  Created by Nam Vu on 12/28/19.
//  Copyright © 2019 NamDV. All rights reserved.
//

import UIKit

final class ScanningViewController: UIViewController {

    var childVC: QRCodeContainerViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onDismissRating),
                                               name: NotificationName.dismissRating,
                                               object: nil)
    }

    @objc private func onDismissRating() {
        performDismiss()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addContainer()
    }

    private func addContainer() {
        let childVCId = "QRCodeContainerViewController"
        let storyboard = UIStoryboard(name: "Vouchers", bundle: nil)
        childVC = storyboard.instantiateViewController(withIdentifier: childVCId) as? QRCodeContainerViewController
        if let vc = childVC {
            vc.onDismiss = { [weak self] in
                self?.performDismiss()
            }
            addChildViewController(vc, toContainerView: view)
        }
    }

    private func removeContainer() {
        childVC?.willMove(toParent: nil)
        childVC?.view.removeFromSuperview()
        childVC?.removeFromParent()
    }

    private func performDismiss() {
        removeContainer()
        NotificationCenter.default.post(name: NotificationName.dismissScanner, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
