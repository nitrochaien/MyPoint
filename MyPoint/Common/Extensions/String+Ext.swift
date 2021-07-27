//
//  String+Ext.swift
//  MyPoint
//
//  Created by Nam Vu on 1/5/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation
import Localize

extension String {
    var isValidPhoneNumber: Bool {
        //        let PHONE_REGEX = "(09|01|03|08|05|07|[2|6|8|9])+([0-9]{8})"
        //        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        //        let result =  phoneTest.evaluate(with: self)
        //        return result

        let validCount = count == Defines.maxPhoneNumberCount
        let startWithZero = first == "0"
        return isDigits && validCount && startWithZero
    }

    func sha256() -> String {
        if let stringData = self.data(using: String.Encoding.utf8) {
            return hexStringFromData(input: digest(input: stringData as NSData))
        }
        return ""
    }

    private func digest(input: NSData) -> NSData {
        let digestLength = Int(CC_SHA256_DIGEST_LENGTH)
        var hash = [UInt8](repeating: 0, count: digestLength)
        CC_SHA256(input.bytes, UInt32(input.length), &hash)
        return NSData(bytes: hash, length: digestLength)
    }

    private  func hexStringFromData(input: NSData) -> String {
        var bytes = [UInt8](repeating: 0, count: input.length)
        input.getBytes(&bytes, length: input.length)

        var hexString = ""
        for byte in bytes {
            hexString += String(format: "%02x", UInt8(byte))
        }

        return hexString
    }

    func dateToString(fromFormat: String, _ toFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormat

        var formattedDateString = ""

        if let date = dateFormatter.date(from: self) {
            let calendar = Calendar.current
            let dateComponents: Set<Calendar.Component> = [
                .year, .month, .day, .hour, .minute, .second
            ]
            let components = calendar.dateComponents(dateComponents, from: date)
            let finalDate = calendar.date(from: components)

            let toDateFormatter = DateFormatter()
            toDateFormatter.dateFormat = toFormat
            toDateFormatter.locale = Locale(identifier: "vi")
            formattedDateString = toDateFormatter.string(from: finalDate!)
        }
        return formattedDateString
    }

    func parseToDate(with format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        if let date = dateFormatter.date(from: self) {
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
            return calendar.date(from: components)
        }
        return nil
    }

    func toDate(withFormat format: String = "yyyy-MM-dd HH:mm:ss") -> Date? {

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "vi_VN")
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)

        return date
    }

    var toBoolean: Bool? {
        if self == "true" {
            return true
        } else if self == "false" {
            return false
        }
        return nil
    }

    var htmlToAttributedString: NSAttributedString? {
        let modifiedString = "<style>body{font-family: 'iCielGraphik-Regular'; font-size:16px; color: #032041; line-height: 1.2; }</style>\(self)"
        guard let data = modifiedString.data(using: .utf8, allowLossyConversion: true) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data,
                                          options: [
                                            .documentType: NSAttributedString.DocumentType.html,
                                            .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }

    var membershipHTMLString: NSAttributedString? {
        let modifiedString = "<style>body{font-family: 'iCielGraphik-Regular'; font-size:14px; color: #032041; line-height: 1.2; }</style>\(self)"
        guard let data = modifiedString.data(using: .utf8, allowLossyConversion: true) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data,
                                          options: [
                                            .documentType: NSAttributedString.DocumentType.html,
                                            .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }

    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }

    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }

    var folded: String {
        return self.folding(options: .diacriticInsensitive, locale: nil)
            .replacingOccurrences(of: "đ", with: "d")
            .replacingOccurrences(of: "Đ", with: "D")
    }

    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin,
                                            attributes: [.font: font], context: nil)
        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin,
                                            attributes: [.font: font], context: nil)
        return ceil(boundingBox.width)
    }
}
