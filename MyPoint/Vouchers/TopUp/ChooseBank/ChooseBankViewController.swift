//
//  ChooseBankViewController.swift
//  MyPoint
//
//  Created by Nam Vu on 2/8/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class ChooseBankViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!

    private let cell = "ChooseBankTableViewCell"
    private let presenter = ChooseBankPresenter()

    var didSelect: ((_ bank: ChooseBankPresenter.BankModel) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        configTableView()
    }

    deinit {
        print("Deinit ChooseBankViewController")
    }

    func setData(_ banks: [ChooseBankPresenter.BankModel]) {
        presenter.banks = banks
    }

    @IBAction private func onDismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    private func configTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: cell, bundle: nil),
                           forCellReuseIdentifier: cell)
    }
}

extension ChooseBankViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cell) as? ChooseBankTableViewCell {
            cell.setData(presenter.banks[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.banks.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.didSelect?(self.presenter.banks[indexPath.row])
        }
    }
}
