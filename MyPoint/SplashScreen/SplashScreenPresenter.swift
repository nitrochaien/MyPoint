//
//  SplashScreenPresenter.swift
//  MyPoint
//
//  Created by Nam Vu on 1/10/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

protocol SplashScreenDelegate: BaseProtocols {
    func handleDidNotEnterNickname()
    func showLoginScreen()
}

class SplashScreenPresenter: APIResponseMethods {

    private let service = SplashScreenServices()
    weak var delegate: SplashScreenDelegate?

    func requestCheckingLoginState() {
        guard Storage.shared.loginData != nil else {
            self.delegate?.showLoginScreen()
            return
        }

        service.requestAccessTokenStatus { [weak self] response, success in
            guard let self = self else { return }
            if success {
                if let response = response as? LoginResponse {
                    guard self.noError(from: response) else {
                        self.delegate?.showLoginScreen()
                        return
                    }

                    if let data = response.data {
                        Storage.shared.loginData = data
                        if let image = data.workerSite?.avatar, !image.isEmpty {
                            Storage.shared.localUserProfilePic = data.workerSite?.image
                        }
                        self.delegate?.requestSuccess()
                    } else {
                        self.delegate?.showLoginScreen()
                    }

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
