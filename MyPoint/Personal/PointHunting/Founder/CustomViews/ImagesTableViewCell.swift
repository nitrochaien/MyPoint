//
//  ImagesTableViewCell.swift
//  MyPoint
//
//  Created by Nam Vu on 2/15/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class ImagesTableViewCell: UITableViewCell {

    @IBOutlet private weak var collectionView: UICollectionView!

    private let cellId = "ImageCollectionViewCell"

    var onUploadImage: ((_ index: Int) -> Void)?
    var onDeleteImage: ((_ index: Int) -> Void)?

    private var images = [UploadImage]()

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none

        configCollectionView()
    }

    func setData(_ images: [UploadImage]) {
        self.images = images
        collectionView.reloadData()
    }

    private func configCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: cellId,
                                      bundle: nil),
                                forCellWithReuseIdentifier: cellId)
    }
}

extension ImagesTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? ImageCollectionViewCell {
            if let item = images[safe: indexPath.row] {
                cell.selectedImage = item.image
                cell.type = item.type
            }

            return cell
        }
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = images[indexPath.row]

        switch item.type {
        case .placeholder:
            onUploadImage?(indexPath.row)
        case .loaded:
            onDeleteImage?(indexPath.row)
        default:
            break
        }
    }
}

extension ImagesTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 64, height: 64)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 16, bottom: 0, right: 16)
    }
}
