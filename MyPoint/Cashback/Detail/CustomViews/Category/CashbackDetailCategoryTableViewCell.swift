//
//  CashbackDetailCategoryTableViewCell.swift
//  MyPoint
//
//  Created by Nam Vu on 7/20/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class CashbackDetailCategoryTableViewCell: UITableViewCell {

    @IBOutlet private weak var collectionView: UICollectionView!

    private let spacing: CGFloat = 8

    static let cellId = "CashbackDetailCategoryTableViewCell"

    var categories = [CashbackDetailModel.Category]()

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        configCollectionView()
    }

    func setData(_ data: [CashbackDetailModel.Category]?) {
        categories = data ?? []
        collectionView.reloadData()
    }

    private func configCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.register(UINib(nibName: CashbackDetailCategoryItemCollectionViewCell.cellId,
                                      bundle: nil),
                                forCellWithReuseIdentifier: CashbackDetailCategoryItemCollectionViewCell.cellId)
    }
}

extension CashbackDetailCategoryTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CashbackDetailCategoryItemCollectionViewCell.cellId,
            for: indexPath) as? CashbackDetailCategoryItemCollectionViewCell {
            cell.setData(categories[safe: indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
}

extension CashbackDetailCategoryTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = Helper.widthForLabel(text: categories[indexPath.row].title, height: 32) + 60
        let minWidth: CGFloat = 160
        let validatedWidth = max(minWidth, width)
        return .init(width: validatedWidth, height: 80)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 8, bottom: 0, right: 8)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
