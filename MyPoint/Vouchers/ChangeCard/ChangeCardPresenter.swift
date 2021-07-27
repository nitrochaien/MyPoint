//
//  ChangeCardPresenter.swift
//  MyPoint
//
//  Created by Nam Vu on 1/19/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation
import UIKit

protocol BalanceDelegate: BaseProtocols {
    func didRedeemSuccess(_ info: ChangeCardPresenter.CardInfo)
    func didRedeemSuccess()
}

extension BalanceDelegate where Self: UIViewController {
    func didRedeemSuccess(_ info: ChangeCardPresenter.CardInfo) {}
    func didRedeemSuccess() {}
}

final class ChangeCardPresenter: APIResponseMethods {
    var quickBuys: [QuickBuyModel] {
        return [
            .init(id: 0),
            .init(id: 1),
            .init(id: 2),
            .init(id: 3)
        ]
    }

    struct CardInfo {
        let dueDate: String
        let secretCode: String

        init(_ data: UsableVoucher?) {
            secretCode = data?.codeSecret ?? ""
            dueDate = data?.expiredTime?.dateToString(fromFormat: DateFormat.server,
                                                     DateFormat.myVoucher) ?? ""
        }
    }

    var telcos = [TelcoSelectionModel]()

    private let service = VoucherServices()
    private let telcoServices = TelcoServices()
    weak var delegate: BalanceDelegate?

    var point: Double {
        return selectedTelco?.selectedValue?.priceValue ?? 0
    }

    var selectedTelco: TelcoSelectionModel? {
        return telcos.first(where: { model -> Bool in
            return model.isSelected
        })
    }

    var isValidBalance: Bool {
        guard let balance = Storage.shared.loginData?.workingSite?.customerBalance?.amount else { return false }
        return balance >= point
    }

    func getMobileCardList() {
        telcos.removeAll()
        
        telcoServices.getMobileCardList { [weak self] response, success in
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
        telcoServices.redeemMobileCard(productId: productId) { [weak self] response, success in
            guard let self = self else { return }
            if success {
                if let response = response as? MobileServiceRedeemResponse {
                    guard self.noError(from: response) else { return }
                    if let itemId = response.data?.itemId {
                        Storage.shared
                            .loginData?
                            .workingSite?
                            .customerBalance?.setNewAmount(with: response.data?.customerBalance)

                        self.getCode(with: itemId)
                    }
                }
            } else {
                self.showError()
            }
        }
    }

    private func getCode(with itemId: String) {
        telcoServices.getMobileCardCode(itemId: itemId) { [weak self] response, success in
            guard let self = self else { return }
            if success {
                if let response = response as? UsableVoucherDetailResponse {
                    guard self.noError(from: response) else { return }
                    let card = CardInfo(response.data?.item)
                    self.delegate?.didRedeemSuccess(card)
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
