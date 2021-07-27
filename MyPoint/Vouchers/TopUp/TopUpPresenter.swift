//
//  TopUpPresenter.swift
//  MyPoint
//
//  Created by Nam Vu on 1/18/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

protocol TopUpPresenterDelegate: BaseProtocols {
    func didGetBanks()
    func didRedeemSuccess()
}

final class TopUpPresenter: APIResponseMethods {
    var telcos = [TelcoSelectionModel]()

    private let services = TelcoServices()

    var banks = [ChooseBankPresenter.BankModel]()
    weak var delegate: TopUpPresenterDelegate?

    var selectedTelco: TelcoSelectionModel? {
        return telcos.first(where: { model -> Bool in
            return model.isSelected
        })
    }

    func requestBankList() {
        banks = [
            .init(id: "0",
                  icon: "bvb",
                  name: "BaoViet Bank"),
            .init(id: "1",
                  icon: "bidv",
                  name: "BIDV")
        ]
        delegate?.didGetBanks()
    }

    var point: Double {
        return selectedTelco?.selectedValue?.priceValue ?? 0
    }

    var isValidBalance: Bool {
        guard let balance = Storage.shared.loginData?.workingSite?.customerBalance?.amount else { return false }
        return balance >= point
    }

    func getTopupList() {
        telcos.removeAll()
        
        services.getTopupList { [weak self] response, success in
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
        guard let productId = selectedTelco?.selectedValue?.id else { return }
        services.redeemTopup(productId: productId) { [weak self] response, success in
            guard let self = self else { return }
            if success {
                if let response = response as? MobileServiceRedeemResponse {
                    guard self.noError(from: response) else { return }
                    if let itemId = response.data?.itemId {
                        Storage.shared
                            .loginData?
                            .workingSite?
                            .customerBalance?.setNewAmount(with: response.data?.customerBalance)
                        self.delegate?.didRedeemSuccess()
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
