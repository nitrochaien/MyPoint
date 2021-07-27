//
//  SupportViewController.swift
//  MyPoint
//
//  Created by Nam Vu on 2/2/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit
import SafariServices
import MessageUI

final class SupportViewController: BaseViewController {

    @IBOutlet private weak var tableView: UITableView!

    private let cellIdentifier = "cell"
    private let presenter = SupportPresenter()

    override func viewDidLoad() {
        super.viewDidLoad()
        configNavigationBar()
        configTableView()

        presenter.delegate = self
        presenter.generateData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    private func configNavigationBar() {
        navigationController?.navigationBar.isHidden = false
        title = "support.header".localized
        customizeBackButton()
    }

    private func configTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }
}

extension SupportViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            cell.selectionStyle = .none

            let item = presenter.items[indexPath.row]
            cell.imageView?.image = UIImage(named: item.icon)
            cell.textLabel?.text = item.title
            cell.textLabel?.textColor = UIColor(hexString: "#032041")
            cell.accessoryView = UIImageView(image: UIImage(named: "ic_arrow_black"))

            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.items.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = presenter.items[indexPath.row]
        let sharedApp = UIApplication.shared

        switch item.id {
//        case SupportMenu.facebook.rawValue:
//            if let url = URL(string: item.value) {
//                let vc = SFSafariViewController(url: url)
//                present(vc, animated: true, completion: nil)
//            }
        case SupportMenu.mail.rawValue:
            let emailTitle = "support.header".localized
            let toRecipents = [item.value]
            let mc: MFMailComposeViewController = MFMailComposeViewController()
            guard MFMailComposeViewController.canSendMail() else {
                showCustomAlert(withTitle: "alert.no_mail".localized,
                                andContent: "alert.no_mail_app".localized)
                return
            }
            mc.mailComposeDelegate = self
            mc.setSubject(emailTitle)
            mc.setToRecipients(toRecipents)
            present(mc, animated: true, completion: nil)
        case SupportMenu.phone.rawValue:
            if let url = URL(string: "tel://\(item.value)"), sharedApp.canOpenURL(url) {
                sharedApp.open(url)
            }
        case SupportMenu.question.rawValue:
            showFrequencyQuestionScreen()
        case SupportMenu.policy.rawValue:
            showPolicyScreen()
        default:
            showCustomAlert(withTitle: "Hế lô Tester",
                            andContent: "Chức năng này tạm thời chưa có nha ^^. Chúc 1 ngày tốt lành, mãi yêu <3")
        }
    }

    private func showFrequencyQuestionScreen() {
        let vc = FrequencyQuestionViewController()
        vc.setType(type: .faq)
        navigationController?.pushViewController(vc, animated: true)
    }

    private func showPolicyScreen() {
        let vc = FrequencyQuestionViewController()
        vc.setType(type: .agreement)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension SupportViewController: BaseProtocols {
    func requestSuccess() {
        tableView.reloadData()
    }
}

extension SupportViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled:
            print("Mail cancelled")
        case .saved:
            print("Mail saved")
        case .sent:
            print("Mail sent")
        case .failed:
            print("Mail sent failure")
        default:
            break
        }
        dismiss(animated: true, completion: nil)
    }
}
