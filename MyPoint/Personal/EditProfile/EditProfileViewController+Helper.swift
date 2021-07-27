//
//  EditProfileHelper.swift
//  MyPoint
//
//  Created by Nam Vu on 1/28/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

extension EditProfileViewController {
    enum SectionType: Int, CaseIterable {
        case profilePic = 0, name, nickname, phone, email, date, gender, address, userId

        static func getHeaderName(from input: Int) -> String {
            switch input {
            case SectionType.name.rawValue:
                return "edit.name".localized
            case SectionType.nickname.rawValue:
                return "edit.nickname".localized
            case SectionType.phone.rawValue:
                return "edit.phone".localized
            case SectionType.date.rawValue:
                return "edit.date".localized
            case SectionType.gender.rawValue:
                return "edit.gender".localized
            case SectionType.address.rawValue:
                return "edit.address".localized
            case SectionType.userId.rawValue:
                return "edit.userId".localized
            case SectionType.email.rawValue:
                return "edit.email".localized
            default:
                return ""
            }
        }

        static func getValue(from input: Int) -> SectionType? {
            switch input {
            case SectionType.name.rawValue:
                return .name
            case SectionType.nickname.rawValue:
                return .nickname
            case SectionType.phone.rawValue:
                return .phone
            case SectionType.date.rawValue:
                return .date
            case SectionType.gender.rawValue:
                return .gender
            case SectionType.address.rawValue:
                return .address
            case SectionType.userId.rawValue:
                return .userId
            case SectionType.email.rawValue:
                return .email
            default:
                return nil
            }
        }
    }

    enum AddressSection: Int, CaseIterable {
        case street = 0, province, district
    }
}

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {

        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            presenter.model.image = pickedImage
            presenter.didChangeAvatar = true
            presenter.didEdit = true
            tableView.reloadSections([SectionType.profilePic.rawValue], with: .automatic)
        }

        dismiss(animated: true, completion: nil)
    }
}
