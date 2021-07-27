//
//  BaseService.swift
//  MyPoint
//
//  Created by Nam Vu on 12/29/19.
//  Copyright © 2019 NamDV. All rights reserved.
//

import Foundation
import Alamofire
import Localize
import SwiftyJSON
import AlamofireSwiftyJSON

class BaseService: BaseServiceManager {
    var limit = 20
    var offset = 0
    var maxLimit = 999999

    var page = 1
    var pageLimit = 5
    var perPage = 20

    /// Number of items of latest server request.
    var numberOfItemsReceived = 0

    var pendingRequest = false

    override init() {
        super.init()
        _ = self.initWith(baseURL: CommonAPI.baseURL)

        //        let token = Storage.shared.loginData?.accessToken ?? ""
        //        self.updateHeaderIfNeed(key: Headers.Authorization, value: "Bearer " + token)
        self.updateHeaderIfNeed(key: Headers.ContentType, value: Headers.ApplicationJson)
        //        let lang = Localize.shared.currentLanguage.prefix(2)
        //        self.updateHeaderIfNeed(key: Headers.Language, value: String(lang))
    }

    func requestPOST<T>(type: T.Type?,
                        params: [String: Any],
                        pathURL: String,
                        messageContent: String = "",
                        isShowLoadding: Bool = true,
                        complete: @escaping (_ response: AnyObject, _ status: Bool, _ code: Int?) -> Void)
        where T: Decodable {
        if isShowLoadding {
            Loading.startAnimation(messageContent: messageContent)
        }
            let dataRequest = sessionManager.request(baseURLAppend(path: pathURL),
                                                     method: .post,
                                                     parameters: params,
                                                     encoding: JSONEncoding.default,
                                                     headers: headers)
           // print("param: \(params)")
        dataRequest.debugLog().responseData { (dataResponse) in
                Loading.stopAnimation()
                self.handleResponse(dataResponse: dataResponse, complete: { (data, status, code) in
                    if status == false {
                        complete(data, status, code)
                        return
                    }
                    if let type = type, let data = data as? Data {
                        // parser data to json.
                        self.paserJsonFromData(type: type, from: data, complete: { responseJson, success in
                            if success {
                                complete(responseJson, status, code)
                            } else {
                                complete(responseJson, false, code)
                            }
                        })
                    } else {
                        // model mapping is nil -> return response data
                        complete(data, status, code)
                        return
                    }
                })
            }.responseSwiftyJSON {dataResponse in
                print(dataResponse.value as Any)
            }
    }

    func uploadImage<T>(type: T.Type?,
                        image: UIImage,
                        params: [String: Any],
                        pathURL: String,
                        complete: @escaping (_ response: AnyObject, _ status: Bool, _ code: Int?) -> Void) where T: Codable {
        guard let imageData = image.jpegData(compressionQuality: 1) else { return }

        Alamofire.upload(multipartFormData: { multipart in
            multipart.append(imageData,
                             withName: "image_data",
                             fileName: UUID().uuidString,
                             mimeType: "image/jpeg")
            for key in params.keys {
                let name = String(key)
                if let val = params[name] as? String {
                    multipart.append(val.data(using: .utf8)!, withName: name)
                }
            }
        }, to: baseURLAppend(path: pathURL), method: .post, headers: ["Content-type": "multipart/form-data"], encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                    print("progress: ", progress)
                })
                upload.responseData(completionHandler: { (dataResponse) in
                    self.handleResponse(dataResponse: dataResponse, complete: { (data, status, code) in
                        if status == false {
                            complete(data, status, code)
                            return
                        }
                        // model mapping is nil -> return response data
                        if type == nil {
                            complete(data, status, code)
                            return
                        }
                        // parser data to json.
                        if let type = type, let data = data as? Data {
                            self.paserJsonFromData(type: type, from: data, complete: { responseJson, success in
                                if success {
                                    complete(responseJson, status, code)
                                } else {
                                    complete(responseJson, false, code)
                                }
                            })
                        }
                    })
                })
            case .failure(let encodingError):
                print("error:\(encodingError)")
                complete(encodingResult as AnyObject, false, nil)
            }
        })
    }

    func increaseOffset() {
        offset += limit
    }

    func resetOffset() {
        offset = 0
    }

    /// Check if there are more data from server
    func canLoadMore() -> Bool {
        if pendingRequest { return false }

        return numberOfItemsReceived >= limit
    }
}
extension Request {
    public func debugLog() -> Self {
        #if DEBUG
        debugPrint("=======================================")
        debugPrint(self)
        debugPrint("=======================================")
        #endif
        return self
    }
}
