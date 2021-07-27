//
//  ListBrandResponseModel.swift
//  MyPoint
//
//  Created by Hieu Nguyen on 1/10/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

// MARK: - ListBrandResponseModel
struct ListBrandResponseModel: Codable, APIHeaderResponse {
    let api, version, lang: String?
    let requestTime, responseTime: String?
    var status, errorMessage: String?
    var errorCode: String?
    var blockedReason: String?
    let data: DataListBrand?

    enum CodingKeys: String, CodingKey {
        case api, version, lang
        case requestTime = "request_time"
        case responseTime = "response_time"
        case status
        case errorCode = "error_code"
        case errorMessage = "error_message"
        case blockedReason = "blocked_reason"
        case data
    }
}

// MARK: - DataClass
struct DataListBrand: Codable {
    let items: [Brand]?
    let start, limit: String?
}

// MARK: - Brand
struct Brand: Codable {
    let organizationID, organizationCode, organizationName, brandID: String?
    let brandCode, brandName, contactName, phone: String?
    let mobile, fax, email, address1: String?
    let address2, address3, city, country: String?
    let website, pointAccumulationRate: String?
    let category: Category?
    let logo: String?
    let images: [Image]?
    
    var displayPointAccumulationRate: String? {
        let value = pointAccumulationRate?.dropLast() ?? "0"
        let doubleValue = Int(Double(value) ?? 0)
        return String(format: "%d", doubleValue)
    }

    enum CodingKeys: String, CodingKey {
        case organizationID = "organization_id"
        case organizationCode = "organization_code"
        case organizationName = "organization_name"
        case brandID = "brand_id"
        case brandCode = "brand_code"
        case brandName = "brand_name"
        case contactName = "contact_name"
        case phone, mobile, fax, email, address1, address2, address3, city, country, website
        case pointAccumulationRate = "point_accumulation_rate"
        case category, logo, images
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
        self.city = ""
        self.country = ""
        self.website = ""
        self.pointAccumulationRate = ""
        self.category = Category()
        self.logo = ""
        self.images = []
    }
}

// MARK: - Image
struct Image: Codable {
    let id, type, caption: String?
    let imageURL: String?

    enum CodingKeys: String, CodingKey {
        case id, type, caption
        case imageURL = "image_url"
    }
}
