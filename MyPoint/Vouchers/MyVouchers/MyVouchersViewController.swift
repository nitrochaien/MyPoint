//
//  MyVouchersViewController.swift
//  MyPoint
//
//  Created by Nam Vu on 1/15/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class MyVouchersViewController: UIViewController, PagerObserver {

    @IBOutlet private weak var selectionView: BaseSelectionView!
    @IBOutlet private weak var tableView: UITableView!

    private let presenter = MyVouchersPresenter()

    override func viewDidLoad() {
        super.viewDidLoad()

        selectionView.setTitle(value: "voucher.all_brands".localized)
        selectionView.onTapSelection = { [weak self] in
            self?.showListOfBrands()
        }
        configTableView()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onRefresh),
                                               name: NotificationName.reloadMyVoucher,
                                               object: nil)

        presenter.delegate = self
    }

    deinit {
        print("Deinit MyVouchersViewController")
        NotificationCenter.default.removeObserver(self)
    }

    private func showListOfBrands() {
        let vc = BrandListTableViewController()
        vc.setSelectingBrand(presenter.selectedBrand)
        vc.onDismiss = {
            self.selectionView.resetTransformation()
        }
        vc.onSelectBrand = { [weak self] brand in
            guard let self = self else { return }
            self.presenter.selectedBrand = brand

            self.selectionView.setTitle(value: brand.title)
            self.selectionView.resetTransformation()

            self.presenter.refresh()
        }
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true, completion: nil)
    }

    private func configTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MyVoucherTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "MyVoucherTableViewCell")
        tableView.registerEmptyCell()
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()

        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
        tableView.refreshControl = refresh
    }

    @objc private func onRefresh() {
        presenter.refresh()
    }

    func needsToLoadData(index: Int) {
        presenter.refresh()
    }

    func loadAlways(index: Int) {
        presenter.refresh()
    }
}

extension MyVouchersViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if presenter.vouchers.isEmpty {
            if let cell = tableView
                .dequeueReusableCell(withIdentifier: "NoDataVoucherTableViewCell") as? NoDataVoucherTableViewCell {
                cell.emptyLabel.text = "voucher.my_voucher_empty".localized
                return cell
            }
            return UITableViewCell()
        }

        if let cell = tableView.dequeueReusableCell(withIdentifier: "MyVoucherTableViewCell") as? MyVoucherTableViewCell {
            cell.setData(presenter.vouchers[indexPath.row])

            if indexPath.row == presenter.vouchers.count - 1 {
                presenter.loadMore()
            }

            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return presenter.vouchers.isEmpty ? UIScreen.main.bounds.height / 2 : UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.vouchers.isEmpty ? 1 : presenter.vouchers.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if presenter.vouchers.isEmpty { return }
        let item = presenter.vouchers[indexPath.row]

        if item.isMobileCard {
            showCardDetail(with: item.itemId, delegate: self)
        } else {
            showVoucherDetail(with: item.itemId, readyToUse: true, isUsable: true)
        }
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(
            style: .destructive,
            title: "voucher.used".localized) { [weak self] (_, _) in
            guard let self = self else { return }
            self.presenter.markVoucherAsUsed(at: indexPath.row)
        }
        return [delete]
    }
}

extension MyVouchersViewController: CardDetailViewControllerDelegate {
    func cardDetailViewController(_ vc: CardDetailViewController,
                                  onChange useStatus: Bool,
                                  id: ProductId) {
        if useStatus { // status is changed to used
            if let index = presenter.vouchers.firstIndex(where: { voucher -> Bool in
                return voucher.itemId == id
            }) {
                presenter.markVoucherAsUsed(at: index)
            }
        }
    }
}

extension MyVouchersViewController: MyVoucherDelegate {
    func requestSuccess() {
        tableView.refreshControl?.endRefreshing()
        tableView.reloadData()
    }

    func onRemoveVoucher(at index: Int) {
        if presenter.vouchers.isEmpty {
            tableView.reloadSections([0], with: .automatic)
        } else {
            tableView.deleteRows(at: [.init(row: index, section: 0)],
                                 with: .automatic)
        }
    }
}
