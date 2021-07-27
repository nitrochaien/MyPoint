//
//  SortFilterFlowLayout.swift
//  MyPoint
//
//  Created by Nam Vu on 2/10/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

class SortFilterFlowLayout: UICollectionViewFlowLayout {
    func config() {
        scrollDirection = .horizontal
        sectionInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        minimumLineSpacing = 16
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
