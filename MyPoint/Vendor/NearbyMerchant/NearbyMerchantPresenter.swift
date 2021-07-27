//
//  NearbyMerchantPresenter.swift
//  MyPoint
//
//  Created by Hieu Nguyen on 2/25/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation
import CoreLocation

protocol NearbyMerchantProtocols: NSObjectProtocol {
    func showError(message: String)

    func showListMerchant()

    func reloadTableView()

}

class NearbyMerchantPresenter: APIResponseMethods {

    var listNearyBrandStore = [NearbyBrandStore]()

    var coordinate = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)

    private let services = MerchantServices()

    private let service = MainServices()

    weak var delegate: NearbyMerchantProtocols?

    func refresh() {
        services.resetOffset()
        listNearyBrandStore.removeAll()
        getListSubscribedCategory()
    }

    func loadMoreBrand() {
        if services.canLoadMore() {
            services.increaseOffset()
            getListNearbyBrand(categoryIds: "", lat: "\(coordinate.latitude)", long: "\(coordinate.longitude)")
        }
    }

    private func getListSubscribedCategory() {
        if service.pendingRequest { return }

        service.pendingRequest = true
        service.getListCategory { [weak self] (response, success) in
            guard let self = self else { return }
            self.service.pendingRequest = false
            if success {
                if let response = response as? CategoryVoucherResponse {
                    guard self.noError(from: response) else { return }
                    if let listCategory = response.data?.listItems, listCategory.count > 0 {
                        let subscribedCategoryIds = listCategory
                            .filter { category -> Bool in
                                let id = category.id ?? ""
                                return category.subscribed == "1" && !id.isEmpty
                            }
                            .map { category -> String in
                                return category.id ?? ""
                            }
                            .joined(separator: ",")
                        self.getListNearbyBrand(categoryIds: subscribedCategoryIds,
                                                lat: "\(self.coordinate.latitude)",
                                                long: "\(self.coordinate.longitude)")
                    } else {
                        self.showError(message: "api.empty".localized)
                    }
                } else {
                    self.showError(message: "api.request_fail".localized)
                }
            }
        }
    }

    func getListNearbyBrand(categoryIds: String, lat: String, long: String) {
        service.pendingRequest = true
        services.getListNearbyStoresBrand(categoryIds: categoryIds, lat: lat, long: long) { [weak self] (response, success) in
            guard let self = self else { return }
            self.service.pendingRequest = false
            if success {
                if let response = response as? NearbyBrandStoreResponse {
                    guard self.noError(from: response) else { return }
                    if let listBrandStore = response.data?.storeList, listBrandStore.count > 0 {
                        self.listNearyBrandStore += listBrandStore
                        self.services.numberOfItemsReceived = listBrandStore.count
                        self.delegate?.reloadTableView()
                    } else {
                        self.showError(message: "api.empty".localized)
                    }
                } else {
                    self.showError(message: "api.request_fail".localized)
                }
            }
        }
    }

    func showError(message: String) {

    }
}
