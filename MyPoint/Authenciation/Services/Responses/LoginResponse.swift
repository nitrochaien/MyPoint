//
//  LoginResponse.swift
//  MyPoint
//
//  Created by Nam Vu on 1/5/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

// MARK: - LoginResponse
struct LoginResponse: Codable, APIHeaderResponse {
    var status, errorCode, errorMessage: String?
    var blockedReason: String?
    let api, version, lang, tzName: String?
    let tzOffset, requestTime, responseTime: String?
    let errorNumber: String?
    let data: LoginData?

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
struct LoginData: Codable {
    var workerSite: WorkerSite?
    var workingSite: WorkingSite?
    let accessToken: String?
    let remainingLoginFail: String?
    let unlockAfter: String?

    enum CodingKeys: String, CodingKey {
        case workerSite = "worker_site"
        case workingSite = "working_site"
        case accessToken = "access_token"
        case remainingLoginFail = "remaining_login_fail"
        case unlockAfter = "unlock_after_time"
    }

    var toUpdateProfileRequestModel: UpdateProfileRequestModel? {
        return
            UpdateProfileRequestModel(accessToken: accessToken ?? "",
                                      workerSiteId: workerSite?.id ?? "",
                                      fullName: workerSite?.fullname ?? "",
                                      nickname: workerSite?.nickname ?? "",
                                      dateOfBirth: workerSite?.birthday ?? "",
                                      gender: PersonalGender(gender: workerSite?.sex ?? ""),
                                      addressFull: workerSite?.addressFull ?? "",
                                      addressDistrictCode: workerSite?.locationDistrictCode ?? "",
                                      addressProvinceCode: workerSite?.locationProvinceCode ?? "",
                                      identificationNumber: workerSite?.identificationNumber ?? "",
                                      email: workerSite?.email ?? "")
    }
}

// MARK: - WorkerSite
struct WorkerSite: Codable {
    var id, fullname, nickname, avatar: String?
    var phoneNumber, birthday, sex, addressFull: String?
    var locationDistrictCode, locationDistrictName, locationProvinceCode, locationProvinceName: String?
    var identificationNumber, email: String?
    var sexLabel: String?

    enum CodingKeys: String, CodingKey {
        case id, fullname, nickname, avatar
        case phoneNumber = "phone_number"
        case birthday, sex
        case addressFull = "address_full"
        case locationDistrictCode = "location_district_code"
        case locationDistrictName = "location_district_name"
        case locationProvinceCode = "location_province_code"
        case locationProvinceName = "location_province_name"
        case identificationNumber = "identification_number"
        case sexLabel = "sex_label"
        case email
    }

    var usernameDisplay: String {
        var name: String
        if let nickname = nickname, !nickname.isEmpty {
            name = nickname
        } else if let username = fullname, !username.isEmpty {
            name = username
        } else {
            name = "main.customer".localized
        }
        return name
    }

    var image: UIImage? {
        let avatarString = avatar ?? ""
        let defaultImage = UIImage(named: "alter")
        if avatarString.isEmpty {
            return Storage.shared.localUserProfilePic ?? defaultImage
        }
        if let url = URL(string: avatarString), let imageData = NSData(contentsOf: url) {
            return UIImage(data: imageData as Data) ?? defaultImage
        }
        return defaultImage
    }
}

// MARK: - WorkingSite
struct WorkingSite: Codable {
    let id, name, avatar: String?
    var customerBalance: CustomerBalance?
    let primaryMembership: PrimaryMembership?
    
    enum CodingKeys: String, CodingKey {
        case id, name, avatar
        case customerBalance = "customer_balance"
        case primaryMembership = "primary_membership"
    }
}

struct CustomerBalance: Codable {
    let primaryCurrencyPoolCode, amountPending, amountExpired: String?
    var amountActive: String?

    enum CodingKeys: String, CodingKey {
        case primaryCurrencyPoolCode = "primary_currency_pool_code"
        case amountActive = "amount_active"
        case amountPending = "amount_pending"
        case amountExpired = "amount_expired"
    }

    var amountActiveDisplay: String {
        let amount = amountActive ?? "0"
        let doubleValue = Double(amount) ?? 0
        return String(format: "personal.point_value".localized, doubleValue.formattedWithSeparator)
    }

    var simpleAmountDisplay: String {
        let amount = amountActive ?? "0"
        let doubleValue = Double(amount) ?? 0
        return doubleValue.formattedWithSeparator
    }

    var amount: Double {
        let amount = amountActive ?? "0"
        return Double(amount) ?? 0
    }

    mutating func updateAmount(value: Double) {
        amountActive = String(amount + value)
    }

    mutating func setNewAmount(with balance: CustomerBalance?) {
        let value = balance?.amountActive
        guard let validValue = value, let number = Double(validValue) else {
            return
        }
        if number != 0 {
            amountActive = validValue
        }
    }
}

// MARK: - PrimaryMembership
struct PrimaryMembership: Codable {
    let accountNumber: String?
    let membershipLine: MembershipLine?
    let membershipType: MembershipType?
    let membershipLevel: MembershipLevel?
    let expirationDate: String?
    let membershipStatus, blockReasonCode: BlockReasonCode?

    enum CodingKeys: String, CodingKey {
        case accountNumber = "account_number"
        case membershipLine = "membership_line"
        case membershipType = "membership_type"
        case membershipLevel = "membership_level"
        case expirationDate = "expiration_date"
        case membershipStatus = "membership_status"
        case blockReasonCode = "block_reason_code"
    }
}

// MARK: - BlockReasonCode
struct BlockReasonCode: Codable {
    let code, blockReasonCodeDescription: String?

    enum CodingKeys: String, CodingKey {
        case code
        case blockReasonCodeDescription = "description"
    }
}

// MARK: - MembershipLevel
struct MembershipLevel: Codable {
    let levelid, levelCode, levelName: String?
    let levelLogo, levelTextColor: String?

    enum CodingKeys: String, CodingKey {
        case levelid = "level_id"
        case levelCode = "level_code"
        case levelName = "level_name"
        case levelLogo = "level_logo"
        case levelTextColor = "level_text_color"
    }
}

// MARK: - MembershipLine
struct MembershipLine: Codable {
    let lineid, lineCode, lineName: String?

    enum CodingKeys: String, CodingKey {
        case lineid = "line_id"
        case lineCode = "line_code"
        case lineName = "line_name"
    }
}

// MARK: - MembershipType
struct MembershipType: Codable {
    let typeid, typeCode, typeName: String?

    enum CodingKeys: String, CodingKey {
        case typeid = "type_id"
        case typeCode = "type_code"
        case typeName = "type_name"
    }
}
