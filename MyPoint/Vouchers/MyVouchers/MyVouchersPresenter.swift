//
//  MyVouchersPresenter.swift
//  MyPoint
//
//  Created by Nam Vu on 1/16/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

protocol MyVoucherDelegate: BaseProtocols {
    func onRemoveVoucher(at index: Int)
}

class MyVouchersPresenter: APIResponseMethods {
    private let service = VoucherServices()

    weak var delegate: MyVoucherDelegate?

    var vouchers = [MyVoucherModel]()
    var selectedBrand: BrandListPresenter.BrandItem?

    func loadMore() {
        if service.canLoadMore() {
            service.increaseOffset()
            getWaitingVoucherList()
        }
    }

    func refresh() {
        vouchers.removeAll()
        service.resetOffset()
        getWaitingVoucherList()
    }

    func getWaitingVoucherList() {
        let brandId = selectedBrand?.id ?? ""
        service.getWaitingVoucherList(ordered: .desc, brandId: brandId) { [weak self](response, success) in
            guard let self = self else { return }
            if success {
                if let response = response as? MyVoucherResponse {
                    guard self.noError(from: response) else { return }

                    let newData = response.data?.listItems?.map({ voucher -> MyVoucherModel in
                        return .init(with: voucher, type: .readyToUse)
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

    func markVoucherAsUsed(at index: Int) {
        service.markVoucherAsUsed(voucherId: vouchers[index].itemId) { [weak self](response, success) in
            guard let self = self else { return }
            if success {
                if let response = response as? GeneralResponse {
                    guard self.noError(from: response) else { return }
                    self.vouchers.remove(at: index)
                    self.delegate?.onRemoveVoucher(at: index)
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
