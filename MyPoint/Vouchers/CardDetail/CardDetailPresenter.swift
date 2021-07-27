//
//  CardDetailPresenter.swift
//  MyPoint
//
//  Created by Nam Vu on 11/16/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

typealias ProductId = String

protocol CardDetailDelegate: BaseProtocols {
    func display(_ card: CardDetailPresenter.Card)
}

final class CardDetailPresenter: APIResponseMethods {
    private let service = VoucherServices()
    weak var delegate: CardDetailDelegate?

    var id: ProductId = ""

    private(set) var card: Card!

    struct Card {
        let thumbnail: String
        let value: String
        let brandName: String
        let used: Bool
        let code: String
        let series: String
        let dueDate: String

        init(_ data: UsableVoucher?) {
            thumbnail = data?.brand?.logo ?? ""
            let price = Double(data?.prices?.first?.originalPrice ?? "") ?? 0
            value = String(format: "voucher.voucher_value".localized,
                           price.formattedWithSeparator)
            brandName = data?.brand?.brandName ?? ""
            code = data?.codeSecret ?? ""
            let serial = data?.serial ?? ""
            series = String(format: "voucher.serial".localized, serial)
            let statusCode = data?.statusCode ?? ""
            used = statusCode.caseInsensitiveCompare("USED") == .orderedSame
            dueDate = data?.expiredTime?.dateToString(fromFormat: DateFormat.server,
                                                      DateFormat.myVoucher) ?? ""
        }
    }

    func getDetail() {
        service.getUsableVoucherDetail(voucherId: id) { [weak self] (response, success) in
            guard let self = self else { return }
            if success {
                if let response = response as? UsableVoucherDetailResponse {
                    guard self.noError(from: response) else { return }
                    let card = Card(response.data?.item)
                    self.card = card
                    self.delegate?.display(card)
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
