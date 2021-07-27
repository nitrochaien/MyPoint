//
//  ScrollableViewController.swift
//  MyPoint
//
//  Created by Nam Vu on 1/2/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

class ScrollableView: UIView {

    @IBOutlet weak var scrollView: UIScrollView!

    var textFields: [UITextField] = []

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func registerForKeyboardNotifications(with textFields: [UITextField]) {
        self.textFields = textFields

//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(onKeyboardAppear),
//                                               name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(onKeyboardDisappear),
//                                               name: UIResponder.keyboardWillHideNotification, object: nil)

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        addGestureRecognizer(tap)
    }

    @objc func onKeyboardAppear(_ notification: NSNotification) {
        let info = notification.userInfo
        guard let rect: CGRect = info?[UIResponder.keyboardFrameBeginUserInfoKey] as? CGRect else { return }
        let kbSize = rect.size

        let insets = UIEdgeInsets(top: 0, left: 0, bottom: kbSize.height, right: 0)
        scrollView.contentInset = insets
        scrollView.scrollIndicatorInsets = insets

        // If active text field is hidden by keyboard, scroll it so it's visible
        // Your application might not need or want this behavior.
        var aRect = frame
        aRect.size.height -= kbSize.height

        let activeField: UITextField? = textFields.first { $0.isFirstResponder }
        if let activeField = activeField {
            if aRect.contains(activeField.frame.origin) {
                let scrollPoint = CGPoint(x: 0, y: 20)
                scrollView.setContentOffset(scrollPoint, animated: true)
            }
        }
    }

    @objc func onKeyboardDisappear(_ notification: NSNotification) {
        scrollView.contentInset = UIEdgeInsets.zero
        scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }

    @objc func dismissKeyboard() {
        endEditing(true)
    }
}
