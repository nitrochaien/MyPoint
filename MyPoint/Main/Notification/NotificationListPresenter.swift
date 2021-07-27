//
//  NotificationListPresenter.swift
//  MyPoint
//
//  Created by Nam Vu on 1/9/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

protocol NotificationListPresenterDelegate: BaseProtocols {
    func didDeleteNotification(index: Int)
    func didMarkNotification(at index: Int)
}

class NotificationListPresenter: APIResponseMethods {

    var data = [NotificationItem]()
    var unreadItems = 0

    weak var delegate: NotificationListPresenterDelegate?

    private let service = NotificationServices()

    func refresh() {
        service.resetOffset()
        data.removeAll()

        requestData()
    }

    func loadMore() {
        if service.canLoadMore() {
            service.increaseOffset()
            requestData()
        }
    }

    func requestData() {
        service.getList { [weak self] (response, success) in
            guard let self = self else { return }
            if success {
                if let response = response as? NotificationListResponse {
                    guard self.noError(from: response) else { return }
                    let newData = response.data?.listItems?.map({ item -> NotificationItem in
                        return .init(with: item)
                    }) ?? []

                    self.service.numberOfItemsReceived = newData.count
                    self.data.append(contentsOf: newData)

                    self.unreadItems = Int(response.data?.unread ?? "0") ?? 0

                    self.delegate?.requestSuccess()
                }
            } else {
                self.showError()
            }
        }
    }

    func deleteNotification(at index: Int) {
        NotificationServices().deleteNotification(id: data[index].id) { [weak self] (response, success) in
            guard let self = self else { return }
            if success {
                if let response = response as? GeneralResponse {
                    guard self.noError(from: response) else { return }
                    self.delegate?.didDeleteNotification(index: index)
                }
            } else {
                self.showError()
            }
        }
    }

    func deleteAllNotifications() {
        NotificationServices().deleteAllNotifications { [weak self] (response, success) in
            guard let self = self else { return }
            if success {
                if let response = response as? GeneralResponse {
                    guard self.noError(from: response) else { return }
                    self.data.removeAll()
                    self.delegate?.requestSuccess()
                }
            } else {
                self.showError()
            }
        }
    }

    func markNotificationAsSeen(at index: Int) {
        let id = data[index].id
        NotificationServices().getNotificationDetail(id: id) { [weak self] (response, success) in
            guard let self = self else { return }
            if success {
                if let response = response as? NotificationDetailResponse {
                    guard self.noError(from: response) else { return }
                    self.delegate?.didMarkNotification(at: index)
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
