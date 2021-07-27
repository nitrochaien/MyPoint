//
//  CashbackDetailPresenter.swift
//  MyPoint
//
//  Created by Nam Vu on 7/20/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

protocol CashbackDetailProtocol: BaseProtocols {
    func showBrandWebsite()
}

class CashbackDetailPresenter: APIResponseMethods {
    weak var delegate: CashbackDetailProtocol?
    private(set) var model: CashbackDetailModel?
    private(set) var displayItems = [PageProperties]()
    var id = ""

    private let service = CashbackService()

    var cannotOpenBrandWebsite: Bool {
        return model?.header.urlString.isEmpty ?? false
    }

    func requestData() {
        service.getCampaignDetail(id: id) { [weak self] response, success in
            guard let self = self else { return }
            if success {
                if let response = response as? CashbackDetailResponse {
                    self.model = .init(item: response.data?.item)

                    if let detail = response.data?.item?.brandPageAbout, !detail.isNull {
//                        let headerItem = NewsDetailPresenter.Header(caption: detail.title ?? "",
//                                                                    text: detail.publishAtDate ?? "",
//                                                                    type: .header,
//                                                                    thumbnail: detail.thumbnail ?? "")
//                        self.displayItems.append(headerItem)

                        let items = detail.items ?? []
                        for item in items {
                            var newItem: PageProperties
                            let type = NewsDetailPresenter.ContentType.getType(from: item.mediaType ?? "")
                            if type == .pageLink {
                                newItem = NewsDetailPresenter.GeneralPage(caption: item.contentCaption ?? "",
                                                                          text: "",
                                                                          type: .text)
                                self.displayItems.append(newItem)

                                let pages = item.pages ?? []
                                for page in pages {
                                    let newPage = NewsModel(with: page)
                                    self.displayItems.append(newPage)
                                }

                            } else {
                                newItem = NewsDetailPresenter.GeneralPage(caption: item.contentCaption ?? "",
                                                                          text: item.contentText ?? "",
                                                                          type: type)
                                self.displayItems.append(newItem)
                            }
                        }
                    }
                    self.delegate?.requestSuccess()
                }
            } else {
                self.showError()
            }
        }
    }

    func recordClickRequest() {
        service.recordClickRequest(id: id) { [weak self] _, success in
            guard let self = self else { return }
            if success {
                self.delegate?.showBrandWebsite()
            } else {
                self.showError()
            }
        }
    }

    func showError(message: String = "api.request_fail".localized) {
        delegate?.showError(message: message)
    }
}
