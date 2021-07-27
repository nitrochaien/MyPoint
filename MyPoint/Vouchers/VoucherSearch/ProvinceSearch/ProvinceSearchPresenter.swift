//
//  ProvinceSearchPresenter.swift
//  MyPoint
//
//  Created by Hieu Nguyen on 2/10/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation
import Localize

class ProvinceSearchPresenter: APIResponseMethods {

    private let service = MainServices()
    var mainList = [DisplayItem]()
    var filteredList = [DisplayItem]()
    var selectedItem: DisplayItem?
    weak var delegate: BaseProtocols?

    typealias DataType = (type: ListType, code: String)
    var dataType: DataType = (type: .district, code: "")

    class DisplayItem: Equatable {
        let name: String
        let code: String
        var isSelected: Bool

        init(name: String, code: String, isSelected: Bool) {
            self.name = name
            self.code = code
            self.isSelected = isSelected
        }

        init() {
            name = "Hà Nội"
            code = ""
            isSelected = false
        }

        static func == (lhs: DisplayItem, rhs: DisplayItem) -> Bool {
            return lhs.code == rhs.code
        }
    }

    enum ListType {
        case province
        case district
    }

    var noFilter: Bool {
        return filteredList.count == mainList.count
    }

    func getListProvince(countryCode: String) {
        service.getListProvinces(countryCode: countryCode) { [weak self] (response, success) in
            guard let self = self else { return }
            if success {
                if let response = response as? ProvinceSearchResponse {
                    guard self.noError(from: response) else { return }
                    if let newData = response.data?.listItems, newData.count > 0 {
                        self.mainList = newData.map({ province -> DisplayItem in
                            return .init(name: province.cityName ?? "",
                                         code: province.cityCode ?? "",
                                         isSelected: province.cityCode == self.selectedItem?.code ?? "")
                        })
                        self.filteredList = self.mainList
                        self.delegate?.requestSuccess()
                    } else {
                        self.showError(message: "api.empty".localized)
                    }
                }
            } else {
                self.showError()
            }
        }
    }

    func getListDistrict(provinceCode: String) {
        service.getListDistrict(provinceCode: provinceCode) { [weak self] (response, success) in
            guard let self = self else { return }
            if success {
                if let response = response as? DistrictListResponse {
                    guard self.noError(from: response) else { return }
                    if let newData = response.data?.listItems, newData.count > 0 {
                        self.mainList = newData.map({ district -> DisplayItem in
                            let code = district.districtCode ?? ""
                            return .init(name: district.districtName ?? "",
                                         code: code,
                                         isSelected: code == self.selectedItem?.code ?? "")
                        })
                        self.filteredList = self.mainList
                        self.delegate?.requestSuccess()
                    } else {
                        self.showError(message: "api.empty".localized)
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
