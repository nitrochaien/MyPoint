//
//  MerchantSearchViewController.swift
//  MyPoint
//
//  Created by Nam Vu on 2/20/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit
import CoreLocation

final class MerchantSearchViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet fileprivate weak var cityPickerButton: UIButton!
    @IBOutlet private weak var headerLabel: UILabel!
    @IBOutlet private weak var filterButton: UIButton!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet private weak var noLocationErrorView: UIView!
    @IBOutlet private weak var tabView: SearchTabView!
    @IBOutlet private weak var tabViewTopConstraint: NSLayoutConstraint!
    
    let presenter = MerchantSearchPresenter()

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()

        searchBar.delegate = self
        presenter.delegate = self
        presenter.registerLocation()
    }

    deinit {
        print("Deinit MerchantSearchViewController")
    }

    private func configTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "NearbyMerchantProfileCell", bundle: nil),
                           forCellReuseIdentifier: "NearbyMerchantProfileCell")
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

        cityPickerButton.setTitle("Hà Nội", for: .normal)

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
            case .nearby:
                break
            }
            self.presenter.refresh()
        }

        showHideFilter()
        showHideNoLocationError()
    }

    private func showHideNoLocationError() {
        if presenter.requestTab == .all {
            tableView.isHidden = false
            noLocationErrorView.isHidden = true
            return
        }

        if presenter.locationManager.canGetLocation {
            tableView.isHidden = false
            noLocationErrorView.isHidden = true
        } else {
            tableView.isHidden = true
            noLocationErrorView.isHidden = false
        }
    }

    private func showHideFilter() {
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
            tabViewTopConstraint.constant = -44
            headerLabel.text = "voucher.all_stores".localized
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
        if let cell = self.tableView
            .dequeueReusableCell(withIdentifier: "NearbyMerchantProfileCell",
                                 for: indexPath) as? NearbyMerchantProfileCell {
            if let store = presenter.suggestItems[safe: indexPath.row] {
                cell.setData(store: store, didGetLocation: presenter.canGetLocation)
            }

            if indexPath.row == presenter.suggestItems.count - 1 {
                presenter.loadMore()
            }

            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return presenter.suggestItems.isEmpty ? UIScreen.main.bounds.height / 2 : 110
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = presenter.suggestItems.count
        return count == 0 ? 1 : count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if presenter.suggestItems.isEmpty {
            if let cell = tableView
                .dequeueReusableCell(withIdentifier: "NoDataVoucherTableViewCell") as? NoDataVoucherTableViewCell {
                let title = "voucher.store_not_found".localized
                cell.emptyLabel.text = title
                cell.emptyImageView.image = UIImage(named: "no_store")
                return cell
            }
            return UITableViewCell()
        }
        return dequeueSuggestCell(indexPath: indexPath)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = presenter.suggestItems[indexPath.row]
        if let lat = Double(item.latitude ?? "0"), let long = Double(item.longitude ?? "0") {
            showGoogleMap(withLat: lat, long: long)
        }
    }

    @IBAction private func onTapFilterButton(_ sender: Any) {
        let vc = FilterViewController()
        vc.setSelectingData(presenter.searchParams)
        vc.onApply = { properties in
            properties.categories.first?.isFiltering = true
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

extension MerchantSearchViewController: BaseProtocols {
    func requestSuccess() {
        tableView.refreshControl?.endRefreshing()
        presenter.stopRequestingLocation()

        showHideFilter()
        showHideNoLocationError()

        if presenter.searchParams.categories.isEmpty {
            headerLabel.isHidden = false
            collectionView.isHidden = true
        } else {
            headerLabel.isHidden = true
            collectionView.isHidden = false
        }
        cityPickerButton.setTitle(presenter.searchParams.province.name, for: .normal)

        tableView.reloadData()
        reloadCollectionView()
    }
}

extension MerchantSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self,
                                               selector: #selector(searchWithText),
                                               object: searchBar)
        perform(#selector(searchWithText),
                with: searchBar,
                afterDelay: 0.5)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchWithText(searchBar)
        view.endEditing(true)
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
        }
        presenter.refresh()
    }
}

extension MerchantSearchViewController: ProvinceSearchProtocol {
    func itemChosen(_ item: ProvinceSearchPresenter.DisplayItem,
                    type: ProvinceSearchPresenter.ListType) {
        presenter.searchParams.province = item
        cityPickerButton.setTitle(item.name, for: .normal)
        presenter.refresh()
    }
}
