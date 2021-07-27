//
//  UpdateProfileRequestModel.swift
//  MyPoint
//
//  Created by Nam Vu on 1/13/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation
import Localize

struct UpdateProfileRequestModel {
    var accessToken: String
    var workerSiteId: String
    var fullName: String
    var nickname: String
    var dateOfBirth: String
    var gender: PersonalGender
    var addressFull: String
    var addressDistrictCode: String
    var addressProvinceCode: String
    var identificationNumber: String
    var email: String

    init(accessToken: String,
         workerSiteId: String,
         fullName: String,
         nickname: String,
         dateOfBirth: String,
         gender: PersonalGender,
         addressFull: String,
         addressDistrictCode: String,
         addressProvinceCode: String,
         identificationNumber: String,
         email: String) {
        self.accessToken = accessToken
        self.workerSiteId = workerSiteId
        self.fullName = fullName
        self.nickname = nickname
        self.dateOfBirth = dateOfBirth
        self.gender = gender
        self.addressFull = addressFull
        self.addressDistrictCode = addressDistrictCode
        self.addressProvinceCode = addressProvinceCode
        self.identificationNumber = identificationNumber
        self.email = email
    }

    var toParams: [String: Any] {
        return [
            "access_token": accessToken,
            "worker_site_id": workerSiteId,
            "fullname": fullName,
            "nickname": nickname,
            "date_of_birth": dateOfBirth,
            "sex": gender.rawValue,
            "address_full": addressFull,
            "address_district_code": addressDistrictCode,
            "address_province_code": addressProvinceCode,
            "identification_number": identificationNumber,
            "email": email,
            "lang": Localize.shared.currentLanguage
        ]
    }
}

enum PersonalGender: String {
    case female = "F"
    case male = "M"
    case unknown = "U"
    case notAllowed = "N"

    init(gender: String) {
        switch gender {
        case PersonalGender.female.rawValue:
            self = .female
        case PersonalGender.male.rawValue:
            self = .male
        case PersonalGender.unknown.rawValue:
            self = .unknown
        case PersonalGender.notAllowed.rawValue:
            self = .notAllowed
        default:
            self = .unknown
        }
    }

    var display: String {
        switch self {
        case .female:
            return "edit.female".localized
        case .male:
            return "edit.male".localized
        case .unknown:
            return "edit.unknown".localized
        case .notAllowed:
            return ""
        }
    }
}
