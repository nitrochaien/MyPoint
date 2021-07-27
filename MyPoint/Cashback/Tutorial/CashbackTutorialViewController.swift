//
//  CashbackTutorialViewController.swift
//  MyPoint
//
//  Created by Nam Vu on 7/20/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class CashbackTutorialViewController: UIViewController {

    @IBOutlet private weak var tableHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var tableView: UITableView!

    let contents = [
        "Chọn đối tác bạn muốn mua sắm",
        "Chuyển đến trang hoặc ứng dụng mua sắm của đối tác",
        "Mua sắm và thanh toán",
        "Kiểm tra trạng thái đơn hàng trên MyPoint",
        "Nhận hoàn điểm sau khi đơn hàng được duyệt"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        tableHeightConstraint.constant = 480
        configTableView()
    }

    private func configTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.isUserInteractionEnabled = false

        tableView.register(UINib(nibName: CashbackTutorialTableViewCell.cellId,
                                 bundle: nil),
                           forCellReuseIdentifier: CashbackTutorialTableViewCell.cellId)
    }

    @IBAction private func onDone(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension CashbackTutorialViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(
            withIdentifier: CashbackTutorialTableViewCell.cellId) as? CashbackTutorialTableViewCell {
            let index = indexPath.row
            cell.setData(index, content: contents[index])
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }
}
