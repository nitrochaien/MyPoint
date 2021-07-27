//
//  VoucherTabListPresenter.swift
//  MyPoint
//
//  Created by Hieu Nguyen on 1/15/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation
import Localize

protocol VoucherTabListProtocols: NSObjectProtocol {
    func showError(message: String)
    func showListHotVoucher(list: [HotVoucher])
    func showListVoucherByCategory(listVoucher: [HotVoucher], category: Category)
    func showListCategory(list: [Category])
    func reloadCollectionView()
    func handleDidCheckForSubcribeCategory(subcribed: Bool)
}

class VoucherTabListPresenter: APIResponseMethods {

    var listHotVoucher = [HotVoucher]()
    var listVoucherByCategory = [[HotVoucher]]()
    var listCategoryWithVoucher = [Category]()
    var listSubscribedCategory = [Category]()
    var listSuggestVoucher = [HotVoucher]()

    private let service = MainServices()
    private let voucherServices = VoucherServices()

    weak var delegate: VoucherTabListProtocols?

    func refresh() {
        voucherServices.resetOffset()
        listHotVoucher.removeAll()
        listVoucherByCategory.removeAll()
        listCategoryWithVoucher.removeAll()
        listSubscribedCategory.removeAll()
        listSuggestVoucher.removeAll()
        getListHotVoucher()
    }
    
    func loadMore() {
        if voucherServices.canLoadMore() {
            voucherServices.increaseOffset()
            getListSuggestVoucher()
        }
    }

    func getListHotVoucher() {
        let requestModel = ListHotVoucherRequestModel()
        service.getListHotVoucher(requestModel: requestModel) { [weak self] (response, success) in
            guard let self = self else { return }
            if success {
                if let response = response as? ListNewHotVoucherResponse {
                    guard self.noError(from: response) else { return }
                    if let listHotVoucher = response.data?.voucherList, listHotVoucher.count > 0 {
                        self.listHotVoucher = listHotVoucher
                        self.delegate?.showListHotVoucher(list: listHotVoucher)
                    } else {
                        self.showError(message: "api.empty".localized)
                    }
                }
            } else {
                self.showError(message: "api.request_fail".localized)
            }
        }
    }
    
    func getListSuggestVoucher() {
        voucherServices.getList { [weak self] (response, success) in
            guard let self = self else { return }
            if success {
                if let response = response as? SearchListResponse {
                    guard self.noError(from: response) else { return }
                    let listHotVoucher = response.data?.listItems ?? []
                    self.voucherServices.numberOfItemsReceived = listHotVoucher.count
                    self.listSuggestVoucher += listHotVoucher
                    self.delegate?.reloadCollectionView()
                }
            } else {
                self.showError(message: "api.request_fail".localized)
            }
        }
    }

    func getListSubscribedCategory() {
        service.getListCategory { [weak self] (response, success) in
            guard let self = self else { return }
            if success {
                if let response = response as? CategoryVoucherResponse {
                    guard self.noError(from: response) else { return }
                    if let listCategory = response.data?.listItems, listCategory.count > 0 {
                        for category in listCategory where category.subscribed == "1" {
                            self.listSubscribedCategory.append(category)
                        }
                        self.delegate?.showListCategory(list: self.listSubscribedCategory)
                    } else {
                        self.showError(message: "api.empty".localized)
                    }
                } else {
                    self.showError(message: "api.request_fail".localized)
                }
            }
            
        }
    }
    
    func getListVoucherByCategories(listCategory: [Category]) {
        let downloadGroup = DispatchGroup()
        for category in listCategory {
            downloadGroup.enter()
            voucherServices.getListVoucherByCategories(categoryCode: category.categoryCode ?? "") { [weak self] (response, success) in
                guard let self = self else { return }
                if success {
                    if let response = response as? ListHotVoucherResponse {
                        guard self.noError(from: response) else { return }
                        if let listVoucher = response.data?.listItems {
                            if listVoucher.count > 0 {
                                self.listVoucherByCategory.append(listVoucher)
                                self.listCategoryWithVoucher.append(category)
                                self.delegate?.showListVoucherByCategory(listVoucher: listVoucher, category: category)
                            }
                        } else {
                            self.showError(message: "api.empty".localized)
                        }
                    }
                } else {
                    self.showError(message: "api.request_fail".localized)
                }
                downloadGroup.leave()
            }
        }
        downloadGroup.notify(queue: DispatchQueue.main) {
            self.delegate?.reloadCollectionView()
        }
    }

    func requestCategoryList() {
        SplashScreenServices().requestCategoryList { [weak self] (response, success) in
            guard let self = self else { return }
            if success {
                if let response = response as? InterestedResponse {
                    guard self.noError(from: response) else { return }
                    let items = response.data?.listItems ?? []
                    if items.isEmpty {
                        self.delegate?.handleDidCheckForSubcribeCategory(subcribed: false)
                        return
                    }
                    var subcribed = false
                    items.forEach { item in
                        if item.subscribed?.bool == true {
                            subcribed = true
                            return
                        }
                    }
                    self.delegate?.handleDidCheckForSubcribeCategory(subcribed: subcribed)
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
