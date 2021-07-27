//
//  HuntFounderPresenter.swift
//  MyPoint
//
//  Created by Nam Vu on 2/16/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

class HuntFounderPresenter: APIResponseMethods {
    var images = [UploadImage]()
    var selectingIndex = -1
    var title = ""
    var feedback = ""

    enum ErrorCode {
        case exceedTitle, exceedFeedback
        case valid
    }

    private let service = PointHuntingService()
    weak var delegate: BaseProtocols?

    var validInput: ErrorCode {
        if title.count > 255 {
            return .exceedTitle
        }
        if feedback.count > 500 {
            return .exceedFeedback
        }
        return .valid
    }

    var enableButton: Bool {
        let hasText = !title.isEmpty && !feedback.isEmpty
        let hasImage = true // images.first { $0.type == .loaded } != nil
        return hasText && hasImage
    }

    func initImages() {
        for i in 0...4 {
            if i == 0 {
                images.append(.init(type: .placeholder))
            } else {
                images.append(.init(type: .empty))
            }
        }
    }

    func updateData(_ image: UIImage) {
        if selectingIndex >= images.count {
            selectingIndex = images.count - selectingIndex
        }
        images[safe: selectingIndex]?.image = image
        images[safe: selectingIndex]?.type = .loaded
        images[safe: selectingIndex + 1]?.type = .placeholder

        selectingIndex += 1
    }

    func deleteImage(at index: Int) {
        images[safe: index]?.image = nil
        images[safe: index]?.type = .empty

        var selected = [UploadImage]()
        var empty = [UploadImage]()
        for image in images {
            if image.type == .loaded {
                selected.append(image)
            } else {
                image.type = .empty
                empty.append(image)
            }
        }
        empty.first?.type = .placeholder
        selected.append(contentsOf: empty)

        images = selected
    }

    func createSubmission() {
        service.createRequestPointHunting(title: title, feedback: feedback) { [weak self] response, success in
            guard let self = self else { return }
            if success {
                if let response = response as? PointHuntingCreateRequestResponse {
                    guard self.noError(from: response) else { return }
                    guard self.images.count > 0 else {
                        self.delegate?.requestSuccess()
                        return
                    }

                    DispatchQueue.main.async {
                        let id = response.data?.feedbackid ?? ""
                        let group = DispatchGroup()
                        for uploadImage in self.images {
                            self.uploadImages(group: group, with: id, and: uploadImage.image)
                        }
//                        let rawImages = self.images.map { uploadImage -> UIImage? in
//                            return uploadImage.image
//                        }
//                        self.uploadImages(group: group, with: id, and: rawImages)
                        group.notify(queue: .main) {
                            self.delegate?.requestSuccess()
                        }
                    }
                }
            }
        }
    }

    func uploadImages(group: DispatchGroup,
                      with id: String,
                      and image: UIImage?) {
//        guard let image = image?.compressed(quality: 0.8) else { return }
        guard let image = image else { return }

        group.enter()
        service.submitFeedbackImages(image: image, id: id) { [weak self] response, success in
            guard let self = self else {
                group.leave()
                return
            }
            if success {
                if let response = response as? GeneralResponse {
                    guard self.noError(from: response) else {
                        group.leave()
                        return
                    }
                    group.leave()
                }
            }
        }
    }

    func showError(message: String = "api.request_fail".localized) {
        delegate?.showError(message: message)
    }
}

class UploadImage {
    var image: UIImage?
    var type: ImageCollectionViewCell.CellType = .empty

    init(type: ImageCollectionViewCell.CellType) {
        self.type = type
    }
}
