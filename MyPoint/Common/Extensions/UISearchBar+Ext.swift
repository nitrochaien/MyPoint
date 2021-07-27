//
//  UISearchBar+Ext.swift
//  MyPoint
//
//  Created by Nam Vu on 2/14/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

extension UISearchBar {
    func customized() {
        for view in subviews.last!.subviews {
            if type(of: view) == NSClassFromString("UISearchBarBackground") {
                view.alpha = 0.0
            }
        }
        if let textfield = value(forKey: "searchField") as? UITextField {
            textfield.textColor = UIColor(hexString: "#032041")
            textfield.backgroundColor = .white
            let placeholderAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor(hexString: "#F1F3F4")!,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium)
            ]
            textfield.attributedPlaceholder = .init(string: textfield.placeholder ?? "",
                                                    attributes: placeholderAttributes)
            textfield.leftViewMode = .never
        }
    }
}
