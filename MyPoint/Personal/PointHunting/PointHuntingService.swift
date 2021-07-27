//
//  PointHuntingService.swift
//  MyPoint
//
//  Created by Nam Vu on 3/18/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation
import Localize

class PointHuntingService: BaseService {
    func createRequestPointHunting(title: String,
                                   feedback: String,
                                   _ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        let params = [
            "access_token": Storage.shared.loginData?.accessToken ?? "",
            "subject": title,
            "body": feedback,
            "lang": Localize.shared.currentLanguage
        ]
        requestPOST(type: PointHuntingCreateRequestResponse.self,
                    params: params,
                    pathURL: CommonAPI.createFeedback) { (response, status, _) in
            callBack(response, status)
        }
    }

    func submitFeedbackImages(image: UIImage,
                              id: String,
                              _ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        let params = [
            "access_token": Storage.shared.loginData?.accessToken ?? "",
            "feedback_id": id,
            "lang": Localize.shared.currentLanguage
        ]

        uploadImage(type: GeneralResponse.self,
                    image: image,
                    params: params,
                    pathURL: CommonAPI.sendFeedbackImage) { response, status, _ in
                        callBack(response, status)
        }
    }

    func getAchievementList(_ callBack: @escaping (_ response: AnyObject, _ status: Bool) -> Void) {
        let params: [String: Any] = [
            "access_token": Storage.shared.loginData?.accessToken ?? "",
            "start": offset,
            "limit": pageLimit,
            "lang": "vi"
        ]
        requestPOST(type: AchievementResponse.self,
                    params: params,
                    pathURL: CommonAPI.getAchievement) { (response, status, _) in
            callBack(response, status)
        }
    }
}
