//
//  VoucherSearchViewController.swift
//  MyPoint
//
//  Created by Hieu Nguyen on 1/31/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit
import CoreLocation

final class VoucherSearchViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var headerLabel: UILabel!
    @IBOutlet private weak var filterButton: UIButton!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet fileprivate weak var buttonDistrictSearch: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tabView: SearchTabView!
    @IBOutlet weak var tabViewTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var noLocationErrorView: UIView!
    
    let presenter = VoucherSearchPresenter()
    let locationManager = CurrentLocationManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()

        initView()

        searchBar.delegate = self
        presenter.delegate = self
        locationManager.delegate = self
    }

    deinit {
        print("Deinit VoucherSearchViewController")
    }

    private func configTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SuggestCell", bundle: nil), forCellReuseIdentifier: "SuggestCell")
        tableView.registerEmptyCell()

        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
        tableView.refreshControl = refresh
    }

    @objc private func onRefresh() {
        presenter.refresh()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if showFirstTime {
            presenter.refresh()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }

    private func initView() {
        searchBar.customized()
        searchBar.delegate = self
        searchBar.becomeFirstResponder()

        buttonDistrictSearch.setTitle("Hà Nội", for: .normal)

        hideKeyboardWhenTappedAround()
        configTableView()
        configCollectionView()

        tabView.alpha = 0
        tabViewTopConstraint.constant = -44
        tabView.didSelected = { [weak self] type in
            guard let self = self else { return }

            self.presenter.requestTab = type
            self.presenter.clearAllData()
            self.requestSuccess()

            switch type {
            case .all:
                self.presenter.searchParams.removeLocationRequest()
                self.presenter.refresh()
            case .nearby:
                if self.locationManager.canGetLocation {
                    self.locationManager.requestLocation()
                } else {
                    self.locationManager.requestWhenInUseAuthorization()
                }
            }
        }

        showFilter()
    }

    private func showHideNoLocationError() {
        if presenter.requestTab == .all {
            tableView.isHidden = false
            noLocationErrorView.isHidden = true
            return
        }

        if locationManager.canGetLocation {
            tableView.isHidden = false
            noLocationErrorView.isHidden = true
        } else {
            tableView.isHidden = true
            noLocationErrorView.isHidden = false
        }
    }

    private func showFilter() {
        let searcher = presenter.searchParams
        let show = searcher.isSearchingWithKeywords

        if searcher.isFiltering {
            filterButton.setImage(UIImage(named: "ic_filter_active"), for: .normal)
        } else {
            filterButton.setImage(UIImage(named: "Group-1"), for: .normal)
        }

        if show {
            let count = presenter.suggestItems.count
            let resultsTemplate = "voucher.results".localized
            let items = presenter.totalItems
            let resultString = items > 0 ? String(format: resultsTemplate, items) : ""
            headerLabel.text = count == 0 ? "voucher.result_empty".localized : resultString

            tabViewTopConstraint.constant = 0
            UIView.animate(withDuration: 0.2) {
                self.tabView.alpha = 1
                self.filterButton.isHidden = false
                self.view.layoutIfNeeded()
            }
        } else {
            headerLabel.text = "voucher.all_voucher".localized

            tabViewTopConstraint.constant = -44
            UIView.animate(withDuration: 0.2) {
                self.tabView.alpha = 0
                self.filterButton.isHidden = true
                self.view.layoutIfNeeded()
            }
        }
    }

    @IBAction private func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func dequeueSuggestCell(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "SuggestCell", for: indexPath) as? SuggestCell else {
            fatalError("Empty Cell")
        }

        if let voucher = presenter.suggestItems[safe: indexPath.row] {
            cell.setData(voucher: voucher)
        }

        if indexPath.row == presenter.suggestItems.count - 1 {
            presenter.loadMore()
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = presenter.suggestItems.count
        return count == 0 ? 1 : count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "VoucherDetail", bundle: nil)
        let viewController = storyboard
            .instantiateViewController(withIdentifier: "VoucherDetailViewController") as? VoucherDetailViewController
        viewController?.voucherId = presenter.suggestItems[safe: indexPath.row]?.voucherID ?? ""
        navigationController?.pushViewController(viewController!, animated: true)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if presenter.suggestItems.isEmpty {
            if let cell = tableView
                .dequeueReusableCell(withIdentifier: "NoDataVoucherTableViewCell") as? NoDataVoucherTableViewCell {
                let title = "voucher.voucher_not_found".localized
                cell.emptyLabel.text = title
                return cell
            }
            return UITableViewCell()
        }
        return dequeueSuggestCell(indexPath: indexPath)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return presenter.suggestItems.isEmpty ? UIScreen.main.bounds.height / 2 : 120
    }

    @IBAction private func onTapFilterButton(_ sender: Any) {
        let vc = FilterViewController()
        vc.setSelectingData(presenter.searchParams)
        vc.onApply = { properties in
            self.presenter.searchParams.categories = properties.categories
            self.presenter.searchParams.districtCodes = properties.districtCodes
            self.presenter.searchParams.province = properties.province

            self.presenter.refresh()
        }
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true, completion: nil)
    }
    
    @IBAction private func buttonDistrictSearchTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "ProvinceSearch", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ProvinceSearchViewController") as? ProvinceSearchViewController
        viewController?.delegate = self
        viewController?.setType((type: .province, code: "VN"))
        viewController?.setSelectedItem(presenter.searchParams.province)
        navigationController?.pushViewController(viewController!, animated: true)
    }

    @IBAction private func openSetting(_ sender: Any) {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                print("Settings opened: \(success)")
            })
        }
    }
}

extension VoucherSearchViewController: BaseProtocols {
    func requestSuccess() {
        tableView.refreshControl?.endRefreshing()
        locationManager.stopRequestingLocation()
        
        showFilter()
        showHideNoLocationError()

        if presenter.searchParams.categories.isEmpty {
            headerLabel.isHidden = false
            collectionView.isHidden = true
        } else {
            headerLabel.isHidden = true
            collectionView.isHidden = false
        }
        buttonDistrictSearch.setTitle(presenter.searchParams.province.name, for: .normal)

        tableView.reloadData()
        reloadCollectionView()
    }
}

extension VoucherSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self,
                                               selector: #selector(searchWithText),
                                               object: searchBar)
        perform(#selector(searchWithText),
                with: searchBar,
                afterDelay: 0.5)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        searchWithText(searchBar)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        presenter.searchParams.reset()
        presenter.refresh()
        view.endEditing(true)
    }

    @objc private func searchWithText(_ searchBar: UISearchBar) {
        if let keyWords = searchBar.textField?.text {
            presenter.searchParams.keywords = keyWords
        } else {
            presenter.searchParams.keywords = ""
        }
        if presenter.searchParams.keywords.isEmpty {
            presenter.searchParams.reset()
            presenter.requestTab = .all
            tabView.active(type: .all)
        }
        presenter.refresh()
    }
}

extension VoucherSearchViewController: ProvinceSearchProtocol {
    func itemChosen(_ item: ProvinceSearchPresenter.DisplayItem,
                    type: ProvinceSearchPresenter.ListType) {
        presenter.searchParams.province = item
        buttonDistrictSearch.setTitle(item.name, for: .normal)
        presenter.refresh()
    }
}

extension VoucherSearchViewController: CurrentLocationManagerProtocol {
    func locationDidUpdate(coordinate: CLLocationCoordinate2D) {
        if presenter.requestTab == .all { return }
        
        presenter.searchParams.lat = String(coordinate.latitude)
        presenter.searchParams.long = String(coordinate.longitude)
        presenter.refresh()
    }
}
