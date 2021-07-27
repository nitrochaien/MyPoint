//
//  GivePointPresenter.swift
//  MyPoint
//
//  Created by Nam Vu on 2/14/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

class GivePointPresenter: APIResponseMethods {
    let model = GivePointModel()

    private let service = GivePointServices()

    weak var delegate: BaseProtocols?

    var isValidInput: Bool {
        let hasPoint = !model.point.isEmpty
        let hasUser = !model.name.isEmpty

        return hasPoint && hasUser
    }

    var transactionId = ""

    var isValidPoint: Bool {
        let balanceString = Storage.shared.loginData?.workingSite?.customerBalance?.amountActive ?? ""
        let validPoint = model.point.replacingOccurrences(of: ".", with: "")
        if let point = Double(validPoint), let balanceDouble = Double(balanceString) {
            let validMinimumPoint = point >= 5000
            let validMaximumPoint = point <= balanceDouble * 0.7
            let validMuliple = point.truncatingRemainder(dividingBy: 100) == 0
            return validMinimumPoint && validMaximumPoint && validMuliple
        }
        return false
    }

    func checkTransfer(_ password: String) {
        service.checkTransfer(password: password) { [weak self] (response, success) in
            guard let self = self else { return }
            if success {
                if let response = response as? CheckTransferPasswordResponse {
                    guard self.noError(from: response) else { return }
                    self.requestTransfer()
                }
            } else {
                self.showError()
            }
        }
    }

    func requestTransfer() {
        service.requestTransfer(model: model) { [weak self] (response, success) in
            guard let self = self else { return }
            if success {
                if let response = response as? RequestTransferResponse {
                    guard self.noError(from: response) else { return }
                    Storage.shared
                        .loginData?
                        .workingSite?
                        .customerBalance?.setNewAmount(with: response.data?.customerBalance)
                    
                    self.transactionId = response.data?.transactionId ?? ""
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
