//
//  NotificationDetailPresenter.swift
//  MyPoint
//
//  Created by Nam Vu on 3/27/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation
import UIKit

class NotificationDetailPresenter: APIResponseMethods {

    weak var delegate: BaseProtocols?
    private let service = NotificationServices()

    var id = ""
    var title = ""
    var content = ""

    func getDetail() {
        service.getNotificationDetail(id: id) { [weak self] (response, success) in
            guard let self = self else { return }
            if success {
                if let response = response as? NotificationDetailResponse {
                    guard self.noError(from: response) else { return }
                    self.title = response.data?.notification?.title ?? ""
                    self.content = response.data?.notification?.body ?? ""
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
