//
//  HistoryPresenter.swift
//  MyPoint
//
//  Created by Hieu on 2/16/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

protocol HistoryProtocols: NSObjectProtocol {
  func showError(message: String)
  
  func showListHistory()
}

class HistoryPresenter: APIResponseMethods {
    
    private var services = PersonalServices()
    
    weak var delegate: HistoryProtocols?

    var type = HistoryListType.redeem
  
    private(set) var listDate = [String]()
    private(set) var availableDates = [Date]()
  
    var numberOfSection: Int = 0
    var numberOfRows: [Int] = []
  
    enum DateSelectionStatus {
        case first, middle, last
    }
    
    var listHistory = [History]()
  
    var selectingDateIndex = 5
  
    var fixedDate = Date() {
        didSet {
            currentDate = fixedDate
        }
    }
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

    func refresh() {
        listHistory.removeAll()
        services.resetOffset()
        getListHistory()
    }

    func loadMore() {
        if services.canLoadMore() {
            services.increaseOffset()
            getListHistory()
        }
    }
    
    private func getListHistory() {
        services.getHistory(month: String(currentDate.month),
                            type: type,
                            year: String(currentDate.year)) { [weak self] (response, success) in
            guard let self = self else { return }
            if success {
                if let response = response as? HistoryResponse {
                    guard self.noError(from: response) else { return }
                    if let listHistory = response.data?.history {
                        self.services.numberOfItemsReceived = listHistory.count

                        let data: [History]
                        switch self.type.toRequest {
                        case HistoryListType.redeemReq:
                            data = listHistory.filter({ history -> Bool in
                                return history.pointValue < 0
                            })
                        case HistoryListType.rewardReq:
                            data = listHistory.filter({ history -> Bool in
                                return history.pointValue > 0
                            })
                        default:
                            data = []
                        }

                        self.listHistory += data

                        if self.listHistory.isEmpty {
                            self.showError(message: "api.no_history".localized)
                        }

                        self.delegate?.showListHistory()
                    }
                }
            } else {
                self.showError(message: "api.request_fail".localized)
            }
        }
    }
    
    func showError(message: String) {
        self.delegate?.showError(message: message)
    }
}
