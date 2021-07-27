//
//  AllHistoryPresenter.swift
//  MyPoint
//
//  Created by Nam Vu on 2/19/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

protocol AllHistoryPresenterDelegate: BaseProtocols {
    func didRequestChart()
}

class AllHistoryPresenter: APIResponseMethods {
    private var services = PersonalServices()

    weak var delegate: AllHistoryPresenterDelegate?

    private(set) var listHistory = [History]()
    private(set) var availableDates = [Date]()
    private(set) var chartData: ChartData?

    enum DateSelectionStatus {
        case first, middle, last
    }
    var selectingDateIndex = 5

    var fixedDate = Date()
    var currentDate = Date()

    func generateAvailableDates() {
        let calendar = Calendar.current

        availableDates = [
            calendar.date(byAdding: .month, value: -5, to: fixedDate)!,
            calendar.date(byAdding: .month, value: -4, to: fixedDate)!,
            calendar.date(byAdding: .month, value: -3, to: fixedDate)!,
            calendar.date(byAdding: .month, value: -2, to: fixedDate)!,
            calendar.date(byAdding: .month, value: -1, to: fixedDate)!,
            fixedDate
        ]
    }

    var dateSelectionStatus: DateSelectionStatus {
        if selectingDateIndex == 0 {
            return .first
        }
        if selectingDateIndex == availableDates.count - 1 {
            return .last
        }
        return .middle
    }

    func onNext() {
        selectingDateIndex = min(availableDates.count - 1, selectingDateIndex + 1)
        currentDate = availableDates[selectingDateIndex]
        requestAllData()
    }

    func onPrevious() {
        selectingDateIndex = max(0, selectingDateIndex - 1)
        currentDate = availableDates[selectingDateIndex]
        requestAllData()
    }

    func requestAllData() {
        fixedDate = Date()
        listHistory.removeAll()
        services.resetOffset()

        let group = DispatchGroup()
        getListHistory(group)
        getChartData(group)

        group.notify(queue: .main) {
            self.delegate?.requestSuccess()
        }
    }

    func loadMore() {
        if services.canLoadMore() {
            services.increaseOffset()
            let group = DispatchGroup()
            getListHistory(group)
            group.notify(queue: .main) {
                self.delegate?.requestSuccess()
            }
        }
    }

    private func getListHistory(_ group: DispatchGroup) {
        group.enter()

        let month = String(currentDate.month)
        let year = String(currentDate.year)
        services.getHistory(month: month, type: .all, year: year) { [weak self] (response, success) in
            group.leave()
            guard let self = self else { return }
            if success {
                if let response = response as? HistoryResponse {
                    guard self.noError(from: response) else { return }
                    if let newData = response.data?.history {
                        self.services.numberOfItemsReceived = newData.count
                        self.listHistory += newData
                    }
                }
            } else {
                self.showError()
            }
        }
    }

    private func getChartData(_ group: DispatchGroup) {
        group.enter()

        let month = String(currentDate.month)
        let year = String(currentDate.year)
        services.getChartData(month: month, year: year) { [weak self] (response, success) in
            group.leave()
            guard let self = self else { return }
            if success {
                if let response = response as? ChartResponse {
                    guard self.noError(from: response) else { return }
                    self.chartData = response.data
                }
            } else {
                self.showError()
            }
        }
    }

    func showError(message: String = "api.request_fail".localized) {
        delegate?.showError(message: message)
    }
}
