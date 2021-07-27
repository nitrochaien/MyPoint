//
//  QuickBuyTableViewCell.swift
//  MyPoint
//
//  Created by Nam Vu on 1/19/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class QuickBuyTableViewCell: UITableViewCell {

    @IBOutlet private weak var collectionView: UICollectionView!

    private var quickBuyValues = [QuickBuyModel]()

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none

        configCollectionView()
    }

    private func configCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "QuickBuyItemCollectionViewCell",
                                      bundle: nil),
                                forCellWithReuseIdentifier: "QuickBuyItemCollectionViewCell")
    }

    func setData(_ data: [QuickBuyModel]) {
        quickBuyValues = data
    }
}

extension QuickBuyTableViewCell: UICollectionViewDelegate,
UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return quickBuyValues.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        return CGSize(width: screenWidth / 2, height: 80)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: "QuickBuyItemCollectionViewCell",
                                 for: indexPath) as? QuickBuyItemCollectionViewCell
            else {
                return UICollectionViewCell()
        }

        cell.setData(quickBuyValues[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 8, left: 20, bottom: 8, right: 8)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Show quick buy
    }
}
