//
//  FrequencyQuestionViewController.swift
//  MyPoint
//
//  Created by Nam Vu on 2/24/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class FrequencyQuestionViewController: BaseViewController {

    @IBOutlet private weak var tableView: UITableView!

    private let presenter = FrequencyQuestionPresenter()

    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle()
        customizeBackButton()

        configTableView()

        presenter.delegate = self
    }

    private func setTitle() {
        switch presenter.type {
        case .faq:
            title = "settings.fequency_question".localized
        case .agreement:
            title = "support.policy".localized
        }
    }

    func setType(type: FrequencyQuestionPresenter.PageType) {
        presenter.type = type
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if showFirstTime {
            presenter.requestData()
        }
    }

    private func configTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none

        tableView.register(UINib(nibName: "FrequencyHeaderView", bundle: nil),
                           forHeaderFooterViewReuseIdentifier: "FrequencyHeaderView")
        tableView.register(UINib(nibName: "FrequencyCellTableViewCell",
                                 bundle: nil),
                           forCellReuseIdentifier: "FrequencyCellTableViewCell")
    }
}

extension FrequencyQuestionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView
            .dequeueReusableCell(withIdentifier: "FrequencyCellTableViewCell") as? FrequencyCellTableViewCell {
            cell.titleLabel.attributedText = presenter.items[indexPath.section].subText
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let headerView = tableView
            .dequeueReusableHeaderFooterView(withIdentifier: "FrequencyHeaderView") as? FrequencyHeaderView {
            headerView.titleLabel.text = presenter.items[section].contentText
            return headerView
        }
        return nil
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 60
//    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.items.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showPageDetail(at: indexPath.section)
    }

    private func showPageDetail(at index: Int) {
        let vc = FrequencyQuestionDetailViewController()
        vc.setPageId(presenter.items[index].id, type: presenter.type)
        navigationController?.pushViewController(vc)
    }
}

extension FrequencyQuestionViewController: BaseProtocols {
    func requestSuccess() {
        tableView.reloadData()
    }
}
