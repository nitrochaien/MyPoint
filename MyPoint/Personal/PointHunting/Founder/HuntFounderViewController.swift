//
//  HuntFounderViewController.swift
//  MyPoint
//
//  Created by Nam Vu on 2/15/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit
import BSImagePicker
import Photos

final class HuntFounderViewController: BaseViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var confirmButton: UIButton!

    private var cellHeights = [IndexPath: CGFloat]()
    
    fileprivate let presenter = HuntFounderPresenter()
    private let maxImageSize = 10 * 1024 * 1024

    enum SectionType: Int, CaseIterable {
        case header = 0, title, feedback, images

        static func headerTitle(of index: Int) -> String {
            switch index {
            case SectionType.header.rawValue:
                return ""
            case SectionType.title.rawValue:
                return "founder.title".localized
            case SectionType.feedback.rawValue:
                return "founder.feedback".localized
            case SectionType.images.rawValue:
                return "founder.images".localized
            default:
                return ""
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "founder.header".localized
        customizeBackButton()

        presenter.initImages()
        configTableView()
        registerKeyboard()
        disableButton()

        presenter.delegate = self
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
        print("Deinit HuntFounderViewController")
    }

    @IBAction private func onConfirm(_ sender: Any) {
        switch presenter.validInput {
        case .exceedFeedback:
            showCustomAlert(withTitle: "founder.exceed".localized,
                            andContent: "founder.ex_feedback".localized)
        case .exceedTitle:
            showCustomAlert(withTitle: "founder.exceed".localized,
                            andContent: "founder.ex_title".localized)
        case .valid:
            presenter.createSubmission()
        }
    }

    private func disableButton() {
        confirmButton.setBackgroundImage(nil, for: .normal)
        confirmButton.backgroundColor = UIColor(hexString: "#98A1AF", transparency: 0.5)
        confirmButton.isUserInteractionEnabled = false
    }

    private func enableButton() {
        confirmButton.setBackgroundImage(UIImage(named: "btn_continue_background"), for: .normal)
        confirmButton.backgroundColor = .white
        confirmButton.isUserInteractionEnabled = true
    }
    
    private func registerKeyboard() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onKeyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onKeyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }

    @objc private func onKeyboardWillShow(_ notification: Notification) {
        let value = notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue
        if let keyboardSize = value?.cgRectValue {
            tableView.contentInset = .init(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }

    @objc private func onKeyboardWillHide(_ notification: Notification) {
        tableView.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
    }

    private func configTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none

        tableView.register(UINib(nibName: "FounderHeaderTableViewCell",
                                 bundle: nil),
                           forCellReuseIdentifier: "FounderHeaderTableViewCell")
        tableView.register(UINib(nibName: "RawInputTableViewCell",
                                 bundle: nil),
                           forCellReuseIdentifier: "RawInputTableViewCell")
        tableView.register(UINib(nibName: "ImagesTableViewCell",
                                 bundle: nil),
                           forCellReuseIdentifier: "ImagesTableViewCell")
        tableView.register(UINib(nibName: "FounderFeedbackTableViewCell",
                                 bundle: nil),
                           forCellReuseIdentifier: "FounderFeedbackTableViewCell")
    }

    fileprivate func selectImage(at index: Int) {
        presenter.selectingIndex = index

        let imagePicker = ImagePickerController()
        let options = imagePicker.settings.fetch.album.options
        imagePicker.settings.fetch.album.fetchResults = [
            PHAssetCollection.fetchAssetCollections(with: .album,
                                                    subtype: .albumRegular,
                                                    options: options),
            PHAssetCollection.fetchAssetCollections(with: .smartAlbum,
                                                    subtype: .smartAlbumUserLibrary,
                                                    options: options)
        ]

        let unselectedCount = presenter.images
            .filter { image -> Bool in
            return image.type == .loaded
        }.count
        imagePicker.settings.selection.max = 5 - unselectedCount

        self.presentImagePicker(imagePicker, select: nil, deselect: nil, cancel: nil, finish: { assets in
            for asset in assets {
                    var value = UIImage()
                    PHImageManager
                        .default()
                        .requestImageData(for: asset, options: nil, resultHandler: { data, _, _, _ in
                            if let data = data {
                                value = UIImage(data: data) ?? UIImage()
                                self.presenter.updateData(value)
                                self.tableView.reloadData()
                            }
                        })
            }
            if self.presenter.enableButton {
                self.enableButton()
            }
        })
    }
}

extension HuntFounderViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case SectionType.header.rawValue:
            return headerCell(tableView, indexPath: indexPath)
        case SectionType.title.rawValue:
            return inputCell(tableView, indexPath: indexPath)
        case SectionType.feedback.rawValue:
            return feedbackCell(tableView, indexPath: indexPath)
        case SectionType.images.rawValue:
            return imageCell(tableView, indexPath: indexPath)
        default:
            return UITableViewCell()
        }
    }

    private func headerCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView
            .dequeueReusableCell(withIdentifier: "FounderHeaderTableViewCell") as? FounderHeaderTableViewCell {
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeights[indexPath] = cell.frame.size.height
    }

    private func inputCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView
            .dequeueReusableCell(withIdentifier: "RawInputTableViewCell") as? RawInputTableViewCell {
            cell.didEndEditing = { [weak self] text in
                guard let self = self else { return }
                self.presenter.title = text ?? ""
                if self.presenter.enableButton {
                    self.enableButton()
                }
            }
            return cell
        }
        return UITableViewCell()
    }

    private func feedbackCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView
            .dequeueReusableCell(withIdentifier: "FounderFeedbackTableViewCell") as? FounderFeedbackTableViewCell {
            cell.onTextChanged = { [weak self] text in
                guard let self = self else { return }
                self.presenter.feedback = text
                if self.presenter.enableButton {
                    self.enableButton()
                }
            }
            return cell
        }
        return UITableViewCell()
    }

    private func imageCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView
            .dequeueReusableCell(withIdentifier: "ImagesTableViewCell") as? ImagesTableViewCell {
            cell.setData(presenter.images)

            cell.onUploadImage = { [weak self] index in
                guard let self = self else { return }
                self.selectImage(at: index)
            }
            cell.onDeleteImage = { [weak self] index in
                self?.presenter.deleteImage(at: index)
                self?.tableView.reloadData()
            }

            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return SectionType.allCases.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return SectionType.headerTitle(of: section)
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight(500))
            header.textLabel?.textColor = UIColor(hexString: "#032041")
            header.contentView.backgroundColor = .white
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == SectionType.header.rawValue {
            return 0
        }
        return 40
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = cellHeights[indexPath]
        return height ?? UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension HuntFounderViewController: BaseProtocols {
    func requestSuccess() {
        let username = Storage.shared.loginData?.workerSite?.usernameDisplay ?? ""
        showCustomAlert(withTitle: "founder.thank".localized,
                        andContent: String(format: "founder.thank_body".localized, username)) { [weak self] in
                            self?.navigationController?.popViewController(animated: true)
        }
    }
}
