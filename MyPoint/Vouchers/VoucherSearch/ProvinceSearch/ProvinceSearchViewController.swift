//
//  ProvinceSearchViewController.swift
//  MyPoint
//
//  Created by Hieu Nguyen on 2/5/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

protocol ProvinceSearchProtocol: NSObjectProtocol {
    func itemChosen(_ item: ProvinceSearchPresenter.DisplayItem,
                    type: ProvinceSearchPresenter.ListType)
}

final class ProvinceSearchViewController: BaseViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    private let presenter = ProvinceSearchPresenter()

    weak var delegate: ProvinceSearchProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        hideKeyboardWhenTappedAround()
        presenter.delegate = self
        searchBar.delegate = self

        configTableView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if showFirstTime {
            if presenter.dataType.type == .district {
                presenter.getListDistrict(provinceCode: presenter.dataType.code)
            } else {
                presenter.getListProvince(countryCode: presenter.dataType.code)
            }
        }
    }

    func setType(_ type: ProvinceSearchPresenter.DataType) {
        presenter.dataType = type
    }

    func setSelectedItem(_ item: ProvinceSearchPresenter.DisplayItem?) {
        presenter.selectedItem = item
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
    }

    private func configTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "ProvinceCell", bundle: nil),
                           forCellReuseIdentifier: "ProvinceCell")
    }

    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension ProvinceSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.filteredList.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ProvinceCell", for: indexPath) as? ProvinceCell {
            cell.setData(presenter.filteredList[indexPath.row])
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = presenter.filteredList[indexPath.row]
        if !selectedItem.isSelected {
            self.delegate?.itemChosen(selectedItem,
                                      type: presenter.dataType.type)
        }
        self.navigationController?.popViewController(animated: true)
    }
}

extension ProvinceSearchViewController: BaseProtocols {
    func requestSuccess() {
        tableView.reloadData { [weak self] in
            guard let self = self, self.presenter.noFilter else { return }

            if let index = self.presenter.filteredList.firstIndex(where: { item -> Bool in
                return item.code == self.presenter.selectedItem?.code
            }) {
                let indexPath = IndexPath(row: index, section: 0)
                self.tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
            }
        }
    }
}

extension ProvinceSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let text = searchText.folded.trimmed.lowercased()
        if text.isEmpty {
            presenter.filteredList = presenter.mainList
        } else {
            presenter.filteredList = presenter.mainList
                .filter({ $0.name.folded.trimmed.lowercased().contains(text) })
        }
        tableView.reloadData()
    }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
      self.view.endEditing(true)
  }
}
