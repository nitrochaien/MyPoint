//
//  UIImage.swift
//  MyPoint
//
//  Created by Hieu on 2/3/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func makeRoundedImage() {
//        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}
