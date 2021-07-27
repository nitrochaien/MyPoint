//
//  CashbackTransactionPresenter.swift
//  MyPoint
//
//  Created by Nam Vu on 7/17/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

final class CashbackTransactionPresenter: APIResponseMethods {

    private(set) var data: CashbackTransactionModel?

    var type: CashbackTransactionModel.TransactionType = .pending
    weak var delegate: BaseProtocols?

    private let service = CashbackService()

    var isTypeCancelled: Bool {
        return type == .cancelled
    }

    func requestData() {
//        switch type {
//        case .pending:
//            requestPendingData()
//        case .approved:
//            requestApprovedData()
//        case .voided:
//            requestVoidedData()
//        case .cancelled:
//            requestCancelledData()
//        }

        service.requestCampaignOrder(type: type) { [weak self] response, success in
            guard let self = self else { return }
            if success {
                if let response = response as? CashbackTransactionResponse {
                    self.data = .init(type: self.type, data: response.data)
                    self.delegate?.requestSuccess()
                }
            } else {
                self.showError()
            }
        }
    }

    func showError(message: String = "api.request_fail".localized) {
        delegate?.showError(message: message)
    }

    private func requestPendingData() {
        data = .init(type: type)
        delegate?.requestSuccess()
    }

    private func requestApprovedData() {
        data = .init(type: type)
        delegate?.requestSuccess()
    }

    private func requestVoidedData() {
        data = .init(type: type)
        delegate?.requestSuccess()
    }

    private func requestCancelledData() {
        data = .init(type: type)
        delegate?.requestSuccess()
    }
}
