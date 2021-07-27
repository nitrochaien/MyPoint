//
//  EnterReceiverPresenter.swift
//  MyPoint
//
//  Created by Nam Vu on 2/14/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

protocol EnterReceiverPresenterDelegate: BaseProtocols {
    func didCheckPhoneNumber(_ phone: String, _ isActive: Bool)
    func handleNonExisted()
    func handleSameUserPhone()
}

class EnterReceiverPresenter: APIResponseMethods {
    private var allContacts = [ContactManager.ContactsModel]()

    var contacts: [ContactManager.ContactsModel] = []
    weak var delegate: EnterReceiverPresenterDelegate?
    private let service = GivePointServices()

    var selectedContact: ContactManager.ContactsModel!

    var noContactsFound = false

    func getContacts() {
        ContactManager().getContacts { contacts in
            self.updateContacts(with: contacts)
            self.delegate?.requestSuccess()
        }
    }

    private func updateContacts(with data: [ContactManager.ContactsModel]) {
        contacts = data
        allContacts = data
    }

    func reset() {
        contacts = allContacts
    }

    func filter(by searchText: String) {
        let text = searchText.folded.trimmed.lowercased()
        contacts = allContacts.filter({
            $0.name.folded.trimmed.lowercased().contains(text)
                || $0.phones.first?.phone.contains(text) ?? false
        })
        noContactsFound = contacts.isEmpty
        if noContactsFound && searchText.isNumeric {
            let unknownContact = ContactManager.ContactsModel(name: "main.unknown".localized,
                                                              phones: [.init(label: nil, phone: searchText)])
            contacts.append(unknownContact)
        }
    }

    func checkExistedPhone() {
        let phone = selectedContact.phones.first?.phone ?? ""
        guard !phone.isEmpty else {
            delegate?.handleNonExisted()
            return
        }
        let validatedPhone = phone.convertToLeadingZeroPhoneNumber()

        guard validatedPhone != Storage.shared.registeredPhoneNumber ?? "" else {
            delegate?.handleSameUserPhone()
            return
        }

        service.checkExistedPhone(phoneNumber: validatedPhone) { [weak self] (response, success) in
            guard let self = self else { return }
            if success {
                if let response = response as? CheckExistedPhoneResponse {
                    guard self.noError(from: response) else { return }

                    if let activeString = response.data?.isActive, let active = activeString.toBoolean {
                        self.delegate?.didCheckPhoneNumber(phone, active)
                    } else {
                        print("Cannot parse Active value")
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

extension String {
    func convertToLeadingZeroPhoneNumber() -> String {
        if starts(with: "+84") {
            return replacingOccurrences(of: "+84", with: "0")
        }
        return self
    }
}
