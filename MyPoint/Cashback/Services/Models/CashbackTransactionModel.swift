//
//  CashbackTransactionModel.swift
//  MyPoint
//
//  Created by Nam Vu on 7/17/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

struct CashbackTransactionModel {
    enum TransactionType: Int {
        case pending = 0, approved, voided, cancelled

        var params: [String: Any] {
            switch self {
            case .pending:
                return [
                    "status": "0",
                    "is_confirmed": "0",
                    "customer_is_rewarded": "0"
                ]
            case .approved:
                return [
                    "status": "1",
                    "is_confirmed": "0",
                    "customer_is_rewarded": "0"
                ]
            case .voided:
                return [
                    "status": "1",
                    "is_confirmed": "1",
                    "customer_is_rewarded": "1"
                ]
            case .cancelled:
                return [
                    "status": "2",
                    "is_confirmed": "0",
                    "customer_is_rewarded": "0"
                ]
            }
        }
    }

    let point: String
    let pointTitle: String
    let transactionGroup: [CashbackTransactionGroup]

    init(type: TransactionType) {
        point = "+50"
        transactionGroup = [.init(type: type)]

        switch type {
        case .approved:
            pointTitle = "Tổng số điểm đã duyệt"
        case .voided:
            pointTitle = "Tổng số điểm đã hoàn"
        case .cancelled:
            pointTitle = ""
        case .pending:
            pointTitle = "Tổng số điểm chờ duyệt"
        }
    }

    init(type: TransactionType, data: CashbackTransactionData?) {
        let reward = Int(Double(data?.summary?.totalRewardValue ?? "")?.ceil ?? 0)
        point = "+\(reward)"

        let items = data?.listItems ?? []
        var groups = [CashbackTransactionGroup]()
        for item in items {
            let dateString = item.atSalesTime?.dateToString(fromFormat: DateFormat.server,
                                                            DateFormat.chart) ?? ""
            let validDateString = dateString.capitalizingFirstLetter()
            if let index = groups.firstIndex(where: { group -> Bool in
                return group.header == validDateString
            }) {
                groups[index].transactions.append(.init(type: type, item: item))
            } else {
                groups.append(.init(type: type, items: [item]))
            }
        }
        transactionGroup = groups

        switch type {
        case .approved:
            pointTitle = "Tổng số điểm đã duyệt"
        case .voided:
            pointTitle = "Tổng số điểm đã hoàn"
        case .cancelled:
            pointTitle = ""
        case .pending:
            pointTitle = "Tổng số điểm chờ duyệt"
        }
    }
}

struct CashbackTransactionGroup {
    let header: String
    var transactions: [CashbackTransaction]

    init(type: CashbackTransactionModel.TransactionType) {
        header = "Tháng 8/2019"
        transactions = Array(repeating: .init(type: type), count: 4)
    }

    init(type: CashbackTransactionModel.TransactionType, items: [CashbackTransactionItem]?) {
        transactions = items?.map({ item -> CashbackTransaction in
            return .init(type: type, item: item)
        }) ?? []

        let dateString = items?.first?
            .atSalesTime?.dateToString(fromFormat: DateFormat.server,
                                       DateFormat.chart)
        header = dateString?.capitalizingFirstLetter() ?? ""
    }
}

struct CashbackTransaction {
    let thumbnail: String
    let code: String
    let time: String
    let value: String
    let desc: String
    let brand: String
    let type: CashbackTransactionModel.TransactionType

    let codeTitle = "Mã giao dịch"
    let timeTitle = "Thời gian"
    let valueTitle = "Giá trị đơn hàng"
    let descTitle: String

    init(type: CashbackTransactionModel.TransactionType) {
        thumbnail = ""
        code = "9876524324324"
        time = "14/08/2019 20:12"
        value = "300.000"
        brand = "Shopee"
        self.type = type

        switch type {
        case .approved, .pending:
            descTitle = "Điểm MyPoint sẽ hoàn"
            desc = "+50"
        case .voided:
            descTitle = "Điểm MyPoint đã hoàn"
            desc = "+50"
        case .cancelled:
            descTitle = "Trạng thái"
            desc = "Đã huỷ"
        }
    }

    init(type: CashbackTransactionModel.TransactionType, item: CashbackTransactionItem) {
        thumbnail = item.brand?.logo ?? ""
        code = item.atOrderid ?? ""
        let dateString = item.atSalesTime?.dateToString(fromFormat: DateFormat.server, DateFormat.profile) ?? ""
        time = dateString.capitalizingFirstLetter()
        brand = item.brand?.brandName ?? ""
        value = Double(item.atProductPrice ?? "")?.formattedWithSeparator ?? ""
        self.type = type

        let reward = Int(Double(item.customerRewardedValue ?? "")?.ceil ?? 0)
        switch type {
        case .approved, .pending:
            descTitle = "Điểm MyPoint sẽ hoàn"
            desc = "+\(reward)"
        case .voided:
            descTitle = "Điểm MyPoint đã hoàn"
            desc = "+\(reward)"
        case .cancelled:
            descTitle = "Trạng thái"
            desc = "Đã huỷ"
        }
    }
}
