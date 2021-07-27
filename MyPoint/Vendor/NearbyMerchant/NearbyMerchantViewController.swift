//
//  NearbyMerchantViewController.swift
//  MyPoint
//
//  Created by Hieu Nguyen on 2/5/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit
import CoreLocation

final class NearbyMerchantViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PagerObserver, NearbyMerchantProtocols {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noLocationErrorView: UIView!
    @IBOutlet weak var noLocationHeaderLabel: UILabel!
    @IBOutlet weak var noLocationButton: UIButton!
    
    private let presenter = NearbyMerchantPresenter()

    private var refreshControl = UIRefreshControl()
  
    private var didGetLocation = false

    let locationManager = CurrentLocationManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
        locationManager.delegate = self
        refreshControl.tintColor = .clear
        refreshControl.addTarget(self, action: #selector(onPullToRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
        if !locationManager.isDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else if !locationManager.canGetLocation {
          presenter.coordinate = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
          presenter.refresh()
          self.didGetLocation = false
//            tableView.isHidden = true
//            noLocationErrorView.isHidden = false
//            noLocationHeaderLabel.text = "merchant.turn_on_location_remind".localized
//            noLocationButton.setTitle("merchant.turn_on_location".localized, for: .normal)
//          locationManager.requestLocation()
          noLocationErrorView.isHidden = true
          tableView.isHidden = false
        } else {
            locationManager.requestLocation()
            noLocationErrorView.isHidden = true
            tableView.isHidden = false
        }
        presenter.delegate = self

    }

    @objc private func onPullToRefresh() {
        presenter.refresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applicationDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }
    
    @objc func applicationDidBecomeActive() {
        locationManager.delegate = self
        if !locationManager.isDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else if !locationManager.canGetLocation {
          presenter.coordinate = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
          presenter.refresh()
          self.didGetLocation = false
//            tableView.isHidden = true
//            noLocationErrorView.isHidden = false
//            noLocationHeaderLabel.text = "merchant.turn_on_location_remind".localized
//            noLocationButton.setTitle("merchant.turn_on_location".localized, for: .normal)
//          locationManager.requestLocation()
          noLocationErrorView.isHidden = true
          tableView.isHidden = false
        } else {
            locationManager.requestLocation()
            noLocationErrorView.isHidden = true
            tableView.isHidden = false
        }
    }
    
    @IBAction func noLocationButtonTapped(_ sender: Any) {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                print("Settings opened: \(success)")
            })
        }
    }
    
    func configTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "NearbyMerchantProfileCell", bundle: nil), forCellReuseIdentifier: "NearbyMerchantProfileCell")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.listNearyBrandStore.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NearbyMerchantProfileCell", for: indexPath) as? NearbyMerchantProfileCell
            else {
                fatalError("Empty Cell")
        }
        cell.setData(store: presenter.listNearyBrandStore[safe: indexPath.row] ?? NearbyBrandStore(), didGetLocation: self.didGetLocation)
        cell.selectionStyle = .none
        if indexPath.row == presenter.listNearyBrandStore.count - 1 {
            presenter.loadMoreBrand()
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//      let storyboard = UIStoryboard(name: "StoreDetail", bundle: nil)
//      let viewController = storyboard.instantiateViewController(withIdentifier: "StoreDetailViewController") as? StoreDetailViewController
//      viewController?.storeId = presenter.listNearyBrandStore[safe: indexPath.row]?.id ?? ""
//      let tabbarViewController = UIApplication.shared.topViewController as? UINavigationController
//      tabbarViewController?.pushViewController(viewController!, animated: true)
        openGoogleMap(index: indexPath.row)
    }

    func openGoogleMap(index: Int) {
        guard let lat = presenter.listNearyBrandStore[safe: index]?.latitude, let latDouble =  Double(lat) else { return }
        guard let long = presenter.listNearyBrandStore[safe: index]?.longitude, let longDouble =  Double(long) else { return }
        showGoogleMap(withLat: latDouble, long: longDouble)
    }

    func needsToLoadData(index: Int) {

    }

    func showError(message: String) {
        self.showCustomAlert(withTitle: "api.error".localized, andContent: message)
    }

    func showListMerchant() {

    }

    func reloadTableView() {
        refreshControl.endRefreshing()
        tableView.reloadData()
    }
}

extension NearbyMerchantViewController: CurrentLocationManagerProtocol {
    func locationDidUpdate(coordinate: CLLocationCoordinate2D) {
        print("updated coordinate: \(coordinate)")
        presenter.coordinate =  coordinate
        self.didGetLocation = true
        presenter.refresh()
    }
}
