//
//  StoreCommentPresenter.swift
//  MyPoint
//
//  Created by Hieu Nguyen on 5/25/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

protocol StoreCommentPresenterProtocols: NSObjectProtocol {
    func showError(message: String)
  
    func display()
}

class StoreCommentPresenter: APIResponseMethods {
  
  private let service = MerchantServices()
  
  weak var delegate: StoreCommentPresenterProtocols?
  
  var storeComments = [StoreComment]()
  
  var storeId = ""
  
  func refresh() {
    service.resetOffset()
    storeComments.removeAll()
    getStoreComments(storeId: storeId)
  }
  
  func getStoreComments(storeId: String) {
        service.getStoreComments(storeId: storeId) { [weak self] (response, success) in
          guard let self = self else { return }
          if success {
            if let response = response as? GetStoreCommentsResponse {
              guard self.noError(from: response) else { return }
              if let storeComments = response.storeComments {
                print("comments: \(storeComments)")
                self.storeComments += storeComments.storeComments ?? []
                self.delegate?.display()
              } else {
                self.showError(message: "api.empty".localized)
              }
            }
          } else {
            self.showError(message: "api.request_fail".localized)
          }
        }
  }
  
  func submitComment(storeId: String, reviewContent: String, reviewRating: String) {
    service.submitStoreComment(storeId: storeId, reviewContent: reviewContent, reviewRating: reviewRating) { [weak self] (response, success) in
      guard let self = self else { return }
      if success {
        if let response = response as? GetStoreCommentsResponse {
          guard self.noError(from: response) else { return }
        }
      } else {
        self.showError(message: "api.request_fail".localized)
      }
    }
  }
  
  func showError(message: String) {
    
  }
}
