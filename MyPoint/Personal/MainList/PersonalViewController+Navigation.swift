//
//  PersonalViewController+Navigation.swift
//  MyPoint
//
//  Created by Nam Vu on 12/29/19.
//  Copyright © 2019 NamDV. All rights reserved.
//

import UIKit

extension PersonalViewController {
    func navigateToPointHunting() {
        let controller = PersonalPointHuntingViewController()
        navigationController?.pushViewController(controller, animated: true)
    }

    func showMyVoucher() {
        let storyboard = UIStoryboard(name: "Vouchers", bundle: nil)
        let tabList = CategoryTabViewController()
        tabList.title = "voucher.header".localized
        tabList.hidesBottomBarWhenPushed = true
        let categories = [
            CategoryTab(title: "voucher.available".localized,
                        viewController: storyboard
                            .instantiateViewController(withIdentifier: "MyVouchersViewController") as! MyVouchersViewController),
            CategoryTab(title: "voucher.used".localized,
                        viewController: storyboard
                            .instantiateViewController(withIdentifier: "UsedVoucherViewController") as! UsedVoucherViewController),
            CategoryTab(title: "voucher.outdated".localized,
                        viewController: storyboard
                            .instantiateViewController(withIdentifier: "ExpiredVoucherViewController") as! ExpiredVoucherViewController)
        ]
        tabList.setTitles(categoryTabs: categories,
                          distribution: .segmented,
                          swipeToScroll: false)
        navigationController?.pushViewController(tabList, animated: true)
    }

    func showHistoryCard() {
        let storyboard = UIStoryboard(name: "Vouchers", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CardHistoryViewController")
        navigationController?.pushViewController(vc, animated: true)
    }

    func showSettings() {
        let storyboard = UIStoryboard(name: "Personal", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SettingsViewController")
        navigationController?.pushViewController(vc, animated: true)
    }

    func showSupport() {
        let storyboard = UIStoryboard(name: "Personal", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SupportViewController")
        navigationController?.pushViewController(vc, animated: true)
    }

    func showCheckIn() {
        let storyboard = UIStoryboard(name: "Personal", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CheckInViewController")
        navigationController?.pushViewController(vc, animated: true)
    }

    func showGivePoint() {
        let storyboard = UIStoryboard(name: "Personal", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "GivePointViewController")
        navigationController?.pushViewController(vc, animated: true)
    }

    func showInviteFriend() {
        let storyboard = UIStoryboard(name: "Personal", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "InviteFriendViewController")
        navigationController?.pushViewController(vc, animated: true)
    }

    func showChangePoint() {
        let vc = ChangePointViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }

    func showPointHunting() {
        let vc = PointHuntingViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }

    func showInfo() {
        let vc = IntroductionViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }

    func showAppStore() {
        let sharedApp = UIApplication.shared
        guard let url = URL(string: Defines.appURL) else {
            print("Cannot create URL")
            return
        }
        if sharedApp.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                sharedApp.open(url, options: [:], completionHandler: nil)
            } else {
                sharedApp.open(url)
            }
        }
    }

    func showEnterInvitationCode() {
        let vc = ShareInvitationCodeViewController()
        vc.hidesBottomBarWhenPushed = true
        vc.didSubmitCode = {
            self.presenter.didEnterInvitationCode = true
            self.tableView.reloadData()
        }
        navigationController?.pushViewController(vc, animated: true)
    }

    func showRanking() {
        let storyboard = UIStoryboard(name: "Ranking", bundle: nil)
        let viewController =
            storyboard.instantiateViewController(withIdentifier: "RankingViewController") as! RankingViewController
        //        let tab = CategoryTabViewController()
        //        tab.navigationController?.navigationBar.isHidden = true
        //        tab.title = "personal.ranking".localized
        //        tab.setTitles(categoryTabs: [
        //            CategoryTab(title: "personal.all".localized, viewController: viewController),
        //            CategoryTab(title: "personal.week".localized, viewController: viewController),
        //            CategoryTab(title: "personal.month".localized, viewController: viewController)
        //        ], distribution: .segmented, swipeToScroll: false)
        //        tab.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
        //        viewController.hidesBottomBarWhenPushed = true
        //        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func showFavorite() {
        let tab = CategoryTabViewController()
        tab.navigationController?.navigationBar.isHidden = true
        tab.title = "personal.favourite".localized
        tab.setTitles(categoryTabs: [
            CategoryTab(title: "personal.voucher".localized, viewController: FavoriteVoucherViewController()),
            CategoryTab(title: "personal.brand".localized, viewController: FavoriteVoucherViewController())
        ], distribution: .segmented, swipeToScroll: false)
        tab.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(tab, animated: true)
    }

    func showHistory() {
        let storyboard = UIStoryboard(name: "MonthHistory", bundle: nil)
        let tab = CategoryTabViewController()
        tab.title = "personal.history".localized

        let redeemVC = storyboard.instantiateViewController(withIdentifier: "MonthHistoryViewController") as! MonthHistoryViewController
        redeemVC.setType(type: .redeem)

        let rewardVC = storyboard.instantiateViewController(withIdentifier: "MonthHistoryViewController") as! MonthHistoryViewController
        rewardVC.setType(type: .reward)

        let tabs = [
            CategoryTab(title: "personal.all_point".localized,
                        viewController: AllHistoryViewController()),
            CategoryTab(title: "personal.gather_point".localized,
                        viewController: rewardVC),
            CategoryTab(title: "personal.spending_point".localized,
                        viewController: redeemVC)
        ]
        tab.setTitles(categoryTabs: tabs, distribution: .segmented, swipeToScroll: false)
        tab.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(tab, animated: true)
    }
}
