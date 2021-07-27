//
//  IntroductionPresenter.swift
//  MyPoint
//
//  Created by Nam Vu on 3/9/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

protocol IntroductionPresenterProtocol: BaseProtocols {
    func didGetTroubleshootingConfig(_ enableMode: Bool)
}

class IntroductionPresenter: APIResponseMethods {
    weak var delegate: IntroductionPresenterProtocol?

    private let service = SettingServices()
    private let troubleshootingService = TroubleshootingService()

    var items = [NewsModel]()
    private(set) var displayItems = [PageProperties]()

    func getIntroduction() {
        service.getIntroduction { [weak self] response, success in
            guard let self = self else { return }
            if success {
                if let response = response as? NewsResponse {
                    guard self.noError(from: response) else { return }
                    let items = response.data?.items?.map({ (item) -> NewsModel in
                        return .init(with: item)
                    }) ?? []

                    if let id = items.first?.id {
                        self.getDetail(with: id)
                    }
                }
            } else {
                self.showError()
            }
        }
    }

    func getDetail(with id: String) {
        MainServices().getPageData(pageId: id) { [weak self] response, success in
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

    func setTroubleshootingConfig() {
        troubleshootingService.getConfig { [weak self] response, success in
            guard let self = self else { return }
            if success {
                if let response = response as? TroubleshootingResponse {
                    guard self.noError(from: response) else { return }

                    if let config = response.data?.config,
                        let url = config.developerBaseurl, !url.isEmpty,
                        let siteId = config.developerSiteid, !siteId.isEmpty {
                        devAPI.url = url
                        devAPI.siteId = siteId
                        self.delegate?.didGetTroubleshootingConfig(true)
                    } else {
                        self.delegate?.didGetTroubleshootingConfig(false)
                    }
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
