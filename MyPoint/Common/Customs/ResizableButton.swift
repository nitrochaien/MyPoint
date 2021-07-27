//
//  File.swift
//  MyPoint
//
//  Created by Nam Vu on 11/11/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

class ResizableButton: UIButton {
    override var intrinsicContentSize: CGSize {
        let labelSize = titleLabel?.sizeThatFits(CGSize(width: frame.size.width,
                                                        height: CGFloat.greatestFiniteMagnitude)) ?? .zero
        let desiredButtonSize = CGSize(width: labelSize.width + titleEdgeInsets.left + titleEdgeInsets.right,
                                       height: labelSize.height + titleEdgeInsets.top + titleEdgeInsets.bottom)

        return desiredButtonSize
    }
}
