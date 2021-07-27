//
//  TopUpValueListTableViewCell.swift
//  MyPoint
//
//  Created by Nam Vu on 1/17/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class TopUpValueListTableViewCell: UITableViewCell {

    @IBOutlet private weak var collectionView: UICollectionView!

    private var topUpValues = [TopUpValueModel]() {
        didSet {
            if topUpValues != oldValue {
                DispatchQueue.main.async {
                    self.collectionView.reloadData { [weak self] in
                        let newHeight = self?.collectionView.contentSize.height ?? 0
                        self?.didFinishRefreshing?(newHeight)
                    }
                }
            }
        }
    }

    var didFinishRefreshing: ((_ newHeight: CGFloat) -> Void)?
    var didChangePickOption: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none

        configCollectionView()
    }

    private func configCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "TopUpValueItemCollectionViewCell",
                                      bundle: nil),
                                forCellWithReuseIdentifier: "TopUpValueItemCollectionViewCell")
    }

    func setData(_ data: [TopUpValueModel]) {
        topUpValues = data
    }
}

extension TopUpValueListTableViewCell: UICollectionViewDelegate,
    UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topUpValues.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        return CGSize(width: (screenWidth - 48) / 2, height: 71)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: "TopUpValueItemCollectionViewCell",
                                 for: indexPath) as? TopUpValueItemCollectionViewCell
            else {
                return UICollectionViewCell()
        }

        cell.setData(topUpValues[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 8, left: 16, bottom: 8, right: 16)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = topUpValues[indexPath.row]
        if selectedItem.isSelected {
            selectedItem.isSelected.toggle()
        } else {
            topUpValues.forEach { item in
                item.isSelected = item == selectedItem
            }
        }
        didChangePickOption?()
        collectionView.reloadData()
    }
}
