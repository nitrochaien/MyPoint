//
//  HistoryChartTableViewCell.swift
//  MyPoint
//
//  Created by Nam Vu on 2/19/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit
import Charts

final class HistoryChartTableViewCell: UITableViewCell {

    @IBOutlet private weak var pointLabel: UILabel!
    @IBOutlet private weak var dateButton: UIButton!
    @IBOutlet private weak var previousMonthButton: UIButton!
    @IBOutlet private weak var nextMonthButton: UIButton!
    @IBOutlet private weak var chartView: BarChartView!
    @IBOutlet private weak var containerView: UIView!

    var onChangePrevious: (() -> Void)?
    var onChangeNext: (() -> Void)?
    var onChangeDate: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none

        containerView.addShadow(ofColor: .lightGray,
                                radius: 8,
                                offset: .zero,
                                opacity: 0.5)
        chartView.config()
    }

    func setData(_ data: ChartData?, date: Date) {
        dateButton.setTitle(date.chartDisplay.capitalizingFirstLetter(), for: .normal)

        let reward = Double(data?.month?.rewardMonthTotal ?? "") ?? 0
        pointLabel.text = reward.formattedWithSeparator
        pointLabel.textColor = UIColor(hexString: "#21C777")
        chartView.updateUI(with: date, and: data)
    }

    func setStatus(_ status: AllHistoryPresenter.DateSelectionStatus) {
        switch status {
        case .first:
            previousMonthButton.alpha = 0.5
            previousMonthButton.isUserInteractionEnabled = false
        case .last:
            nextMonthButton.alpha = 0.5
            nextMonthButton.isUserInteractionEnabled = false
        case .middle:
            previousMonthButton.alpha = 1
            previousMonthButton.isUserInteractionEnabled = true
            nextMonthButton.alpha = 1
            nextMonthButton.isUserInteractionEnabled = true
        }
    }
    
    @IBAction private func onChangePreviousMonth(_ sender: Any) {
        onChangePrevious?()
    }

    @IBAction private func onChangeNextMonth(_ sender: Any) {
        onChangeNext?()
    }

    @IBAction private func onChangeDate(_ sender: Any) {
        onChangeDate?()
    }
}

extension BarChartView {
    func config() {
        drawValueAboveBarEnabled = false
        legend.enabled = false
        fitBars = true
        isUserInteractionEnabled = false

        noDataText = "alert.no_data".localized
        noDataFont = UIFont.systemFont(ofSize: 15)
        noDataTextColor = UIColor(hexString: "#032041")!

        xAxis.labelPosition = .bottom
        xAxis.drawGridLinesEnabled = false
        xAxis.drawAxisLineEnabled = false
        xAxis.avoidFirstLastClippingEnabled = true

        rightAxis.drawLabelsEnabled = false
        rightAxis.drawAxisLineEnabled = false

        leftAxis.drawAxisLineEnabled = false
    }

    func updateUI(with date: Date, and data: ChartData?) {
        guard let dailyData = data?.days else { return }

        let days = date.daysInMonth

        var entries = [BarChartDataEntry]()
        var daysDisplay = [""]
        for i in 1...days {
            var entry: BarChartDataEntry

            if let monthData = dailyData
                .first(where: { $0.summaryDate?.toDate(withFormat: DateFormat.profileRequest)?.day ?? 0 == i}) {
                let yValue = Double(monthData.rewardDayTotal ?? "") ?? 0
                entry = .init(x: Double(i), y: max(0, yValue))
            } else {
                entry = .init(x: Double(i), y: 0)
            }
            entries.append(entry)

            let set = Set([1, 5, 10, 15, 20, 25, days])
            if set.contains(i) {
                daysDisplay.append(String(i))
            } else {
                daysDisplay.append("")
            }
        }
        let dataSet = BarChartDataSet(entries: entries)
        dataSet.drawValuesEnabled = false
        dataSet.colors = [UIColor(hexString: "#FE515A")!]

        let data = BarChartData(dataSets: [dataSet])
        xAxis.axisMinimum = 0.5
        xAxis.axisMaximum = Double(days) + 0.5
        xAxis.setLabelCount(days, force: false)
        xAxis.valueFormatter = IndexAxisValueFormatter(values: daysDisplay)
        xAxis.granularity = 1

        self.data = data
        animate(xAxisDuration: 0.6)
    }
}
