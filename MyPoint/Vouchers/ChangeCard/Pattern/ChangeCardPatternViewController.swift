//
//  ChangeCardPatternViewController.swift
//  MyPoint
//
//  Created by Nam Vu on 2/7/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class ChangeCardPatternViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var outsideView: UIView!
    
    var didHideSelection: (() -> Void)?

    var codes = [Pattern]() {
        didSet {
            if tableView != nil {
                tableView.reloadData()
            }
        }
    }

    struct Pattern {
        let title: String
        let content: String

        init(title: String, content: String) {
            self.title = title
            self.content = content
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configTableView()

        bottomConstraint.constant = -16
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapOutside))
        outsideView.addGestureRecognizer(tapGesture)
    }

    @objc private func onTapOutside() {
        hide()
    }

    private func configTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }

    @IBAction private func onDismiss(_ sender: Any) {
        hide()
    }

    private func hide() {
        bottomConstraint.constant = -256
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        }) { (completed) in
            if completed {
                self.didHideSelection?()
                self.willMove(toParent: nil)
                self.view.removeFromSuperview()
                self.removeFromParent()
            }
        }
    }
}

extension ChangeCardPatternViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        }

        let item = codes[indexPath.row]
        cell!.textLabel?.text = item.title
        cell!.detailTextLabel?.text = item.content
        cell!.textLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        cell!.textLabel?.textColor = UIColor(hexString: "#032041")
        cell!.detailTextLabel?.textColor = UIColor(hexString: "#8e969f")
        cell!.accessoryView = UIImageView(image: UIImage(named: "ic_arrow_black"))

        return cell!
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return codes.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = codes[indexPath.row]
        if let url = URL(string: "tel://\(item.content)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}
