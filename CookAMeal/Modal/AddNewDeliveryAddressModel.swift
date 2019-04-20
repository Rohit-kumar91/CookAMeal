//
//  AddNewDeliveryAddressModel.swift
//  CookAMeal
//
//  Created by CYNOMAC001 on 10/04/18.
//  Copyright © 2018 Cynoteck. All rights reserved.
//

import UIKit
import SwiftyJSON

class AddNewDeliveryAddressModel: NSObject {
    
    var cookId: String!
    var countryCode: String!
    var name: String!
    var dialCode: String!
    var fullName: String!
    var mobileNumber: String!
    var pinCode: String!
    var streetAddress: String!
    var city: String!
    var state: String!
    var country: String!
    var alertMessage: String!
    var latitude: String!
    var longitute: String!
    var addressJson = JSON()
    let authServiceObj:AuthServices = AuthServices()
   
    
    override init() {
        fullName = ""
        mobileNumber = ""
        pinCode = ""
        streetAddress = ""
        city = ""
        state = ""
        country = ""
        latitude = ""
        longitute = ""
        
        name = ""
        dialCode = ""
        countryCode = ""
        cookId = ""
        
    }
    
    
    
    func validateFullname () -> Bool
    {
        var valid: Bool = true
        
        if self.fullName.isEmpty
        {
            valid = false
            self.alertMessage = "Full Name required"
        }
        return valid
    }
    
    
    
    func validatePhone () -> Bool
    {
        var valid: Bool = true
        if self.mobileNumber.isEmpty
        {
            valid = false
            self.alertMessage = "Mobile number required"
        }
        else
        {
            if self.mobileNumber.count > 0 && self.mobileNumber.count < 10
            {
                valid = false
                self.alertMessage = "Mobile number is not correct."
            }
            else
            {
                valid = true
            }
        }
        return valid
    }
    
    
    
    func validatePincode () -> Bool
    {
        var valid: Bool = true
        
        if self.pinCode.isEmpty
        {
            valid = false
            self.alertMessage = "Pincode required"
        }
        return valid
    }
    
    
    func validateStreet () -> Bool
    {
        var valid: Bool = true
        
        if self.streetAddress.isEmpty
        {
            valid = false
            self.alertMessage = "Street Address is required"
        }
        return valid
    }
    
    
    func validateCity () -> Bool
    {
        var valid: Bool = true
        
        if self.city.isEmpty
        {
            valid = false
            self.alertMessage = "City is required"
        }
        return valid
    }
    
    
    func validateState () -> Bool
    {
        var valid: Bool = true
        
        if self.state.isEmpty
        {
            valid = false
            self.alertMessage = "State is required"
        }
        return valid
    }
    
    func validateCountry () -> Bool
    {
        var valid: Bool = true
        
        if self.country.isEmpty
        {
            valid = false
            self.alertMessage = "Country is required"
        }
        return valid
    }
    
    
    func addNewAddress(completion: @escaping (_ success: Bool)->Void) {
        
        
        let code: [String: String] = [
            "name": name,
            "dial_code": dialCode,
            "code": countryCode
        ]
        
        let parameter: [String: Any] = [
            "fullName": fullName as String,
            "mobileNumber": mobileNumber as String,
            "street": streetAddress as String,
            "city": city as String,
            "state": state as String,
            "zipCode": pinCode as String,
            "country": country as String,
            "latitude": latitude as String,
            "longitude": longitute as String,
            "code": code as [String: String],
            "cookId": cookId
        
        ]
        
        
        // /addressID
        authServiceObj.synPostMethod(url: BASE_URL_KEY + "auth/delivery-address", parameter: parameter, header: Helper.headerWithToken(token: Helper.getUserDefault(key: TOKEN_KEY)!)) { (success, response) in
            print(response)
            if success {
                self.addressJson  =  response[DATA_KEY]
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
}
