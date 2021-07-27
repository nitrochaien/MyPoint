//
//  MembershipPrivilegePresenter.swift
//  MyPoint
//
//  Created by Hieu on 2/22/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

protocol MembershipPrivilegeProtocols: NSObjectProtocol {
  func showError(message: String)
  
  func showListLevels()
  func showPointExprie()
}

class MembershipPrivilegePresenter: APIResponseMethods {
    
    private let services = PersonalServices()
    
    weak var delegate: MembershipPrivilegeProtocols?
    
    var listLevels = [Level]()
    var dataCustomerBalanceDetail: CustomerBalanceDetail?
    var listAllCurrencyPools = [AllCurrencyPools]()
    func getListMembershipPrivilege() {
      services.getListMembershipPrivilege { [weak self] (response, success) in
        guard let self = self else { return }
        if success {
          if let response = response as? MembershipPrivilegeResponse {
            guard self.noError(from: response) else { return }
            if let listLevels = response.data?.levels, listLevels.count > 0 {
                self.listLevels = listLevels
                self.delegate?.showListLevels()
            } else {
              self.showError(message: "api.empty".localized)
            }
          }
        } else {
          self.showError(message: "api.request_fail".localized)
        }
      }
    }
    
    func getCustomerBalanceGetDetail() {
      services.getCustomerBalanceGetDetail { [weak self] (response, success) in
        guard let self = self else { return }
        if success {
          if let response = response as? CustomerBalanceGetDetailResponse {
            guard self.noError(from: response) else { return }
            self.dataCustomerBalanceDetail = response.data
            if let listAllCurrencyPools = response.data?.allCurrencyPools, listAllCurrencyPools.count > 0 {
                self.listAllCurrencyPools = listAllCurrencyPools
               
                self.delegate?.showPointExprie()
            } else {
              self.showError(message: "api.empty".localized)
            }
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
