//
//  LanguageViewController.swift
//  MyPoint
//
//  Created by Nam Vu on 2/16/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class LanguageViewController: BaseTableViewController {

    private let presenter = LanguagePresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "main.language".localized
        customizeBackButton()

        presenter.delegate = self
        presenter.generateData()

        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") {
            cell.setLanguage(presenter.languages[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.languages.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected = presenter.languages[indexPath.row]
        presenter.languages.forEach { lang in
            lang.selected = lang.code == selected.code
        }
        tableView.reloadData()
    }
}

extension LanguageViewController: BaseProtocols {
    func requestSuccess() {
        tableView.reloadData()
    }
}

fileprivate extension UITableViewCell {
    func setLanguage(_ lang: LanguagePresenter.Language) {
        selectionStyle = .none
        textLabel?.text = lang.name
        imageView?.image = UIImage(named: lang.icon)

        if lang.selected {
            accessoryView = UIImageView(image: UIImage(named: "ic_check_green"))
            textLabel?.textColor = UIColor(hexString: "#032041")
        } else {
            accessoryView = UIView()
            textLabel?.textColor = UIColor(hexString: "#727C88")
        }
    }
}
