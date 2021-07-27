//
//  BrandCell.swift
//  MyPoint
//
//  Created by Hieu Nguyen on 1/6/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

class BrandCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var brandCollectionView: UICollectionView!
    @IBOutlet weak var brandHeaderLabel: UILabel!
    @IBOutlet weak var viewAllButton: UIButton!
    var frameSize: CGSize!
    var listBrand = [Brand]()
    var listCampain = [Campaign]()

    private let numberOfItemsOnScreen: CGFloat = 4
    private let maxItem = 10

    var onSelected: ((_ id: String) -> Void)?
    var onShowAllCampaign: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //        brandHeaderLabel.text = "main.brand".localized
        viewAllButton.setTitle("main.view_all".localized, for: .normal)
        viewAllButton.setTitleColor(UIColor(hexString: "#7493DB"), for: .normal)
    }

    func setupBrandCollectionView(frameSize: CGSize, brandHeaderText: String) {
        brandCollectionView.delegate = self
        brandCollectionView.dataSource = self
        brandCollectionView.reloadData()
        brandHeaderLabel.text = brandHeaderText
        self.frameSize = frameSize
        self.brandCollectionView.register(UINib(nibName: "BrandItemCell", bundle: nil), forCellWithReuseIdentifier: "BrandItemCell")
        self.brandCollectionView.register(UINib(nibName: "NewBrandItemCell", bundle: nil), forCellWithReuseIdentifier: "NewBrandItemCell")
    }

    @IBAction func viewAllButtonTapped(_ sender: Any) {
        if listCampain.isEmpty {
            NotificationCenter.default.post(name: NotificationName.goToMerchantProfile, object: nil)
        } else {
            onShowAllCampaign?()
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if listBrand.isEmpty {
            return min(listCampain.count, maxItem)
        }
        return min(listBrand.count, maxItem)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (frameSize.width - 20) / numberOfItemsOnScreen
        return .init(width: width, height: 100)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewBrandItemCell", for: indexPath) as? NewBrandItemCell
        else {
            fatalError("Empty Cell")
        }
        cell.layer.masksToBounds = false
        if !listBrand.isEmpty {
            if let url = URL(string: listBrand[safe: indexPath.row]?.logo ?? "") {
                cell.brandImageView.kf.setImage(with: url, placeholder: UIImage(named: "alter"))
            } else {
                cell.brandImageView.image = UIImage(named: "alter")
            }
            cell.brandNameLabel.text = listBrand[safe: indexPath.row]?.brandName ?? ""
        } else {
            if let url = URL(string: listCampain[safe: indexPath.row]?.brand?.logo ?? "") {
                cell.brandImageView.kf.setImage(with: url, placeholder: UIImage(named: "alter"))
            } else {
                cell.brandImageView.image = UIImage(named: "alter")
            }
            cell.brandNameLabel.text = listCampain[safe: indexPath.row]?.brand?.brandName ?? ""
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
//        let numberOfItems: CGFloat = CGFloat(collectionView.numberOfItems(inSection: 0))
//        if numberOfItems >= numberOfItemsOnScreen { return .zero }
//
//        let itemWidth = (frameSize.width - 20) / numberOfItemsOnScreen
//        let totalCellWidth = itemWidth * numberOfItems
//        let totalSpacingWidth: CGFloat = 4 * (numberOfItemsOnScreen + 1)
//
//        let leftInset = (collectionView.layer.frame.size.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
//        let rightInset = leftInset
//
//        return .init(top: 0, left: leftInset, bottom: 0, right: rightInset)

        return .init(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !listBrand.isEmpty {
            onSelected?(listBrand[indexPath.row].brandID ?? "")
        } else {
            onSelected?(listCampain[indexPath.row].id ?? "")
        }
    }

}
