//
//  NewsListViewController.swift
//  MyPoint
//
//  Created by Nam Vu on 1/9/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

class NewsListViewController: BaseViewController {

    @IBOutlet private weak var tableView: UITableView!

    private var refreshControl = UIRefreshControl()
    private let presenter = NewsPresenter()

    override func viewDidLoad() {
        super.viewDidLoad()
        configNavigationBar()
        configTableView()

        presenter.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if showFirstTime {
            presenter.getNewsList()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    private func configNavigationBar() {
        title = "news.title".localized
        customizeBackButton()
    }

    private func configTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "NewsTableViewCell",
                                 bundle: nil),
                           forCellReuseIdentifier: "NewsTableViewCell")
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 120

        refreshControl.addTarget(self, action: #selector(onPullToRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    @objc private func onPullToRefresh() {
        presenter.refreshNewsList()
    }
}

extension NewsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell") as? NewsTableViewCell {
            if let item = presenter.newsList[safe: indexPath.row] {
                cell.setData(from: item)
            }

            if indexPath.row == presenter.newsList.count - 1 {
                presenter.loadMore()
            }

            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.newsList.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = NewsDetailViewController()
        vc.setPageId(presenter.newsList[indexPath.row].id)
        navigationController?.pushViewController(vc)
    }
}

extension NewsListViewController: BaseProtocols {
    func requestSuccess() {
        refreshControl.endRefreshing()
        tableView.reloadData()
    }
}
