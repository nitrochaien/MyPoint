//
//  MerchantSearchPresenter.swift
//  MyPoint
//
//  Created by Nam Vu on 2/20/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation
import CoreLocation

class MerchantSearchPresenter: NSObject, APIResponseMethods {

    weak var delegate: BaseProtocols?
    private let service = SearchStoreService()

    let locationManager = CurrentLocationManager.shared

    var requestTab = SearchTabView.SelectionType.all

    var suggestItems = [NearbyBrandStore]()
    var searchParams = SearchParams()
    var totalItems = 0

    var isRequestingAPI = false

    func registerLocation() {
        locationManager.delegate = self
    }

    var canGetLocation: Bool {
        return locationManager.canGetLocation
    }

    func clearAllData() {
        suggestItems.removeAll()
        service.resetOffset()
    }

    func refresh() {
        if canGetLocation {
            locationManager.requestLocation()
        } else {
            if locationManager.isDetermined {
                clearAllData()
                searchParams.allowLocation = false
                getSearchStoreList()
            } else {
                locationManager.requestWhenInUseAuthorization()
            }
        }
    }

    func stopRequestingLocation() {
        locationManager.stopRequestingLocation()
    }

    func loadMore() {
        if service.canLoadMore() {
            service.increaseOffset()
            getSearchStoreList()
        }
    }

    private func getSearchStoreList() {
        if isRequestingAPI { return }

        isRequestingAPI = true
        searchParams.searchVoucher = false
        service.getList(params: searchParams) { [weak self] response, success in
            guard let self = self else { return }
            if success {
                if let response = response as? NearbyBrandStoreResponse {
                    guard self.noError(from: response) else {
                        self.isRequestingAPI = false
                        return
                    }

                    if let total = response.data?.total {
                        self.totalItems = Int(total) ?? 0
                    }

                    if let storeList = response.data?.storeList {
                        self.service.numberOfItemsReceived = storeList.count
                        self.suggestItems.append(contentsOf: storeList)
                        self.delegate?.requestSuccess()
                    }

                    self.isRequestingAPI = false
                }
            } else {
                self.isRequestingAPI = false
                self.showError()
            }
        }
    }

    func showError(message: String = "api.request_fail".localized) {
        delegate?.showError(message: message)
    }
}

extension MerchantSearchPresenter: CurrentLocationManagerProtocol {
    func locationDidUpdate(coordinate: CLLocationCoordinate2D) {
        searchParams.lat = String(coordinate.latitude)
        searchParams.long = String(coordinate.longitude)

        clearAllData()
        searchParams.allowLocation = true
        getSearchStoreList()
    }

    func locationDidFailRequest() {
        refresh()
    }
}
