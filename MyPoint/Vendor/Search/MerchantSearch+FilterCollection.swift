//
//  MerchantSearch+FilterCollection.swift
//  MyPoint
//
//  Created by Nam Vu on 3/23/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

extension MerchantSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func configCollectionView() {
        collectionView.isHidden = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "FilterCategoryCollectionViewCell",
                                      bundle: nil),
                                forCellWithReuseIdentifier: "FilterCategoryCollectionViewCell")
        let layout = SortFilterFlowLayout()
        layout.config()
        collectionView.collectionViewLayout = layout
    }

    func reloadCollectionView() {
        collectionView.reloadData { [weak self] in
            guard let self = self else { return }
            
            if let firstIndex = self.presenter.searchParams.categories
                .firstIndex(where: { category -> Bool in
                    return category.isFiltering
                }) {
                let indexPath = IndexPath(row: firstIndex, section: 0)
                self.collectionView.scrollToItem(at: indexPath,
                                                 at: .centeredHorizontally,
                                                 animated: true)
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: "FilterCategoryCollectionViewCell",
                                 for: indexPath) as? FilterCategoryCollectionViewCell {
            cell.setData(presenter.searchParams.categories[indexPath.row])
            cell.onRemove = { [weak self] in
                guard let self = self else { return }
                let removeItem = self.presenter.searchParams.categories.remove(at: indexPath.row)
                if removeItem.isFiltering {
                    self.presenter.searchParams.categories.first?.isFiltering = true
                    self.presenter.refresh()
                }
                self.collectionView.reloadData()
            }
            return cell
        }
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.searchParams.categories.count
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.searchParams.categories[indexPath.row].isFiltering.toggle()
        presenter.refresh()
    }
}

extension MerchantSearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = widthForLabel(text: presenter.searchParams.categories[indexPath.row].title,
                                  height: 32)

        return .init(width: width + 20, height: 32)
    }

    func widthForLabel(text: String, height: CGFloat) -> CGFloat {
        let label: UILabel = UILabel(frame: .init(x: 0,
                                                   y: 0,
                                                   width: CGFloat.greatestFiniteMagnitude,
                                                   height: height))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.text = text
        label.sizeToFit()

        return label.frame.width + 20
    }
}
