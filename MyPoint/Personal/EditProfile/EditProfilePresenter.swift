//
//  EditProfilePresenter.swift
//  MyPoint
//
//  Created by Nam Vu on 1/31/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation
import UIKit

protocol EditProfilePresenterDelegate: BaseProtocols {
    func invalidEmail()
    func noData()
    func enableConfirmButton()
}

extension EditProfilePresenterDelegate where Self: EditProfileViewController {
    func invalidEmail() {
        showCustomAlert(withTitle: "alert.wrong_email".localized,
                        andContent: "alert.wrong_email_content".localized)
    }

    func noData() {
        showCustomAlert(withTitle: "alert.no_data".localized,
                        andContent: "alert.no_data_content".localized) { [weak self] in
                            self?.navigationController?.popViewController(animated: true)
        }
    }
}

class EditProfilePresenter: APIResponseMethods {
    var model: EditProfileModel!

    weak var delegate: EditProfilePresenterDelegate?
    var selectedProvince: ProvinceSearchPresenter.DisplayItem!
    var selectedDistrict: ProvinceSearchPresenter.DisplayItem!
    var didChangeAvatar = false
    var didEdit = false {
        didSet {
            delegate?.enableConfirmButton()
        }
    }

    private let service = PersonalServices()

    func checkValidInput() -> Bool {
        if !model.email.isEmpty && !model.email.isValidEmail {
            delegate?.invalidEmail()
            return false
        }

        return true
    }

    func getData() {
        if let worker = Storage.shared.loginData?.workerSite {
            model = EditProfileModel(worker)

            if !model.address.provinceCode.isEmpty {
                selectedProvince = .init(name: model.address.provinceName,
                                         code: model.address.provinceCode,
                                         isSelected: true)
            }

            if !model.address.districtCode.isEmpty {
                selectedDistrict = .init(name: model.address.districtName,
                                         code: model.address.districtCode,
                                         isSelected: true)
            }

        } else {
            delegate?.noData()
        }
    }

    func updateProfile() {
        let group = DispatchGroup()
        if didChangeAvatar {
            uploadAvatar(with: group)
        }

        group.enter()
        service.updateProfile(requestModel: model.toRequestModel) { [weak self] (response, success) in
            group.leave()
            guard let self = self else { return }
            if success {
                if let response = response as? GeneralResponse {
                    guard self.noError(from: response) else { return }
                }
            } else {
                self.showError()
            }
        }

        group.notify(queue: .main) {
            Storage.shared.loginData = self.model.loginData
            self.delegate?.requestSuccess()
        }
    }

    private func uploadAvatar(with group: DispatchGroup) {
        guard let image = model.image?.scaled(toWidth: 360) else { return }

        group.enter()
        service.uploadAvatar(image) { [weak self] response, success in
            group.leave()
            guard let self = self else { return }
            if success {
                if let response = response as? GeneralResponse {
                    guard self.noError(from: response) else { return }
                    Storage.shared.localUserProfilePic = self.model.image
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

class EditProfileModel {
    var name: String
    var nickname: String
    var phone: String
    var date: String
    var gender: PersonalGender
    var address: Address
    var userId: String
    var email: String
    var image: UIImage?

    init(_ worker: WorkerSite) {
        name = worker.fullname ?? ""
        nickname = worker.nickname ?? ""
        phone = Storage.shared.registeredPhoneNumber ?? ""
        let birthday = worker.birthday?.dateToString(fromFormat: DateFormat.profileRequest, DateFormat.profile)
        date = birthday ?? "dd/mm/yyyy"
        gender = .init(gender: worker.sex ?? PersonalGender.unknown.rawValue)
        address = .init(worker)
        userId = worker.identificationNumber ?? ""
        email = worker.email ?? ""
        image = worker.image
    }

    var toRequestModel: UpdateProfileRequestModel {
        let loginData = Storage.shared.loginData
        return .init(accessToken: loginData?.accessToken ?? "",
                     workerSiteId: loginData?.workerSite?.id ?? "",
                     fullName: name,
                     nickname: nickname,
                     dateOfBirth: date.dateToString(fromFormat: DateFormat.profile, DateFormat.profileRequest),
                     gender: gender,
                     addressFull: address.street,
                     addressDistrictCode: address.districtCode,
                     addressProvinceCode: address.provinceCode,
                     identificationNumber: userId,
                     email: email)
    }

    var loginData: LoginData {
        let oldLoginData = Storage.shared.loginData

        let workerSite = WorkerSite(id: oldLoginData?.workerSite?.id,
                                    fullname: name,
                                    nickname: nickname,
                                    avatar: "",
                                    phoneNumber: phone,
                                    birthday: date.dateToString(fromFormat: DateFormat.profile,
                                                                DateFormat.profileRequest),
                                    sex: gender.rawValue,
                                    addressFull: address.street,
                                    locationDistrictCode: address.districtCode,
                                    locationDistrictName: address.districtName,
                                    locationProvinceCode: address.provinceCode,
                                    locationProvinceName: address.provinceName,
                                    identificationNumber: userId,
                                    email: email)
        return LoginData(workerSite: workerSite,
                         workingSite: oldLoginData?.workingSite,
                         accessToken: oldLoginData?.accessToken,
                         remainingLoginFail: nil,
                         unlockAfter: nil)
    }
}

class Address {
    var street: String = ""
    var provinceCode: String = ""
    var provinceName: String = ""
    var districtName: String = ""
    var districtCode: String = ""

    init() {
        
    }

    func reset() {
        street = ""
        provinceCode = ""
        provinceName = ""
        districtCode = ""
        districtName = ""
    }

    var notSelectedProvince: Bool {
        return provinceCode.isEmpty && provinceName.isEmpty
    }

    init(_ worker: WorkerSite) {
        street = worker.addressFull ?? ""
        districtCode = worker.locationDistrictCode ?? ""
        districtName = worker.locationDistrictName ?? ""

        provinceCode = worker.locationProvinceCode ?? ""
        provinceName = worker.locationProvinceName ?? ""
    }
}
