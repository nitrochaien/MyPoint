//
//  TelcoSelectionTableViewCell.swift
//  MyPoint
//
//  Created by Nam Vu on 1/19/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class TelcoSelectionTableViewCell: UITableViewCell {

    @IBOutlet private weak var collectionView: UICollectionView!

    private var telcoValues = [TelcoSelectionModel]()

    var didSelectTelco: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none

        configCollectionView()
    }

    private func configCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "TelcoSelectionItemCollectionViewCell",
                                      bundle: nil),
                                forCellWithReuseIdentifier: "TelcoSelectionItemCollectionViewCell")
    }

    func setData(_ data: [TelcoSelectionModel]) {
        telcoValues = data
        collectionView.reloadData()
    }
}

extension TelcoSelectionTableViewCell: UICollectionViewDelegate,
UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return telcoValues.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        return CGSize(width: screenWidth / 2, height: 80)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: "TelcoSelectionItemCollectionViewCell",
                                 for: indexPath) as? TelcoSelectionItemCollectionViewCell
            else {
                return UICollectionViewCell()
        }

        cell.setData(telcoValues[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 8, left: 20, bottom: 8, right: 8)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = telcoValues[indexPath.row]
        guard selectedItem.isEnable else { return }
        guard !selectedItem.isSelected else { return }

        telcoValues.forEach { item in
            item.isSelected = item == selectedItem
        }
        collectionView.reloadData {
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            self.didSelectTelco?()
        }
    }
}
