//
//  FilterCategoryTableViewCell.swift
//  MyPoint
//
//  Created by Nam Vu on 2/2/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

class FilterCategoryTableViewCell: UITableViewCell {

    @IBOutlet private weak var collectionView: UICollectionView!

    private let cellId = "FilterCategoryItemCollectionViewCell"
    private var categories = [FilterPresenter.Category]() {
        didSet {
            collectionView.reloadData()
            if let first = categories.firstIndex(where: { $0.isSelected }) {
                let indexPath = IndexPath(row: first, section: 0)
                collectionView.scrollToItem(at: indexPath,
                                            at: .centeredHorizontally,
                                            animated: true)
            } else {
                collectionView.scrollToFrame(scrollOffset: .zero)
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        configCollectionView()
    }

    func setData(_ data: [FilterPresenter.Category]) {
        categories = data
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

extension FilterCategoryTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? FilterCategoryItemCollectionViewCell {
            cell.setData(categories[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        categories[indexPath.row].isSelected.toggle()
        collectionView.reloadData()
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}
