//
//  VoucherCell.swift
//  MyPoint
//
//  Created by Hieu Nguyen on 1/6/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

class VoucherCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

  @IBOutlet weak var voucherCollectionView: UICollectionView!
  @IBOutlet weak var headerVoucherLabel: UILabel!
  @IBOutlet weak var viewAllButton: UIButton!
  
  var frameSize: CGSize!
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//      brandHeaderLabel.text = "main.brand".localized
      viewAllButton.setTitle("common.continue".localized, for: .normal)
    }
  
  func setupVoucherCollectionView(frameSize: CGSize) {
    voucherCollectionView.delegate = self
    voucherCollectionView.dataSource = self
    self.frameSize = frameSize
    self.voucherCollectionView.register(UINib(nibName: "VoucherItemCell", bundle: nil), forCellWithReuseIdentifier: "VoucherItemCell")
  }
    
  func numberOfSections(in collectionView: UICollectionView) -> Int {
      return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return 6
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      return CGSize(width: frameSize.width - 80, height: (frameSize.width - 80)*0.6)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VoucherItemCell", for: indexPath) as? VoucherItemCell
        else {
        fatalError("Empty Cell")
      }
      return cell
    }
}
