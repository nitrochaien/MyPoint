//
//  CashbackMainViewController.swift
//  MyPoint
//
//  Created by Nam Vu on 7/20/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class CashbackMainViewController: BaseViewController {

    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var collectionView: UICollectionView!

    private let presenter = CashbackMainPresenter()

    private enum Section: Int, CaseIterable {
        case header = 0, items
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configCollectionView()
        presenter.delegate = self

        backButton.backgroundColor = .clear
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if showFirstTime {
            presenter.refreshData()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    private func configCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = .init(top: -44, left: 0, bottom: 0, right: 0)

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        refreshControl.backgroundColor = UIColor(hexString: "#FF6262")
        collectionView.refreshControl = refreshControl

        collectionView.bounces = false

        collectionView.register(UINib(nibName: CashbackMainItemCollectionViewCell.cellId,
                                      bundle: nil),
                                forCellWithReuseIdentifier: CashbackMainItemCollectionViewCell.cellId)
        collectionView.register(UINib(nibName: CashbackMainHeaderCollectionViewCell.cellId,
                                      bundle: nil),
                                forCellWithReuseIdentifier: CashbackMainHeaderCollectionViewCell.cellId)
    }

    @objc private func refreshData() {
        presenter.refreshData()
    }

    @IBAction func onBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let maxY: CGFloat = 60
        if offsetY > maxY {
            backButton.backgroundColor = .lightGray
        } else {
            backButton.backgroundColor = .clear
        }
    }

    fileprivate func showCashbackDetail(with id: String?) {
        let vc = CashbackDetailViewController()
        vc.hidesBottomBarWhenPushed = true
        vc.setId(id)
        navigationController?.pushViewController(vc, animated: true)
    }

    fileprivate func showCashbackTransaction() {
        let tab = CategoryTabViewController()
        tab.title = "Giao dịch hoàn điểm"

        let pendingVC = CashbackTransactionsViewController()
        pendingVC.setType(.pending)
        let approvedVC = CashbackTransactionsViewController()
        approvedVC.setType(.approved)
        let voidedVC = CashbackTransactionsViewController()
        voidedVC.setType(.voided)
        let cancelledVC = CashbackTransactionsViewController()
        cancelledVC.setType(.cancelled)

        let tabs = [
            CategoryTab(title: "Chờ duyệt",
                        viewController: pendingVC),
            CategoryTab(title: "Đã duyệt",
                        viewController: approvedVC),
            CategoryTab(title: "Đã hoàn",
                        viewController: voidedVC),
            CategoryTab(title: "Đã huỷ",
                        viewController: cancelledVC)
        ]
        tab.setTitles(categoryTabs: tabs, distribution: .segmented, swipeToScroll: true)
        tab.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(tab, animated: true)
    }
}

extension CashbackMainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case Section.header.rawValue:
            return dequeueCashbackMainHeaderCollectionViewCell(collectionView, cellForItemAt: indexPath)
        default:
            return dequeueCashbackMainItemCollectionViewCell(collectionView, cellForItemAt: indexPath)
        }
    }

    private func dequeueCashbackMainItemCollectionViewCell(
        _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CashbackMainItemCollectionViewCell.cellId, for: indexPath) as? CashbackMainItemCollectionViewCell {
            let items = presenter.model?.items ?? []
            cell.setData(items[indexPath.row])

            if indexPath.row == items.count - 1 {
                presenter.loadMore()
            }

            return cell
        }
        return UICollectionViewCell()
    }

    private func dequeueCashbackMainHeaderCollectionViewCell(
        _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CashbackMainHeaderCollectionViewCell.cellId, for: indexPath) as? CashbackMainHeaderCollectionViewCell {
            cell.setData(presenter.model?.header)
            cell.showTutorial = {
                self.showCashbackTutorial()
            }
            cell.showTransaction = {
                self.showCashbackTransaction()
            }
            return cell
        }
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case Section.header.rawValue:
            return 1
        default:
            let items = presenter.model?.items ?? []
            return items.count
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Section.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let id = presenter.model?.items[indexPath.row].id
        showCashbackDetail(with: id)
    }
}

extension CashbackMainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width

        switch indexPath.section {
        case Section.header.rawValue:
            return .init(width: screenWidth, height: 300)
        default:
            let width = screenWidth / 2 - 16
            let height = screenWidth / 2
            return .init(width: width, height: height)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch section {
        case Section.header.rawValue:
            return .zero
        default:
            return .init(top: 0, left: 8, bottom: 0, right: 8)
        }
    }
}

extension CashbackMainViewController: BaseProtocols {
    func requestSuccess() {
        collectionView.refreshControl?.endRefreshing()
        collectionView.reloadData()
    }
}
