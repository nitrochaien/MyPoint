//
//  GeneralResponse.swift
//  MyPoint
//
//  Created by Nam Vu on 1/5/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

struct GeneralResponse: Codable, APIHeaderResponse {
    var status: String?
    var errorCode: String?
    var errorMessage: String?
    var blockedReason: String?

    let api, version, lang: String?
    let requestTime, responseTime: String?

    enum CodingKeys: String, CodingKey {
        case api, version, lang
        case requestTime = "request_time"
        case responseTime = "response_time"
        case status
        case errorCode = "error_code"
        case errorMessage = "error_message"
        case blockedReason = "blocked_reason"
    }
}
