//
//  NewsDetailPresenter.swift
//  MyPoint
//
//  Created by Nam Vu on 2/17/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

class NewsDetailPresenter: APIResponseMethods {

    weak var delegate: BaseProtocols?
    private let service = MainServices()

    enum ContentType: String {
        case text = "text"
        case image = "image"
        case voucher = "voucher"
        case brand = "brand"
        case pageLink = "page_link"
        case header = "header"

        static func getType(from value: String) -> ContentType {
            switch value {
            case ContentType.text.rawValue:
                return .text
            case ContentType.image.rawValue:
                return .image
            case ContentType.voucher.rawValue:
                return .voucher
            case ContentType.brand.rawValue:
                return .brand
            case ContentType.pageLink.rawValue:
                return .pageLink
            default:
                return .header
            }
        }
    }

    struct GeneralPage: PageProperties {
        var contentCaption: String
        var contentText: String
        var type: ContentType
        var convertedImage: UIImage?

        let htmlString: NSAttributedString

        init(caption: String, text: String, type: ContentType) {
            contentCaption = caption
            contentText = text
            htmlString = text.htmlToAttributedString ?? NSAttributedString()

            let defaultImage = UIImage(named: "alter")
            if let url = URL(string: contentText), let imageData = NSData(contentsOf: url) {
                let image = UIImage(data: imageData as Data) ?? defaultImage
                convertedImage = image
            } else {
                convertedImage = defaultImage
            }

            self.type = type
        }
    }

    struct Header: PageProperties {
        var contentCaption: String
        var contentText: String
        let thumbnail: String
        var type: ContentType
        var convertedImage: UIImage?

        init(caption: String, text: String, type: ContentType, thumbnail: String) {
            contentCaption = caption
            contentText = text
            self.type = type
            self.thumbnail = thumbnail

            let defaultImage = UIImage(named: "alter")
            if let url = URL(string: thumbnail), let imageData = NSData(contentsOf: url) {
                let image = UIImage(data: imageData as Data) ?? defaultImage
                convertedImage = image
            } else {
                convertedImage = defaultImage
            }
        }
    }

    var pageId = ""
    private(set) var displayItems = [PageProperties]()

    func requestData() {
        service.getPageData(pageId: pageId) { [weak self] response, success in
            guard let self = self else { return }
            if success {
                if let response = response as? PageDetailResponse {
                    guard self.noError(from: response) else { return }
                    let detail = response.data?.pageDetail

                    let headerItem = Header(caption: detail?.title ?? "",
                                            text: detail?.publishAtDate ?? "",
                                            type: .header,
                                            thumbnail: detail?.thumbnail ?? "")
                    self.displayItems.append(headerItem)

                    let items = detail?.items ?? []
                    for item in items {
                        var newItem: PageProperties
                        let type = ContentType.getType(from: item.mediaType ?? "")
                        if type == .pageLink {
                            newItem = GeneralPage(caption: item.contentCaption ?? "",
                                                  text: "",
                                                  type: .text)
                            self.displayItems.append(newItem)

                            let pages = item.pages ?? []
                            for page in pages {
                                let newPage = NewsModel(with: page)
                                self.displayItems.append(newPage)
                            }

                        } else {
                            newItem = GeneralPage(caption: item.contentCaption ?? "",
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

protocol PageProperties {
    var contentCaption: String { get set }
    var contentText: String { get set }
    var type: NewsDetailPresenter.ContentType { get set }
    var convertedImage: UIImage? { get set }
}
