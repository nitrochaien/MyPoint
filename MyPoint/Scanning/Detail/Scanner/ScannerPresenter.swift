//
//  ScannerPresenter.swift
//  MyPoint
//
//  Created by Nam Vu on 2/9/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

protocol ScannerPresenterDelegate: BaseProtocols {
    func didScanFailed()
}

class ScannerPresenter: APIResponseMethods {
    let service = VoucherServices()
    weak var delegate: ScannerPresenterDelegate?

    var voucherId = ""
    var voucherName = ""

    /// Generate by server
    var generatedCode = ""

    func redeemVoucher(with storeId: String) {
        service.redeemMyVoucher(voucherId: voucherId) { [weak self] (response, success) in
            guard let self = self else { return }
            if success {
                if let response = response as? MyVoucherRedeemResponse {
                    guard self.noError(from: response) else {
                        self.delegate?.didScanFailed()
                        return
                    }
                    self.generatedCode = response.data?.voucherCode ?? ""
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
