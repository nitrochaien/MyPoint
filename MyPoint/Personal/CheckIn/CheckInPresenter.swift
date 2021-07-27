//
//  CheckInPresenter.swift
//  MyPoint
//
//  Created by Nam Vu on 2/13/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

class CheckInPresenter: APIResponseMethods {
    var items = [CheckInItem]()

    var points: Double = 0
    var rewardValue: Double = 0
    var needsToTriggerAlert = false

    private let service = CheckInService()

    weak var delegate: BaseProtocols?

    var didCheckInToday: Bool {
        return items.filter { item -> Bool in
            return item.type == .today
        }.isEmpty
    }

    func getItems() {
        let amount = Storage.shared.loginData?.workingSite?.customerBalance?.amountActive ?? ""
        points = Double(amount) ?? 0

        service.getRewardList { [weak self] response, success in
            guard let self = self else { return }
            if success {
                if let response = response as? ListCheckinResponse {
                    guard self.noError(from: response) else { return }

                    guard let counters = response.data?.counters else { return }

                    var counter = 0
                    var daily = [CounterValue]()
                    for counts in counters {
                        guard let counterEnum = counts.counterValues else { return }

                        switch counterEnum {
                        case .counterValue(let value):
                            counter = Int(value.counterValue ?? "") ?? 0
                        case .counterValueArray(let array):
                            daily = array
                        }
                    }

                    let dailyValues = daily

                    if counter > dailyValues.count { return }

                    let dailyCount = dailyValues.count
                    if counter == dailyCount || counter == 0 {
                        self.items.append(.today)
                        for i in 2...7 {
                            let name = String(format: "check-in.day_format".localized, i)
                            let item = CheckInItem(title: name, type: .notCheckedIn)
                            self.items.append(item)
                        }
                    } else {
                        var addedToday = false
                        // Draw checked in
                        for i in 1...counter {
                            if i == counter {
                                // First daily value determine if today is checked
                                if dailyValues.first!.checkedIn {
                                    addedToday = true
                                    self.items.append(.checkedInToday)
                                } else {
                                    let name = String(format: "check-in.day_format".localized, i)
                                    self.items.append(.init(title: name, type: .checkedIn))
                                }
                            } else {
                                let name = String(format: "check-in.day_format".localized, i)
                                self.items.append(.init(title: name, type: .checkedIn))
                            }
                        }
                        counter += 1

                        // Draw today if needed
                        if !addedToday {
                            self.items.append(.today)
                            counter += 1
                        }

                        // Draw not checked in
                        for i in counter...7 {
                            let name = String(format: "check-in.day_format".localized, i)
                            self.items.append(.init(title: name, type: .notCheckedIn))
                        }
                    }

                    self.delegate?.requestSuccess()
                }
            } else {
                self.showError()
            }
        }
    }

    func checkIn() {
        service.submitCheckIn { [weak self] response, success in
            guard let self = self else { return }
            if success {
                if let response = response as? SubmitCheckInResponse {
                    guard self.noError(from: response) else { return }

                    let reward = response.data?.reward ?? ""
                    let rewardValue = Double(reward) ?? 0

                    self.points += rewardValue
                    self.rewardValue = rewardValue
                    Storage.shared
                        .loginData?
                        .workingSite?
                        .customerBalance?.setNewAmount(with: response.data?.customerBalance)

                    self.items.forEach(where: { item -> Bool in
                        item.type == .today
                    }) { item in
                        item.type = .checkedIn
                    }
                    self.needsToTriggerAlert = true
                    self.delegate?.requestSuccess()
                }
            } else {
                self.showError()
            }
        }
    }

    func showError(message: String = "api.request_fail".localized) {
        delegate?.showError(message: message)
    }
}
