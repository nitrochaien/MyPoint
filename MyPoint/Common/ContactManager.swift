//
//  ContactManager.swift
//  MyPoint
//
//  Created by Nam Vu on 2/14/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation
import Contacts

final class ContactManager {
    static let shared = ContactManager()

    struct ContactsModel: Comparable {
        let name: String
        let phones: [ContactPhone]

        static func < (lhs: ContactsModel, rhs: ContactsModel) -> Bool {
            return lhs.name < rhs.name
        }

        static func == (lhs: ContactsModel, rhs: ContactsModel) -> Bool {
            return lhs.name == rhs.name
        }
    }

    struct ContactPhone {
        let label: String
        let phone: String

        init(label: String?, phone: String) {
            self.label = label ?? ""
            self.phone = phone
        }
    }

    private var contacts = [ContactsModel]()

    func contactListNotEmpty() -> Bool {
        return !contacts.isEmpty
    }

    func getContacts(_ completion: ((_ contacts: [ContactsModel]) -> Void)? = nil) {
        contacts.removeAll()
        var newContacts = [ContactsModel]()
        let contactStore = CNContactStore()
        let keys = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactPhoneNumbersKey,
            CNContactEmailAddressesKey,
            CNContactThumbnailImageDataKey
            ] as [Any]
        let request = CNContactFetchRequest(keysToFetch: keys as! [CNKeyDescriptor])
        do {
            try contactStore.enumerateContacts(with: request) { (contact, _) in
                // Array containing all unified contacts from everywhere
                let name = "\(contact.givenName) \(contact.middleName) \(contact.familyName)"
                let phones = contact.phoneNumbers.map({ phoneNumber -> ContactPhone in
                    let phoneValue = phoneNumber.value.stringValue
                    let phone = phoneValue.trimmed.replacingOccurrences(of: " ", with: "")
                    return .init(label: phoneNumber.label?.trimmed, phone: phone)
                })
                if phones.count > 0 {
                    newContacts.append(ContactsModel(name: name, phones: phones))
                }
            }
        } catch {
            print("unable to fetch contacts")
        }
        var sorted = newContacts.sorted(by: <)
        let empties = sorted.filter { model -> Bool in
            return model.name.trimmed.isEmpty
        }
        sorted.removeAll { model -> Bool in
            return model.name.trimmed.isEmpty
        }
        sorted.append(contentsOf: empties)
        contacts = sorted
        completion?(contacts)
    }
}

extension Array {
    /// Picks `n` random elements (partial Fisher-Yates shuffle approach)
    subscript (randomPick n: Int) -> [Element] {
        var copy = self
        for i in stride(from: count - 1, to: count - n - 1, by: -1) {
            copy.swapAt(i, Int(arc4random_uniform(UInt32(i + 1))))
        }
        return Array(copy.suffix(n))
    }
}
