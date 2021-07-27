//
//  Storage.swift
//  MyPoint
//
//  Created by Nam Vu on 1/5/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

class Storage {
    static let shared = Storage()

    var loggedAccounts: [String] {
        get {
            return UserDefaults.standard.array(forKey: .loggedAccounts) as? [String] ?? []
        }
        set {
            UserDefaults.standard.set(newValue, forKey: .loggedAccounts)
        }
    }

    var deviceToken: String? {
        get {
            return UserDefaults.standard.value(forKey: .deviceToken) as? String
        }
        set {
            UserDefaults.standard.set(newValue, forKey: .deviceToken)
        }
    }

    var firebaseToken: String? {
        get {
            return UserDefaults.standard.value(forKey: .firebaseToken) as? String
        }
        set {
            UserDefaults.standard.set(newValue, forKey: .firebaseToken)
        }
    }

    var loginData: LoginData? {
        get {
            if let encoded = UserDefaults.standard.object(forKey: .loginData) as? Data {
                let storedData = try? PropertyListDecoder().decode(LoginData.self, from: encoded)
                return storedData
            }
            return nil
        }
        set {
            if let value = newValue {
                try? UserDefaults.standard.set(PropertyListEncoder().encode(value), forKey: .loginData)
            } else {
                UserDefaults.standard.set(nil, forKey: .loginData)
            }
        }
    }

    var localUserProfilePic: UIImage? {
        get {
            if let data = UserDefaults.standard.data(forKey: .userProfilePic) {
                return UIImage(data: data)
            }
            return nil
        }
        set {
            if let value = newValue {
                UserDefaults.standard.set(value.pngData(), forKey: .userProfilePic)
            } else {
                UserDefaults.standard.set(nil, forKey: .userProfilePic)
            }
        }
    }

    var registeredPhoneNumber: String? {
        get {
            return UserDefaults.standard.value(forKey: .registeredPhoneNumber) as? String
        }
        set {
            UserDefaults.standard.set(newValue, forKey: .registeredPhoneNumber)
        }
    }

    var isFirstTimeUseApp: Bool {
        get {
            return UserDefaults.standard.value(forKey: .isFirstTimeUseApp) as? Bool ?? true
        }
        set {
            UserDefaults.standard.set(newValue, forKey: .isFirstTimeUseApp)
        }
    }

    var didDismissEnterInvitationCode: Bool {
        get {
            return UserDefaults.standard.value(forKey: .didDismissEnterInvitationCode) as? Bool ?? false
        }
        set {
            UserDefaults.standard.set(newValue, forKey: .didDismissEnterInvitationCode)
        }
    }

    var didNotShowVoucherTab: Bool {
        get {
            return UserDefaults.standard.value(forKey: .didNotShowVoucherTab) as? Bool ?? true
        }
        set {
            UserDefaults.standard.set(newValue, forKey: .didNotShowVoucherTab)
        }
    }

    var registeringState: [String: String]? {
        get {
            let data = UserDefaults.standard.value(forKey: .registerState) as? [String: String]
            return data
        }
        set {
            UserDefaults.standard.set(newValue, forKey: .registerState)
        }
    }

    func clearDataWhenSignOut() {
        loginData = nil
        registeredPhoneNumber = nil
        didDismissEnterInvitationCode = false
        localUserProfilePic = nil
    }
}

private extension String {
    static let loggedAccounts = "loggedAccounts"
    static let deviceToken = "deviceToken"
    static let loginData = "loginData"
    static let userProfilePic = "userProfilePic"
    static let registeredPhoneNumber = "registeredPhoneNumber"
    static let isFirstTimeUseApp = "isFirstTimeUseApp"
    static let registerState = "registerState"
    static let didNotShowVoucherTab = "didNotShowVoucherTab"
    static let didDismissEnterInvitationCode = "didDismissEnterInvitationCode"
    static let firebaseToken = "firebaseToken"
}
