//
//  RequireInfoPresenter.swift
//  MyPoint
//
//  Created by Nam Vu on 2/9/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

class RequireInfoPresenter: APIResponseMethods {
    weak var delegate: BaseProtocols?
    private let service = PersonalServices()

    var nickname = ""
    var date = ""

    func updateProfile() {
        let validDate = date.dateToString(fromFormat: DateFormat.profile, DateFormat.profileRequest)
        let loginData = Storage.shared.loginData
        let model = UpdateProfileRequestModel(accessToken: loginData?.accessToken ?? "",
                                              workerSiteId: loginData?.workerSite?.id ?? "",
                                              fullName: loginData?.workerSite?.fullname ?? "",
                                              nickname: nickname,
                                              dateOfBirth: validDate,
                                              gender: PersonalGender(gender: loginData?.workerSite?.sex ?? ""),
                                              addressFull: loginData?.workerSite?.addressFull ?? "",
                                              addressDistrictCode: loginData?.workerSite?.locationDistrictName ?? "",
                                              addressProvinceCode: loginData?.workerSite?.locationProvinceName ?? "",
                                              identificationNumber: loginData?.workerSite?.identificationNumber ?? "",
                                              email: loginData?.workerSite?.email ?? "")
        service.updateProfile(requestModel: model) { [weak self] (response, success) in
            guard let self = self else { return }
            if success {
                if let response = response as? GeneralResponse {
                    guard self.noError(from: response) else { return }

                    Storage.shared.loginData?.workerSite?.nickname = self.nickname
                    Storage.shared.loginData?.workerSite?.birthday = validDate

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
