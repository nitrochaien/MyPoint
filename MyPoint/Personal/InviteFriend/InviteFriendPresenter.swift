//
//  InviteFriendPresenter.swift
//  MyPoint
//
//  Created by Nam Vu on 2/15/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

protocol InviteFriendPresenterDelegate: BaseProtocols {
    func didConfirm()
    func handleSameUserPhone()
}

final class InviteFriendPresenter: APIResponseMethods {
    weak var delegate: InviteFriendPresenterDelegate?

    private let service = PersonalServices()
    private(set) var points = "0"
    
    var didReference = true

    func submitReferenceCode(_ text: String) {
        let validatedPhone = text.convertToLeadingZeroPhoneNumber()
        guard validatedPhone != Storage.shared.registeredPhoneNumber ?? "" else {
            delegate?.handleSameUserPhone()
            return
        }

        service.submitReferenceCode(validatedPhone) { [weak self] (response, success) in
            guard let self = self else { return }
            if success {
                if let response = response as? SubmitInviteCodeResponse {
                    guard self.noError(from: response) else { return }
                    let pointString = response.data?.awardedPoint ?? ""
                    let pointDouble = Double(pointString) ?? 0
                    self.points = pointDouble.formattedWithSeparator

                    Storage.shared
                        .loginData?
                        .workingSite?
                        .customerBalance?.setNewAmount(with: response.data?.customerBalance)

                    self.delegate?.didConfirm()
                }
            } else {
                self.showError()
            }
        }
    }

    func checkSubmitReferenceCode() {
        service.checkSubmitReferenceCode { [weak self] (response, success) in
            guard let self = self else { return }
            if success {
                if let response = response as? CheckSubmitReferenceCodeResponse {
                    guard self.noError(from: response) else { return }
                    let data = response.data?.hasReferee
                    self.didReference = data?.toBoolean ?? false
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
