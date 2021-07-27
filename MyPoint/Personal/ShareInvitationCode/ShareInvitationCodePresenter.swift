//
//  ShareInvitationCodePresenter.swift
//  MyPoint
//
//  Created by Nam Vu on 3/25/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

final class ShareInvitationCodePresenter: APIResponseMethods {
    weak var delegate: InviteFriendPresenterDelegate?
    private let service = PersonalServices()
    private(set) var points = "0"

    var phoneNumber = ""

    var isValidCode: Bool {
        let validatedPhone = phoneNumber.convertToLeadingZeroPhoneNumber()

        guard validatedPhone != Storage.shared.registeredPhoneNumber ?? "" else {
            delegate?.handleSameUserPhone()
            return false
        }
        
        return true
    }

    func submitReferenceCode() {
        service.submitReferenceCode(phoneNumber) { [weak self] (response, success) in
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

    func showError(message: String = "api.request_fail".localized) {
        delegate?.showError(message: message)
    }
}
