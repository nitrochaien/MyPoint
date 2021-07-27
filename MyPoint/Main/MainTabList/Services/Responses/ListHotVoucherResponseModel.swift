//
//  ListHotVoucherResponseModel.swift
//  MyPoint
//
//  Created by Hieu Nguyen on 1/9/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

// MARK: - ListHotVoucherResponse
struct ListHotVoucherResponse: Codable, APIHeaderResponse {
    let api, version, lang: String?
    var blockedReason: String?
    let requestTime, responseTime: String?
    var status, errorMessage: String?
    var errorCode: String?
    let data: ListHotVoucherData?

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
struct ListHotVoucherData: Codable {
    let listItems: [HotVoucher]?

    enum CodingKeys: String, CodingKey {
        case listItems = "list_items"
    }
}

// MARK: - ListHotVoucher
struct HotVoucher: Codable {
    var voucherID, code, name, listItemDescription: String?
    var distance: String?
    var voucherTypeCode, voucherTypeName, voucherValue, startTime: String?
    var endTime: String?
    var prices: [Price]?
    var images: [Image]?
    var catalogue: Catalogue?
    var brand: Brand?
    var stock: String?
    var itemMode: String?
    
    enum CodingKeys: String, CodingKey {
        case voucherID = "voucher_id"
        case code, name
        case listItemDescription = "description"
        case voucherTypeCode = "voucher_type_code"
        case voucherTypeName = "voucher_type_name"
        case voucherValue = "voucher_value"
        case startTime = "start_time"
        case endTime = "end_time"
        case prices, images, catalogue, brand
        case distance, stock
        case itemMode = "import_mode"
    }
  
    var amount: Int {
      return Int(stock ?? "0") ?? 0
    }

   init() {
        self.voucherID = ""
        self.code = ""
        self.name = ""
        self.listItemDescription = ""
        self.voucherTypeCode = ""
        self.voucherTypeName = ""
        self.voucherValue = ""
        self.startTime = ""
        self.endTime = ""
        self.prices = []
        self.images = []
        self.catalogue = Catalogue()
        self.brand = Brand()
        self.distance = ""
        self.stock = ""
        self.itemMode = ""
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            self.voucherID = try container.decodeIfPresent(String.self, forKey: .voucherID)
            self.code = try container.decodeIfPresent(String.self, forKey: .code)
            self.name = try container.decodeIfPresent(String.self, forKey: .name)
            self.listItemDescription = try container.decodeIfPresent(String.self, forKey: .listItemDescription)
            self.voucherTypeCode = try container.decodeIfPresent(String.self, forKey: .voucherTypeCode)
            self.voucherTypeName = try container.decodeIfPresent(String.self, forKey: .voucherTypeName)
            self.voucherValue = try container.decodeIfPresent(String.self, forKey: .voucherValue)
            self.startTime = try container.decodeIfPresent(String.self, forKey: .startTime)
            self.endTime = try container.decodeIfPresent(String.self, forKey: .endTime)
            self.prices = try container.decodeIfPresent([Price].self, forKey: .prices)
            self.images = try container.decodeIfPresent([Image].self, forKey: .images)
            self.catalogue = try container.decodeIfPresent(Catalogue.self, forKey: .catalogue)
            self.brand = try container.decodeIfPresent(Brand.self, forKey: .brand)
            self.distance = try container.decodeIfPresent(String.self, forKey: .distance)
            self.itemMode = try container.decodeIfPresent(String.self, forKey: .itemMode)
            self.stock = try container.decodeIfPresent(String.self, forKey: .stock)
        } catch DecodingError.typeMismatch {
            if let string = try container.decodeIfPresent(Int.self, forKey: .stock) {
                self.stock = "\(string)"
            }
        }
    }
}

// MARK: - Price
struct Price: Codable {
    let channelCode, channelName, payPoint, originalPrice: String?

    enum CodingKeys: String, CodingKey {
        case channelCode = "channel_code"
        case channelName = "channel_name"
        case payPoint = "pay_point"
        case originalPrice = "original_price"
    }
}

struct Catalogue: Codable {
    let id, catalogueCode, catalogueName: String?
    let imageURL: String?

    enum CodingKeys: String, CodingKey {
        case id
        case catalogueCode = "catalogue_code"
        case catalogueName = "catalogue_name"
        case imageURL = "image_url"
    }

    init() {
        self.id = ""
        self.catalogueCode = ""
        self.catalogueName = ""
        self.imageURL = ""
    }
}
