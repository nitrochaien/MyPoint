//
//  ServiceDefines.swift
//  MyPoint
//
//  Created by Nam Vu on 12/29/19.
//  Copyright © 2019 NamDV. All rights reserved.
//

import UIKit

struct Headers {
    static let ContentType = "Content-Type"
    static let Accept = "Accept"
    static let Authorization = "Authorization"
    static let ApplicationJson = "application/json"
    static let ApplicationFormUrlencoded = "application/x-www-form-urlencoded"
    static let ApplicationFormData = "application/form-data"
    static let MultipartFormData = "multipart/form-data"
    static let TextHtml = "text/html"
    static let Language = "language"
}

enum FileType {
    case image
    case link
}

struct UploadFile {
    // type image or link
    var fileType: FileType

    var fileName: String?
    var withName: String?
    var mimeType: String?
    var scale: Float?

    // local file to upload
    var pathFile: String?
    // type image to upload
    var image: UIImage?

    // full URL upload
    var url: NSURL?
}
