//
//  EnterReceiverViewController.swift
//  MyPoint
//
//  Created by Nam Vu on 2/14/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class EnterReceiverViewController: BaseViewController {

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!

    private let presenter = EnterReceiverPresenter()

    var onSelect: ((_ contact: ContactManager.ContactsModel, _ isNotFound: Bool) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)

        searchBar.customized()
        searchBar.delegate = self
        configTableView()

        presenter.delegate = self
    }

    deinit {
        print("Deinit EnterReceiverViewController")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if showFirstTime {
            presenter.getContacts()
        }
    }

    private func configTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()

        let control = UIRefreshControl()
        control.add(for: .valueChanged) {
            self.presenter.getContacts()
        }
        tableView.refreshControl = control
    }

    @IBAction private func onBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension EnterReceiverViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")

        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
            cell?.selectionStyle = .none
        }

        guard let contact = presenter.contacts[safe: indexPath.row] else {
            return UITableViewCell()
        }

        cell?.textLabel?.text = contact.name
        cell?.textLabel?.textColor = UIColor(hexString: "#032041")
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)

        cell?.detailTextLabel?.text = contact.phones.first?.phone
        cell?.detailTextLabel?.textColor = UIColor(hexString: "#727C88", transparency: 0.8)
        cell?.detailTextLabel?.font = UIFont.systemFont(ofSize: 12, weight: .regular)

        cell?.accessoryView = UIImageView(image: UIImage(named: "ic_arrow_black"))

        return cell!
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.contacts.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.selectedContact = presenter.contacts[indexPath.row]
        presenter.checkExistedPhone()
    }
}

extension EnterReceiverViewController: EnterReceiverPresenterDelegate {
    func requestSuccess() {
        tableView.refreshControl?.endRefreshing()
        tableView.reloadData()
    }

    func didCheckPhoneNumber(_ phone: String, _ isActive: Bool) {
        if isActive {
            onSelect?(presenter.selectedContact, presenter.noContactsFound)
            navigationController?.popViewController(animated: true)
        } else {
            showCustomAlert(withTitle: "give_point.non_existed".localized,
                            andContent: "give_point.non_member".localized)
        }
    }

    func handleNonExisted() {
        showCustomAlert(withTitle: "give_point.non_existed".localized,
                        andContent: "give_point.non_existed_phone".localized)
    }

    func handleSameUserPhone() {
        showCustomAlert(withTitle: "give_point.duplicated".localized,
                        andContent: "give_point.duplicated_phone".localized)
    }
}

extension EnterReceiverViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            presenter.reset()
        } else {
            presenter.filter(by: searchText)
        }
        tableView.reloadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
