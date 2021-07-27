//
//  TopUpViewController.swift
//  MyPoint
//
//  Created by Nam Vu on 1/17/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class TopUpViewController: UIViewController, PagerObserver {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var confirmButton: UIButton!

    private let presenter = TopUpPresenter()
    private var topUpValuesCellHeight: CGFloat = 0

    private enum SectionType: Int, CaseIterable {
        case telcos = 0, bankSelection, topUpValue
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.delegate = self
        disableButton()
        configTableView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        showAlert(title: "Thông báo",
                  message: "Chức năng đang trong quá trình hoàn thiện. Vui lòng thử lại sau.")
    }

    private func configTableView() {
        tableView.isHidden = true // remove this line when enable this feature
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TopUpValueListTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "TopUpValueListTableViewCell")
        tableView.register(UINib(nibName: "TopUpSelectionTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "TopUpSelectionTableViewCell")
        tableView.register(UINib(nibName: "TelcoSelectionTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "TelcoSelectionTableViewCell")
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
    }

    func needsToLoadData(index: Int) {
        // uncomment these when enable this feature
//        presenter.requestBankList()
//        presenter.getTopupList()
    }

    fileprivate func disableButton() {
        confirmButton.setBackgroundImage(nil, for: .normal)
        confirmButton.backgroundColor = UIColor(hexString: "#98A1AF", transparency: 0.5)
        confirmButton.isUserInteractionEnabled = false
    }

    fileprivate func enableButton() {
        confirmButton.setBackgroundImage(UIImage(named: "btn_continue_background"), for: .normal)
        confirmButton.backgroundColor = .white
        confirmButton.isUserInteractionEnabled = true
    }

    @IBAction private func onPressConfirm(_ sender: Any) {
        redeemTopup()
    }
    
    fileprivate func redeemTopup() {
        if presenter.isValidBalance {
            presenter.redeem()
        } else {
            showCustomAlert(withTitle: "alert.not_enough_point_header".localized,
                            andContent: "alert.not_enough_point".localized)
        }
    }
}

extension TopUpViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == SectionType.bankSelection.rawValue {
            if let cell = tableView
                .dequeueReusableCell(withIdentifier: "TopUpSelectionTableViewCell") as? TopUpSelectionTableViewCell {
                cell.setData(presenter.banks.first { $0.isSelected })
                cell.onTapBankSelection = { [weak self] in
                    self?.showChooseBankScreen()
                }
                return cell
            }
        }

        if indexPath.section == SectionType.telcos.rawValue {
            if let cell = tableView
                .dequeueReusableCell(withIdentifier: "TelcoSelectionTableViewCell") as? TelcoSelectionTableViewCell {
                cell.setData(presenter.telcos)
                cell.didSelectTelco = {
                    self.presenter.selectedTelco?.deselectAllPrices()
                    self.tableView.reloadData()
                }
                return cell
            }
        }

        if let cell = tableView
            .dequeueReusableCell(withIdentifier: "TopUpValueListTableViewCell") as? TopUpValueListTableViewCell {
            cell.setData(presenter.selectedTelco?.values ?? [])
            cell.didFinishRefreshing = { newHeight in
                self.topUpValuesCellHeight = newHeight
                self.tableView.reloadData()
            }
            cell.didChangePickOption = {
                if let _ = self.presenter.selectedTelco?.selectedValue {
                    self.enableButton()
                } else {
                    self.disableButton()
                }
            }
            return cell
        }

        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case SectionType.telcos.rawValue:
            return 100
        case SectionType.bankSelection.rawValue:
            return 60
        case SectionType.topUpValue.rawValue:
            return topUpValuesCellHeight
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return SectionType.allCases.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case SectionType.telcos.rawValue:
            return "voucher.telco_selection".localized
        case SectionType.bankSelection.rawValue:
            return "voucher.bank_selection".localized
        case SectionType.topUpValue.rawValue:
            return "voucher.top_up_value".localized
        default:
            return ""
        }
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight(500))
            header.textLabel?.textColor = UIColor(hexString: "#032041")
            header.contentView.backgroundColor = .white
        }
    }
}

extension TopUpViewController: TopUpPresenterDelegate {
    func didGetBanks() {
        tableView.reloadData()
    }

    func requestSuccess() {
        tableView.reloadData()
    }

    func showChooseBankScreen() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let contentViewController = ChooseBankViewController()
        contentViewController.setData(presenter.banks)
        contentViewController.didSelect = { bank in
            self.presenter.banks.forEach { iterator in
                iterator.isSelected = iterator.id == bank.id
            }
            self.tableView.reloadData()
        }
        alertController.setValue(contentViewController, forKey: "contentViewController")
        present(alertController, animated: true, completion: nil)
    }

    func didRedeemSuccess() {
        showCustomAlert(withTitle: "Thành công",
                        andContent: "Chúc mừng bạn đã nạp tiền thành công.")
    }
}
