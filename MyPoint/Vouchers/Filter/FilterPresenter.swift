//
//  FilterPresenter.swift
//  MyPoint
//
//  Created by Nam Vu on 2/2/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

class FilterPresenter: APIResponseMethods {
    private let voucherService = VoucherServices()
    private let merchantService = MerchantServices()

    weak var delegate: BaseProtocols?
    var categories = [Category]()
    var filterItems = [FilterItemCollectionViewCell.FilterItem]()
    var districts = [ProvinceSearchPresenter.DisplayItem]()
    var selectedProvince: ProvinceSearchPresenter.DisplayItem?
    var defaultProvince: ProvinceSearchPresenter.DisplayItem?
    var properties: Properties!

    struct Properties {
        let categories: [Category]
        let province: ProvinceSearchPresenter.DisplayItem
        let districtCodes: [String]
    }

    class Category: Equatable {
        let title: String
        let code: String
        var isSelected: Bool
        var isFiltering: Bool
        let icon: String
        let id: String

        init(_ data: InterestedListItem) {
            title = data.categoryName ?? ""
            code = data.categoryCode ?? ""
            isSelected = false
            icon = data.imageurl ?? ""
            id = data.id ?? ""
            isFiltering = true
        }

        init(_ data: Brand) {
            title = data.brandName ?? ""
            code = data.brandCode ?? ""
            isSelected = false
            icon = data.images?.first?.imageURL ?? ""
            id = data.brandID ?? ""
            isFiltering = false
        }

        static func == (lhs: Category, rhs: Category) -> Bool {
            return rhs.code == lhs.code
        }
    }

    var requestProperties: Properties {
        let filteredCategories = categories.filter { category -> Bool in
            return category.isSelected
        }
        let provinceCode = selectedProvince
        let districtCodes = districts.filter { district -> Bool in
            return district.isSelected
        }.map { district -> String in
            return district.code
        }

        return Properties(categories: filteredCategories,
                          province: provinceCode ?? .init(),
                          districtCodes: districtCodes)
    }

    func requestData() {
        let group = DispatchGroup()
        getCategoryList(group)
        getListProvince(group, countryCode: "VN")

        group.notify(queue: DispatchQueue.main) {
            self.delegate?.requestSuccess()
        }
    }

    private func getCategoryList(_ group: DispatchGroup) {
        group.enter()
        voucherService.requestCategoryList { [weak self] (response, success) in
            guard let self = self else { return }
            if success {
                if let response = response as? InterestedResponse {
                    guard self.noError(from: response) else { return }
                    let newData = response.data?.listItems?.map({ item -> Category in
                        return .init(item)
                    }) ?? []
                    let selected = self.properties.categories.map { category -> String in
                        return category.id
                    }
                    for data in newData {
                        data.isSelected = selected.contains(data.id)
                        self.categories.append(data)
                    }
                }
            } else {
                self.showError()
            }
            group.leave()
        }
    }

    func getListProvince(_ group: DispatchGroup, countryCode: String) {
        group.enter()
        MainServices().getListProvinces(countryCode: countryCode) { [weak self] (response, success) in
            guard let self = self else { return }
            if success {
                if let response = response as? ProvinceSearchResponse {
                    guard self.noError(from: response) else { return }
                    if let newData = response.data?.listItems {
                        if let selected = newData.first(where: { province -> Bool in
                            return province.cityCode == self.properties.province.code
                        }) {
                            self.selectedProvince = .init(name: selected.cityName ?? "",
                                                          code: selected.cityCode ?? "",
                                                          isSelected: true)
                        } else {
                            self.selectedProvince = .init(name: newData.first?.cityName ?? "",
                                                          code: newData.first?.cityCode ?? "",
                                                          isSelected: true)
                            self.defaultProvince = self.selectedProvince
                        }
                        self.getListDistrict(group, provinceCode: self.selectedProvince?.code ?? "")
                    } else {
                        self.showError(message: "api.empty".localized)
                    }
                }
            } else {
                self.showError()
            }
            group.leave()
        }
    }

    func getListDistrict(_ group: DispatchGroup? = nil, provinceCode: String) {
        group?.enter()
        MainServices().getListDistrict(provinceCode: provinceCode) { [weak self] (response, success) in
            guard let self = self else { return }
            if success {
                if let response = response as? DistrictListResponse {
                    guard self.noError(from: response) else { return }
                    if let newData = response.data?.listItems {
                        let newDistrict = newData.map({ district -> ProvinceSearchPresenter.DisplayItem in
                            let code = district.districtCode ?? ""
                            return .init(name: district.districtName ?? "",
                                         code: code,
                                         isSelected: false)
                        })

                        for district in newDistrict {
                            if self.properties.districtCodes.contains(district.code) {
                                district.isSelected = true
                            }
                            self.districts.append(district)
                        }

                        if group == nil {
                            self.delegate?.requestSuccess()
                        }
                    } else {
                        self.showError(message: "api.empty".localized)
                    }
                    group?.leave()
                }
            } else {
                self.showError()
            }
        }
    }

    private func getFilterItems() {
        filterItems = [
            .init(id: 0, name: "filter.newest".localized, isSelected: false),
            .init(id: 1, name: "filter.hottest".localized, isSelected: false),
            .init(id: 2, name: "filter.most_stores".localized, isSelected: false),
            .init(id: 3, name: "filter.most_likes".localized, isSelected: false)
        ]
    }

    func createRequest(from type: FilterViewController.DataType) -> [String: Any] {
        switch type {
        case .merchant:
            break
        case .voucher:
            break
        }
        return [:]
    }

    func reset() {
        categories.forEach { category in
            category.isSelected = false
        }
        filterItems.forEach { item in
            item.isSelected = false
        }
        selectedProvince = defaultProvince
        districts.removeAll()
    }

    func showError(message: String = "api.request_fail".localized) {
        delegate?.showError(message: message)
    }
}
