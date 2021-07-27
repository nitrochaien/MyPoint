//
//  QRCodeContainerViewController.swift
//  MyPoint
//
//  Created by Nam Vu on 1/24/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class QRCodeContainerViewController: UIViewController {

    @IBOutlet private weak var tabContainerView: UIView!
    @IBOutlet private weak var codeButton: UIButton!
    @IBOutlet private weak var cardButton: UIButton!

    var onDismiss: (() -> Void)?

    private var pager: QRCodePagerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        
        addPagerController()

        changeButtonColor(isFirstTabActive: true)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        tabContainerView.roundCorners([.topLeft, .topRight], radius: 12)
    }

    func changeButtonColor(isFirstTabActive: Bool) {
        codeButton.alpha = isFirstTabActive ? 1 : 0.3
        cardButton.alpha = isFirstTabActive ? 0.3 : 1
    }

    @IBAction private func onTapScanner(_ sender: Any) {
        pager.backToScanner()
    }

    @IBAction private func onTapUseCard(_ sender: Any) {
        pager.forwardToUseCard()
    }

    @IBAction func onTapDismissButton(_ sender: Any) {
        onDismiss?()
    }
    
    private func addPagerController() {
        pager = QRCodePagerViewController(transitionStyle: .scroll,
                                              navigationOrientation: .horizontal,
                                              options: nil)
        pager.onChangedTab = { [weak self] page in
            self?.changeButtonColor(isFirstTabActive: page == 0)
        }
        addChild(pager)
        pager.view.frame = view.frame
        view.addSubview(pager.view)
        pager.didMove(toParent: self)
        view.sendSubviewToBack(pager.view)
    }
}
