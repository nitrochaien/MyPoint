//
//  OperatorVoucherCell.swift
//  MyPoint
//
//  Created by Hieu Nguyen on 1/16/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit
import Localize

class OperatorVoucherCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var operatorVoucherCollectionView: UICollectionView!
    @IBOutlet weak var operatorVoucherHeaderLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!

    var frameSize: CGSize!
    var isFromHome: Bool = true

//    private let limit = 5
    private let limit = 4
//    private var currentIndex = 0
    private let operatorName: [String] = ["voucher.charge_account".localized,
                                          "voucher.exchange_code".localized,
                                          "voucher.exchange_charges".localized,
                                          "voucher.exchange_charge_sms".localized]
    private let operatorImageString: [String] = ["Group 435", "Group 432", "Group 433", "Group 434"]
  
    private let homeOperatorName: [String] = ["voucher.accumulate_point".localized,
                                              "voucher.return_point".localized,
                                              "voucher.check_in".localized,
                                              "voucher.point_hunt".localized]
    private let homeOperatorImageString: [String] = ["accumulate_point", "return_point", "Group 433", "point_hunt"]

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    func setupOperatorVoucherCollectionView(frameSize: CGSize, isFromHome: Bool) {
        if isFromHome {
          operatorVoucherHeaderLabel.text = ""
        } else {
          operatorVoucherHeaderLabel.text = "voucher.operator_voucher".localized
        }
        self.isFromHome = isFromHome
        operatorVoucherCollectionView.delegate = self
        operatorVoucherCollectionView.dataSource = self
        self.frameSize = frameSize
        self.operatorVoucherCollectionView.register(UINib(nibName: "OperatorVoucherItemCell",
                                                          bundle: nil),
                                                    forCellWithReuseIdentifier: "OperatorVoucherItemCell")
        self.operatorVoucherCollectionView.register(UINib(nibName: "NewBrandItemCell", bundle: nil), forCellWithReuseIdentifier: "NewBrandItemCell")
    }
  
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return limit
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: frameSize.width - 16, height: frameSize.height - 20)
      if isFromHome {
        return CGSize(width: UIScreen.main.bounds.width/4 - 5, height: 100)
      } else {
        return CGSize(width: frameSize.width/4 - 5, height: 100)
      }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OperatorVoucherItemCell",
//                                                            for: indexPath) as? OperatorVoucherItemCell
//            else {
//                fatalError("Empty Cell")
//        }
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewBrandItemCell",
                                                          for: indexPath) as? NewBrandItemCell
          else {
              fatalError("Empty Cell")
      }
      if isFromHome {
        cell.brandNameLabel.text = homeOperatorName[indexPath.row].localized
        cell.brandImageView.image = UIImage(named: homeOperatorImageString[indexPath.row])
          return cell
      } else {
        cell.brandNameLabel.text = operatorName[indexPath.row].localized
        cell.brandImageView.image = UIImage(named: operatorImageString[indexPath.row])
          return cell
      }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: 0, right: 8)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !isFromHome {
            if indexPath.row == 1 {
                showTelcoPromotionScreen(index: indexPath.row)
            } else {
                let tabbarViewController = UIApplication.shared.topViewController as? UINavigationController
                tabbarViewController?.topViewController?.showAlert(title: "Thông báo",
                                                                   message: "Chức năng đang trong quá trình hoàn thiện. Vui lòng thử lại sau.")
            }
        } else {
          showOperatorFromHome(index: indexPath.row)
        }
    }
    
    private func showTelcoPromotionScreen(index: Int) {
        let storyboard = UIStoryboard(name: "Vouchers", bundle: nil)
        let tabList = CategoryTabViewController()
        tabList.title = "voucher.telco_header".localized
        tabList.hidesBottomBarWhenPushed = true
        let categories = [
            CategoryTab(title: "voucher.top_up_header".localized,
                        viewController: storyboard
                            .instantiateViewController(withIdentifier: "TopUpViewController") as! TopUpViewController),
            CategoryTab(title: "voucher.change_code_header".localized,
                        viewController: storyboard
                            .instantiateViewController(withIdentifier: "ChangeCardViewController") as! ChangeCardViewController),
            CategoryTab(title: "voucher.change_package".localized,
                        viewController: storyboard
                            .instantiateViewController(withIdentifier: "ChangePackageViewController") as! ChangePackageViewController),
            CategoryTab(title: "voucher.change_combo".localized,
                        viewController: storyboard
                            .instantiateViewController(withIdentifier: "ChangePackageViewController") as! ChangePackageViewController)
        ]
        tabList.setTitles(categoryTabs: categories,
                          distribution: .normal,
                          swipeToScroll: false)
        tabList.firstSelectedIndex = index
        let tabbarViewController = UIApplication.shared.topViewController as? UINavigationController
        tabbarViewController?.pushViewController(tabList, animated: true)
    }
  
    private func showOperatorFromHome(index: Int) {
      let tabbarViewController = UIApplication.shared.topViewController as? UINavigationController
      switch index {
      case 0:
        let vc = QRCardViewController()
        vc.hidesBottomBarWhenPushed = true
        vc.isShowCancelButton = true
        tabbarViewController?.pushViewController(vc, animated: true)
      case 1:
        tabbarViewController?
            .showAlert(title: "Thông báo", message: "Bạn chờ xíu nha! Sẽ sớm có ưu đãi ngập tràn!")
//        let vc = CashbackMainViewController()
//        vc.hidesBottomBarWhenPushed = true
//        tabbarViewController?.pushViewController(vc, animated: true)
      case 2:
        let storyboard = UIStoryboard(name: "Personal", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CheckInViewController")
        tabbarViewController?.pushViewController(vc, animated: true)
      case 3:
        let vc = PointHuntingViewController()
        vc.hidesBottomBarWhenPushed = true
        tabbarViewController?.pushViewController(vc, animated: true)
      default:
        break
      }
    }
}
