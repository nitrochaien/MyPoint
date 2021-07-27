//
//  UIView+Ext.swift
//  MyPoint
//
//  Created by Nam Vu on 1/5/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

extension UIView {
    class var identifier: String {
        return String(describing: self)
    }

    class var nibName: String {
        return String(describing: self)
    }

    // shadow anh corner view
    func shadowView(color: UIColor,
                    cornerRadius: CGFloat,
                    size: CGSize,
                    shadowRadius: CGFloat,
                    cornerRadiusShadow: CGFloat,
                    clipToBounds: Bool = false) {
        self.cornerRadius = cornerRadius
        self.clipsToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = size
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: cornerRadiusShadow).cgPath
    }
  
    func makeConstraintToFullWithParentView() {
      guard let parentView = self.superview else {
        return
      }
      let dict = ["view": self]
      self.translatesAutoresizingMaskIntoConstraints = false
      parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|",
                                                               options: NSLayoutConstraint.FormatOptions(rawValue: 0),
                                                               metrics: nil,
                                                               views: dict))
      parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|",
                                                               options: NSLayoutConstraint.FormatOptions(rawValue: 0),
                                                               metrics: nil,
                                                               views: dict))
    }
  
    func fixInView(_ container: UIView) {
          self.translatesAutoresizingMaskIntoConstraints = false
          self.frame = container.frame
          container.addSubview(self)
          NSLayoutConstraint(item: self,
                             attribute: .leading,
                             relatedBy: .equal,
                             toItem: container,
                             attribute: .leading,
                             multiplier: 1.0,
                             constant: 0).isActive = true
          NSLayoutConstraint(item: self,
                             attribute: .trailing,
                             relatedBy: .equal,
                             toItem: container,
                             attribute: .trailing,
                             multiplier: 1.0,
                             constant: 0).isActive = true
          NSLayoutConstraint(item: self,
                             attribute: .top,
                             relatedBy: .equal,
                             toItem: container,
                             attribute: .top,
                             multiplier: 1.0,
                             constant: 0).isActive = true
          NSLayoutConstraint(item: self,
                             attribute: .bottom,
                             relatedBy: .equal,
                             toItem: container,
                             attribute: .bottom,
                             multiplier: 1.0,
                             constant: 0).isActive = true
      }
  
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        if #available(iOS 11, *) {
            var cornerMask = CACornerMask()
            if corners.contains(.topLeft) {
                cornerMask.insert(.layerMinXMinYCorner)
            }
            if corners.contains(.topRight) {
                cornerMask.insert(.layerMaxXMinYCorner)
            }
            if corners.contains(.bottomLeft) {
                cornerMask.insert(.layerMinXMaxYCorner)
            }
            if corners.contains(.bottomRight) {
                cornerMask.insert(.layerMaxXMaxYCorner)
            }
            self.layer.cornerRadius = radius
            self.layer.maskedCorners = cornerMask

        } else {
            let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            self.layer.mask = mask
        }
    }
}

extension UIViewController {
    class var identifier: String {
        return String(describing: self)
    }
}
