//
//  FrequencyQuestionPresenter.swift
//  MyPoint
//
//  Created by Nam Vu on 2/24/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

class FrequencyQuestionPresenter: APIResponseMethods {
    weak var delegate: BaseProtocols?

    private let service = SettingServices()

    enum PageType: String {
        case faq = "FAQ"
        case agreement = "AGREEMENT"
    }
    var type = PageType.faq

    var items = [NewsModel]()

    func requestData() {
        service.getQuestions(type: type) { [weak self] response, success in
            guard let self = self else { return }
            if success {
                if let response = response as? NewsResponse {
                    guard self.noError(from: response) else { return }
                    self.items = response.data?.items?.map({ (item) -> NewsModel in
                        return .init(with: item)
                    }) ?? []
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
