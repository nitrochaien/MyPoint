//
//  MainListPresenter.swift
//  MyPoint
//
//  Created by Nam Vu on 12/28/19.
//  Copyright © 2019 NamDV. All rights reserved.
//

import Foundation
import Localize

protocol MainListProtocols: BaseProtocols {
    func showError(message: String)

    func showListHotVoucher(list: [HotVoucher])

    func showListCategory(list: [Category])

    func showListBrand(list: [Brand])

    func showListCampain(list: [Campaign])

    func showListNews()

    func showListBanner()
}

class MainListPresenter: APIResponseMethods {

    var listHotVoucher = [HotVoucher]()
    var listCategory = [Category]()
    var listBrand = [Brand]()
    var listNews = [NewsModel]()
    var listBanners = [Banner]()
    var listSubscribedCategory = [Category]()
    var listCampain = [Campaign]()

    private let service = MainServices()
    private let notificationService = NotificationServices()

    weak var delegate: MainListProtocols?

    var unreadItems = 0

    func refresh() {
        notificationService.resetOffset()
        listHotVoucher.removeAll()
        listCategory.removeAll()
        listBrand.removeAll()
        listNews.removeAll()
        getListHotVoucher()
        getNotificationList()
    }

    func getNotificationList(isShowLoadding: Bool = true) {
        notificationService.getList(isShowLoadding: isShowLoadding) { [weak self] (response, success) in
            guard let self = self else { return }
            if success {
                if let response = response as? NotificationListResponse {
                    guard self.noError(from: response) else { return }
                    let newData = response.data?.listItems?.map({ item -> NotificationItem in
                        return .init(with: item)
                    }) ?? []

                    self.notificationService.numberOfItemsReceived = newData.count
                    self.unreadItems = Int(response.data?.unread ?? "0") ?? 0

                    Storage.shared
                        .loginData?
                        .workingSite?
                        .customerBalance?.setNewAmount(with: response.data?.customerBalance)

                    self.delegate?.requestSuccess()
                }
            } else {
                self.showError(message: "api.request_fail".localized)
            }
        }
    }

    func getListHotVoucher() {
        let requestModel = ListHotVoucherRequestModel()
        service.getListHotVoucher(requestModel: requestModel) { [weak self] (response, success) in
            guard let self = self else { return }
            if success {
                if let response = response as? ListNewHotVoucherResponse {
                    guard self.noError(from: response) else { return }
                    if let listHotVoucher = response.data?.voucherList {
                        self.listHotVoucher = listHotVoucher
                        self.delegate?.showListHotVoucher(list: listHotVoucher)
                    } else {
                        self.getListCategory()
                    }
                }
            } else {
                self.showError(message: "api.request_fail".localized)
            }
        }
        //      let parsedData: [HotVoucher] = load("list_hot_voucher.json")
        //      delegate?.showListHotVoucher(list: parsedData)
    }

    func getListCampain() {
        service.getListCampain { [weak self] (response, success) in
            guard let self = self else { return }
            if success {
                if let response = response as? AffiliateAccessTradeCampaignGetListResponse {
                    guard self.noError(from: response) else { return }
                    if let listCampain = response.data?.listCampaign {
                        self.listCampain = listCampain
                        self.delegate?.showListCampain(list: listCampain)
                    }
                }
            } else {
                self.showError(message: "api.request_fail".localized)
            }
        }
    }

    func getListBanner() {
        service.getListBanner { [weak self] (response, success) in
            guard let self = self else { return }
            if success {
                if let response = response as? ListBannerResponse {
                    guard self.noError(from: response) else { return }
                    if let listBanner = response.data?.banners {
                        if listBanner.count > 0 {
                            self.listBanners = listBanner
                        }
                        self.delegate?.showListBanner()
                    }
                }
            } else {
                self.showError(message: "api.request_fail".localized)
            }
        }
    }

    func updateNotificationToken() {
        service.updateNotificationToken { [weak self] (response, success) in
            guard let self = self else { return }
            if success {
                if let response = response as? GeneralResponse {
                    guard self.noError(from: response) else { return }
                }
            } else {
                self.showError(message: "api.request_fail".localized)
            }
        }
    }

    func getListCategory() {
        service.getListCategory { [weak self] (response, success) in
            guard let self = self else { return }
            if success {
                if let response = response as? CategoryVoucherResponse {
                    guard self.noError(from: response) else { return }
                    if let listCategory = response.data?.listItems {
                        self.listCategory = listCategory
                        self.delegate?.showListCategory(list: listCategory)
                    }
                } else {
                    self.showError(message: "api.request_fail".localized)
                }
            }

        }
        //      let parsedData: [Category] = load("list_category.json")
        //      delegate?.showListCategory(list: parsedData)
    }

    func getListBrand() {
        service.getListBrand { [weak self] (response, success) in
            guard let self = self else { return }
            if success {
                if let response = response as? ListBrandResponseModel {
                    guard self.noError(from: response) else { return }
                    if let listBrand = response.data?.items {
                        self.listBrand = listBrand
                        self.delegate?.showListBrand(list: listBrand)
                    }
                } else {
                    self.showError(message: "api.request_fail".localized)
                }
            }
        }
    }

    func getListNews() {
        service.getListNews { [weak self] (response, success) in
            guard let self = self else { return }
            if success {
                if let response = response as? ListNewsResponseModel {
                    guard self.noError(from: response) else { return }
                    if let listNews = response.data?.items {
                        self.listNews = listNews.map({ news -> NewsModel in
                            return .init(with: news)
                        })
                        self.delegate?.showListNews()
                    }
                } else {
                    self.showError(message: "api.request_fail".localized)
                }
            }
        }
        //      let parsedData: [News] = load("list_news.json")
        //      delegate?.showListNews(list: parsedData)
    }

    func showError(message: String) {
        delegate?.showError(message: message)
    }
}
