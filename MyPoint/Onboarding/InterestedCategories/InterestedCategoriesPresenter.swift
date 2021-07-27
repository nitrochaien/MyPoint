//
//  InterestedCategoriesPresenter.swift
//  MyPoint
//
//  Created by Nam Vu on 1/21/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

protocol InterestedCategoriesPresenterDelegate: BaseProtocols {
    func didSubmitSelectedItems()
}

class InterestedCategoriesPresenter: APIResponseMethods {

    private let service = SplashScreenServices()
    weak var delegate: InterestedCategoriesPresenterDelegate?

    var categories = [InterestedItem]()

    var allowsToProceed: Bool {
        let firstItem = categories.first { item -> Bool in
            return item.isSelected
        }
        return firstItem != nil
    }

    func submitSelectedItems() {
        subCategories()
    }

    private func subCategories() {
        let codes = categories
            .filter({ (item) -> Bool in
                return item.isSelected
            })
            .map({ item -> String in
                return item.code
            })
            .joined(separator: ",")

        service.requestSubCategories(codes: codes) { [weak self] (response, success) in
            guard let self = self else { return }
            if success {
                if let response = response as? GeneralResponse {
                    guard self.noError(from: response) else { return }
                    self.unsubCategories()
                }
            } else {
                self.showError()
            }
        }
    }

    private func unsubCategories() {
        let codes = categories
        .filter({ (item) -> Bool in
            return !item.isSelected
        })
        .map({ item -> String in
            return item.code
        })
        .joined(separator: ",")

        service.requestUnsubCategories(codes: codes) { [weak self] (response, success) in
            guard let self = self else { return }
            if success {
                if let response = response as? GeneralResponse {
                    guard self.noError(from: response) else { return }
                    self.delegate?.didSubmitSelectedItems()
                }
            } else {
                self.showError()
            }
        }
    }

    func requestCategoryList() {
        service.requestCategoryList { [weak self] (response, success) in
            guard let self = self else { return }
            if success {
                if let response = response as? InterestedResponse {
                    guard self.noError(from: response) else { return }
                    self.categories = response.data?.listItems?.map({ item -> InterestedItem in
                        return .init(item)
                    }) ?? []
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
