//
//  HotVoucherCell.swift
//  MyPoint
//
//  Created by Hieu Nguyen on 1/6/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

class HotVoucherCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var hotVoucherCollectionView: UICollectionView!
    @IBOutlet weak var hotVoucherHeaderLabel: UILabel!
    @IBOutlet weak var viewAllButton: UIButton!

    var frameSize: CGSize!
    var listHotVoucher = [HotVoucher]()
    var shouldShowSales: Bool = true
    var category = Category(id: "", subscribed: "", categoryCode: "", categoryName: "", imageUrl: "")

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewAllButton.setTitle("main.view_all".localized, for: .normal)
        viewAllButton.setTitleColor(UIColor(hexString: "#7493DB"), for: .normal)
    }

    func setupHotVoucherCollectionView(frameSize: CGSize) {
        hotVoucherCollectionView.delegate = self
        hotVoucherCollectionView.dataSource = self
        hotVoucherCollectionView.reloadData()
        self.frameSize = frameSize
        self.hotVoucherCollectionView.register(UINib(nibName: "HotVoucherItemCell", bundle: nil), forCellWithReuseIdentifier: "HotVoucherItemCell")
    }

    @IBAction func viewAllButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "ListVoucher", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ListVoucherViewController") as? ListVoucherViewController
        viewController?.category = self.category
        let tabbarViewController = UIApplication.shared.topViewController as? UINavigationController
        tabbarViewController?.pushViewController(viewController!, animated: true)
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listHotVoucher.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = frameSize.width * 0.7
        let height = width * 9 / 16 + 68
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: 0, right: 16)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HotVoucherItemCell", for: indexPath) as? HotVoucherItemCell
        else {
            fatalError("Empty Cell")
        }
        if self.shouldShowSales {
            cell.hotVoucherSaleBackGround.isHidden = false
        } else {
            cell.hotVoucherSaleBackGround.isHidden = true
        }

        let item = listHotVoucher[safe: indexPath.row]
        
        if item?.amount == 0 {
            cell.outOfStockView.isHidden = false
            cell.outOfStockLabel.isHidden = false
        } else {
            cell.outOfStockView.isHidden = true
            cell.outOfStockLabel.isHidden = true
        }
        cell.hotVoucherTitleLabel.text = item?.name ?? ""
        let payPointValue = Double(item?.prices?.first?.payPoint ?? "") ?? 0
        cell.hotVoucherPriceLabel.text = payPointValue.formattedWithSeparator
        //        cell.hotVoucherSaleBackGround.backgroundColor = UIColor(hexString: "#F15757")
        cell.hotVoucherBrandNameLabel.text = item?.brand?.brandName
        cell.hotVoucherImageView.setImage(withURL: item?.images?.first?.imageURL)
        cell.hotVoucherBrandImageView.setImage(withURL: item?.brand?.logo)
        if item?.voucherTypeCode == "D" {
            cell.hotVoucherSaleLabel.text = "\(Int(Float(item?.voucherValue ?? "0") ?? 0))%"
        } else {
            let value = Double(item?.voucherValue ?? "0") ?? 0
            cell.hotVoucherSaleLabel.text = String(format: "voucher.voucher_value".localized, value.formattedWithSeparator)
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "VoucherDetail", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "VoucherDetailViewController") as? VoucherDetailViewController
        viewController?.voucherId = listHotVoucher[safe: indexPath.row]?.voucherID ?? ""
        let tabbarViewController = UIApplication.shared.topViewController as? UINavigationController
        tabbarViewController?.pushViewController(viewController!, animated: true)
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        targetContentOffset.pointee = scrollView.contentOffset
        var indexes = self.hotVoucherCollectionView.indexPathsForVisibleItems
        indexes.sort()
        var index = indexes.first!
        let cell = self.hotVoucherCollectionView.cellForItem(at: index)!
        let position = self.hotVoucherCollectionView.contentOffset.x - cell.frame.origin.x
        if position > cell.frame.size.width/2 {
            index.row += 1
        }
        self.hotVoucherCollectionView.scrollToItem(at: index, at: .left, animated: true )
    }
}
