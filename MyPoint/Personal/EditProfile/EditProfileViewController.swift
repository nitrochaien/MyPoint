//
//  EditProfileViewController.swift
//  MyPoint
//
//  Created by Nam Vu on 1/14/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class EditProfileViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet private weak var genderPicker: GenderPicker!
    @IBOutlet private weak var genderBackgroundView: UIView!
    @IBOutlet private weak var confirmButton: UIButton!
    
    fileprivate var isShowingDatePicker = false {
        didSet {
            if oldValue {
                tableView.deleteRows(at: [IndexPath(row: 1, section: SectionType.date.rawValue)],
                                     with: .automatic)
            } else {
                tableView.insertRows(at: [IndexPath(row: 1, section: SectionType.date.rawValue)],
                                     with: .automatic)
            }
        }
    }

    let presenter = EditProfilePresenter()
    private let imagePicker = UIImagePickerController()

    deinit {
        NotificationCenter.default.removeObserver(self)
        print("Deinit EditProfileViewController")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.delegate = self
        presenter.getData()

        imagePicker.delegate = self
        registerKeyboard()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if showFirstTime {
            configGenderPicker()
            configNavigationBar()
            configTableView()
            disableButton()
        }
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    private func configGenderPicker() {
        genderBackgroundView.backgroundColor = .clear
        let dismissGenderGesture = UITapGestureRecognizer(target: self, action: #selector(onDismiss))
        genderBackgroundView.addGestureRecognizer(dismissGenderGesture)
        view.sendSubviewToBack(genderBackgroundView)
        genderPicker.setData(presenter.model.gender)
        genderPicker.delegate = self
    }

    @objc private func onDismiss() {
        genderPicker.hide()
    }

    private func configTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "ProfilePictureTableViewCell",
                                 bundle: nil),
                           forCellReuseIdentifier: "ProfilePictureTableViewCell")
        tableView.register(UINib(nibName: "RawInputTableViewCell",
                                 bundle: nil),
                           forCellReuseIdentifier: "RawInputTableViewCell")
        tableView.register(UINib(nibName: "EditSelectionTableViewCell",
                                 bundle: nil),
                           forCellReuseIdentifier: "EditSelectionTableViewCell")
        tableView.register(UINib(nibName: "InfoTableViewCell",
                                 bundle: nil),
                           forCellReuseIdentifier: "InfoTableViewCell")
        tableView.register(UINib(nibName: "DatePickerTableViewCell",
                                 bundle: nil),
                           forCellReuseIdentifier: "DatePickerTableViewCell")
    }
    
    private func configNavigationBar() {
        customizeBackButton()
        title = "settings.edit_profile_header".localized
    }

    @IBAction private func onConfirm(_ sender: Any) {
        if presenter.checkValidInput() {
            presenter.updateProfile()
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
}

// MARK: DataSource and Delegate
extension EditProfileViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case SectionType.profilePic.rawValue:
            return profilePicCell(tableView, indexPath: indexPath)
        case SectionType.name.rawValue,
             SectionType.nickname.rawValue,
             SectionType.userId.rawValue,
             SectionType.email.rawValue:
            return rawInputCell(tableView,
                                indexPath: indexPath)
        case SectionType.address.rawValue:
            if indexPath.row == 0 {
                return rawInputCell(tableView, indexPath: indexPath)
            }
            return editSelectionCell(tableView,
                                     indexPath: indexPath)
        case SectionType.date.rawValue:
            if isShowingDatePicker {
                if indexPath.row == 1 {
                    return datePickerCell(tableView, indexPath: indexPath)
                }
            }
            return editSelectionCell(tableView,
                                     indexPath: indexPath)
        case SectionType.gender.rawValue:
            return editSelectionCell(tableView,
                                     indexPath: indexPath)
        case SectionType.phone.rawValue:
            return infoCell(tableView, indexPath: indexPath)
        default:
            return UITableViewCell()
        }
    }

    private func profilePicCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cellId = "ProfilePictureTableViewCell"
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? ProfilePictureTableViewCell {
            cell.setImage(byImage: presenter.model.image)
            cell.onTapSelectImage = { [weak self] in
                guard let self = self else { return }
                self.imagePicker.allowsEditing = false
                self.imagePicker.sourceType = .photoLibrary

                self.present(self.imagePicker, animated: true, completion: nil)
            }
            return cell
        }
        return UITableViewCell()
    }

    private func rawInputCell(_ tableView: UITableView,
                              indexPath: IndexPath) -> UITableViewCell {
        let cellId = "RawInputTableViewCell"
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? RawInputTableViewCell {
            let type = SectionType.getValue(from: indexPath.section)
            cell.didEndEditing = { [weak self] value in
                guard let self = self else { return }
                self.presenter.didEdit = true

                switch type {
                case .name:
                    self.presenter.model.name = value ?? ""
                case .nickname:
                    self.presenter.model.nickname = value ?? ""
                case .userId:
                    self.presenter.model.userId = value ?? ""
                case .email:
                    self.presenter.model.email = value ?? ""
                case .address:
                    self.presenter.model.address.street = value ?? ""
                default:
                    break
                }
            }

            switch type {
            case .name:
                cell.setText(self.presenter.model.name)
                cell.setPlaceholder("edit.not_updated".localized)
                cell.keyboardType = .default
                cell.inputTextField.autocapitalizationType = .sentences
            case .nickname:
                cell.setText(self.presenter.model.nickname)
                cell.setPlaceholder("edit.not_updated".localized)
                cell.keyboardType = .default
                cell.inputTextField.autocapitalizationType = .sentences
            case .userId:
                cell.setText(self.presenter.model.userId)
                cell.setPlaceholder("edit.not_updated".localized)
                cell.keyboardType = .numberPad
                cell.inputTextField.autocapitalizationType = .none
            case .email:
                cell.setText(self.presenter.model.email)
                cell.setPlaceholder("edit.email_sample".localized)
                cell.keyboardType = .default
                cell.inputTextField.autocapitalizationType = .none
            case .address:
                cell.setText(self.presenter.model.address.street)
                cell.setPlaceholder("edit.address_placeholder".localized)
                cell.keyboardType = .default
                cell.inputTextField.autocapitalizationType = .none
            default:
                break
            }

            return cell
        }

        return UITableViewCell()
    }

    private func editSelectionCell(_ tableView: UITableView,
                                   indexPath: IndexPath) -> UITableViewCell {
        let cellId = "EditSelectionTableViewCell"
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? EditSelectionTableViewCell {
            cell.updateSection(at: indexPath.section)
            let type = SectionType.getValue(from: indexPath.section)

            cell.didSelectOption = { [weak self] in
                guard let self = self else { return }

                switch type {
                case .address:
                    if indexPath.row == AddressSection.province.rawValue {
                        self.showAddressPicker((type: .province, code: "VN"))
                    } else if indexPath.row == AddressSection.district.rawValue {
                        let provinceCode = self.presenter.model.address.provinceCode
                        if provinceCode.isEmpty {
                            self.showCustomAlert(withTitle: "edit.pick_province".localized,
                                                 andContent: "edit.pick_province_warning".localized)
                        } else {
                            self.showAddressPicker((type: .district,
                                                    code: provinceCode))
                        }
                    }
                case .date:
                    self.isShowingDatePicker.toggle()
                case .gender:
                    self.genderPicker.setData(self.presenter.model.gender)
                    self.genderPicker.show()
                    self.view.bringSubviewToFront(self.genderBackgroundView)
                default:
                    break
                }
            }

            switch type {
            case .address:
                if indexPath.row == AddressSection.province.rawValue {
                    let provinceName = presenter.model.address.provinceName
                    if provinceName.isEmpty {
                        cell.setPlaceholder("edit.pick_province".localized)
                    } else {
                        cell.setTitle(provinceName)
                    }
                } else if indexPath.row == AddressSection.district.rawValue {
                    let districtName = presenter.model.address.districtName
                    if districtName.isEmpty {
                        cell.setPlaceholder("edit.pick_district".localized)
                    } else {
                        cell.setTitle(districtName)
                    }
                }
            case .date:
                let date = presenter.model.date
                if date.isEmpty {
                    cell.setPlaceholder("edit.date".localized)
                } else {
                    cell.setTitle(date)
                }
            case .gender:
                let gender = presenter.model.gender.display
                if gender.isEmpty {
                    cell.setPlaceholder("edit.pick".localized)
                } else {
                    cell.setTitle(gender, !genderPicker.isShowing)
                }
            default:
                break
            }

            return cell
        }
        return UITableViewCell()
    }

    private func showAddressPicker(_ type: ProvinceSearchPresenter.DataType) {
        let storyboard = UIStoryboard(name: "ProvinceSearch", bundle: nil)
        let viewController = storyboard
            .instantiateViewController(withIdentifier: "ProvinceSearchViewController") as? ProvinceSearchViewController
        viewController?.delegate = self
        viewController?.setType(type)
        viewController?.setSelectedItem(type.type == .province ? presenter.selectedProvince : presenter.selectedDistrict)
        navigationController?.pushViewController(viewController!, animated: true)
    }

    private func infoCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cellId = "InfoTableViewCell"
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? InfoTableViewCell {
            cell.setInfo(presenter.model.phone)
            return cell
        }
        return UITableViewCell()
    }

    private func datePickerCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cellId = "DatePickerTableViewCell"
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? DatePickerTableViewCell {
            cell.onDateChanged = { [weak self] value in
                guard let self = self else { return }
                self.presenter.didEdit = true

                self.presenter.model.date = value
                tableView.reloadRows(at: [IndexPath(row: 0, section: indexPath.section)],
                                     with: .automatic)
            }
            return cell
        }
        return UITableViewCell()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return SectionType.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case SectionType.profilePic.rawValue,
             SectionType.name.rawValue,
             SectionType.nickname.rawValue,
             SectionType.phone.rawValue,
             SectionType.gender.rawValue,
             SectionType.userId.rawValue,
             SectionType.email.rawValue:
            return 1
        case SectionType.date.rawValue:
            return isShowingDatePicker ? 2 : 1
        case SectionType.address.rawValue:
            return AddressSection.allCases.count
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case SectionType.profilePic.rawValue:
            return 144
        case SectionType.date.rawValue:
            if indexPath.row == 1 {
                return 144
            }
            return 64
        default:
            return 64
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return EditProfileViewController.SectionType.getHeaderName(from: section)
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight(500))
            header.textLabel?.textColor = UIColor(hexString: "#032041")
            header.contentView.backgroundColor = .white
        }
    }
}

extension EditProfileViewController: EditProfilePresenterDelegate {
    func requestSuccess() {
        showCustomAlert(withTitle: "Cập nhật thông tin",
                        andContent: "Cập nhật thông tin thành công.") { [weak self] in
                            self?.navigationController?.popViewController(animated: true)
        }
    }

    func enableConfirmButton() {
        enableButton()
    }
}

extension EditProfileViewController: GenderPickerDelegate {
    func didHide() {
        view.sendSubviewToBack(genderBackgroundView)
    }

    func didChoose(_ gender: PersonalGender) {
        presenter.didEdit = true
        presenter.model.gender = gender
        tableView.reloadRows(at: [IndexPath(row: 0, section: SectionType.gender.rawValue)],
                             with: .automatic)
    }
}

extension EditProfileViewController: ProvinceSearchProtocol {
    func itemChosen(_ item: ProvinceSearchPresenter.DisplayItem,
                    type: ProvinceSearchPresenter.ListType) {
        presenter.didEdit = true

        let districtIndexPath = IndexPath(row: AddressSection.district.rawValue, section: SectionType.address.rawValue)
        let provinceIndexPath = IndexPath(row: AddressSection.province.rawValue, section: SectionType.address.rawValue)

        if type == .province {
            presenter.model.address.provinceCode = item.code
            presenter.model.address.provinceName = item.name
            presenter.selectedProvince = item

            // Reset district
            presenter.selectedDistrict = nil
            presenter.model.address.districtName = ""
            presenter.model.address.districtCode = ""

            tableView.reloadRows(at: [districtIndexPath, provinceIndexPath],
                                 with: .automatic)
        } else {
            presenter.model.address.districtCode = item.code
            presenter.model.address.districtName = item.name
            presenter.selectedDistrict = item

            tableView.reloadRows(at: [districtIndexPath],
            with: .automatic)
        }
    }
}
