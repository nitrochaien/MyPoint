//
//  StoreDetailPresenter.swift
//  MyPoint
//
//  Created by Hieu Nguyen on 4/13/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

protocol StoreDetailProtocols: NSObjectProtocol {
    func showError(message: String)
  
    func display()
}

class StoreDetailPresenter: APIResponseMethods {
  private let service = MerchantServices()
   
  private let voucherServices = VoucherServices()
   
  weak var delegate: StoreDetailProtocols?
  
  var listHotVoucher = [HotVoucher]()
  
  var brandDetail = BrandDetail()
  
  var store = Store()
  
  var listComment = [StoreComment]()
  
  func refreshVoucher() {
    service.resetOffset()
    listHotVoucher.removeAll()
  }
  
  func refreshComments() {
    service.resetOffset()
    listComment.removeAll()
//    getStoreComments(storeId: storeId)
  }
  
  func getBrandDetail(brandId: String) {
    service.getBrandDetail(brandId: brandId) { [weak self] (response, success) in
      guard let self = self else { return }
      if success {
        if let response = response as? BrandDetailResponse {
          guard self.noError(from: response) else { return }
          if let brand = response.data?.brand {
            print("brand detail: \(brand)")
            self.brandDetail = brand
            self.delegate?.display()
//            self.delegate?.display(brand: brand)
          } else {
            self.showError(message: "api.empty".localized)
          }
        }
      } else {
        self.showError(message: "api.request_fail".localized)
      }
    }
  }
  
  func getStoreDetail(storeId: String) {
        service.getStoreDetail(storeId: storeId) { [weak self] (response, success) in
          guard let self = self else { return }
          if success {
            if let response = response as? StoreDetailResponse {
              guard self.noError(from: response) else { return }
              if let store = response.data?.store {
                print("store detail: \(store)")
                self.store = store
                self.delegate?.display()
    //            self.delegate?.display(brand: brand)
              } else {
                self.showError(message: "api.empty".localized)
              }
            }
          } else {
            self.showError(message: "api.request_fail".localized)
          }
        }
  }
  
//  func getStoreComments(storeId: String) {
//    service.getStoreComments(storeId: storeId) { [weak self] (response, success) in
//      guard let self = self else { return }
//      if success {
//        if let response = response as? GetStoreCommentsResponse {
//          guard self.noError(from: response) else { return }
//          if let storeComments = response.storeComments {
//            print("store comments: \(storeComments)")
//            self.listComment += storeComments.storeComments ?? []
//          } else {
//            self.showError(message: "api.empty".localized)
//          }
//        }
//      }
//    }
//  }
  
  func submitComment(storeId: String, reviewContent: String, reviewRating: String) {
    service.submitStoreComment(storeId: storeId, reviewContent: reviewContent, reviewRating: reviewRating) { [weak self] (response, success) in
      guard let self = self else { return }
      if success {
        if let response = response as? SubmitStoreCommentResponse {
          guard self.noError(from: response) else { return }
          NotificationCenter.default.post(name: NotificationName.successSubmitReview, object: nil)
        }
      } else {
        self.showError(message: "api.request_fail".localized)
      }
    }
  }
  
  func showError(message: String) {
    delegate?.showError(message: message)
  }
}
