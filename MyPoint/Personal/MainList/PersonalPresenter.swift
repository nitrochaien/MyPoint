//
//  PersonalPresenter.swift
//  MyPoint
//
//  Created by Nam Vu on 12/29/19.
//  Copyright © 2019 NamDV. All rights reserved.
//

import Foundation

protocol PersonalProtocols: BaseProtocols {
    func handleSignOut()
    func didConfirmCode()
    func handleSameUserPhone()
}

extension PersonalProtocols where Self: PersonalViewController {
    func handleSignOut() {
        setRoot(storyboard: "Authenciation", viewControllerId: "LoginViewController")
    }
}

final class PersonalPresenter: APIResponseMethods {
    weak var delegate: PersonalProtocols?

    var menu = [[PersonalItem]]()

    private let service = PersonalServices()

    var didEnterInvitationCode = false
    var invitationReward = ""

    func generateMenu() {
        self.menu.removeAll()
        Loading.startAnimation()

        DispatchQueue.global(qos: .background).async {
            let parsedData: [PersonalItem] = load("personal_menu_vi.json")
            var section = 0

            while section <= parsedData.count {
                let sectionData = parsedData.filter { $0.section == section }
                if sectionData.isEmpty { break }
                section += 1
                self.menu.append(sectionData)
            }
            DispatchQueue.main.async {
                Loading.stopAnimation()
                self.delegate?.requestSuccess()
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
                    self.didEnterInvitationCode = data?.toBoolean ?? false

                    self.generateMenu()
                }
            } else {
                self.showError()
            }
        }
    }

    func submitReferenceCode(_ text: String) {
        let validatedPhone = text.convertToLeadingZeroPhoneNumber()
        guard validatedPhone != Storage.shared.registeredPhoneNumber ?? "" else {
            delegate?.handleSameUserPhone()
            return
        }

        service.submitReferenceCode(text) { [weak self] (response, success) in
            guard let self = self else { return }
            if success {
                if let response = response as? SubmitInviteCodeResponse {
                    guard self.noError(from: response) else { return }
                    let pointString = response.data?.awardedPoint ?? ""
                    let pointDouble = Double(pointString) ?? 0
                    self.invitationReward = pointDouble.formattedWithSeparator

                    Storage.shared
                        .loginData?
                        .workingSite?
                        .customerBalance?.setNewAmount(with: response.data?.customerBalance)

                    self.delegate?.didConfirmCode()
                }
            } else {
                self.showError()
            }
        }
    }

    func logout() {
        service.logout { [weak self] (response, success) in
            guard let self = self else { return }
            if success {
                if let response = response as? GeneralResponse {
                    guard self.noError(from: response) else { return }
                    Storage.shared.clearDataWhenSignOut()
                    self.delegate?.handleSignOut()
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
