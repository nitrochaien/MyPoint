//
//  MonthHistoryViewController.swift
//  MyPoint
//
//  Created by Hieu on 2/16/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class MonthHistoryViewController: BaseViewController, PagerObserver, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var picker: MonthYearPickerView!
    
    private let presenter = HistoryPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        hideKeyboardWhenTappedAround()
        initView()
        presenter.delegate = self
        presenter.generateAvailableDates()
    }

    func setType(type: HistoryListType) {
        presenter.type = type
    }

    func initView() {
        picker.backgroundColor = .white
        picker.onDateSelected = { (_: Int, _: Int) in
            self.view.endEditing(true)
            self.presenter.refresh()
            self.tableView.reloadData()
        }
    }

    @objc func disMissPicker() {
        self.view.endEditing(true)
        picker.isHidden = true
    }

    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "HistoryCell", bundle: nil), forCellReuseIdentifier: "HistoryCell")
        tableView.register(UINib(nibName: "SelectMonthCell", bundle: nil), forCellReuseIdentifier: "SelectMonthCell")

        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
        tableView.refreshControl = refresh
    }

    @objc private func onRefresh() {
        presenter.refresh()
    }

    fileprivate func showChangeDate() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let contentViewController = MonthPickerViewController()
        contentViewController.setData(presenter.availableDates,
                                      selectedDate: presenter.currentDate,
                                      showAll: false)
        contentViewController.didSelect = { date in
            self.presenter.currentDate = date
            if let index = self.presenter.availableDates.firstIndex(where: { d -> Bool in
                return d.month == date.month && d.year == date.year
            }) {
                self.presenter.selectingDateIndex = index
            }
            self.presenter.refresh()
        }
        alertController.setValue(contentViewController, forKey: "contentViewController")
        present(alertController, animated: true, completion: nil)
    }

    func dequeueHistoryCell(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as? HistoryCell
            else {
                fatalError("Empty Cell")
        }
        cell.setData(presenter.listHistory[indexPath.row - 1])
        return cell
    }

    func dequeSelectMonthCell(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SelectMonthCell", for: indexPath) as? SelectMonthCell
            else {
                fatalError("Empty Cell")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 30
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.listHistory.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SelectMonthCell", for: indexPath) as? SelectMonthCell
                else {
                    fatalError("Empty Cell")
            }
            cell.selectMonthButton.setTitle("personal.month".localized + " " + "\(self.presenter.currentDate.month)" + "/" + "\(self.presenter.currentDate.year)", for: .normal)
            cell.selectMonthButton.add(for: .touchUpInside) {
                self.showChangeDate()
            }
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as? HistoryCell
                else {
                    fatalError("Empty Cell")
            }
            //        let key = presenter.listDate[safe: indexPath.section - 1] ?? ""
            //        let item = presenter.listHistory[key]?[safe: indexPath.row]
            let item = presenter.listHistory[indexPath.row - 1]
            cell.setData(item)
            cell.separatorView.isHidden = false

            if indexPath.row == presenter.listHistory.count - 1 {
                presenter.loadMore()
            }
            return cell
        }
    } 

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = TransactionDetailViewController()
        if let item = presenter.listHistory[safe: indexPath.row - 1] {
            vc.setId(item.transactionSequenceID ?? "")
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func needsToLoadData(index: Int) {
        presenter.refresh()
    }
}

extension MonthHistoryViewController: HistoryProtocols {
    func showError(message: String) {
        self.showCustomAlert(withTitle: "".localized, andContent: message)
        tableView.reloadData()
    }
    
    func showListHistory() {
        tableView.refreshControl?.endRefreshing()
        tableView.reloadData()
    }
}
