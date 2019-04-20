//
//  SelectDeliveryAddressModel.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 26/03/18.
//  Copyright © 2018 Cynoteck. All rights reserved.
//

import UIKit
import SwiftyJSON

class SelectDeliveryAddressModel: NSObject {
    
    let authServiceObj: AuthServices = AuthServices()
    var alertMessage : String!
    var currentaddressArray = [[String: String]]()
    var otherAddress = [[String: String]]()
    var finalAddressArray = [[[String: String]]] ()
    var sectionTitleArray = ["Current Address", "Other Address"]
   
    
    override init() {
        alertMessage = ""
    }
    
    func getAllAddress(completion: @escaping (_ success: Bool)->Void) {
        
        authServiceObj.synGetMethod(url: BASE_URL_KEY + "auth/delivery-address/current", header: Helper.headerWithToken(token: Helper.getUserDefault(key: TOKEN_KEY)!)) { (success, response) in
            
            print(response)
            if success {
                
                let street = response[DATA_KEY]["currentAddress"]["street"].stringValue
                let city =  response[DATA_KEY]["currentAddress"]["city"].stringValue
                let state =  response[DATA_KEY]["currentAddress"]["state"].stringValue
                let zipCode =  response[DATA_KEY]["currentAddress"]["zipCode"].stringValue
                let country =  response[DATA_KEY]["currentAddress"]["country"].stringValue
                let fullName = response[DATA_KEY]["currentAddress"]["fullName"].stringValue
                let id  = response[DATA_KEY]["currentAddress"][ID_KEY].stringValue
                
                let temp = [
                    "street" : street,
                    "city" : city,
                    "state" : state,
                    "zipCode" : zipCode,
                    "country" : country,
                    "fullName" : fullName,
                    "selected" : "1",
                    ID_KEY : id
                ]
                
                print(temp)
                self.currentaddressArray.append(temp)
                print(self.currentaddressArray)
                
                for address in response[DATA_KEY]["otherAddresses"].arrayValue {
                    
                    let street = address["street"].stringValue
                    let city =  address["city"].stringValue
                    let state =  address["state"].stringValue
                    let zipCode =  address["zipCode"].stringValue
                    let country =  address["country"].stringValue
                    let fullName = address["fullName"].stringValue
                    let id = address[ID_KEY].stringValue
                    
                    let temp = [
                        "street" : street,
                        "city" : city,
                        "state" : state,
                        "zipCode" : zipCode,
                        "country" : country,
                        "fullName" : fullName,
                        "selected" : "0",
                        ID_KEY : id
                    ]
                    
                    self.otherAddress.append(temp)
                }
                
                self.finalAddressArray.append(self.currentaddressArray)
                
                if self.otherAddress.count == 0 {
                    self.sectionTitleArray.remove(at: 1)
                }else{
                    self.finalAddressArray.append(self.otherAddress)
                }
                
                completion(true)
            } else{
                self.alertMessage = response[ERROR_KEY]["message"].stringValue
                if (self.alertMessage == nil) {
                    self.alertMessage = response[ERROR_KEY].stringValue
                }
                completion(false)
            }
        }
    }
    
    
    func deleteAddress(addressId: String, completion: @escaping (_ success: Bool)->Void) {
        
        authServiceObj.syndeleteMethod(url: BASE_URL_KEY + "auth/delivery-address/" + addressId, header: Helper.headerWithToken(token: Helper.getUserDefault(key: TOKEN_KEY)!)) { (success, response) in
            if success {
                print(response)
                completion(true)
            } else{
                self.alertMessage = response[ERROR_KEY]["message"].stringValue
                if (self.alertMessage == nil) {
                    self.alertMessage = response[ERROR_KEY].stringValue
                }
                completion(false)
            }
        }
    }
    
    
    func validateDeliveryAddress(sectionValue: Int, cookId: String, addressId: String, completion: @escaping (_ success: Bool)->Void) {
        
        var url = String()
        if sectionValue == 0 {
            //url = BASE_URL_KEY + "auth/order/validate-delivery-address/" + cookId + "/" + addressId
            url = BASE_URL_KEY + "auth/order/validate-delivery-address"
        } else {
            //url = BASE_URL_KEY + "auth/order/validate-other-delivery-address/" + cookId + "/" + addressId
            url = BASE_URL_KEY + "auth/order/validate-other-delivery-address"
        }
        
        
        let param = [
            "cookId" : cookId,
            "address" : addressId
        ]
        
        
        
        authServiceObj.synPostMethod(url: url, parameter: param, header: Helper.headerWithToken(token: Helper.getUserDefault(key: TOKEN_KEY)!)) { (success, response) in
            if success {
                print(response)
                completion(true)
            } else {
                self.alertMessage = response[ERROR_KEY]["message"].stringValue
                if (self.alertMessage == nil) {
                    self.alertMessage = response[ERROR_KEY].stringValue
                }
                completion(false)
            }
        }
        
        /*
        authServiceObj.synGetMethod(url: url , header: Helper.headerWithToken(token: Helper.getUserDefault(key: TOKEN_KEY)!)) { (success, response) in
            if success {
                print(response)
                completion(true)
            } else {
                self.alertMessage = response[ERROR_KEY]["message"].stringValue
                if (self.alertMessage == nil) {
                    self.alertMessage = response[ERROR_KEY].stringValue
                }
                completion(false)
            }
        } */
    }
    
}
