//
//  BrandListPresenter.swift
//  MyPoint
//
//  Created by Nam Vu on 1/31/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

class BrandListPresenter: APIResponseMethods {
    weak var delegate: BaseProtocols?

    let service = VoucherServices()

    var items = [BrandItem]()
    var selectingBrand: BrandItem?

    struct BrandItem {
        let icon: String
        let title: String
        let id: String
        let isLocalImage: Bool
        let isSelecting: Bool

        init(_ item: BrandWaitingItem, isSelecting: Bool) {
            icon = item.logo ?? ""
            title = item.brandName ?? ""
            id = item.brandid ?? ""
            isLocalImage = false
            self.isSelecting = isSelecting
        }

        init(icon: String, title: String, isSelecting: Bool) {
            id = ""
            self.icon = icon
            self.title = title
            isLocalImage = true
            self.isSelecting = isSelecting
        }
    }

    func getBrandList() {
        let selectingId = selectingBrand?.id ?? ""
        service.getMyVoucherBrandWaitingList { [weak self] (response, success) in
            guard let self = self else { return }
            if success {
                if let response = response as? BrandWaitingListResponse {
                    guard self.noError(from: response) else { return }

                    let newItems = response.data?.items?.map({ item -> BrandItem in
                        return .init(item, isSelecting: item.brandid ?? "" == selectingId)
                    }) ?? []

                    self.items.removeAll()
                    self.items.append(.init(icon: "ic_interested_categories",
                                            title: "voucher.all_brands".localized,
                                            isSelecting: selectingId.isEmpty))
                    self.items.append(contentsOf: newItems)

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
