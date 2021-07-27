//
//  NameFilterFlowLayout.swift
//  MyPoint
//
//  Created by Nam Vu on 2/2/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class NameFilterFlowLayout: UICollectionViewFlowLayout {
    func config() {
        itemSize = .init(width: 56, height: 100)
//        minimumInteritemSpacing = 40
        minimumLineSpacing = 40
        sectionInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        scrollDirection = .horizontal
    }
}
