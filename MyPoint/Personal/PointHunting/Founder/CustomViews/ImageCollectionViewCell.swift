//
//  ImageCollectionViewCell.swift
//  MyPoint
//
//  Created by Nam Vu on 2/15/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class ImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var placeholderImage: UIImageView!
    @IBOutlet private weak var imageContainerView: UIView!
    @IBOutlet private weak var uploadImageView: UIImageView!
    @IBOutlet private weak var closeImageView: UIImageView!

    enum CellType {
        case loaded, empty, placeholder
    }

    var type = CellType.empty {
        didSet {
            placeholderImage.isHidden = true
            imageContainerView.isHidden = true
            closeImageView.isHidden = true
            switch type {
            case .loaded:
                imageContainerView.isHidden = false
                closeImageView.isHidden = false
            case .placeholder:
                placeholderImage.isHidden = false
            case .empty:
                imageContainerView.isHidden = false
            }
        }
    }

    var selectedImage: UIImage? = nil {
        didSet {
            uploadImageView.image = selectedImage
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
