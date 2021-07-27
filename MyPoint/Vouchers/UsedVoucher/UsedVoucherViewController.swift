//
//  UsedVoucherViewController.swift
//  MyPoint
//
//  Created by Nam Vu on 1/16/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class UsedVoucherViewController: UIViewController, PagerObserver {

    @IBOutlet private weak var tableView: UITableView!

    private let presenter = UsedVoucherPresenter()

    override func viewDidLoad() {
        super.viewDidLoad()

        configTableView()

        presenter.delegate = self
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

extension UsedVoucherViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if presenter.vouchers.isEmpty {
            if let cell = tableView
                .dequeueReusableCell(withIdentifier: "NoDataVoucherTableViewCell") as? NoDataVoucherTableViewCell {
                cell.emptyLabel.text = "voucher.used_voucher_empty".localized
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
        if presenter.vouchers.isEmpty { return }
        let item = presenter.vouchers[indexPath.row]
        if item.isMobileCard {
            showCardDetail(with: item.itemId, delegate: self)
        } else {
            showVoucherDetail(with: item.itemId, readyToUse: true, isUsable: false)
        }
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(
            style: .normal,
            title: "voucher.unused".localized) { [weak self] (_, _) in
            guard let self = self else { return }
            self.presenter.markVoucherAsUnused(at: indexPath.row)
        }
        delete.backgroundColor = UIColor(hexString: "#1EB36C")
        return [delete]
    }
}

extension UsedVoucherViewController: CardDetailViewControllerDelegate {
    func cardDetailViewController(_ vc: CardDetailViewController,
                                  onChange useStatus: Bool,
                                  id: ProductId) {
        if !useStatus { // status is changed to used
            if let index = presenter.vouchers.firstIndex(where: { voucher -> Bool in
                return voucher.itemId == id
            }) {
                presenter.markVoucherAsUnused(at: index)
            }
        }
    }
}

extension UsedVoucherViewController: MyVoucherDelegate {
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
