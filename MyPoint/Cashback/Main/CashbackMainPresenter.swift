//
//  CashbackMainPresenter.swift
//  MyPoint
//
//  Created by Nam Vu on 7/21/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

final class CashbackMainPresenter: APIResponseMethods {
    weak var delegate: BaseProtocols?
    private(set) var model: CashbackMainModel?

    private let service = CashbackService()

    func refreshData() {
        model = nil
        requestData()
    }

    func loadMore() {
        if service.canLoadMore() {
            service.increaseOffset()
            requestData()
        }
    }

    private func requestData() {
        service.getCampaign { [weak self] response, success in
            guard let self = self else { return }
            if success {
                if let response = response as? AffiliateAccessTradeCampaignGetListResponse {
                    if let model = self.model {
                        let newItems = response.data?.listCampaign?.map({ campaign -> CashbackMainModel.Item in
                            return .init(campaign: campaign)
                        }) ?? []
                        model.items.append(contentsOf: newItems)
                    } else {
                        self.model = .init(data: response)
                    }
                    self.service.numberOfItemsReceived = response.data?.listCampaign?.count ?? 0
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
}
