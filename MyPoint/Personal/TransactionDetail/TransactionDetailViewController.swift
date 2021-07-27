//
//  TransactionDetailViewController.swift
//  MyPoint
//
//  Created by Nam Vu on 2/23/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class TransactionDetailViewController: BaseViewController {

    @IBOutlet private weak var tableView: UITableView!

    private let presenter = TransactionDetailPresenter()

    enum SectionType: Int, CaseIterable {
        case rating, change, info1, info2
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "transaction_detail.header".localized
        navigationController?.setNavigationBarHidden(false, animated: true)
        customizeBackButton()

        configTableView()

        presenter.delegate = self
    }

    func setId(_ id: String) {
        presenter.id = id
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if showFirstTime {
            presenter.requestData()
        }
    }

    private func configTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.contentInset = .init(top: -24, left: 0, bottom: 0, right: 0)
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.tableHeaderView = UIView(frame: .zero)
        tableView.sectionFooterHeight = 6
        tableView.sectionHeaderHeight = 6

        tableView.register(UINib(nibName: "TransactionRatingTableViewCell",
                                 bundle: nil),
                           forCellReuseIdentifier: "TransactionRatingTableViewCell")
        tableView.register(UINib(nibName: "TransactionChangeTableViewCell",
                                 bundle: nil),
                           forCellReuseIdentifier: "TransactionChangeTableViewCell")
        tableView.register(UINib(nibName: "TransactionInfoTableViewCell",
                                 bundle: nil),
                           forCellReuseIdentifier: "TransactionInfoTableViewCell")
    }
}

extension TransactionDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case SectionType.rating.rawValue:
            if let cell = tableView
                .dequeueReusableCell(withIdentifier: "TransactionRatingTableViewCell") as? TransactionRatingTableViewCell {
                return cell
            }
        case SectionType.change.rawValue:
            if let cell = tableView
                .dequeueReusableCell(withIdentifier: "TransactionChangeTableViewCell") as? TransactionChangeTableViewCell {
                cell.pointLabel.text = presenter.pointChange
                return cell
            }
        case SectionType.info1.rawValue:
            if let cell = tableView
                .dequeueReusableCell(withIdentifier: "TransactionInfoTableViewCell") as? TransactionInfoTableViewCell {
                cell.setData(presenter.info1[indexPath.row])
                return cell
            }
        case SectionType.info2.rawValue:
            if let cell = tableView
                .dequeueReusableCell(withIdentifier: "TransactionInfoTableViewCell") as? TransactionInfoTableViewCell {
                cell.setData(presenter.info2[indexPath.row])
                return cell
            }
        default:
            break
        }
        return UITableViewCell()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return SectionType.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case SectionType.rating.rawValue:
            return 0
        case SectionType.change.rawValue:
            return 1
        case SectionType.info1.rawValue:
            return presenter.info1.count
        case SectionType.info2.rawValue:
            return presenter.info2.count
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case SectionType.rating.rawValue:
            return 132
        case SectionType.change.rawValue:
            return 75
        default:
            return UITableView.automaticDimension
        }
    }
}

extension TransactionDetailViewController: BaseProtocols {
    func requestSuccess() {
        tableView.reloadData()
    }
}
