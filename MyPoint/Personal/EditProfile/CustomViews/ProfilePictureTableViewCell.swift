//
//  ProfilePictureTableViewCell.swift
//  MyPoint
//
//  Created by Nam Vu on 1/28/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class ProfilePictureTableViewCell: UITableViewCell {

    @IBOutlet private weak var imagePickerView: UIView!
    @IBOutlet private weak var thumbnailImageView: UIImageView!

    var onTapSelectImage: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onSelectImage))
        imagePickerView.addGestureRecognizer(tapGesture)
    }

    func setImage(byImage image: UIImage?) {
        thumbnailImageView.image = image
    }

    func setImage(byURL url: String) {
        thumbnailImageView.setImage(withURL: url)
    }

    @objc private func onSelectImage() {
        onTapSelectImage?()
    }
}
