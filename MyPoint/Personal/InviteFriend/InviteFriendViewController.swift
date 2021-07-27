//
//  InviteFriendViewController.swift
//  MyPoint
//
//  Created by Nam Vu on 2/15/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class InviteFriendViewController: BaseViewController {

    @IBOutlet private weak var tableView: UITableView!

    private let presenter = InviteFriendPresenter()

    enum SectionType: Int, CaseIterable {
        case header = 0, myCode, enterCode

        static func headerTitle(of index: Int) -> String {
            switch index {
            case SectionType.header.rawValue:
                return ""
            case SectionType.myCode.rawValue:
                return "invite.your_code".localized
            case SectionType.enterCode.rawValue:
                return "invite.enter_code".localized
            default:
                return ""
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: true)
        title = "invite.title".localized

        presenter.delegate = self

        configTableView()
        customizeBackButton()
        registerKeyboard()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        if showFirstTime {
//            presenter.checkSubmitReferenceCode()
//        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
        print("Deinit InviteFriendViewController")
    }

    private func configTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none

        tableView.register(UINib(nibName: "InviteHeaderTableViewCell",
                                 bundle: nil),
                           forCellReuseIdentifier: "InviteHeaderTableViewCell")
        tableView.register(UINib(nibName: "CopyableTableViewCell",
                                 bundle: nil),
                           forCellReuseIdentifier: "CopyableTableViewCell")
        tableView.register(UINib(nibName: "InputInviteCodeTableViewCell",
                                 bundle: nil),
                           forCellReuseIdentifier: "InputInviteCodeTableViewCell")
    }

    private func registerKeyboard() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onKeyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onKeyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }

    @objc private func onKeyboardWillShow(_ notification: Notification) {
        let value = notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue
        if let keyboardSize = value?.cgRectValue {
            tableView.contentInset = .init(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }

    @objc private func onKeyboardWillHide(_ notification: Notification) {
        tableView.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
    }

    @IBAction func onShare(_ sender: Any) {
        guard let phone = Storage.shared.registeredPhoneNumber else { return }

        let shareContent = String(format: "personal.share_content".localized, phone)
        let activityViewController = UIActivityViewController(activityItems: [shareContent], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        present(activityViewController, animated: true, completion: nil)
    }
}

extension InviteFriendViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case SectionType.header.rawValue:
            return inviteHeaderCell(tableView, indexPath: indexPath)
        case SectionType.myCode.rawValue:
            return copyableCell(tableView, indexPath: indexPath)
        case SectionType.enterCode.rawValue:
            return enterCodeCell(tableView, indexPath: indexPath)
        default:
            return UITableViewCell()
        }
    }

    private func inviteHeaderCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView
            .dequeueReusableCell(withIdentifier: "InviteHeaderTableViewCell") as? InviteHeaderTableViewCell {
            cell.update()
            return cell
        }
        return UITableViewCell()
    }

    private func copyableCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView
            .dequeueReusableCell(withIdentifier: "CopyableTableViewCell") as? CopyableTableViewCell {
            cell.setText(Storage.shared.registeredPhoneNumber)
            return cell
        }
        return UITableViewCell()
    }

    private func enterCodeCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView
            .dequeueReusableCell(withIdentifier: "InputInviteCodeTableViewCell") as? InputInviteCodeTableViewCell {
            cell.didConfirm = { [weak self] text in
                self?.presenter.submitReferenceCode(text)
            }
            return cell
        }
        return UITableViewCell()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        let allSectionCount = SectionType.allCases.count
        return presenter.didReference ? allSectionCount - 1 : allSectionCount
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == SectionType.enterCode.rawValue {
            return presenter.didReference ? 0 : 1
        }
        return 1
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return SectionType.headerTitle(of: section)
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight(500))
            header.textLabel?.textColor = UIColor(hexString: "#032041")
            header.contentView.backgroundColor = .white
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 40
    }
}

extension InviteFriendViewController: InviteFriendPresenterDelegate {
    func requestSuccess() {
        tableView.reloadData()
    }

    func didConfirm() {
        showSubmitInviteCodeSuccess()
    }

    func handleSameUserPhone() {
        showCustomAlert(withTitle: "give_point.duplicated".localized,
                        andContent: "give_point.duplicated_phone".localized)
    }

    private func showSubmitInviteCodeSuccess() {
        self.view.endEditing(true)
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let contentViewController = CheckinSuccessViewController()
        contentViewController.points = presenter.points
        contentViewController.screenType = .invite
        contentViewController.didConfirm = {
            self.presenter.didReference = true
            self.tableView.deleteSections([SectionType.enterCode.rawValue], with: .automatic)
        }
        alertController.setValue(contentViewController, forKey: "contentViewController")
        present(alertController, animated: true, completion: nil)
    }
}
