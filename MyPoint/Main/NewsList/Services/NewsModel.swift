//
//  NewsModel.swift
//  MyPoint
//
//  Created by Nam Vu on 1/16/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

struct NewsModel: PageProperties {
    var contentCaption: String
    var contentText: String
    var type: NewsDetailPresenter.ContentType
    let id: String
    let subText: NSAttributedString
    var convertedImage: UIImage?

    init(with data: NewsItem) {
        contentCaption = data.thumbnail ?? ""
        contentText = data.pageTitle ?? ""
        subText = data.chapeau?.htmlToAttributedString ?? NSAttributedString()
        id = data.id ?? ""
        type = .pageLink

        let defaultImage = UIImage(named: "alter")
        if let url = URL(string: contentText), let imageData = NSData(contentsOf: url) {
            let image = UIImage(data: imageData as Data) ?? defaultImage
            convertedImage = image
        } else {
            convertedImage = defaultImage
        }
    }

    init(with data: Page) {
        contentCaption = data.thumbnail ?? ""
        contentText = data.title ?? ""
        subText = data.chapeau?.htmlToAttributedString ?? NSAttributedString()
        id = data.pageid ?? ""
        type = .pageLink

        let defaultImage = UIImage(named: "alter")
        if let url = URL(string: contentText), let imageData = NSData(contentsOf: url) {
            let image = UIImage(data: imageData as Data) ?? defaultImage
            convertedImage = image
        } else {
            convertedImage = defaultImage
        }
    }
}

struct MerchantInfoModel: PageMerchantProperties {  
    var contentCaption: String
    var contentText: String
    var type: NewMerchantInfoViewController.ContentType
    let id: String
    let subText: NSAttributedString

    init(with data: NewsItem) {
        contentCaption = data.thumbnail ?? ""
        contentText = data.pageTitle ?? ""
        subText = data.chapeau?.htmlToAttributedString ?? NSAttributedString()
        id = data.id ?? ""
        type = .pageLink
    }

    init(with data: Page) {
        contentCaption = data.thumbnail ?? ""
        contentText = data.title ?? ""
        subText = data.chapeau?.htmlToAttributedString ?? NSAttributedString()
        id = data.pageid ?? ""
        type = .pageLink
    }
}
