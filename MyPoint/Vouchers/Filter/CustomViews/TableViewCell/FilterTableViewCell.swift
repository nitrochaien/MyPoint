//
//  FilterTableViewCell.swift
//  MyPoint
//
//  Created by Nam Vu on 2/2/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class FilterTableViewCell: UITableViewCell {

    @IBOutlet private weak var collectionView: UICollectionView!

    private let cellId = "FilterItemCollectionViewCell"
    fileprivate var items = [ProvinceSearchPresenter.DisplayItem]() {
        didSet {
            collectionView.reloadData()
            if let first = items.firstIndex(where: { $0.isSelected }) {
                let indexPath = IndexPath(row: first, section: 0)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.collectionView.scrollToItem(at: indexPath,
                                                     at: .centeredHorizontally,
                                                     animated: true)
                }
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

    func setData(_ data: [ProvinceSearchPresenter.DisplayItem]) {
        items = data
    }

    private func configCollectionView() {
        collectionView.register(UINib(nibName: cellId,
                                      bundle: nil),
                                forCellWithReuseIdentifier: cellId)
        collectionView.delegate = self
        collectionView.dataSource = self
        let layout = SortFilterFlowLayout()
        layout.config()
        collectionView.collectionViewLayout = layout
    }
}

extension FilterTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? FilterItemCollectionViewCell {
            cell.setData(items[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        items[indexPath.row].isSelected.toggle()
        collectionView.reloadData()
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}

extension FilterTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = Helper.widthForLabel(text: items[indexPath.row].name, height: 32)
        return .init(width: width, height: 32)
    }
}
