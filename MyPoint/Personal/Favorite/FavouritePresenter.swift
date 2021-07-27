//
//  FavouritePresenter.swift
//  MyPoint
//
//  Created by Hieu on 2/23/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

protocol FavouriteListProtocols: NSObjectProtocol {
  func showError(message: String)
  
  func showListFavouriteVoucher(list: [HotVoucher])
  
  func showListFavouriteBrand(list: [Brand])
  
  func didUnlikeVoucher(index: Int)
  
  func didUnlikeBrand(index: Int)
  
  func reloadTableView()
  
}

class FavouritePresenter: APIResponseMethods {
    
    var listFavouriteVoucher = [LikedVoucher]()
    
    var listFavouriteBrand = [LikedBrand]()
    
    private let services = PersonalServices()
  
    private let merchantServices = MerchantServices()
  
    private let voucherService = VoucherServices()
  
    private let mainService = MainServices()
    
    weak var delegate: FavouriteListProtocols?
    
    func refresh(index: Int) {
        services.resetOffset()
        merchantServices.resetOffset()
        mainService.resetOffset()
        listFavouriteVoucher.removeAll()
        listFavouriteBrand.removeAll()
        if index == 0 {
          getListFavouriteVoucher()
        } else {
          getListAllBrand()
        }
    }
    
    func loadMore(index: Int) {
      if index == 0 {
        if mainService.canLoadMore() {
          mainService.increaseOffset()
          getListFavouriteVoucher()
        }
      } else {
        if merchantServices.canLoadMore() {
          merchantServices.increaseOffset()
          getListAllBrand()
        }
      }
    }
  
    func getListFavouriteVoucher() {
//        let requestModel = ListHotVoucherRequestModel()
//        mainService.getListHotVoucher(requestModel: requestModel) { [weak self] (response, success) in
//          guard let self = self else { return }
//          if success {
//            if let response = response as? ListHotVoucherResponse {
//              guard self.noError(from: response) else { return }
//              if let listHotVoucher = response.data?.listItems, listHotVoucher.count > 0 {
//                self.listFavouriteVoucher += listHotVoucher
//                self.mainService.numberOfItemsReceived = listHotVoucher.count
//                self.delegate?.reloadTableView()
//              } else {
//                self.showError(message: "api.empty".localized)
//              }
//            }
//          } else {
//            self.showError(message: "api.request_fail".localized)
//          }
//        }
//      let requestModel = ListHotVoucherRequestModel()
        services.getListFavouriteVoucher { [weak self] (response, success) in
        guard let self = self else { return }
        if success {
          if let response = response as? ListFavouriteVoucherResponse {
            guard self.noError(from: response) else { return }
            if let listFavouriteVoucher = response.data?.items {
              self.listFavouriteVoucher += listFavouriteVoucher
              self.services.numberOfItemsReceived = listFavouriteVoucher.count
              self.delegate?.reloadTableView()
            }
          }
        } else {
          self.showError(message: "api.request_fail".localized)
        }
      }
    }
  
    func getListAllBrand() {
//      merchantServices.getListAllBrands { [weak self] (response, success) in
//        guard let self = self else { return }
//        if success {
//          if let response = response as? ListBrandResponseModel {
//            guard self.noError(from: response) else { return }
//            if let listBrand = response.data?.items, listBrand.count > 0 {
//              self.listFavouriteBrand += listBrand
//              self.merchantServices.numberOfItemsReceived = listBrand.count
//              self.delegate?.reloadTableView()
//            } else {
//              self.showError(message: "api.empty".localized)
//            }
//          } else {
//            self.showError(message: "api.request_fail".localized)
//          }
//        }
//      }
      services.getListFavouriteBrand { [weak self] (response, success) in
        guard let self = self else { return }
        if success {
          if let response = response as? ListFavouriteBrandResponse {
            guard self.noError(from: response) else { return }
            if let listFavouriteBrand = response.data?.items {
              self.listFavouriteBrand += listFavouriteBrand
              self.services.numberOfItemsReceived = listFavouriteBrand.count
              self.delegate?.reloadTableView()
            }
          } else {
            self.showError(message: "api.request_fail".localized)
          }
        }
      }
    }
  
    func unlikeVoucher(at index: Int) {
        voucherService.unLikeBrand(likeId: listFavouriteVoucher[index].likeID ?? "") { [weak self] (response, success) in
        guard let self = self else { return }
        if success {
          if let response = response as? UnLikeBrandResponse {
            guard self.noError(from: response) else { return }
            self.delegate?.didUnlikeVoucher(index: index)
          } else {
            self.showError(message: "api.request_fail".localized)
          }
        }
      }
    }
  
    func unlikeBrand(at index: Int) {
      merchantServices.unLikeBrand(likeId: listFavouriteBrand[index].likeID ?? "") { [weak self] (response, success) in
        guard let self = self else { return }
        if success {
          if let response = response as? UnLikeBrandResponse {
            guard self.noError(from: response) else { return }
            self.delegate?.didUnlikeBrand(index: index)
          } else {
            self.showError(message: "api.request_fail".localized)
          }
        }
      }
    }

    func showError(message: String) {
      delegate?.showError(message: message)
    }
}
