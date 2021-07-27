//
//  UICollectionView.swift
//  MyPoint
//
//  Created by Hieu Nguyen on 1/31/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView {

    func scrollToNextItem() {
        let scrollOffset = CGFloat(floor(self.contentOffset.x + self.bounds.size.width))
        self.scrollToFrame(scrollOffset: scrollOffset)
    }

    func scrollToPreviousItem() {
        let scrollOffset = CGFloat(floor(self.contentOffset.x - self.bounds.size.width))
        self.scrollToFrame(scrollOffset: scrollOffset)
    }

    func scrollToFrame(scrollOffset: CGFloat) {
        guard scrollOffset <= self.contentSize.width - self.bounds.size.width else { return }
        guard scrollOffset >= 0 else { return }
        self.setContentOffset(CGPoint(x: scrollOffset, y: self.contentOffset.y), animated: true)
    }
}
