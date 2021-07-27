//
//  OnboardingFlowLayout.swift
//  MyPoint
//
//  Created by Nam Vu on 4/12/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

class OnboardingFlowLayout: UICollectionViewFlowLayout {
    func config() {
        let screenBounds = UIScreen.main.bounds
        let width = screenBounds.width
        let height = collectionView?.bounds.height ?? 0
        itemSize = .init(width: width, height: height)
        scrollDirection = .horizontal

        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        sectionInset = .zero
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
