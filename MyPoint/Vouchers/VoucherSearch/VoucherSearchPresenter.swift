//
//  VoucherSearchPresenter.swift
//  MyPoint
//
//  Created by Nam Vu on 2/27/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

class VoucherSearchPresenter: APIResponseMethods {
    weak var delegate: BaseProtocols?
    private let service = SearchVoucherService()

    var requestTab = SearchTabView.SelectionType.all

    var suggestItems = [HotVoucher]()
    var searchParams = SearchParams()
    var totalItems = 0

    func refresh() {
        clearAllData()
        getSearchVoucherList()
    }

    func clearAllData() {
        suggestItems.removeAll()
        service.resetOffset()
    }

    func loadMore() {
        if service.canLoadMore() {
            service.increaseOffset()
            getSearchVoucherList()
        }
    }

    private func getSearchVoucherList() {
        service.getList(params: searchParams) { [weak self] response, success in
            guard let self = self else { return }
            if success {
                if let response = response as? SearchListResponse {
                    guard self.noError(from: response) else { return }

                    if let total = response.data?.total {
                        self.totalItems = Int(total) ?? 0
                    }

                    if let listHotVoucher = response.data?.listItems {
                        self.service.numberOfItemsReceived = listHotVoucher.count
                        self.suggestItems.append(contentsOf: listHotVoucher)
                        self.delegate?.requestSuccess()
                    }
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
