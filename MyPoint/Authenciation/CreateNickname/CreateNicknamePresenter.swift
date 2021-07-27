//
//  CreateNicknamePresenter.swift
//  MyPoint
//
//  Created by Nam Vu on 1/5/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

class CreateNicknamePresenter: APIResponseMethods {
    weak var delegate: BaseProtocols?

    private let service = PersonalServices()

    var phone = ""
    var pinCode = ""

    func registerNickname(value: String) {
        if var requestModel = Storage.shared.loginData?.toUpdateProfileRequestModel {
            requestModel.nickname = value

            service.updateProfile(requestModel: requestModel) { [weak self] (response, success) in
                guard let self = self else { return }
                if success {
                    if let response = response as? GeneralResponse {
                        guard self.noError(from: response) else { return }

                        var newLoginData = Storage.shared.loginData
                        newLoginData?.workerSite?.nickname = value
                        Storage.shared.loginData = newLoginData

                        self.delegate?.requestSuccess()
                    }
                } else {
                    self.showError()
                }
            }
        } else {
            print("Cannot parse LoginData")
        }
    }

    func showError(message: String = "api.request_fail".localized) {
        delegate?.showError(message: message)
    }
}
