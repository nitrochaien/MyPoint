//
//  RankingPresenter.swift
//  MyPoint
//
//  Created by Hieu Nguyen on 2/12/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

protocol RankingProtocols: NSObjectProtocol {
    func showError(message: String)

    func showListRanking()
}

class RankingPresenter: APIResponseMethods {

    private let services = PersonalServices()
    
    var listCustomer = [Model]()

    struct Model {
        let rank: Int
        let name: String
        let image: String
        let value: String
        let id: String
        let customerSiteId: String

        init(value: CustomerList) {
            rank = Int(value.ranking ?? "") ?? 0
            name = value.customerFullname ?? ""
            image = ""
            self.value = value.counterValue ?? ""
            id = value.customerID ?? ""
            customerSiteId = value.customerSiteID ?? ""
        }

        init(rank: Int, name: String, image: String, value: String, id: Int, customerSiteId: Int) {
            self.rank = rank
            self.name = name
            self.image = image
            self.value = value
            self.id = String(id)
            self.customerSiteId = String(customerSiteId)
        }
    }

    weak var delegate: RankingProtocols?

    func getListRanking() {
        services.getRankingAll { [weak self] (response, success) in
            guard let self = self else { return }
            if success {
                if let response = response as? RankingResponse {
                    guard self.noError(from: response) else { return }
                    if let customerList = response.data?.customerList {
                        self.listCustomer = customerList.map({ customer -> Model in
                            return .init(value: customer)
                        })
                        self.delegate?.showListRanking()
                    } else {
                        self.showError(message: "api.empty".localized)
                    }

                    self.delegate?.showListRanking()
                }
            } else {
                self.showError(message: "api.request_fail".localized)
            }
        }
    }

    func showError(message: String = "api.request_fail".localized) {
        delegate?.showError(message: message)
    }
}
