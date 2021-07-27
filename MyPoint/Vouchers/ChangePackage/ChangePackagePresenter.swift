//
//  ChangePackagePresenter.swift
//  MyPoint
//
//  Created by Nam Vu on 1/20/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

final class ChangePackagePresenter: APIResponseMethods {
    var telcos = [TelcoSelectionModel]()

    private let service = VoucherServices()
    private let telcoServices = TelcoServices()

    weak var delegate: BalanceDelegate?
    var points = 0

    var selectedTelco: TelcoSelectionModel? {
        return telcos.first(where: { model -> Bool in
            return model.isSelected
        })
    }

    var isValidBalance: Bool {
        guard let balance = Storage.shared.loginData?.workingSite?.customerBalance?.amount else { return false }
        return balance >= Double(points)
    }

    func getData() {
        telcos.removeAll()
        
        telcoServices.getMobileServiceList { [weak self] response, success in
            guard let self = self else { return }
            if success {
                if let response = response as? TelcoListResponse {
                    guard self.noError(from: response) else { return }
                    if let data = response.data {
                        let newProducts = data.products ?? []

                        newProducts.forEach { product in
                            if let first = self.telcos.first(where: { model -> Bool in
                                return model.code == product.brandCode ?? ""
                            }) {
                                if product.prices?.isEmpty == false {
                                    first.values.append(.init(data: product))
                                }
                            } else {
                                self.telcos.append(.init(data: product))
                            }
                        }
                        self.telcos.first?.isSelected = true
                        self.delegate?.requestSuccess()
                    }
                }
            } else {
                self.showError()
            }
        }
    }

    func redeem() {
        guard let product = selectedTelco?.selectedValue else { return }
        let count = points / Int(product.priceValue)

        telcoServices.redeemMobileService(productId: product.id, quantity: count) { [weak self] response, success in
            guard let self = self else { return }
            if success {
                if let response = response as? MobileServiceRedeemResponse {
                    guard self.noError(from: response) else { return }

                    Storage.shared
                        .loginData?
                        .workingSite?
                        .customerBalance?.setNewAmount(with: response.data?.customerBalance)

                    self.delegate?.didRedeemSuccess()
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
