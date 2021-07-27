//
//  ShareInvitationCodeViewController.swift
//  MyPoint
//
//  Created by Nam Vu on 3/25/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class ShareInvitationCodeViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var confirmButton: UIButton!

    private let presenter = ShareInvitationCodePresenter()

    var didSubmitCode: (() -> Void)?

    enum SectionType: Int, CaseIterable {
        case header = 0, enterCode

        static func headerTitle(of index: Int) -> String {
            switch index {
            case SectionType.header.rawValue:
                return ""
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
        title = "invite.invited_person".localized

        presenter.delegate = self

        configTableView()
        customizeBackButton()
        registerKeyboard()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
        print("Deinit ShareInvitationCodeViewController")
    }

    @IBAction private func onConfirm(_ sender: Any) {
        if presenter.isValidCode {
            presenter.submitReferenceCode()
        }
    }

    private func configTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none

        tableView.register(UINib(nibName: "InviteHeaderTableViewCell",
                                 bundle: nil),
                           forCellReuseIdentifier: "InviteHeaderTableViewCell")
        tableView.register(UINib(nibName: "RawInputTableViewCell",
                                 bundle: nil),
                           forCellReuseIdentifier: "RawInputTableViewCell")
    }

    private func disableButton() {
        confirmButton.setBackgroundImage(nil, for: .normal)
        confirmButton.backgroundColor = UIColor(hexString: "#98A1AF", transparency: 0.5)
        confirmButton.isUserInteractionEnabled = false
    }

    private func enableButton() {
        confirmButton.setBackgroundImage(UIImage(named: "btn_continue_background"), for: .normal)
        confirmButton.backgroundColor = .white
        confirmButton.isUserInteractionEnabled = true
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
}

extension ShareInvitationCodeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case SectionType.header.rawValue:
            return inviteHeaderCell(tableView, indexPath: indexPath)
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

    private func enterCodeCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView
            .dequeueReusableCell(withIdentifier: "RawInputTableViewCell") as? RawInputTableViewCell {
            cell.setPlaceholder("invite.invited_person".localized)
            cell.enablePhoneChecking = true
            cell.keyboardType = .numberPad
            cell.phoneDidChange = { text, valid in
                if valid {
                    self.enableButton()
                } else {
                    self.disableButton()
                }
                self.presenter.phoneNumber = text
            }
            return cell
        }
        return UITableViewCell()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return SectionType.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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

extension ShareInvitationCodeViewController: InviteFriendPresenterDelegate {
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
            self.didSubmitCode?()
            self.navigationController?.popViewController(animated: true)
        }
        alertController.setValue(contentViewController, forKey: "contentViewController")
        present(alertController, animated: true, completion: nil)
    }
}
