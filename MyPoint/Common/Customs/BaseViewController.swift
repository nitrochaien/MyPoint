//
//  BaseViewController.swift
//  MyPoint
//
//  Created by Nam Vu on 2/2/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    private var shadowImageView: UIImageView?

    var showFirstTime = true

    override func viewDidLoad() {
        super.viewDidLoad()

        customizeNavigationBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 13.0, *) { return }
        guard let navigationBar = navigationController?.navigationBar else { return }

        if shadowImageView == nil {
            shadowImageView = findShadowImage(under: navigationBar)
        }
        shadowImageView?.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showFirstTime = false
        
        if #available(iOS 13.0, *) { return }

//        shadowImageView?.isHidden = false
    }

    private func customizeNavigationBar() {
        let navigationBar = navigationController?.navigationBar
        if #available(iOS 13.0, *) {
            let navigationBarAppearence = UINavigationBarAppearance()
            navigationBarAppearence.shadowColor = .clear
            navigationBarAppearence.backgroundColor = .white
            navigationBar?.standardAppearance = navigationBarAppearence
            navigationBar?.scrollEdgeAppearance = navigationBarAppearence
        } else {
            navigationBar?.tintColor = .white
            navigationBar?.isTranslucent = false
        }
    }

    private func findShadowImage(under view: UIView) -> UIImageView? {
        if view is UIImageView && view.bounds.size.height <= 1 {
            return (view as! UIImageView)
        }

        for subview in view.subviews {
            if let imageView = findShadowImage(under: subview) {
                return imageView
            }
        }
        return nil
    }
}
