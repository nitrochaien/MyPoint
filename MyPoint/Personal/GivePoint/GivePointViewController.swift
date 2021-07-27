//
//  GivePointViewController.swift
//  MyPoint
//
//  Created by Nam Vu on 2/14/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class GivePointViewController: BaseViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var confirmButton: UIButton!
    @IBOutlet private weak var confirmPINView: GivePointInputPINView!
    @IBOutlet private weak var pinViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var pinCodeContainerView: UIView!
    
    private let presenter = GivePointPresenter()

    private let defaultBottomConstaint: CGFloat = -300
    private var isShowingPinCode = false {
        didSet {
            pinCodeContainerView.isHidden = !isShowingPinCode
        }
    }

    enum SectionType: Int, CaseIterable {
        case info = 0, phone, point, text

        static func headerTitle(of index: Int) -> String {
            switch index {
            case SectionType.info.rawValue:
                return ""
            case SectionType.phone.rawValue:
                return "give_point.receiver".localized
            case SectionType.point.rawValue:
                return "give_point.give_away".localized
            case SectionType.text.rawValue:
                return "give_point.message".localized
            default:
                return ""
            }
        }

        static func getValue(from input: Int) -> SectionType? {
            switch input {
            case SectionType.info.rawValue:
                return .info
            case SectionType.phone.rawValue:
                return .phone
            case SectionType.point.rawValue:
                return .point
            case SectionType.text.rawValue:
                return .text
            default:
                return nil
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "give_point.title".localized

        presenter.delegate = self

        customizeBackButton()
        configTableView()
        registerKeyboard()
        disableButton()
        configPINView()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
        print("Deinit GivePointViewController")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }

    private func configPINView() {
        pinCodeContainerView.isHidden = true
        pinViewBottomConstraint.constant = defaultBottomConstaint
        confirmPINView.onDismiss = { [weak self] in
            guard let self = self else { return }
            self.isShowingPinCode = false
            self.view.endEditing(true)
        }
        confirmPINView.onConfirm = { [weak self] pinCode in
            self?.presenter.checkTransfer(pinCode)
        }
        confirmPINView.onForgotPassword = { [weak self] in
            guard let self = self else { return }
            
            let nav = self.navigationController
            let storyboard = UIStoryboard(name: "Authenciation", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "ReclaimPinCodeViewController")
            nav?.setNavigationBarHidden(true, animated: true)
            nav?.pushViewController(controller)
        }
    }

    func reset() {
        confirmPINView.reset()
    }

    fileprivate func showGivePointSuccessScreen() {
        let vc = GivePointSuccessViewController()
        vc.setData(model: presenter.model)
        vc.transactionId = presenter.transactionId
        navigationController?.pushViewController(vc, animated: true)
    }

    private func configTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none

        tableView.register(UINib(nibName: "GivePointUserInfoTableViewCell",
                                 bundle: nil),
                           forCellReuseIdentifier: "GivePointUserInfoTableViewCell")
        tableView.register(UINib(nibName: "GivePointReceiverTableViewCell",
                                 bundle: nil),
                           forCellReuseIdentifier: "GivePointReceiverTableViewCell")
        tableView.register(UINib(nibName: "RawInputTableViewCell",
                                 bundle: nil),
                           forCellReuseIdentifier: "RawInputTableViewCell")
    }
    
    @IBAction private func onConfirm(_ sender: Any) {
        if presenter.isValidPoint {
            isShowingPinCode = true
            confirmPINView.focus()
        } else {
            showCustomAlert(withTitle: "alert.try_again".localized,
                            andContent: "alert.not_valid_point".localized)
        }
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

    fileprivate func showInputReceiver() {
        let vc = EnterReceiverViewController()
        vc.onSelect = { contact, isNotFound in
            let phone = contact.phones.first?.phone ?? ""
            self.presenter.model.name = contact.name
            self.presenter.model.phone = phone
            self.presenter.model.isNotInContact = isNotFound
            self.enaleButtonIfDataIsValid()
            self.tableView.reloadData()
        }
        navigationController?.pushViewController(vc)
    }

    fileprivate func enaleButtonIfDataIsValid() {
        if self.presenter.isValidInput {
            self.enableButton()
        }
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
        let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        if let keyboardSize = value?.cgRectValue {
            if isShowingPinCode {
                showPinView(padding: keyboardSize.height)
            } else {
                tableView.contentInset = .init(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
            }
        }
    }

    @objc private func onKeyboardWillHide(_ notification: Notification) {
        hidePinView()
        tableView.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        tableView.scrollToTop()
    }

    private func hidePinView() {
        isShowingPinCode = false
        pinViewBottomConstraint.constant = defaultBottomConstaint
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }

    private func showPinView(padding: CGFloat) {
        pinViewBottomConstraint.constant = padding
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
}

extension GivePointViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case SectionType.info.rawValue:
            return infoCell(tableView, indexPath: indexPath)
        case SectionType.phone.rawValue:
            return receiverCell(tableView, indexPath: indexPath)
        default:
            return rawInputCell(tableView, indexPath: indexPath)
        }
    }

    private func infoCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView
            .dequeueReusableCell(withIdentifier: "GivePointUserInfoTableViewCell") as? GivePointUserInfoTableViewCell {
            cell.updateData()
            return cell
        }
        return UITableViewCell()
    }

    private func receiverCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView
            .dequeueReusableCell(withIdentifier: "GivePointReceiverTableViewCell") as? GivePointReceiverTableViewCell {
            cell.model = presenter.model
            cell.onPickReceiver = { _ in
                self.showInputReceiver()
            }
            return cell
        }
        return UITableViewCell()
    }

    private func rawInputCell(_ tableView: UITableView,
                              indexPath: IndexPath) -> UITableViewCell {
        let cellId = "RawInputTableViewCell"
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? RawInputTableViewCell {
            let type = SectionType.getValue(from: indexPath.section)
            cell.didEndEditing = { [weak self] value in
                guard let self = self else { return }
                switch type {
                case .point:
                    self.presenter.model.point = value ?? ""
                    self.enaleButtonIfDataIsValid()
                case .text:
                    self.presenter.model.content = value ?? ""
                    self.enaleButtonIfDataIsValid()
                default:
                    break
                }
            }

            switch type {
            case .point:
                cell.setText(self.presenter.model.point)
                cell.enableBalanceChecking = true
                cell.keyboardType = .numberPad
                cell.enableNumberFormatting = true
            case .text:
                cell.setText(self.presenter.model.content)
                cell.keyboardType = .default
            default:
                break
            }

            return cell
        }

        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return SectionType.allCases.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return SectionType.headerTitle(of: section)
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(500))
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

extension GivePointViewController: BaseProtocols {
    func requestSuccess() {
        showGivePointSuccessScreen()
        confirmPINView.reset()
    }
}
