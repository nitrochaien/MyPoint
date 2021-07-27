//
//  BrandDetailResponse.swift
//  MyPoint
//
//  Created by Hieu Nguyen on 2/26/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

// MARK: - BrandDetailResponse
struct BrandDetailResponse: Codable, APIHeaderResponse {
    var errorCode, errorMessage, status: String?
    var blockedReason: String?

    let api, version, lang, tzName: String?
    let tzOffset, requestTime, responseTime: String?
    let errorNumber: String?
    let data: DataBrandDetail?

    enum CodingKeys: String, CodingKey {
        case api, version, lang
        case tzName = "tz_name"
        case tzOffset = "tz_offset"
        case requestTime = "request_time"
        case responseTime = "response_time"
        case status
        case errorNumber = "error_number"
        case errorCode = "error_code"
        case errorMessage = "error_message"
        case blockedReason = "blocked_reason"
        case data
    }
}

// MARK: - DataClass
struct DataBrandDetail: Codable {
    let brand: BrandDetail?
}

// MARK: - Brand
struct BrandDetail: Codable {
    let organizationID, organizationCode, organizationName, brandID: String?
    let brandCode, brandName, contactName, phone: String?
    let mobile, fax, email, address1: String?
    let address2, address3, aboutBrandInWebsitePageID, city: String?
    let country: String?
    let website: String?
    let category: Category?
    let pointAccumulationRate: String?
    let logo: String?
    let images: [Image]?
    let pageAbout: Page?
    let likeId: String?

    enum CodingKeys: String, CodingKey {
        case organizationID = "organization_id"
        case organizationCode = "organization_code"
        case organizationName = "organization_name"
        case brandID = "brand_id"
        case brandCode = "brand_code"
        case brandName = "brand_name"
        case contactName = "contact_name"
        case phone, mobile, fax, email, address1, address2, address3
        case aboutBrandInWebsitePageID = "about_brand_in_website_page_id"
        case city, country, website, category
        case pointAccumulationRate = "point_accumulation_rate"
        case logo, images
        case pageAbout = "page_about"
        case likeId = "like_id"
    }
  
    init() {
      self.organizationID = ""
      self.organizationCode = ""
      self.organizationName = ""
      self.brandID = ""
      self.brandCode = ""
      self.brandName = ""
      self.contactName = ""
      self.phone = ""
      self.mobile = ""
      self.fax = ""
      self.email = ""
      self.address1 = ""
      self.address2 = ""
      self.address3 = ""
      self.aboutBrandInWebsitePageID = ""
      self.city = ""
      self.country = ""
      self.website = ""
      self.category = Category()
      self.pointAccumulationRate = ""
      self.logo = ""
      self.images = []
      self.pageAbout = Page()
      self.likeId = ""
    }
  
    var displayPointAccumulationRate: String? {
        let value = pointAccumulationRate?.dropLast() ?? "0"
        let doubleValue = Int(Double(value) ?? 0)
        return String(format: "%d", doubleValue)
    }

    var coverImages: [Image] {
        return images?.filter({ image -> Bool in
            return image.type == "COVER"
        }) ?? []
    }

    var backgroundImages: [Image] {
        return images?.filter({ image -> Bool in
            return image.type == "BACKGROUND"
        }) ?? []
    }
}

// MARK: - PageAbout
struct PageAbout: Codable {
    let pageID, title, subTitle, chapeau: String?
    let thumbnail: String?
    let publishAtDate: String?
    let items: [Content]?

    enum CodingKeys: String, CodingKey {
        case pageID = "page_id"
        case title
        case subTitle = "sub_title"
        case chapeau, thumbnail
        case publishAtDate = "publish_at_date"
        case items
    }
  
    init() {
      self.pageID = ""
      self.title = ""
      self.subTitle = ""
      self.chapeau = ""
      self.thumbnail = ""
      self.publishAtDate = ""
      self.items = []
    }
}

// MARK: - Item
struct Content: Codable {
    let contentText, mediaType, contentCaption, showOrder: String?

    enum CodingKeys: String, CodingKey {
        case contentText = "content_text"
        case mediaType = "media_type"
        case contentCaption = "content_caption"
        case showOrder = "show_order"
    }
}
