//
//  CardHistoryViewController.swift
//  MyPoint
//
//  Created by Nam Vu on 1/20/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class CardHistoryViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!

    private let presenter = CardHistoryPresenter()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "voucher.bought_card".localized

        customizeBackButton()

        configTableView()
    }

    private func configTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CardHistoryTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "CardHistoryTableViewCell")
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
    }
}

extension CardHistoryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView
            .dequeueReusableCell(withIdentifier: "CardHistoryTableViewCell") as? CardHistoryTableViewCell {
            cell.setData(presenter.cards[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.cards.count
    }
}
