//
//  StoreCommentViewController.swift
//  MyPoint
//
//  Created by Hieu Nguyen on 4/13/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

protocol DidLayoutStoreCommentProtocol: NSObjectProtocol {
    func updateStoreCommentLayout(height: CGFloat)
}

class StoreCommentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PagerObserver {
  
  @IBOutlet weak var tableView: ContentWrappingTableView!
  let tempTextField = UITextField(frame: CGRect.zero)
  
  var storeId = ""
  
  weak var delegate: DidLayoutStoreCommentProtocol?
  
  private let presenter = StoreCommentPresenter()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    hideKeyboardWhenTappedAround()
    configTableView()
    presenter.delegate = self
    presenter.storeId = storeId
//    presenter.getStoreComments(storeId: storeId)
  }
  
  override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      NotificationCenter.default.addObserver(self, selector: #selector(successSubmitReview),
                                             name: NotificationName.successSubmitReview,
                                             object: nil)
  }
  
  deinit {
      NotificationCenter.default.removeObserver(self)
      print("Deinit StoreCommentViewController")
  }
  
  @objc func successSubmitReview(notification: Notification) {
    UserDefaults.standard.set("", forKey: "comment")
    UserDefaults.standard.set(0, forKey: "rate")
    UserDefaults.standard.synchronize()
    presenter.refresh()
  }
  
  func configTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UINib(nibName: "DefaultCommentCell", bundle: nil), forCellReuseIdentifier: "DefaultCommentCell")
    tableView.register(UINib(nibName: "YourCommentCell", bundle: nil), forCellReuseIdentifier: "YourCommentCell")
    tableView.register(UINib(nibName: "AddCommentCell", bundle: nil), forCellReuseIdentifier: "AddCommentCell")
    tableView.estimatedRowHeight = 320
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return presenter.storeComments.count + 1
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
  func dequeueAddCommentCell(indexPath: IndexPath) -> UITableViewCell {
    guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "AddCommentCell", for: indexPath) as? AddCommentCell else {
              fatalError("Empty Cell")
          }
    cell.commentLabel.text = "merchant.add_comment".localized
    cell.ratingView.rating = 0.0
    cell.commentViewButton.add(for: .touchUpInside) {
      self.tempTextField.delegate = self
      self.view.addSubview(self.tempTextField)
      let customInputAccessoryView = AddCommentView(frame: CGRect(x: 0, y: 0, width: 10, height: 180))
      customInputAccessoryView.delegate = cell
      self.tempTextField.inputAccessoryView = customInputAccessoryView
      self.tempTextField.becomeFirstResponder()
    }
    return cell
  }
  
  func dequeueYourComment(indexPath: IndexPath) -> UITableViewCell {
    guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "YourCommentCell", for: indexPath) as? YourCommentCell else {
              fatalError("Empty Cell")
          }
    cell.editButton.add(for: .touchUpInside) {

      self.tempTextField.delegate = self
      self.view.addSubview(self.tempTextField)
      let customInputAccessoryView = AddCommentView(frame: CGRect(x: 0, y: 0, width: 10, height: 180))
      self.tempTextField.inputAccessoryView = customInputAccessoryView
      self.tempTextField.becomeFirstResponder()
      print("edit")
    }
    cell.deleteButton.add(for: .touchUpInside) {
      print("delete")
    }
    return cell
  }
  
  func dequeueDefaultComment(indexPath: IndexPath) -> UITableViewCell {
    guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "DefaultCommentCell", for: indexPath) as? DefaultCommentCell else {
              fatalError("Empty Cell")
          }
    self.delegate?.updateStoreCommentLayout(height: tableView.intrinsicContentSize.height)
    cell.setData(comment: presenter.storeComments[safe: indexPath.row - 1] ?? StoreComment())
    return cell
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.row {
    case 0:
//      return dequeueYourComment(indexPath: indexPath)
      return dequeueAddCommentCell(indexPath: indexPath)
    default:
      return dequeueDefaultComment(indexPath: indexPath)
    }
  }
  
  func needsToLoadData(index: Int) {
    presenter.storeComments = []
    presenter.getStoreComments(storeId: storeId)
  }
  
  func loadAlways(index: Int) {
    presenter.storeComments = []
    presenter.getStoreComments(storeId: storeId)
  }
  
}

extension StoreCommentViewController: UITextFieldDelegate {
  
}

extension StoreCommentViewController: StoreCommentPresenterProtocols {
  func showError(message: String) {
    
  }
  
  func display() {
    tableView.reloadData()
  }
  
}
