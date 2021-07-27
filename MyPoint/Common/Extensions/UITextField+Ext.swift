//
//  UITextField+Ext.swift
//  MyPoint
//
//  Created by Nam Vu on 2/22/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

extension UITextField {
    func addDoneButtonOnKeyboard() {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: nil,
                                            action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                         target: self, action: #selector(resignFirstResponder))
        keyboardToolbar.items = [flexibleSpace, doneButton]
        self.inputAccessoryView = keyboardToolbar
    }
}

extension UITextView {
    func addDoneButtonOnKeyboard() {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: nil,
                                            action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                         target: self, action: #selector(resignFirstResponder))
        keyboardToolbar.items = [flexibleSpace, doneButton]
        self.inputAccessoryView = keyboardToolbar
    }
}
