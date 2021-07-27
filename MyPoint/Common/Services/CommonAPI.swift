//
//  CommonAPI.swift
//  MyPoint
//
//  Created by Nam Vu on 12/29/19.
//  Copyright © 2019 NamDV. All rights reserved.
//

import Foundation

typealias DevAPI = (url: String, siteId: String)
var devAPI = DevAPI(url: "", siteId: "")

struct CommonAPI {
    static var baseURL = "https://api.mypoint.com.vn/8854/gup2start/rest"
//     static var baseURL = "https://api.sandbox.mypoint.com.vn/8854/gup2start/rest"

    static let productionURL = "https://api.mypoint.com.vn/"
    static let workingSiteId = "8854"

    static func reset() {
        baseURL = "\(CommonAPI.productionURL)\(CommonAPI.workingSiteId)/gup2start/rest"
    }

    static func updateTemp() {
        let productionURL = devAPI.url
        let workingSiteId = devAPI.siteId
        baseURL = "\(productionURL)/\(workingSiteId)/gup2start/rest"
    }

    static var isUsingDevAPI: Bool {
        if devAPI.url.isEmpty && devAPI.siteId.isEmpty { return false }
        return baseURL.contains(devAPI.url)
    }

    // MARK: Authenciation
    /// Check old password before change when Logged In
    static let accountLoginForPasswordChange = "/accountLoginForPasswordChange/1.0.0"
    /// Forgot Password
    static let accountPasswordReset = "/accountPasswordReset/1.0.0"
    /// Change Password when Logged In
    static let accountPasswordChange = "/accountPasswordChange/1.0.0"
    static let accountPasswordForgetVerifyAccountName = "/accountPasswordForgetVerifyAccountName/1.0.0"
    static let resendOTP = "/otpResend/1.0.0"
    static let updateProfile = "/workerSiteProfileUpdate/1.0.0"
    static let verifyNewAccount = "/signupVerifyNewAccountName/1.0.0"
    static let forgotPassCreateNewOTP = "/otpCreateNew/1.0.0"
    static let getLatestOTP = "/otpGetLasted/1.0.0"
    #if DEBUG
    static let verifyOTP = "/otpVerifyForDoingNextEvent/1.0.0" // Sandbox
    static let createNewOTP = "/otpCreateNew/1.0.0" // Sandbox
    static let register = "/signupNewAccount/1.0.0" // Sandbox
    #else
    static let verifyOTP = "/otpMobiFoneVerify/1.0.0" // Production
    static let createNewOTP = "/otpMobiFoneSend/1.0.0" // Production
    static let register = "/signupNewAccountViaMobiFone/1.0.0" // Production
    #endif
    static let forgotPassVerifyOTP = "/otpVerifyForDoingNextEvent/1.0.0"
    static let logout = "/accountLogout/1.0.0"
    static let login = "/accountLogin/2.0.0"
    static let uploadAvatar = "/workerSiteAvatarUpdate/1.0.0"

    // MARK: Onboarding
    static let getAllCategories = "/categoryTopLevelGetList/1.0.0"
    static let accountAccessTokenRefresh = "/accountAccessTokenRefresh/2.0.0"
    static let categorySubscribeList = "/categorySubscribeList/1.0.0"
    static let categoryUnsubscribeList = "/categoryUnsubscribeList/1.0.0"

    // MARK: Main
    static let getNewsList = "/websiteFolderGetPageList/1.0.0"
    static let getNotificationList = "/notificationGetList/1.0.0"
    static let deleteOneNotification = "/notificationDeleteOne/1.0.0"
    static let deleteAllNotifications = "/notificationDeleteAll/1.0.0"
    static let getPageDetail = "/websitePageGetDetail/1.0.0"
    static let getBanner = "/adsBannerByContextRequest/1.0.0"
    static let getNotificationDetail = "/notificationGetDetail/1.0.0"

    // MARK: Voucher
    static let myVoucherRedeem = "/myProductRedeem/1.0.0"
    static let getCustomerBalance = "/customerBalance/1.0.0"
    static let getExpiredVoucherList = "/myProductGetExpiredList/1.0.0"
    static let getUsedVoucherList = "/myProductGetUsedList/1.0.0"
    static let getWaitingVoucherList = "/myProductGetWaitingList/1.0.0"
    static let listHotVoucher = "/voucherGetHotList/1.0.0"
    static let getMyVoucherBrandWaitingList = "/myProductBrandWaitingList/1.0.0"
    static let getVoucherDetail = "/voucherGetDetail/1.0.0"
    static let getVoucherApplicablePlace = "/voucherStoreGetList/1.0.0"
    static let getListVoucherByCategory = "/categoryVoucherGetList/1.0.0"
    static let redeemVoucher = "/productRedeemRequest/1.0.0"
    static let getUsableVoucherDetail = "/myProductItemGetDetail/1.0.0"
    static let requestTransactionReview = "/customerReviewRequest/1.0.0"
    static let getListFavouriteVoucher = "/likeGetList/1.0.0"
    static let getSearchList = "/voucherGetList/1.0.0"
    static let markVoucherAsUsed = "/myProductMarkAsUsed/1.0.0"
    static let markVoucherAsUnused = "/myProductMarkAsNotUsedYet/1.0.0"

    // MARK: Invite Friend
    static let submitReferenceCode = "/customerFillReferenceCodeRequest/1.0.0"
    static let checkSubmitReferenceCode = "/customerFilledReferenceCodeChecker/1.0.0"

    // MARK: Give Point
    static let checkExistedPhone = "/myPointTransferCheckReceiverId/1.0.0"
    static let checkTransferPassword = "/accountLoginForPointTransfer/1.0.0"
    static let requestTransfer = "/myPointTransferRequest/1.0.0"
    
    // MARK: Category
    static let listCategory = "/categoryTopLevelGetList/1.0.0"
  
    // MARK: Brand
    static let listBrand = "/brandHottestGetList/1.0.0"
    static let listBiggestBrand = "/brandBiggestGetList/1.0.0"
    static let listNearbyBrandStore = "/storeGetList/1.0.0"
    static let filterStores = "/storeGetList/1.0.0"
    static let brandDetail = "/brandGetDetail/1.0.0"
    static let voucherBrand = "/voucherGetList/1.0.0"
    static let listFavouriteBrand = "/likeGetList/1.0.0"
    static let likeBrand = "/likeRequest/1.0.0"
    static let unlikeBrand = "/unlikeRequest/1.0.0"
  
    // MARK: Province
    static let listProvince = "/locationProvinceGetList/1.0.0"
    static let listDistrict = "/locationDistrictGetList/1.0.0"

    // MARK: Checkin
    static let getListReward = "/rewardOpportunityGetList/1.0.0"
    static let submitCheckIn = "/rewardOpportunityOpenRequest/1.0.0"

    // MARK: Ranking
    static let getRank = "/membershipLineRankingGetList/1.0.0"
    
    // MARK: MembershipPrivilege
    static let getMembershipPrivilege = "/primaryMembershipLevelGetList/1.0.0"
    
    // MARK: History
    static let getHistory = "/transactionHistoryGetList/1.0.0"
    static let getChartData = "/transactionGetSummaryByDate/1.0.0"
    static let getHistoryDetail = "/transactionHistoryGetDetail/1.0.0"

    // MARK: Push Notification
    static let updatePushNotificationToken = "/pushNotificationDeviceUpdateToken/1.0.0"

    // MARK: Feedback
    static let createFeedback = "/feedbackCreateRequest/1.0.0"
    static let sendFeedbackImage = "/feedbackAddImageRequest/1.0.0"

    // MARK: Telco
    static let getTopupList = "/productMobileTopupGetList/1.0.0"
    static let getMobileCardList = "/productMobileCardGetList/1.0.0"
    static let getMobileServiceList = "/productMobileServiceGetList/1.0.0"

    static let redeemMobileCard = "/productMobileCardRedeemRequest/1.0.0"
    static let redeemMobileService = "/productMobileServiceRedeemRequest/1.0.0"
    static let redeemTopup = "/productMobileTopupRedeemRequest/1.0.0"

    static let getMobileCardCode = "/myProductItemGetDetail/1.0.0"

    // MARK: - Bar Code
    static let getOneTimeCode = "/oneTimeCardNumberGetValue/1.0.0"
  
    // MARK: - Store
    static let getStoreDetail = "/storeGetDetail/1.0.0"
    static let getStoreComments = "/customerReviewGetList/1.0.0"
    static let submitStoreComment = "/customerReviewRequest/1.0.0"

    // MARK: - Cashback
    static let getCampaign = "/affiliateAccessTradeCampaignGetList/1.0.0"
    static let getCampaignDetail = "/affiliateAccessTradeCampaignGetDetail/1.0.0"
    static let getCampaignOrder = "/affiliateAccessTradeOrderGetList/1.0.0"
    static let recordClickRequest = "/affiliateAccessTradeCustomerClickRequest/1.0.0"

    // MARK: - Troubleshooting
    static let getTroubleshootingConfig = "/troubleshootingModeGetConfig/1.0.0"

    // MARK: - Point hunting
    static let getAchievement = "/achievementGetList/1.0.0"
    
    // MARK: - Point exprie
    static let getCustomerBalanceGetDetail = "/customerBalanceGetDetail/1.0.0"
}
