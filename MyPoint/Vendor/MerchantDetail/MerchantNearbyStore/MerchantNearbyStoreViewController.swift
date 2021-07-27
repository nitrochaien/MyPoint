//
//  MerchantNearbyStoreViewController.swift
//  MyPoint
//
//  Created by Hieu Nguyen on 2/20/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MessageUI

protocol DidLayoutMerchantNearbyStoreProtocol: NSObjectProtocol {
    func updateLayout(size: CGSize)

    func updateLayout(height: CGFloat)

}

class MerchantNearbyStoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PagerObserver {

    @IBOutlet weak var tableView: UITableView!

    var brandId = ""

    private let presenter = MerchantDetailPresenter()

    weak var delegate: DidLayoutMerchantNearbyStoreProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.delegate = self
        //      presenter.refreshStore()
        configTableView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //      tableView.frame = CGRect(x: tableView.frame.origin.x,
        //                                              y: tableView.frame.origin.y,
        //                                              width: tableView.frame.size.width,
        //                                              height: tableView.contentSize.height + 40.0)
        //      delegate?.updateLayout(size: tableView.frame.size)
    }

    func configTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "NearbyStoreCell", bundle: nil), forCellReuseIdentifier: "NearbyStoreCell")
    }

    func updateTableViewHeight() {
        DispatchQueue.main.async {
            self.tableView.frame = CGRect(x: self.tableView.frame.origin.x,
                                          y: self.tableView.frame.origin.y,
                                          width: self.tableView.frame.size.width,
                                          height: self.tableView.contentSize.height + 40.0)
        }
    }

    func dequeNearbyStoreCell(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "NearbyStoreCell", for: indexPath) as? NearbyStoreCell else {
            fatalError("Empty Cell")
        }
        cell.setData(store: presenter.listNearyBrandStore[safe: indexPath.row] ?? NearbyBrandStore())
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.listNearyBrandStore.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        dequeNearbyStoreCell(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        openGoogleMap(index: indexPath.row)
        let storyboard = UIStoryboard(name: "StoreDetail", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "StoreDetailViewController") as? StoreDetailViewController
        viewController?.storeId = presenter.listNearyBrandStore[safe: indexPath.row]?.id ?? ""
        let tabbarViewController = UIApplication.shared.topViewController as? UINavigationController
        tabbarViewController?.pushViewController(viewController!, animated: true)
    }
    
    func openGoogleMap(index: Int) {
        guard let lat = presenter.listNearyBrandStore[safe: index]?.latitude,
              let latDouble =  Double(lat) else { return }
        guard let long = presenter.listNearyBrandStore[safe: index]?.longitude,
              let longDouble =  Double(long) else { return }
        showGoogleMap(withLat: latDouble, long: longDouble)
    }

    func needsToLoadData(index: Int) {
        presenter.brandId = self.brandId
        presenter.refreshStore()
    }

    func loadAlways(index: Int) {
        presenter.brandId = self.brandId
        presenter.refreshStore()
    }
}

extension MerchantNearbyStoreViewController: MerchantDetailProtocols {
    func didUnlikeBrand() {

    }

    func didLikeBrand() {

    }

    func showListStoreByBrand() {
        tableView.reloadData()
        //    self.updateTableViewHeight()
        //    delegate?.updateLayout(size: tableView.frame.size)
        delegate?.updateLayout(height: CGFloat(presenter.listNearyBrandStore.count * 120) + 80)
    }

    func showError(message: String) {
        self.showCustomAlert(withTitle: "api.error".localized, andContent: message)
    }

    func display(brand: BrandDetail) {

    }

    func showListVoucherByBrand() {

    }

}
