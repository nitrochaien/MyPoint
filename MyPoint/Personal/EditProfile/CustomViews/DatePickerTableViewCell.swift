//
//  DatePickerTableViewCell.swift
//  MyPoint
//
//  Created by Nam Vu on 1/28/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit
import Localize

final class DatePickerTableViewCell: UITableViewCell {

    @IBOutlet private weak var datePicker: UIDatePicker!

    var onDateChanged: ((_ value: String) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none

        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        datePicker.locale = Locale(identifier: Localize.shared.currentLanguage)
        datePicker.addTarget(self, action: #selector(onUpdate), for: .valueChanged)
    }

    @objc private func onUpdate(_ sender: UIDatePicker) {
        let selectedValue = sender.date.string(withFormat: DateFormat.profile)
        onDateChanged?(selectedValue)
    }
}
