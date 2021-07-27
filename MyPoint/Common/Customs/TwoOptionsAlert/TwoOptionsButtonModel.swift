//
//  File.swift
//  MyPoint
//
//  Created by Nam Vu on 1/10/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

struct TwoOptionsButtonModel {
    let title: String
    let content: NSAttributedString
    let leftButtonTitle: String
    let rightButtonTitle: String
    let type: AlertType

    enum AlertType {
        case normal
        case destructive
        case confirm
    }

    init(title: String,
         content: NSAttributedString,
         leftButtonTitle: String,
         rightButtonTitle: String,
         type: AlertType) {
        self.title = title
        self.content = content
        self.leftButtonTitle = leftButtonTitle
        self.rightButtonTitle = rightButtonTitle
        self.type = type
    }

    static var notificationDeleteAllAlert: TwoOptionsButtonModel {
        let content = "notification.confirm_delete_all".localized
        return TwoOptionsButtonModel(title: "notification.delete_all".localized,
                                     content: content.alertContentAttributedString,
                                     leftButtonTitle: "common.cancel".localized,
                                     rightButtonTitle: "notification.delete".localized,
                                     type: .destructive)
    }

    static var logoutAlert: TwoOptionsButtonModel {
        let content = "personal.signOut_confirm".localized
        return TwoOptionsButtonModel(title: "personal.signOut".localized,
                                     content: content.alertContentAttributedString,
                                     leftButtonTitle: "common.cancel".localized,
                                     rightButtonTitle: "personal.signOut".localized,
                                     type: .destructive)
    }
    
    static var useVoucherAlert: TwoOptionsButtonModel {
        let content = "voucher.use_voucher_confirm1".localized + "voucher.use_voucher_confirm2".localized
        return TwoOptionsButtonModel(title: "voucher.confirm".localized,
                                     content: content.alertContentAttributedString,
                                     leftButtonTitle: "common.cancel".localized,
                                     rightButtonTitle: "common.agree".localized,
                                     type: .confirm)
    }

    static var cantGetLocationAlert: TwoOptionsButtonModel {
        let content = "error.setting_app_location_error_msg".localized
        return TwoOptionsButtonModel(title: "error.setting_app_location_error_title".localized,
                                     content: content.alertContentAttributedString,
                                     leftButtonTitle: "common.cancel".localized,
                                     rightButtonTitle: "common.turn_on_location".localized,
                                     type: .confirm)
    }

    static func createChangeCardAlert(withPoint points: Int) -> TwoOptionsButtonModel {
        let pointDisplay = String(format: "common.point_format".localized, points)
        let content = String(format: "alert.change_card_content".localized, pointDisplay)
        let attribute = content.alertContentAttributedString

        let highlightedRange = (content as NSString).range(of: pointDisplay)
        attribute.addAttributes([.font: UIFont(name: AppFontName.medium, size: 14.0)!,
                                 .foregroundColor: UIColor(hexString: "032041")!],
                                range: highlightedRange)

        return TwoOptionsButtonModel(title: "voucher.confirm".localized,
                                     content: attribute,
                                     leftButtonTitle: "common.cancel".localized,
                                     rightButtonTitle: "common.agree".localized,
                                     type: .confirm)
    }

    static func createChangePointAlert(withPoint points: Int) -> TwoOptionsButtonModel {
        let pointDisplay = String(format: "common.point_format".localized, points)
        let content = String(format: "change_point.alert".localized, pointDisplay)
        let attribute = content.alertContentAttributedString

        let highlightedRange = (content as NSString).range(of: pointDisplay)
        attribute.addAttributes([.font: UIFont(name: AppFontName.medium, size: 14.0)!,
                                 .foregroundColor: UIColor(hexString: "032041")!],
                                range: highlightedRange)

        return TwoOptionsButtonModel(title: "change_point.alert_header".localized,
                                     content: attribute,
                                     leftButtonTitle: "common.cancel".localized,
                                     rightButtonTitle: "common.agree".localized,
                                     type: .confirm)
    }

    static func createChangePackageAlert(withPoint points: Int) -> TwoOptionsButtonModel {
        let pointDisplay = String(format: "common.point_format".localized, points)
        let content = String(format: "alert.change_package_content".localized, pointDisplay)
        let attribute = content.alertContentAttributedString

        let highlightedRange = (content as NSString).range(of: pointDisplay)
        attribute.addAttributes([.font: UIFont(name: AppFontName.medium, size: 14.0)!,
                                 .foregroundColor: UIColor(hexString: "032041")!],
                                range: highlightedRange)

        return TwoOptionsButtonModel(title: "voucher.confirm".localized,
                                     content: attribute,
                                     leftButtonTitle: "common.cancel".localized,
                                     rightButtonTitle: "common.agree".localized,
                                     type: .confirm)
    }

    static var troubleshootingAlert: TwoOptionsButtonModel {
        let content = "Bạn có muốn thay đổi chế độ nhà phát triển ngay bây giờ không?"
        return TwoOptionsButtonModel(title: "Chế độ nhà phát triển",
                                     content: content.alertContentAttributedString,
                                     leftButtonTitle: "common.cancel".localized,
                                     rightButtonTitle: "common.agree".localized,
                                     type: .confirm)
    }

    static var accountExistAlert: TwoOptionsButtonModel {
        let content = "Số điện thoại bạn vừa nhập đã tồn tại!\nHãy thử đăng nhập nhé"
        return TwoOptionsButtonModel(title: "Sai tài khoản",
                                     content: content.alertContentAttributedString,
                                     leftButtonTitle: "common.cancel".localized,
                                     rightButtonTitle: "Đăng nhập",
                                     type: .confirm)
    }
}

private extension String {
    var alertContentAttributedString: NSMutableAttributedString {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        paragraph.lineSpacing = 8.0
        let attribute = NSMutableAttributedString(string: self,
                                                  attributes: [.font: UIFont(name: AppFontName.regular,
                                                                             size: 14.0)!,
                                                               .foregroundColor: UIColor(hexString: "727C88")!,
                                                               .paragraphStyle: paragraph])
        return attribute
    }
}
