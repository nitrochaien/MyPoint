//
//  Date+Ext.swift
//  MyPoint
//
//  Created by Nam Vu on 1/15/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> (dateString: String, type: VoucherDate)? {
        if 1...3 ~= days(from: date) {
            let dateString = String(format: "voucher.day_format".localized, days(from: date))
            return (dateString, .days)
        }
        if 1...24 ~= hours(from: date) {
            let dateString = String(format: "voucher.hour_format".localized, hours(from: date))
            return (dateString, .hours)
        }

        let minute = max(1, minutes(from: date))
        if 1...60 ~= minute {
            let dateString = String(format: "voucher.minute_format".localized, minute)
            return (dateString, .minutes)
        }
        return nil
    }

    func time(from date: Date) -> String? {
        let dayTime = days(from: date)
        let hourTime = hours(from: date)
        if dayTime > 1 {
            return String(format: "voucher.day_format".localized, dayTime)
        } else if dayTime == 1 {
            return String(format: "voucher.hour_format".localized, hourTime)
        }
        if 1...23 ~= hourTime {
            return String(format: "voucher.hour_format".localized, hourTime + 1)
        }

        let minute = max(1, minutes(from: date))
        if 1...59 ~= minute {
            return String(format: "voucher.minute_format".localized, minute + 1)
        } else if minute == 60 {
            return String(format: "voucher.minute_format".localized, minute)
        }
        return nil
    }

    var daysInMonth: Int {
        let calendar = Calendar.current

        let dateComponents = DateComponents(year: calendar.component(.year, from: self), month: calendar.component(.month, from: self))
        let date = calendar.date(from: dateComponents)!

        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count

        return numDays
    }

    var chartDisplay: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormat.chart
        dateFormatter.locale = Locale(identifier: "vi")
        return dateFormatter.string(from: self)
    }
}

enum VoucherDate {
    case days, hours, minutes
    case none
}
