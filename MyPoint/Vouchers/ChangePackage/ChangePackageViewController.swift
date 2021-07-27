//
//  ChangePackageViewController.swift
//  MyPoint
//
//  Created by Nam Vu on 1/20/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class ChangePackageViewController: UIViewController, PagerObserver {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var counterView: CounterView!
    @IBOutlet private weak var bottomConstraint: NSLayoutConstraint!

    private var cellHeights = [IndexPath: CGFloat]()
    
    private enum SectionType: Int, CaseIterable {
        case telco = 0, package
    }

    private let presenter = ChangePackagePresenter()

    override func viewDidLoad() {
        super.viewDidLoad()

        configTableView()
        presenter.delegate = self
        configCounterView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showAlert(title: "Thông báo",
                  message: "Chức năng đang trong quá trình hoàn thiện. Vui lòng thử lại sau.")
    }

    private func configCounterView() {
        hideCounterView(animated: false)
        counterView.onRedeem = { [weak self] points in
            self?.showTwoButtonsAlert(with: .createChangePackageAlert(withPoint: points),
                                      rightButtonCompletion: { [weak self] in
                                        self?.redeemPackage(with: points)
            })
        }
        counterView.onRemoveAll = { [weak self] in
            guard let self = self else { return }

            self.hideCounterView(animated: true)
            if let selectedTelco = self.presenter.telcos.first(where: { model -> Bool in
                return model.isSelected
            }) {
                selectedTelco.values.first { model -> Bool in
                    return model.isSelected
                }?.isSelected = false
            }
            self.tableView.reloadData()
        }
    }

    private func redeemPackage(with points: Int) {
        presenter.points = points

        if presenter.isValidBalance {
            presenter.redeem()
        } else {
            showCustomAlert(withTitle: "alert.not_enough_point_header".localized,
                            andContent: "alert.not_enough_point".localized)
        }
    }

    func showCounterView() {
        UIView.animate(withDuration: 0.2) {
            self.bottomConstraint.constant = 0

            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
            }
        }
    }

    private func hideCounterView(animated: Bool) {
        bottomConstraint.constant = -180

        if animated {
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
            }
        }
    }

    private func configTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TelcoSelectionTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "TelcoSelectionTableViewCell")
        tableView.register(UINib(nibName: "TelcoPackageItemTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "TelcoPackageItemTableViewCell")
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
    }

    func needsToLoadData(index: Int) {
//        presenter.getData()
    }
}

extension ChangePackageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case SectionType.telco.rawValue:
            if let cell = tableView
                .dequeueReusableCell(withIdentifier: "TelcoSelectionTableViewCell") as? TelcoSelectionTableViewCell {
                cell.setData(presenter.telcos)
                cell.didSelectTelco = {
                    self.presenter.selectedTelco?.deselectAllPrices()
                    self.hideCounterView(animated: true)
                    self.tableView.reloadData()
                }
                return cell
            }
        case SectionType.package.rawValue:
            if let cell = tableView
                .dequeueReusableCell(withIdentifier: "TelcoPackageItemTableViewCell") as? TelcoPackageItemTableViewCell {
                let values = presenter.selectedTelco?.values ?? []
                if let value = values[safe: indexPath.row] {
                    cell.setData(value)
                }
                return cell
            }
        default:
            break
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let packages = presenter.telcos.first(where: { model -> Bool in
            return model.isSelected
        })?.values ?? []
        if indexPath.section == SectionType.package.rawValue {
            let selectedItem = packages[indexPath.row]
            packages.forEach { package in
                if package == selectedItem {
                    package.isSelected.toggle()
                } else {
                    package.isSelected = false
                }
            }
            tableView.reloadData()

            let price = packages.first { $0.isSelected }?.priceValue ?? 0
            counterView.setPoints(Int(price))
            if selectedItem.isSelected {
                showCounterView()
            } else {
                hideCounterView(animated: true)
            }
        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeights[indexPath] = cell.frame.size.height
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = cellHeights[indexPath]
        switch indexPath.section {
        case SectionType.telco.rawValue:
            return height ?? 100
        case SectionType.package.rawValue:
            return height ?? UITableView.automaticDimension
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case SectionType.telco.rawValue:
            return 100
        case SectionType.package.rawValue:
            return UITableView.automaticDimension
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case SectionType.telco.rawValue:
            return 1
        case SectionType.package.rawValue:
            if let selectedTelco = presenter.telcos.first(where: { model -> Bool in
                return model.isSelected
            }) {
                return selectedTelco.values.count
            } else {
                return 0
            }
        default:
            return 0
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
//        return SectionType.allCases.count
        return 0
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case SectionType.telco.rawValue:
            return "voucher.telco_selection".localized
        case SectionType.package.rawValue:
            return "voucher.select_package".localized
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

extension ChangePackageViewController: BalanceDelegate {
    func didRedeemSuccess() {
        showChangePackageSuccess()
    }

    func requestSuccess() {
        tableView.reloadData()
    }
}
