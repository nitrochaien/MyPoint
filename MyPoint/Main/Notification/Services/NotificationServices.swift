//
//  NotificationServices.swift
//  MyPoint
//
//  Created by Nam Vu on 2/3/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation
import Localize

class NotificationServices: BaseService {
    func getList(isShowLoadding: Bool = true, _ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        let storage = Storage.shared
        let params = [
            "lang": Localize.shared.currentLanguage,
            "access_token": storage.loginData?.accessToken ?? "",
            "get_customer_balance": "1",
            "limit": limit,
            "start": offset
            ] as [String: Any]
        requestPOST(type: NotificationListResponse.self,
                    params: params,
                    pathURL: CommonAPI.getNotificationList,
                    isShowLoadding: isShowLoadding
                    ) { (response, status, _) in
                        callBack(response, status)
        }
    }

    func deleteNotification(id: String, _ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        let storage = Storage.shared
        let params = [
            "lang": Localize.shared.currentLanguage,
            "access_token": storage.loginData?.accessToken ?? "",
            "notification_id": id
        ]
        requestPOST(type: GeneralResponse.self,
                    params: params,
                    pathURL: CommonAPI.deleteOneNotification) { (response, status, _) in
                        callBack(response, status)
        }
    }

    func deleteAllNotifications(_ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        let storage = Storage.shared
        let params = [
            "lang": Localize.shared.currentLanguage,
            "access_token": storage.loginData?.accessToken ?? ""
        ]
        requestPOST(type: GeneralResponse.self,
                    params: params,
                    pathURL: CommonAPI.deleteAllNotifications) { (response, status, _) in
                        callBack(response, status)
        }
    }

    func getNotificationDetail(id: String,
                               _ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        let storage = Storage.shared
        let params = [
            "lang": Localize.shared.currentLanguage,
            "access_token": storage.loginData?.accessToken ?? "",
            "notification_id": id,
            "mark_as_seen": "1"
        ]
        requestPOST(type: NotificationDetailResponse.self,
                    params: params,
                    pathURL: CommonAPI.getNotificationDetail) { (response, status, _) in
                        callBack(response, status)
        }
    }
}
