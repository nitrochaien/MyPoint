//
//  MerchantProfilePresenter.swift
//  MyPoint
//
//  Created by Hieu on 2/23/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

protocol MerchantProfileProtocols: NSObjectProtocol {
  func showError(message: String)
  
  func showListMerchant()
  
  func reloadTableView()
  
}

class MerchantProfilePresenter: APIResponseMethods {
    
//    var listBiggestBrand = [Brand]()
//    var listHottestBrand = [Brand]()
    var listBrand = [Brand]()
    
    private let services = MerchantServices()
    
    weak var delegate: MerchantProfileProtocols?
    
    func refresh(index: Int) {
      services.resetOffset()
//      listBiggestBrand.removeAll()
//      listHottestBrand.removeAll()
        listBrand.removeAll()
        switch index {
        case 0:
          getListAllBrand()
        case 1:
          getListLastestBrands()
        case 3:
          getListAllBrand()
        default:
          break
        }
    }
  
    func loadMoreBrand(index: Int) {
      if services.canLoadMore() {
        services.increaseOffset()
        getListBrand(index: index)
      }
    }
    
    func getListBrand(index: Int) {
      switch index {
      case 0:
        getListAllBrand()
      case 1:
        getListLastestBrands()
      case 3:
        getListAllBrand()
      default:
        break
      }
    }
  
    func getListAllBrand() {
      services.getListAllBrands { [weak self] (response, success) in
        guard let self = self else { return }
        if success {
          if let response = response as? ListBrandResponseModel {
            guard self.noError(from: response) else { return }
            if let listBrand = response.data?.items {
              self.listBrand += listBrand
              self.services.numberOfItemsReceived = listBrand.count
              self.delegate?.reloadTableView()
            }
          } else {
            self.showError(message: "api.request_fail".localized)
          }
        }
      }
    }
  
    func getListLastestBrands() {
      services.getListLastestBrands { [weak self] (response, success) in
        guard let self = self else { return }
        if success {
          if let response = response as? ListBrandResponseModel {
            guard self.noError(from: response) else { return }
            if let listBrand = response.data?.items, listBrand.count > 0 {
              self.listBrand += listBrand
              self.services.numberOfItemsReceived = listBrand.count
              self.delegate?.reloadTableView()
            } else {
              self.showError(message: "api.empty".localized)
            }
          } else {
            self.showError(message: "api.request_fail".localized)
          }
        }
      }
    }
  
    func getListFavouriteBrands() {
      services.getListFavouriteStoresBrand { [weak self] (response, success) in
        guard let self = self else { return }
        if success {
          if let response = response as? ListBrandResponseModel {
            guard self.noError(from: response) else { return }
            if let listBrand = response.data?.items, listBrand.count > 0 {
              self.listBrand += listBrand
              self.services.numberOfItemsReceived = listBrand.count
              self.delegate?.reloadTableView()
            } else {
              self.showError(message: "api.empty".localized)
            }
          } else {
            self.showError(message: "api.request_fail".localized)
          }
        }
      }
    }
    
    func showError(message: String) {
    
    }
}
