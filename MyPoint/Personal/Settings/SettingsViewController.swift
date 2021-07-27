//
//  SettingsViewController.swift
//  MyPoint
//
//  Created by Nam Vu on 1/22/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class SettingsViewController: BaseViewController {

    @IBOutlet private weak var tableView: UITableView!
    private let cellIdentifier = "cell"
    private let presenter = SettingsPresenter()

    override func viewDidLoad() {
        super.viewDidLoad()
        configNavigationBar()
        configTableView()

        presenter.delegate = self
        presenter.generateData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    private func configNavigationBar() {
        title = "personal.settings".localized
        customizeBackButton()
    }

    private func configTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }

    @objc private func onSwitchChanged(_ switcher: UISwitch) {
        print("Changed switch \(switcher.tag) to value: \(switcher.isOn)")
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            cell.selectionStyle = .none

            let item = presenter.items[indexPath.row]
            cell.imageView?.image = UIImage(named: item.icon)
            cell.textLabel?.text = String(format: "%@.%@", "personal", item.title).localized
            cell.textLabel?.textColor = UIColor(hexString: item.titleColor)

            var accessoryView: UIView
            if item.toggle {
                let switcher = UISwitch()
                switcher.tag = indexPath.row
                switcher.addTarget(self, action: #selector(onSwitchChanged), for: .valueChanged)
                accessoryView = switcher
            } else {
                accessoryView = UIImageView(image: UIImage(named: "ic_arrow_black"))
            }
            cell.accessoryView = accessoryView

            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.items.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = presenter.items[indexPath.row].id

        switch id {

        case SettingMenu.interestedCategories.rawValue:
            showCategories()
        case SettingMenu.changePin.rawValue:
            showChangePinScreen()
//        case SettingMenu.language.rawValue:
//            showLanguageScreen()
        case SettingMenu.notificationSettings.rawValue:
            showCustomNotificationScreen()
        default:
            showCustomAlert(withTitle: "Hế lô Tester",
                            andContent: "Chức năng này tạm thời chưa có nha ^^. Chúc 1 ngày tốt lành, mãi yêu <3")
        }
    }

    private func showCategories() {
        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "InterestedCategoriesViewController")
        present(vc, animated: true, completion: nil)
    }

    private func showChangePinScreen() {
        let storyboard = UIStoryboard(name: "Personal", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ChangePINViewController")
        navigationController?.pushViewController(vc, animated: true)
    }

    private func showLanguageScreen() {
        let vc = LanguageViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    private func showCustomNotificationScreen() {
        let vc = CustomNotificationViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension SettingsViewController: BaseProtocols {
    func requestSuccess() {
        tableView.reloadData()
    }
}
