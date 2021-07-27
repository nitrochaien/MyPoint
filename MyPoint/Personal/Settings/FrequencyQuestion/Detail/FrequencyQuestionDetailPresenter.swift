//
//  FrequencyQuestionDetailPresenter.swift
//  MyPoint
//
//  Created by Nam Vu on 3/25/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

class FrequencyQuestionDetailPresenter: APIResponseMethods {
    weak var delegate: BaseProtocols?
    private let service = MainServices()

    var pageId = ""
    var type = FrequencyQuestionPresenter.PageType.faq
    
    private(set) var displayItems = [PageProperties]()

    func requestData() {
        service.getPageData(pageId: pageId) { [weak self] response, success in
            guard let self = self else { return }
            if success {
                if let response = response as? PageDetailResponse {
                    guard self.noError(from: response) else { return }
                    let detail = response.data?.pageDetail

                    let headerItem = NewsDetailPresenter.Header(caption: detail?.title ?? "",
                                                                text: detail?.publishAtDate ?? "",
                                                                type: .header,
                                                                thumbnail: detail?.thumbnail ?? "")
                    self.displayItems.append(headerItem)

                    let items = detail?.items ?? []
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
