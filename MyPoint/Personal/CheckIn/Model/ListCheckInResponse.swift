//
//  ListCheckInResponse.swift
//  MyPoint
//
//  Created by Nam Vu on 3/8/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

// MARK: - ListCheckinResponse
struct ListCheckinResponse: Codable, APIHeaderResponse {
    var status, errorCode, errorMessage: String?
    var blockedReason: String?
    let api, version, lang, tzName: String?
    let tzOffset, requestTime, responseTime: String?
    let errorNumber: String?
    let data: ListCheckinData?

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
struct ListCheckinData: Codable {
    let counters: [Counter]?
}

// MARK: - Counter
struct Counter: Codable {
    let counterName, counterPeriodType: String?
    let counterValues: CounterValues?

    enum CodingKeys: String, CodingKey {
        case counterName = "counter_name"
        case counterPeriodType = "counter_period_type"
        case counterValues = "counter_values"
    }
}

enum CounterValues: Codable {
    case counterValue(CounterValue)
    case counterValueArray([CounterValue])

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode([CounterValue].self) {
            self = .counterValueArray(x)
            return
        }
        if let x = try? container.decode(CounterValue.self) {
            self = .counterValue(x)
            return
        }
        throw DecodingError.typeMismatch(CounterValues.self,
                                         DecodingError.Context(codingPath: decoder.codingPath,
                                                               debugDescription: "Wrong type for CounterValues"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .counterValue(let x):
            try container.encode(x)
        case .counterValueArray(let x):
            try container.encode(x)
        }
    }
}

// MARK: - CounterValue
struct CounterValue: Codable {
    let counterPeriodValue, counterValue: String?

    enum CodingKeys: String, CodingKey {
        case counterPeriodValue = "counter_period_value"
        case counterValue = "counter_value"
    }

    var checkedIn: Bool {
        return counterValue ?? "" == "1"
    }
}
