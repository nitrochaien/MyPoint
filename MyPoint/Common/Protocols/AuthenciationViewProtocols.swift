//
//  AuthenciationView.swift
//  MyPoint
//
//  Created by Nam Vu on 1/2/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

/// Only use for input view in Authenciation components
protocol AuthenciationViewProtocols {
    /// Animate present view from the bottom
    func showView(input view: UIView)
    /// Init frame for input view
    func getFrame() -> CGRect
}

extension AuthenciationViewProtocols where Self: UIViewController {
    func showView(input view: UIView) {
        UIView.animate(withDuration: 0.3) {
            view.transform = CGAffineTransform(translationX: 0, y: -view.frame.minY * 4/5)
        }
    }

    func getFrame() -> CGRect {
        let screenBounds = UIScreen.main.bounds
        let x: CGFloat = 0
        let y: CGFloat = screenBounds.height
        let width: CGFloat = screenBounds.width
        let height: CGFloat = screenBounds.height
        return CGRect(x: x, y: y, width: width, height: height)
    }
}
