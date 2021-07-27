//
//  MonthPickerViewController.swift
//  MyPoint
//
//  Created by Nam Vu on 2/20/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

class MonthPickerViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    class Value {
        let text: String
        var selected: Bool

        init(text: String, selected: Bool = false) {
            self.text = text
            self.selected = selected
        }
    }

    var didSelect: ((_ date: Date) -> Void)?

    private var values = [Value]()

    override func viewDidLoad() {
        super.viewDidLoad()

        configTableView()
    }

    func setData(_ dates: [Date],
                 selectedDate: Date,
                 showAll: Bool) {
        var foundSelected = false
        var newValues = [Value]()
        for date in dates {
            let text = date.chartDisplay.capitalizingFirstLetter()
            let matched = date.month == selectedDate.month && date.year == selectedDate.year
            if matched {
                foundSelected = matched
            }
            newValues.append(.init(text: text, selected: matched))
        }
        if showAll {
            newValues.append(.init(text: "personal.filter_date".localized,
                                   selected: !foundSelected))
        }
        values = newValues.reversed()
    }

    private func configTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    @IBAction func onDismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension MonthPickerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") {
            cell.selectionStyle = .none
            let value = values[indexPath.row]
            cell.textLabel?.text = value.text
            cell.accessoryType = value.selected ? .checkmark : .none
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return values.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            if let date = self.values[indexPath.row].text.toDate(withFormat: DateFormat.chart) {
                self.didSelect?(date)
            }
        }
    }
}
