//
//  CustomNotificationViewController.swift
//  MyPoint
//
//  Created by Nam Vu on 2/16/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class CustomNotificationViewController: BaseTableViewController {

    private let presenter = CustomNotificationPresenter()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "main.custom_noti".localized
        customizeBackButton()

        presenter.delegate = self
        presenter.generateData()

        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    @objc private func onSwitchChanged(_ switcher: UISwitch) {
        let item = presenter.items[switcher.tag]
        if item.id == 0 {
            item.selected.toggle()
            for i in presenter.items {
                i.selected = item.selected
            }
        } else {
            item.selected.toggle()
        }
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") {
            let item = presenter.items[indexPath.row]

            cell.textLabel?.text = item.name
            let switcher = UISwitch()
            switcher.isOn = item.selected
            switcher.tag = indexPath.row
            switcher.addTarget(self, action: #selector(onSwitchChanged), for: .valueChanged)
            cell.accessoryView = switcher

            return cell
        }
        return UITableViewCell()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.items.count
    }
}

extension CustomNotificationViewController: BaseProtocols {
    func requestSuccess() {
        tableView.reloadData()
    }
}
