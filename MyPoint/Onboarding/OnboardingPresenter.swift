//
//  OnboardingPresenter.swift
//  MyPoint
//
//  Created by Nam Vu on 12/29/19.
//  Copyright © 2019 NamDV. All rights reserved.
//

import Foundation

protocol OnboardingProtocols: NSObjectProtocol {
    func didSelectItem(at index: Int)
}

final class OnboardingPresenter {
    weak var delegate: OnboardingProtocols?

    struct OnboardingData {
        let image: String
        let indicator: String
        let descriptionText: String
        let headerText: String

        init(image: String, indicator: String, descriptionText: String, headerText: String) {
            self.image = image
            self.indicator = indicator
            self.descriptionText = descriptionText
            self.headerText = headerText
        }
    }

    var index = 0
    let data = [
        OnboardingData(image: "onboarding_1",
                       indicator: "indicator_1",
                       descriptionText: "onboarding.content1",
                       headerText: "onboarding.header1"),
        OnboardingData(image: "onboarding_2",
                       indicator: "indicator_2",
                       descriptionText: "onboarding.content2",
                       headerText: "onboarding.header2"),
        OnboardingData(image: "onboarding_3",
                       indicator: "indicator_3",
                       descriptionText: "onboarding.content3",
                       headerText: "onboarding.header3")
    ]

    func handleNext() {
        index += 1
        delegate?.didSelectItem(at: index)
    }

    func handleBack() {
        index -= 1
        delegate?.didSelectItem(at: index)
    }
}
