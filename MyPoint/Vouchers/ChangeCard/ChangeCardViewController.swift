//
//  ChangeCardViewController.swift
//  MyPoint
//
//  Created by Nam Vu on 1/19/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

struct TelcoPattern {
    static let prePaid = "*100*%@#"
    static let postPaidMobi = "*100*%@#"
    static let postPaidVina = "*188*0*%@#"
    static let postPaidViettel = "*199*%@#"
}

final class ChangeCardViewController: UIViewController, PagerObserver {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var patternView: UIView!
    @IBOutlet private weak var confirmButton: UIButton!
    
    private let presenter = ChangeCardPresenter()
    private var cardValuesCellHeight: CGFloat = 0

    private var patternVC: ChangeCardPatternViewController!

    private enum SectionType: Int, CaseIterable {
        //        case quickBuy = 0, telcoSelection, cardValue
        case telcoSelection = 0, cardValue
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.delegate = self
        disableButton()
        configTableView()
    }

    private func showPatternView(with code: String) {
        patternVC = ChangeCardPatternViewController()
        patternVC.codes = [
            .init(title: "voucher.pre_paid_pattern".localized,
                  content: String(format: TelcoPattern.prePaid, code)),
            .init(title: "voucher.post_paid_pattern".localized,
                  content: String(format: TelcoPattern.postPaidViettel, code))
        ]
        patternVC.didHideSelection = { [weak self] in
            self?.patternVC = nil
        }
        addChild(patternVC)
        patternVC.view.frame = view.frame
        view.addSubview(patternVC.view)
        patternVC.didMove(toParent: self)
    }

    private func configTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TelcoSelectionTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "TelcoSelectionTableViewCell")
        tableView.register(UINib(nibName: "TopUpValueListTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "TopUpValueListTableViewCell")
        tableView.register(UINib(nibName: "QuickBuyTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "QuickBuyTableViewCell")
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
    }

    @IBAction private func onProceed(_ sender: Any) {
        redeemCard()
    }
    
    func needsToLoadData(index: Int) {
        presenter.getMobileCardList()
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

    fileprivate func redeemCard() {
        if presenter.isValidBalance {
            presenter.redeem()
        } else {
            showCustomAlert(withTitle: "alert.not_enough_point_header".localized,
                            andContent: "alert.not_enough_point".localized)
        }
    }
}

extension ChangeCardViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
            //        case SectionType.quickBuy.rawValue:
            //            if let cell = tableView
            //                .dequeueReusableCell(withIdentifier: "QuickBuyTableViewCell") as? QuickBuyTableViewCell {
            //                cell.setData(presenter.quickBuys)
            //                return cell
        //            }
        case SectionType.telcoSelection.rawValue:
            if let cell = tableView
                .dequeueReusableCell(withIdentifier: "TelcoSelectionTableViewCell") as? TelcoSelectionTableViewCell {
                cell.setData(presenter.telcos)
                cell.didSelectTelco = {
                    self.presenter.selectedTelco?.deselectAllPrices()
                    self.disableButton()
                    self.tableView.reloadData()
                }
                return cell
            }
        case SectionType.cardValue.rawValue:
            if let cell = tableView
                .dequeueReusableCell(withIdentifier: "TopUpValueListTableViewCell") as? TopUpValueListTableViewCell {
                cell.setData(presenter.selectedTelco?.values ?? [])
                cell.didFinishRefreshing = { newHeight in
                    self.cardValuesCellHeight = newHeight
                    self.tableView.reloadData()
                }
                cell.didChangePickOption = {
                    if let selectedItem = self.presenter.selectedTelco?.selectedValue {
                        self.enableButton()
                    } else {
                        self.disableButton()
                    }
                }
                return cell
            }
        default:
            break
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        //        case SectionType.quickBuy.rawValue,
        case SectionType.telcoSelection.rawValue:
            return 100
        case SectionType.cardValue.rawValue:
            return cardValuesCellHeight
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
            //        case SectionType.quickBuy.rawValue:
        //            return "voucher.quick_buy".localized
        case SectionType.telcoSelection.rawValue:
            return "voucher.telco_selection".localized
        case SectionType.cardValue.rawValue:
            return "voucher.card_value".localized
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

extension ChangeCardViewController: BalanceDelegate {
    func didRedeemSuccess(_ info: ChangeCardPresenter.CardInfo) {
        showTwoButtonsAlert(with: .createChangeCardAlert(withPoint: Int(presenter.point))) { [weak self] in
            guard let self = self else { return }
            self.showChangeCardSuccess(dueDate: info.dueDate,
                                       code: info.secretCode) { [weak self] in
                                        self?.showPatternView(with: info.secretCode)
            }
        }
    }

    func requestSuccess() {
        tableView.reloadData()
    }
}
