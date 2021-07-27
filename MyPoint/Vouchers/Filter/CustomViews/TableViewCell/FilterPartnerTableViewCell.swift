//
//  FilterPartnerTableViewCell.swift
//  MyPoint
//
//  Created by Nam Vu on 2/2/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class FilterPartnerTableViewCell: UITableViewCell {

    @IBOutlet private weak var collectionView: UICollectionView!

    private let cellId = "FilterPartnerItemCollectionViewCell"

    private var merchants = [FilterPresenter.Category]() {
        didSet {
            collectionView.reloadData()
            if merchants.first(where: { $0.isSelected }) == nil {
                collectionView.scrollToFrame(scrollOffset: .zero)
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        configCollectionView()
    }

    func setData(_ data: [FilterPresenter.Category]) {
        merchants = data
    }

    private func configCollectionView() {
        let layout = NameFilterFlowLayout()
        layout.config()
        collectionView.collectionViewLayout = layout
        collectionView.register(UINib(nibName: cellId,
                                      bundle: nil),
                                forCellWithReuseIdentifier: cellId)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

extension FilterPartnerTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? FilterPartnerItemCollectionViewCell {
            cell.setData(merchants[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = merchants[indexPath.row]
        merchants.forEach { item in
            item.isSelected = item == selectedItem
        }
        collectionView.reloadData()
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}
