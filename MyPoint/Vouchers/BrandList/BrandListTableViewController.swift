//
//  BrandListTableViewController.swift
//  MyPoint
//
//  Created by Nam Vu on 1/31/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class BrandListTableViewController: BaseTableViewController {

    private let presenter = BrandListPresenter()
    private let cellIdentifier = "BrandListTableViewCell"

    var onSelectBrand: ((_ item: BrandListPresenter.BrandItem) -> Void)?
    var onDismiss: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "voucher.select_brand".localized

        presenter.delegate = self

        setRightBarButton()

        tableView.register(UINib(nibName: cellIdentifier,
                                 bundle: nil),
                           forCellReuseIdentifier: cellIdentifier)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if showFirstTime {
            presenter.getBrandList()
        }
    }

    func setSelectingBrand(_ brand: BrandListPresenter.BrandItem?) {
        presenter.selectingBrand = brand
    }

    deinit {
        print("Deinit BrandListTableViewController")
    }

    private func setRightBarButton() {
        let image = UIImage(named: "ic_close")
        let item = UIBarButtonItem(image: image,
                                   style: .plain,
                                   target: self, action: #selector(onCancel))
        item.tintColor = UIColor(hexString: "#032041")
        navigationItem.rightBarButtonItem = item
    }

    @objc private func onCancel() {
        dismiss(animated: true) { [weak self] in
            self?.onDismiss?()
        }
    }

    // MARK: Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? BrandListTableViewCell {
            cell.selectionStyle = .none

            let item = presenter.items[indexPath.row]
            cell.setData(item)

            return cell
        }
        return UITableViewCell()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.onSelectBrand?(self.presenter.items[indexPath.row])
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
}

extension BrandListTableViewController: BaseProtocols {
    func requestSuccess() {
        tableView.reloadData()
    }
}
