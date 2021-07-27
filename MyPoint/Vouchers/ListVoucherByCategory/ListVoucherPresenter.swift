//
//  ListVoucherPresenter.swift
//  MyPoint
//
//  Created by Hieu Nguyen on 2/13/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

protocol ListVoucherProtocols: NSObjectProtocol {
    func showError(message: String)
    func showListHotVoucher(list: [HotVoucher])
    func showListVoucherByCategory(list: [HotVoucher])
}

class ListVoucherPresenter: APIResponseMethods {

    private let service = MainServices()
    
    private let voucherServices = VoucherServices()

    var category = Category(id: "", subscribed: "", categoryCode: "", categoryName: "", imageUrl: "")

    var listHotVoucher = [HotVoucher]()

    weak var delegate: ListVoucherProtocols?

    func refresh() {
        service.resetOffset()
        listHotVoucher.removeAll()

        if category.categoryCode != "" {
            getListVoucherByCategories(category: category)
        } else {
            getListHotVoucher()
        }
    }

    func loadMore() {
        if service.canLoadMore() {
            service.increaseOffset()
            if category.categoryCode != "" {
                getListVoucherByCategories(category: category)
            } else {
                getListHotVoucher()
            }
        }
    }

    func getListHotVoucher() {
//        let requestModel = ListHotVoucherRequestModel()
        service.getListHotVoucherByCategories(categoryId: category.id ?? "") { [weak self] (response, success) in
            guard let self = self else { return }
            if success {
                if let response = response as? ListNewHotVoucherResponse {
                    guard self.noError(from: response) else { return }
                    if let newList = response.data?.voucherList, newList.count > 0 {
                        self.listHotVoucher.append(contentsOf: newList)
                        self.service.numberOfItemsReceived = newList.count
                        self.delegate?.showListHotVoucher(list: self.listHotVoucher)
                    } else {
                        self.showError(message: "api.empty".localized)
                    }
                }
            } else {
                self.showError(message: "api.request_fail".localized)
            }
        }
    }
    
    func getListVoucherByCategories(category: Category) {
        voucherServices.getListVoucherByCategories(categoryCode: category.categoryCode ?? "") { [weak self] (response, success) in
            guard let self = self else { return }
            if success {
                if let response = response as? ListHotVoucherResponse {
                    guard self.noError(from: response) else { return }
                    if let newList = response.data?.listItems {
                        if newList.count > 0 {
                            self.listHotVoucher.append(contentsOf: newList)
                            self.service.numberOfItemsReceived = newList.count
                            self.delegate?.showListVoucherByCategory(list: self.listHotVoucher)
                        }
                    } else {
                        self.showError(message: "api.empty".localized)
                    }
                }
            } else {
                self.showError(message: "api.request_fail".localized)
            }
        }
    }

    func showError(message: String) {
        delegate?.showError(message: message)
    }
}
