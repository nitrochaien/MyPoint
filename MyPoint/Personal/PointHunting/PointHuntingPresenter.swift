//
//  PointHuntingPresenter.swift
//  MyPoint
//
//  Created by Nam Vu on 1/21/21.
//  Copyright © 2021 NamDV. All rights reserved.
//

import Foundation

final class PointHuntingPresenter: APIResponseMethods {
    weak var delegate: BaseProtocols?
    private let service = PointHuntingService()
    private(set) var achievements = [AchievementModel]()

    func refreshData() {
        service.resetOffset()
        requestData()
    }

    func loadMore() {
        if service.canLoadMore() {
            requestData()
        }
    }

    private func requestData() {
        service.getAchievementList { [weak self] response, success in
            guard let self = self else { return }
            if success {
                if let response = response as? AchievementResponse {
                    guard self.noError(from: response) else { return }

                    self.achievements = response.data?.achievements?.map({ data -> AchievementModel in
                        return .init(data)
                    }) ?? []
                    self.service.increaseOffset()
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
