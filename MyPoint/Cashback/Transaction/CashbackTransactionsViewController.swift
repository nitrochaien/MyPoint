//
//  CashbackTransactionsViewController.swift
//  MyPoint
//
//  Created by Nam Vu on 7/17/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

class CashbackTransactionsViewController: UIViewController, PagerObserver {

    @IBOutlet private weak var tableView: UITableView!

    private let presenter = CashbackTransactionPresenter()

    override func viewDidLoad() {
        super.viewDidLoad()

        configTableView()

        presenter.delegate = self
    }

    private func configTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()

        tableView.register(UINib(nibName: CashbackTransactionTableViewCell.cellId, bundle: nil),
                           forCellReuseIdentifier: CashbackTransactionTableViewCell.cellId)
        tableView.register(UINib(nibName: CashbackPointTableViewCell.cellId, bundle: nil),
                           forCellReuseIdentifier: CashbackPointTableViewCell.cellId)
        tableView.register(UINib(nibName: "MonthHeaderView", bundle: nil),
                           forHeaderFooterViewReuseIdentifier: "MonthHeaderView")
    }

    func setType(_ type: CashbackTransactionModel.TransactionType) {
        presenter.type = type
    }

    func needsToLoadData(index: Int) {
        presenter.requestData()
    }
}

extension CashbackTransactionsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if presenter.isTypeCancelled {
            return dequeueCashbackTransactionTableViewCell(tableView, cellForRowAt: indexPath)
        }
        if indexPath.section == 0 {
            return dequeueCashbackPointTableViewCell(tableView, cellForRowAt: indexPath)
        }
        return dequeueCashbackTransactionTableViewCell(tableView, cellForRowAt: indexPath)
    }

    private func dequeueCashbackTransactionTableViewCell(_ tableView: UITableView,
                                                         cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = presenter.isTypeCancelled ? indexPath.section : indexPath.section - 1
        if let cell = tableView.dequeueReusableCell(withIdentifier: CashbackTransactionTableViewCell.cellId) as? CashbackTransactionTableViewCell {
            let transaction = presenter.data?.transactionGroup[section].transactions[indexPath.row]
            cell.setData(transaction)
            return cell
        }
        return UITableViewCell()
    }

    private func dequeueCashbackPointTableViewCell(_ tableView: UITableView,
                                                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CashbackPointTableViewCell.cellId) as? CashbackPointTableViewCell {
            cell.setData(presenter.data)
            return cell
        }
        return UITableViewCell()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        let groupCount = presenter.data?.transactionGroup.count ?? 0
        if presenter.isTypeCancelled {
            return groupCount
        }
        return groupCount + 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if presenter.isTypeCancelled {
                let transactions = presenter.data?.transactionGroup[section].transactions ?? []
                return transactions.count
            }
            return 1
        }
        let index = presenter.isTypeCancelled ? section : section - 1
        let transactions = presenter.data?.transactionGroup[index].transactions ?? []
        return transactions.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let index = presenter.isTypeCancelled ? section : section - 1
        if let headerView = tableView
            .dequeueReusableHeaderFooterView(withIdentifier: "MonthHeaderView") as? MonthHeaderView {
            headerView.titleLabel.text = presenter.data?.transactionGroup[index].header
            return headerView
        }
        return nil
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 && !presenter.isTypeCancelled {
            return 0
        }
        return 40
    }
}

extension CashbackTransactionsViewController: BaseProtocols {
    func requestSuccess() {
        tableView.reloadData()
    }
}
