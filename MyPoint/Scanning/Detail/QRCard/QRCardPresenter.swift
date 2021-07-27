//
//  QRCardPresenter.swift
//  MyPoint
//
//  Created by Nam Vu on 2/11/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

class QRCardPresenter: APIResponseMethods {
    enum CardType {
        case voucher, userInfo
    }

    var cardType = CardType.userInfo
    var code = Storage.shared.loginData?.workerSite?.id ?? ""

    /// Only use for voucher type
    var voucherName = ""
    var voucherImage = ""

    private let service = ScanningServices()
    weak var delegate: BaseProtocols?

    private var timer: Timer?

    func performUpdateCardNumberPeriodically() {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 120,
                                         target: self,
                                         selector: #selector(updateCardNumber),
                                         userInfo: nil,
                                         repeats: true)
        }
        timer?.fire()
    }

    func invalidateTimer() {
        timer?.invalidate()
        timer = nil
    }

    @objc private func updateCardNumber() {
        service.getOneTimeCardNumber { [weak self] response, success in
            guard let self = self else { return }
            if success {
                if let response = response as? OneTimeCodeResponse {
                    guard self.noError(from: response) else { return }

                    if let oneTimeCode = response.data?.oneTimeNumber {
                        self.code = oneTimeCode
                    }

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
