//
//  NewsPresenter.swift
//  MyPoint
//
//  Created by Nam Vu on 1/16/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

class NewsPresenter: APIResponseMethods {

    weak var delegate: BaseProtocols?
    var newsList = [NewsModel]()

    private let service = NewsService()

    func refreshNewsList() {
        service.resetOffset()
        newsList.removeAll()

        getNewsList()
    }

    func loadMore() {
        if service.canLoadMore() {
            service.increaseOffset()
            getNewsList()
        }
    }

    func getNewsList() {
        service.getNewsList { [weak self] (response, success) in
            guard let self = self else { return }
            if success {
                if let response = response as? NewsResponse {
                    guard self.noError(from: response) else { return }
                    let newData = response.data?.items?.map({ (item) -> NewsModel in
                        return .init(with: item)
                    }) ?? []
                    
                    self.service.numberOfItemsReceived = newData.count
                    self.newsList.append(contentsOf: newData)

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
