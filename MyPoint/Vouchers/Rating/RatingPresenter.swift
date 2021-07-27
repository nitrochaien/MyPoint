//
//  RatingPresenter.swift
//  MyPoint
//
//  Created by Nam Vu on 3/3/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation
import Localize

class RatingPresenter: APIResponseMethods {
    class RatingRequestModel {
        var stars: Int
        var reviewContent: String
        let id: String

        init(id: String) {
            self.id = id
            stars = 0
            reviewContent = ""
        }

        var toParams: [String: Any] {
            return [
                "access_token": Storage.shared.loginData?.accessToken ?? "",
                "object_class_name": "PRODUCT_VOUCHER",
                "lang": Localize.shared.currentLanguage,
                "review_content": reviewContent,
                "review_rating": String(stars)
            ]
        }
    }

    weak var delegate: BaseProtocols?
    private let service = VoucherServices()

    var requestModel: RatingRequestModel?

    func rateTransaction() {
        guard let model = requestModel else { return }
        service.rateTransaction(requestModel: model) { [weak self] response, success in
            guard let self = self else { return }
            if success {
                if let response = response as? GeneralResponse {
                    guard self.noError(from: response) else { return }
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
