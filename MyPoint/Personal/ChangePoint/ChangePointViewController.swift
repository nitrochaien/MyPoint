//
//  ChangePointViewController.swift
//  MyPoint
//
//  Created by Nam Vu on 2/16/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class ChangePointViewController: BaseViewController {

    @IBOutlet fileprivate weak var tableView: UITableView!

    private let presenter = ChangePointPresenter()

    private var cellHeights = [IndexPath: CGFloat]()

    enum SectionType: Int, CaseIterable {
        case card = 0, description, option
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "main.change_point".localized
        customizeBackButton()
        navigationController?.setNavigationBarHidden(false, animated: true)

        presenter.delegate = self

        configTableView()
        registerKeyboard()
    }

    deinit {
        print("Deinit ChangePointViewController")
    }

    @IBAction private func toggleAutoPoint(_ sender: UIButton) {
        presenter.selectedMonthly.toggle()
        if presenter.selectedMonthly {
            sender.setImage(UIImage(named: "ic_tick_green"), for: .normal)
        } else {
            sender.setImage(UIImage(named: "ic_tick_none"), for: .normal)
        }
    }

    @IBAction func onConfirm(_ sender: Any) {
        if !presenter.selectingChangeAll {
            if !presenter.value.isEmpty {
                showTwoButtonsAlert(with: .createChangePointAlert(withPoint: Int(presenter.value) ?? 0)) { [weak self] in
                    self?.navigationController?.popViewController(animated: true)
                }
            } else {
                showAlert(title: "Chưa nhập số điểm", message: "Hãy nhập số điểm bạn muốn đổi")
            }
        } else {
            navigationController?.popViewController(animated: true)
        }
    }

    private func registerKeyboard() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onKeyboardDidShow),
                                               name: UIResponder.keyboardDidShowNotification,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onKeyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }

    @objc private func onKeyboardDidShow(_ notification: Notification) {
        let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        if let keyboardSize = value?.cgRectValue {
            tableView.contentInset = .init(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }

    @objc private func onKeyboardWillHide(_ notification: Notification) {
        tableView.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
    }

    private func configTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none

        tableView.register(UINib(nibName: "ChangePointHeaderTableViewCell",
                                 bundle: nil),
                           forCellReuseIdentifier: "ChangePointHeaderTableViewCell")
        tableView.register(UINib(nibName: "ChangePointDescTableViewCell",
                                 bundle: nil),
                           forCellReuseIdentifier: "ChangePointDescTableViewCell")
        tableView.register(UINib(nibName: "ChagePointAllTableViewCell",
                                 bundle: nil),
                           forCellReuseIdentifier: "ChagePointAllTableViewCell")
        tableView.register(UINib(nibName: "ChangePointCustomTableViewCell",
                                 bundle: nil),
                           forCellReuseIdentifier: "ChangePointCustomTableViewCell")
    }
}

extension ChangePointViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case SectionType.card.rawValue:
            return cardCell(tableView, indexPath: indexPath)
        case SectionType.description.rawValue:
            return descCell(tableView, indexPath: indexPath)
        case SectionType.option.rawValue:
            if indexPath.row == 0 {
                return chagePointAllCell(tableView, indexPath: indexPath)
            }
            return chagePointCustomCell(tableView, indexPath: indexPath)
        default:
            return UITableViewCell()
        }
    }

    private func cardCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView
            .dequeueReusableCell(withIdentifier: "ChangePointHeaderTableViewCell") as? ChangePointHeaderTableViewCell {
            return cell
        }
        return UITableViewCell()
    }

    private func descCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView
            .dequeueReusableCell(withIdentifier: "ChangePointDescTableViewCell") as? ChangePointDescTableViewCell {
            cell.config()
            return cell
        }
        return UITableViewCell()
    }

    private func chagePointAllCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView
            .dequeueReusableCell(withIdentifier: "ChagePointAllTableViewCell") as? ChagePointAllTableViewCell {
            cell.isChecked = presenter.selectingChangeAll
            return cell
        }
        return UITableViewCell()
    }

    private func chagePointCustomCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView
            .dequeueReusableCell(withIdentifier: "ChangePointCustomTableViewCell") as? ChangePointCustomTableViewCell {
            cell.isChecked = !presenter.selectingChangeAll
            cell.textDidChange = { [weak self] text in
                self?.presenter.value = text ?? ""
            }
            cell.beginEditing = { [weak self] in
                self?.presenter.selectingChangeAll = false
            }
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == SectionType.option.rawValue {
            return 2
        }
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case SectionType.card.rawValue:
            return 250
        case SectionType.description.rawValue:
            return UITableView.automaticDimension
        case SectionType.option.rawValue:
            if indexPath.row == 0 {
                return UITableView.automaticDimension
            }
            return 162
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeights[indexPath] = cell.frame.size.height
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = cellHeights[indexPath]
        switch indexPath.section {
        case SectionType.card.rawValue:
            return height ?? 250
        case SectionType.description.rawValue:
            return height ?? UITableView.automaticDimension
        case SectionType.option.rawValue:
            if indexPath.row == 0 {
                return height ?? UITableView.automaticDimension
            }
            return height ?? 162
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == SectionType.option.rawValue {
            presenter.selectingChangeAll = indexPath.row == 0
        }
        view.endEditing(true)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return SectionType.allCases.count
    }
}

extension ChangePointViewController: ChangePointPresenterDelegate {
    func onUpdateSelection() {
        tableView.reloadSections([SectionType.option.rawValue], with: .automatic)
    }

    func requestSuccess() {

    }
}
