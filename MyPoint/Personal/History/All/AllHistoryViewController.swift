//
//  AllHistoryViewController.swift
//  MyPoint
//
//  Created by Nam Vu on 2/15/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

class AllHistoryViewController: UIViewController, PagerObserver {

    @IBOutlet weak var tableView: UITableView!

    private let presenter = AllHistoryPresenter()

    enum SectionType: Int, CaseIterable {
        case chart, data
    }

    deinit {
        print("Deinit AllHistoryViewController")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.delegate = self
        presenter.generateAvailableDates()
        configTableView()
    }

    private func configTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none

        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
        tableView.refreshControl = refresh

        tableView.register(UINib(nibName: "HistoryChartTableViewCell",
                                 bundle: nil),
                           forCellReuseIdentifier: "HistoryChartTableViewCell")
        tableView.register(UINib(nibName: "MonthHeaderView",
                                 bundle: nil),
                           forHeaderFooterViewReuseIdentifier: "MonthHeaderView")
        tableView.register(UINib(nibName: "HistoryCell",
                                 bundle: nil),
                           forCellReuseIdentifier: "HistoryCell")
    }

    @objc private func onRefresh() {
        requestData()
    }

    func needsToLoadData(index: Int) {
        requestData()
    }

    private func requestData() {
        presenter.requestAllData()
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
            self.presenter.requestAllData()
        }
        alertController.setValue(contentViewController, forKey: "contentViewController")
        present(alertController, animated: true, completion: nil)
    }
}

extension AllHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case SectionType.chart.rawValue:
            return chartCell(tableView, indexPath: indexPath)
        default:
            return historyCell(tableView, indexPath: indexPath)
        }
    }

    private func chartCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView
            .dequeueReusableCell(withIdentifier: "HistoryChartTableViewCell") as? HistoryChartTableViewCell {
            cell.setData(presenter.chartData, date: presenter.currentDate)
            cell.setStatus(presenter.dateSelectionStatus)
            cell.onChangeNext = { [weak self] in
                guard let self = self else { return }
                self.presenter.onNext()
            }
            cell.onChangePrevious = { [weak self] in
                guard let self = self else { return }
                self.presenter.onPrevious()
            }
            cell.onChangeDate = { [weak self] in
                self?.showChangeDate()
            }
            return cell
        }
        return UITableViewCell()
    }

    private func historyCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView
            .dequeueReusableCell(withIdentifier: "HistoryCell") as? HistoryCell {
            if let history = presenter.listHistory[safe: indexPath.row] {
                cell.setData(history)

                if indexPath.row == presenter.listHistory.count - 1 {
                    presenter.loadMore()
                }
            }
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case SectionType.chart.rawValue:
            return 1
        default:
            return presenter.listHistory.count
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == SectionType.chart.rawValue {
            return UIView()
        }

        if let headerView = tableView
            .dequeueReusableHeaderFooterView(withIdentifier: "MonthHeaderView") as? MonthHeaderView {
            headerView.titleLabel.text = presenter.listHistory.first?.transctionDate
            return headerView
        }
        return nil
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == SectionType.chart.rawValue {
            return 0
        }
        return 40
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == SectionType.chart.rawValue { return }

        if let history = presenter.listHistory[safe: indexPath.row] {
            let vc = TransactionDetailViewController()
            vc.setId(history.transactionSequenceID ?? "")
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension AllHistoryViewController: AllHistoryPresenterDelegate {
    func requestSuccess() {
        tableView.refreshControl?.endRefreshing()
        tableView.reloadData()
    }

    func didRequestChart() {
        tableView.reloadRows(at: [IndexPath(row: 0, section: SectionType.chart.rawValue)],
                             with: .none)
    }
}
