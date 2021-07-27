//
//  MerchantDetailPresenter.swift
//  MyPoint
//
//  Created by Hieu Nguyen on 2/26/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation
import CoreLocation

protocol MerchantDetailProtocols: NSObjectProtocol {
    func showError(message: String)
  
    func display(brand: BrandDetail)
  
    func showListVoucherByBrand()
  
    func showListStoreByBrand()
  
    func didLikeBrand()
  
    func didUnlikeBrand()
  
}

class MerchantDetailPresenter: APIResponseMethods {
  
  private let service = MerchantServices()
  
  private let voucherServices = VoucherServices()
  
  weak var delegate: MerchantDetailProtocols?
  
  var listHotVoucher = [HotVoucher]()
  
  var listNearyBrandStore = [NearbyBrandStore]()
  
  var brandDetail = BrandDetail()
  
  var brandId = ""
  
  var coordinate = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
  
  func refreshVoucher() {
    service.resetOffset()
    listHotVoucher.removeAll()
    getListAllVoucherByBrand(brandId: brandId)
  }
  
//  func loadMoreVoucher() {
//    if service.canLoadMore() {
//      service.increaseOffset()
//      getListAllVoucherByBrand(brandId: brandId)
//    }
//  }
  
  func refreshStore() {
    service.resetOffset()
    listNearyBrandStore.removeAll()
    getListNearbyBrand(brandId: brandId, lat: "\(coordinate.latitude)", long: "\(coordinate.longitude)")
  }
  
  func loadMoreStore() {
    if service.canLoadMore() {
      service.increaseOffset()
      getListNearbyBrand(brandId: brandId, lat: "\(coordinate.latitude)", long: "\(coordinate.longitude)")
    }
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
            self.delegate?.display(brand: brand)
          } else {
            self.showError(message: "api.empty".localized)
          }
        }
      } else {
        self.showError(message: "api.request_fail".localized)
      }
    }
  }
  
  func getListAllVoucherByBrand(brandId: String) {
      voucherServices.getListAllVoucherByBrand(brandId: brandId) { [weak self] (response, success) in
        guard let self = self else { return }
        if success {
          if let response = response as? ListVoucherByBrandResponse {
            guard self.noError(from: response) else { return }
            if let listVoucher = response.data?.voucherList {
              if listVoucher.count > 0 {
                  self.listHotVoucher = listVoucher
                  self.delegate?.showListVoucherByBrand()
              }
            } else {
              self.showError(message: "api.empty".localized)
            }
          }
        } else {
          self.showError(message: "api.request_fail".localized)
        }
      }
    }
  
  func getListNearbyBrand(brandId: String, lat: String, long: String) {
    service.getListAllNearbyStoresBrand(brandId: brandId, lat: lat, long: long) { [weak self] (response, success) in
      guard let self = self else { return }
      if success {
        if let response = response as? NearbyBrandStoreResponse {
          guard self.noError(from: response) else { return }
          if let listBrandStore = response.data?.storeList, listBrandStore.count > 0 {
            self.listNearyBrandStore += listBrandStore
            self.service.numberOfItemsReceived = listBrandStore.count
            self.delegate?.showListStoreByBrand()
          } else {
            self.showError(message: "api.empty".localized)
          }
        } else {
          self.showError(message: "api.request_fail".localized)
        }
      }
    }
  }
  
  func likeBrand(brandId: String) {
    service.likeBrand(brandId: brandId) { [weak self] (response, success) in
      guard let self = self else { return }
      if success {
        if let response = response as? LikeBrandResponse {
          guard self.noError(from: response) else { return }
          if let likeID = response.data?.likeID, likeID != "" {
            self.delegate?.didLikeBrand()
          } else {
            self.showError(message: "api.empty".localized)
          }
        } else {
          self.showError(message: "api.request_fail".localized)
        }
      }
    }
  }
  
  func unLikeBrand(likeId: String) {
    service.unLikeBrand(likeId: likeId) { [weak self] (response, success) in
      guard let self = self else { return }
      if success {
        if let response = response as? UnLikeBrandResponse {
          guard self.noError(from: response) else { return }
          self.delegate?.didUnlikeBrand()
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
