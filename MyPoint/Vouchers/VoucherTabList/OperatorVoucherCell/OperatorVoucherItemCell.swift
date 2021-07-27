//
//  OperatorVoucherItemCell.swift
//  MyPoint
//
//  Created by Hieu Nguyen on 1/16/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

class OperatorVoucherItemCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var operatorVoucherImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.addShadow(ofColor: .lightGray,
                                radius: 8,
                                offset: .zero,
                                opacity: 0.5)
    }
    
}
