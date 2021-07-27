//
//  Defines.swift
//  MyPoint
//
//  Created by Nam Vu on 1/4/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

typealias Second = Int

struct Defines {
    static let otpCodeLength = 6
    static let pinCodeLength = 6
    static let timeToDoNextEvent: Second = 180
    static let timeToLive: Second = 180
    static let maxFeedbackInput = 500
    static let resendOTPCountdown: Second = 30
    // Allows to enter OTP 5 times before lock registering
    //    static let numberOfIncorrectOTPInputAllowed = 5
    //    static let daysOfLockRegistering = 7
    static let hotline = "1900599863"
    static let notificationViewShowTime: Double = 1.5
    static let maxPhoneNumberCount = 10
    static let checkInPoints = Double(100).formattedWithSeparator
    static let appURL = "itms-apps://itunes.apple.com/app/id1495923300?action=write-review"
    static let appITunesItemIdentifier = "1495923300"
    static let appsFlyerDevKey = "wGiCpTFXtCEHzYeWCDzfXP"

    // Support
    static let facebook = "facebook.com/mypointvn"
    static let email = "cskh.mypoint@paytech.vn"

    enum RequestStatus: String {
        case success = "success"
        case error = "fail"
    }

    enum ErrorCode: String {
        case noError = "NO_ERROR"
        case otpInvalid = "ERR_OTP_INVALID"
        case exceedsOTPVerification = "ERR_OTP_LOCKED_BY_TOO_MANY_FAILS_WHEN_VERIFY"
        case accountNameNotFound = "ERR_ACCOUNT_NAME_NOT_FOUND"
        case verifyPasswordFail = "ERR_ACCOUNT_VERIFY_FOR_PASSWORD_CHANGE_FAIL"
        case invalidLoginPassword = "ERR_LOGIN_PASSWORD_INVALID"
        case lockLogin = "ERR_ACCOUNT_LOCKED_BY_TOO_MANY_FAIL_VERIFICATIONS"
        case blocked = "ERR_BLOCKED_BY_WORKING_SITE"
        case accountExisted = "ERR_SIGNUP_ACCOUNT_EXISTING"
    }
}

protocol APIResponseMethods {
    func noError<T: APIHeaderResponse>(from response: T) -> Bool
    func showError(message: String)
}

protocol APIHeaderResponse {
    var status: String? { get set }
    var errorCode: String? { get set }
    var errorMessage: String? { get set }
    var blockedReason: String? { get set }
}

protocol OTPChecker {
    var data: CreateOTPData? { get set }
}

extension APIResponseMethods {
    func noError<T: APIHeaderResponse>(from response: T) -> Bool {
        let errorMessage = response.errorMessage ?? "api.unknown_error".localized
        
        if let errorCode = response.errorCode {
            switch errorCode {
            case Defines.ErrorCode.noError.rawValue:
                break
            case Defines.ErrorCode.otpInvalid.rawValue:
                if let response = response as? OTPChecker {
                    let remainings = response.data?.remainingVerifications ?? ""
                    let remainInt = Int(remainings) ?? 0
                    let alert = String(format: "alert.wrong_otp".localized, String(remainInt + 1))
                    showError(message: alert)
                }
                return false
            case Defines.ErrorCode.exceedsOTPVerification.rawValue:
                if let response = response as? OTPChecker {
                    let until = response.data?.unlockAfter ?? ""
                    let date = until.parseToDate(with: DateFormat.server)
                    if let offset = date?.time(from: Date()) {
                        let alert = String(format: "alert.lock_registering".localized,
                                           offset,
                                           Defines.hotline)
                        showError(message: alert)
                    }
                }
                return false
            case Defines.ErrorCode.accountNameNotFound.rawValue:
                showError(message: "alert.account_not_found".localized)
                return false
            case Defines.ErrorCode.invalidLoginPassword.rawValue:
                if let response = response as? LoginResponse {
                    let remainings = response.data?.remainingLoginFail ?? ""
                    let remainInt = Int(remainings) ?? 0
                    let alert = String(format: "alert.wrong_password".localized, String(remainInt + 1))
                    showError(message: alert)
                }
                return false
            case Defines.ErrorCode.lockLogin.rawValue:
                if let response = response as? LoginResponse {
                    let unlockAfter = response.data?.unlockAfter ?? ""
                    let date = unlockAfter.parseToDate(with: DateFormat.server)
                    if let offset = date?.time(from: Date()) {
                        let alert = String(format: "alert.lock_login".localized,
                                           offset,
                                           Defines.hotline)
                        showError(message: alert)
                    }
                }
                return false
            case Defines.ErrorCode.blocked.rawValue:
                let blockedReason = response.blockedReason ?? ""
                showError(message: "\(errorMessage)\n\(blockedReason)")
                return false
            case Defines.ErrorCode.accountExisted.rawValue:
                return true
            default:
                showError(message: errorMessage)
                return false
            }
        }

        guard let status = response.status,
            status == Defines.RequestStatus.success.rawValue else {
                showError(message: errorMessage)
                return false
        }

        return true
    }
}

struct NotificationName {
    // notify when done receive device token from System
    static let didGetDeviceToken = Notification.Name("notificationDidGetDeviceToken")
    static let didTapVoucher = Notification.Name("notificationDidTapVoucher")
    static let dismissScanner = Notification.Name("notificationDismissScanner")
    static let dismissRating = Notification.Name("notificationDismissRating")
    static let didChangeInterestedCategories = Notification.Name("notificationDidChangeInterestedCategories")
    static let didLeaveMainScreen = Notification.Name("notificationDidLeaveMainScreen")
    static let didLeaveNotificationScreen = Notification.Name("notificationDidLeaveNotificationScreen")
    static let didLoadMoreSearchMerchant = Notification.Name("notificationDidLoadMoreSearchMerchant")
    static let goToMerchantProfile = Notification.Name("notificationGoToMerchantProfile")
    static let goToMerchantProfileFromStore = Notification.Name("notificationGoToMerchantProfileFromStore")
    static let reloadMyVoucher = Notification.Name("notificationReloadMyVoucher")
    static let didSubmitReview = Notification.Name("notificationDidSubmitReview")
    static let successSubmitReview = Notification.Name("notificationSuccessSubmitReview")
}

enum ListOrder: String {
    case desc = "DESC"
    case asc = "ASC"
}

enum ClickActionType: String {
    case website = "VIEW_WEBSITE_PAGE"
    case voucher = "VIEW_PRODUCT_VOUCHER"
    case brand = "VIEW_BRAND"
    case transaction = "VIEW_TRANSACTION_REQUEST"
    case statistic = "OPEN_DATA_TOPIC_ADJUSTMENT_CREATOR"
    case appScreen = "VIEW_APP_SCREEN"
    case link = "VIEW_LINK"
    case none = ""

    static func showViewController(withType type: String,
                                   andParam param: String,
                                   from nav: UINavigationController?) {
        switch type {
        case ClickActionType.website.rawValue:
            let vc = NewsDetailViewController()
            vc.hidesBottomBarWhenPushed = true
            vc.setPageId(param)
            nav?.pushViewController(vc, animated: true)
        case ClickActionType.voucher.rawValue:
            let storyboard = UIStoryboard(name: "VoucherDetail", bundle: nil)
            let viewController = storyboard
                .instantiateViewController(withIdentifier: "VoucherDetailViewController") as! VoucherDetailViewController
            viewController.voucherId = param
            viewController.hidesBottomBarWhenPushed = true
            nav?.pushViewController(viewController, animated: true)
        case ClickActionType.brand.rawValue:
            let storyboard = UIStoryboard(name: "MerchantDetail", bundle: nil)
            let viewController = storyboard
                .instantiateViewController(withIdentifier: "MerchantDetailViewController") as! MerchantDetailViewController
            viewController.hidesBottomBarWhenPushed = true
            nav?.pushViewController(viewController, animated: true)
        case ClickActionType.transaction.rawValue:
            let vc = TransactionDetailViewController()
            vc.setId(param)
            nav?.pushViewController(vc, animated: true)
        case ClickActionType.none.rawValue:
            let vc = NotificationDetailViewController()
            vc.setId(param)
            nav?.pushViewController(vc, animated: true)
        case ClickActionType.appScreen.rawValue:
            ClickActionParams.showAppScreen(fromParam: param, nav: nav)
        default:
            break
        }
    }

    static func showNotificationDetail(with title: String,
                                       and body: String,
                                       from nav: UINavigationController?) {
        let vc = NotificationDetailViewController()
        vc.setData(title, body)
        nav?.pushViewController(vc, animated: true)
    }
}

enum ClickActionParams: String {
    case feedback = "FEEDBACK"
    case dailyCheckin = "DAILY_CHECKIN"
    case inputReferralCode = "INPUT_REFERRAL_CODE"

    static func showAppScreen(fromParam param: String,
                              nav: UINavigationController?) {
        switch param {
        case ClickActionParams.feedback.rawValue:
            let vc = HuntFounderViewController()
            nav?.pushViewController(vc, animated: true)
        case ClickActionParams.dailyCheckin.rawValue:
            let storyboard = UIStoryboard(name: "Personal", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "CheckInViewController")
            nav?.pushViewController(vc, animated: true)
        case ClickActionParams.inputReferralCode.rawValue:
            break
        default:
            break
        }
    }
}

enum HistoryListType: String {
    case reward = "RW"
    case redeem = "RD"
    case adjust = "AD"
    case all = ""

    var toRequest: String {
        switch self {
        case .redeem:
            return HistoryListType.redeemReq
        case .reward:
            return HistoryListType.rewardReq
        case .adjust:
            return "AD"
        case .all:
            return ""
        }
    }

    static var redeemReq = "RD,AD"
    static var rewardReq = "RW,AD"
}
