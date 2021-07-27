//
//  ExpiredVoucherPresenter.swift
//  MyPoint
//
//  Created by Nam Vu on 1/16/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

class ExpiredVoucherPresenter: APIResponseMethods {
    private let service = VoucherServices()

    weak var delegate: BaseProtocols?

    var vouchers = [MyVoucherModel]()

    func loadMore() {
        if service.canLoadMore() {
            service.increaseOffset()
            getExpiredVoucherList()
        }
    }

    func refresh() {
        vouchers.removeAll()
        service.resetOffset()
        getExpiredVoucherList()
    }

    func getExpiredVoucherList() {
        service.getExpiredVoucherList(ordered: .desc) { [weak self](response, success) in
            guard let self = self else { return }
            if success {
                if let response = response as? MyVoucherResponse {
                    guard self.noError(from: response) else { return }

                    let newData = response.data?.listItems?.map({ voucher -> MyVoucherModel in
                        return .init(with: voucher, type: .outdate)
                    }) ?? []
                    self.service.numberOfItemsReceived = newData.count
                    self.vouchers.append(contentsOf: newData)

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
