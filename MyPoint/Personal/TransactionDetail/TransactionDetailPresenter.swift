//
//  TransactionDetailPresenter.swift
//  MyPoint
//
//  Created by Nam Vu on 2/23/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

class TransactionDetailPresenter: APIResponseMethods {

    struct Value {
        let title: String
        let content: String
    }

    private let service = HistoryDetailService()

    var id = ""
    private(set) var pointChange = ""

    weak var delegate: BaseProtocols?

    var info1 = [Value]()
    var info2 = [Value]()

    func requestData() {
        service.getDetail(id: id) { [weak self] response, success in
            guard let self = self else { return }
            if success {
                if let response = response as? HistoryDetailResponse {
                    guard self.noError(from: response) else { return }

                    let info = response.data?.info
                    let dateTime = info?.transactionDatetime
                    let timeDisplay = dateTime?.dateToString(fromFormat: DateFormat.server,
                                                             DateFormat.history) ?? ""
                    self.info1 = [
                        .init(title: "transaction_detail.time".localized,
                              content: timeDisplay),
                        .init(title: "transaction_detail.type".localized,
                              content: info?.transactionTagDescription ?? ""),
                        .init(title: "transaction_detail.code".localized,
                              content: info?.transactionSequenceid ?? "")
                    ]

                    let redeem = Double(info?.redeemTotal ?? "") ?? 0
                    let reward = Double(info?.rewardTotal ?? "") ?? 0
                    let adjust = Double(info?.adjustTotal ?? "") ?? 0
                    let point = reward - redeem + adjust
                    if point >= 0 {
                        self.pointChange = "+\(point.formattedWithSeparator)"
                    } else {
                        self.pointChange = "\(point.formattedWithSeparator)"
                    }

                    self.delegate?.requestSuccess()
                }
            } else {
                self.showError()
            }
        }
    }

    func generateInfo() {
        info1 = [
            .init(title: "transaction_detail.time".localized,
                  content: "14 tháng 8, 2019 20:12"),
            .init(title: "transaction_detail.type".localized,
                  content: "Mua thẻ"),
            .init(title: "transaction_detail.code".localized,
                  content: "9876524324324")
        ]

        info2 = [
            .init(title: "transaction_detail.info".localized,
                  content: "Đổi thẻ điện thoại MobiFone"),
            .init(title: "transaction_detail.supplier".localized,
                  content: "MobiFone"),
            .init(title: "transaction_detail.fee".localized,
                  content: "Miễn phí"),
            .init(title: "transaction_detail.product".localized,
                  content: "Thẻ nạp mệnh giá 20.000"),
            .init(title: "transaction_detail.quantity".localized,
                  content: "1"),
            .init(title: "transaction_detail.detail".localized,
                  content: "Mã thẻ 098 888 99999\nSố seri: 099473763934936")
        ]
        delegate?.requestSuccess()
    }

    func showError(message: String = "api.request_fail".localized) {
        delegate?.showError(message: message)
    }
}
