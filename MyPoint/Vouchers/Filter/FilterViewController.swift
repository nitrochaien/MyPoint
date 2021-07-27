//
//  FilterViewController.swift
//  MyPoint
//
//  Created by Nam Vu on 2/2/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class FilterViewController: BaseViewController {

    @IBOutlet private weak var tableView: UITableView!

    private let presenter = FilterPresenter()

    var onApply: ((_ properties: FilterPresenter.Properties) -> Void)?

    enum DataType {
        case voucher, merchant
    }
    var dataType = DataType.voucher

    private enum SectionType: Int, CaseIterable {
        case categories = 0, province, districts

        static func getHeaderName(from section: Int) -> String {
            switch section {
            case SectionType.categories.rawValue:
                return "voucher.categories".localized
            case SectionType.province.rawValue:
                return "voucher.province".localized
            case SectionType.districts.rawValue:
                return "voucher.districts".localized
            default:
                return ""
            }
        }
    }

    func setSelectingData(_ data: SearchParams) {
        presenter.properties = FilterPresenter.Properties(categories: data.categories,
                                                          province: data.province,
                                                          districtCodes: data.districtCodes)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configNavigationBar()

        presenter.delegate = self

        configTableView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if showFirstTime {
            presenter.requestData()
        }
    }

    private func configNavigationBar() {
        let leftItem = UIBarButtonItem(image: UIImage(named: "ic_close"),
                                       style: .plain,
                                       target: self,
                                       action: #selector(onDismiss))
        leftItem.tintColor = UIColor(hexString: "#032041")
        navigationItem.leftBarButtonItem = leftItem

        let rightItem = UIBarButtonItem(title: "filter.reset".localized,
                                        style: .plain,
                                        target: self,
                                        action: #selector(resetAll))
        rightItem.tintColor = UIColor(hexString: "#E71D28")
        navigationItem.rightBarButtonItem = rightItem

        title = "filter.title".localized
    }

    @objc private func onDismiss() {
        dismiss(animated: true, completion: nil)
    }

    @objc private func resetAll() {
        presenter.reset()
        presenter.getListDistrict(provinceCode: presenter.selectedProvince?.code ?? "")
    }

    private func configTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none

        tableView.register(UINib(nibName: "FilterCategoryTableViewCell",
                                 bundle: nil),
                           forCellReuseIdentifier: "FilterCategoryTableViewCell")
        tableView.register(UINib(nibName: "FilterTableViewCell",
                                 bundle: nil),
                           forCellReuseIdentifier: "FilterTableViewCell")
        tableView.register(UINib(nibName: "EditSelectionTableViewCell",
                                 bundle: nil),
                           forCellReuseIdentifier: "EditSelectionTableViewCell")
    }

    @IBAction private func onTapConfirm(_ sender: Any) {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.onApply?(self.presenter.requestProperties)
        }
    }

    fileprivate func showAddressPicker(_ type: ProvinceSearchPresenter.DataType) {
        let storyboard = UIStoryboard(name: "ProvinceSearch", bundle: nil)
        let viewController = storyboard
            .instantiateViewController(withIdentifier: "ProvinceSearchViewController") as? ProvinceSearchViewController
        viewController?.delegate = self
        viewController?.setType(type)
        viewController?.setSelectedItem(presenter.selectedProvince)
        navigationController?.pushViewController(viewController!, animated: true)
    }
}

extension FilterViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case SectionType.categories.rawValue:
            if let cell = tableView
                .dequeueReusableCell(withIdentifier: "FilterCategoryTableViewCell") as? FilterCategoryTableViewCell {
                cell.setData(presenter.categories)
                return cell
            }
        case SectionType.province.rawValue:
            return editSelectionCell(tableView, indexPath: indexPath)
        case SectionType.districts.rawValue:
            if let cell = tableView
                .dequeueReusableCell(withIdentifier: "FilterTableViewCell") as? FilterTableViewCell {
                cell.setData(presenter.districts)
                return cell
            }
        default:
            break
        }
        return UITableViewCell()
    }

    private func editSelectionCell(_ tableView: UITableView,
                                   indexPath: IndexPath) -> UITableViewCell {
        let cellId = "EditSelectionTableViewCell"
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? EditSelectionTableViewCell {
            cell.updateFilterSection()
            cell.didSelectOption = { [weak self] in
                self?.showAddressPicker((type: .province, code: "VN"))
            }
            cell.setTitle(presenter.selectedProvince?.name ?? "")

            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == SectionType.districts.rawValue {
            return 50
        }

        if indexPath.section == SectionType.province.rawValue {
            return 70
        }

        return 120
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return SectionType.getHeaderName(from: section)
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(500))
            header.textLabel?.textColor = UIColor(hexString: "#032041")
            header.contentView.backgroundColor = .white
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        let count = SectionType.allCases.count
        return presenter.selectedProvince == nil ? count - 1 : count
    }
}

extension FilterViewController: BaseProtocols {
    func requestSuccess() {
        tableView.reloadData()
    }
}

extension FilterViewController: ProvinceSearchProtocol {
    func itemChosen(_ item: ProvinceSearchPresenter.DisplayItem,
                    type: ProvinceSearchPresenter.ListType) {
        presenter.selectedProvince = item
        presenter.districts.removeAll()
        presenter.getListDistrict(provinceCode: item.code)
    }
}
