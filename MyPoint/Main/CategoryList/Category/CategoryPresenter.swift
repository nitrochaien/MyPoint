//
//  CategoryPresenter.swift
//  MyPoint
//
//  Created by Hieu Nguyen on 1/14/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation
import Localize

protocol CategoryListProtocols: NSObjectProtocol {
  func showError(message: String)
  
  func showListHotVoucher(list: [HotVoucher])
  
  func showListBrand(list: [Brand])
  
  func showListSuggestion(list: [NewsItem])
  
  func reloadCollectionView()
}

class CategoryListPresenter: APIResponseMethods {
  
  var listVoucherByCategory = [HotVoucher]()
  var listHotVoucher = [HotVoucher]()
  var listBrand = [Brand]()
  var category = Category()
//  var listNews = [News]()
    
  private let service = MainServices()
  private let voucherServices = VoucherServices()
    
  weak var delegate: CategoryListProtocols?
  
  func refresh() {
    service.resetOffset()
    voucherServices.resetOffset()
    listVoucherByCategory.removeAll()
    listHotVoucher.removeAll()
    getListVoucherByCategories(category: category)
  }
  
  func loadMore() {
    if voucherServices.canLoadMore() {
      voucherServices.increaseOffset()
      getListVoucherByCategories(category: category)
    }
  }
  
  func getListHotVoucher(categoryId: String) {
//        let requestModel = ListHotVoucherRequestModel()
        service.getListHotVoucherByCategories(categoryId: categoryId) { [weak self] (response, success) in
          guard let self = self else { return }
          if success {
            if let response = response as? ListNewHotVoucherResponse {
              guard self.noError(from: response) else { return }
              if let listHotVoucher = response.data?.voucherList {
                self.listHotVoucher = listHotVoucher
                self.delegate?.showListHotVoucher(list: listHotVoucher)
              } else {
                self.showError(message: "api.empty".localized)
              }
            }
          } else {
            self.showError(message: "api.request_fail".localized)
          }
        }
      }
  
  func getListBrand() {
    service.getListBrand { [weak self] (response, success) in
      guard let self = self else { return }
      if success {
        if let response = response as? ListBrandResponseModel {
          guard self.noError(from: response) else { return }
          if let listBrand = response.data?.items, listBrand.count > 0 {
            self.delegate?.showListBrand(list: listBrand)
          } else {
            self.showError(message: "api.empty".localized)
          }
        } else {
          self.showError(message: "api.request_fail".localized)
        }
      }
    }
  }
  
    func getListNews() {
        service.getListNews { [weak self] (response, success) in
          guard let self = self else { return }
          if success {
            if let response = response as? ListNewsResponseModel {
              guard self.noError(from: response) else { return }
              if let listNews = response.data?.items, listNews.count > 0 {
                self.delegate?.showListSuggestion(list: listNews)
              } else {
                self.showError(message: "api.empty".localized)
              }
            } else {
              self.showError(message: "api.request_fail".localized)
            }
          }
        }
    }
  
    func getListVoucherByCategories(category: Category) {
        voucherServices.getListVoucherByCategories(categoryCode: category.categoryCode ?? "") { [weak self] (response, success) in
          guard let self = self else { return }
          if success {
            if let response = response as? ListHotVoucherResponse {
              guard self.noError(from: response) else { return }
              if let listVoucher = response.data?.listItems {
                if listVoucher.count > 0 {
                    self.listVoucherByCategory += listVoucher
//                    self.delegate?.reloadCollectionView()
                }
              } else {
                self.showError(message: "api.empty".localized)
              }
            }
          } else {
            self.showError(message: "api.request_fail".localized)
          }
          self.getListHotVoucher(categoryId: category.id ?? "")
      }
    }
  
    func showError(message: String) {
      delegate?.showError(message: message)
    }
}
