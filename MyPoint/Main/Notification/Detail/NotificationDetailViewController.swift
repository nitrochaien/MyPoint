//
//  NotificationDetailViewController.swift
//  MyPoint
//
//  Created by Nam Vu on 2/3/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class NotificationDetailViewController: BaseViewController {
    
    @IBOutlet private weak var tableView: UITableView!

    private let presenter = NotificationDetailPresenter()

    override func viewDidLoad() {
        super.viewDidLoad()
        customizeBackButton()
        title = "notification.view_controller_header".localized

        configTableView()

        presenter.delegate = self

        if !presenter.id.isEmpty {
            presenter.getDetail()
        } else {
            tableView.reloadData()
        }
    }

    private func configTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "NotificationDetailTableViewCell",
                                 bundle: nil),
                           forCellReuseIdentifier: "NotificationDetailTableViewCell")
    }

    func setId(_ id: String) {
        presenter.id = id
    }

    func setData(_ title: String, _ body: String) {
        presenter.title = title
        presenter.content = body
    }
}

extension NotificationDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView
            .dequeueReusableCell(withIdentifier: "NotificationDetailTableViewCell") as? NotificationDetailTableViewCell {
            cell.setData(presenter.title, content: presenter.content)
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
}

extension NotificationDetailViewController: BaseProtocols {
    func requestSuccess() {
        tableView.reloadData()
    }
}
