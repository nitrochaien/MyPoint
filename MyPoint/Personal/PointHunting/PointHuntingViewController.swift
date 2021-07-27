//
//  PointHuntingViewController.swift
//  MyPoint
//
//  Created by Nam Vu on 2/15/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class PointHuntingViewController: BaseViewController {

    @IBOutlet private weak var tableView: UITableView!

    private let presenter = PointHuntingPresenter()
    
    enum SectionType: Int, CaseIterable {
        case header = 0, data
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        hidesBottomBarWhenPushed = true
        navigationController?.setNavigationBarHidden(false, animated: true)
        title = "hunting.header".localized

        configTableView()
        customizeBackButton()

        presenter.delegate = self
        presenter.refreshData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
        print("Deinit PointHuntingViewController")
    }

    private func configTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none

        tableView.register(UINib(nibName: "HuntingHeaderTableViewCell",
                                 bundle: nil),
                           forCellReuseIdentifier: "HuntingHeaderTableViewCell")
        tableView.register(UINib(nibName: "HuntingItemTableViewCell",
                                 bundle: nil),
                           forCellReuseIdentifier: "HuntingItemTableViewCell")
    }
    
    fileprivate func showFounderFeedback() {
        let vc = HuntFounderViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension PointHuntingViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return SectionType.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case SectionType.header.rawValue:
            return headerCell(tableView, indexPath: indexPath)
        case SectionType.data.rawValue:
            return huntingItemCell(tableView, indexPath: indexPath)
        default:
            break
        }
        return UITableViewCell()
    }

    private func headerCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView
            .dequeueReusableCell(withIdentifier: "HuntingHeaderTableViewCell") as? HuntingHeaderTableViewCell {
            return cell
        }
        return UITableViewCell()
    }

    private func huntingItemCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView
            .dequeueReusableCell(withIdentifier: "HuntingItemTableViewCell") as? HuntingItemTableViewCell {
            let model = presenter.achievements[indexPath.row]
            cell.setData(model)
            cell.onHunt = { [weak self] in
                guard let self = self else { return }
                ClickActionType.showViewController(withType: model.actionType,
                                                   andParam: model.actionParam,
                                                   from: self.navigationController)
            }

            if indexPath.row == presenter.achievements.count - 1 {
                presenter.loadMore()
            }

            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case SectionType.header.rawValue:
            return 256
        case SectionType.data.rawValue:
            return 170
        default:
            break
        }
        return 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case SectionType.header.rawValue:
            return 1
        default:
            return presenter.achievements.count
        }
    }
}

extension PointHuntingViewController: BaseProtocols {
    func requestSuccess() {
        tableView.reloadData()
    }
}
