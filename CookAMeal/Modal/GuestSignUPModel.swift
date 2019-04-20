//
//  GuestSignUPModel.swift
//  CookAMeal
//
//  Created by Cynoteck on 18/04/18.
//  Copyright © 2018 Cynoteck. All rights reserved.
//

import UIKit
import SwiftyJSON

class GuestSignUPModel: NSObject {
    
    var userEmail: String!
    var firstname: String!
    var lastname: String!
    var mobileNumber: String!
    
    var street: String!
    var city: String!
    var state: String!
    var pinCode: String!
    var country: String!
    var alertMessage: String!
    var noOfServing: String!
    var spiceLevel: String!
    var specialInstruction: String!
    var deliveryType: String!
    var deliveryFee: String!
    var deliveryDateTime: String!
    var nonce: String!
    var chargeAmount: String!
    var paymentType: String!
    var recipeId: String!
    var paymentResponse = JSON()

    let authServiceObj:AuthServices = AuthServices()
    
    
    
    override init() {
        self.userEmail = ""
        self.firstname = ""
        self.lastname = ""
        self.mobileNumber = ""
        self.street = ""
        self.city = ""
        self.state = ""
        self.pinCode = ""
        self.country = ""
        self.alertMessage = ""
        self.noOfServing = ""
        self.spiceLevel = ""
        self.specialInstruction = ""
        self.deliveryType = ""
        self.deliveryFee = ""
        self.deliveryDateTime = ""
        self.nonce = ""
        self.chargeAmount = ""
        self.paymentType = ""
        self.recipeId = ""

        
    }
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Oct, 30 2017
    // Input Parameters :   N/A.
    // Purpose          :   Validate the email textfield.
    //>--------------------------------------------------------------------------------------------------
    
    
    func validateEmail () -> Bool
    {
        var valid: Bool = true
        
        self.userEmail = self.userEmail.trimmingCharacters(in: .whitespaces)
        let lowerCasedEmail = userEmail.lowercased()
        
        if lowerCasedEmail.isEmpty
        {
            valid = false
            self.alertMessage = LOGIN_CONSTANT.EMAIL_MISSING_KEY
        }
        else  if !lowerCasedEmail.isValidEmail()  {
            valid = false
            self.alertMessage = LOGIN_CONSTANT.EMAIL_AUTHENTICATION_MESSAGE_KEY
        }
        
        return valid
    }
    
    
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Oct, 30 2017
    // Input Parameters :   N/A.
    // Purpose          :   Validate the firstname textfield.
    //>--------------------------------------------------------------------------------------------------
    
    func validateFirstname () -> Bool
    {
        var valid: Bool = true
        self.firstname = self.firstname.trimmingCharacters(in: .whitespaces)

        self.firstname = self.firstname.trimmingCharacters(in: .whitespaces)
        
        if self.firstname.isEmpty
        {
            valid = false
            self.alertMessage = "First Name required"
        }
        
        return valid
    }
    
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Oct, 30 2017
    // Input Parameters :   N/A.
    // Purpose          :   Validate the lastname textfield.
    //>--------------------------------------------------------------------------------------------------
    
    func validateLastname () -> Bool
    {
        var valid: Bool = true
        self.lastname = self.lastname.trimmingCharacters(in: .whitespaces)
        if self.lastname.isEmpty
        {
            valid = false
            self.alertMessage = "Last Name required"
        }
        
        return valid
    }
    
    
    
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Oct, 30 2017
    // Input Parameters :   N/A.
    // Purpose          :   Validate the phone number textfield.
    //>--------------------------------------------------------------------------------------------------
    
    func validatePhone () -> Bool
    {
        var valid: Bool = true
        self.mobileNumber = self.mobileNumber.trimmingCharacters(in: .whitespaces)
        if self.mobileNumber.isEmpty
        {
            valid = false
            self.alertMessage = "Phone number required"
        }
        else
        {
            if self.mobileNumber.count > 0 && self.mobileNumber.count < 10
            {
                valid = false
                self.alertMessage = "Phone number is not correct."
            }
            else
            {
                valid = true
            }
        }
        return valid
    }
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Oct, 30 2017
    // Input Parameters :   N/A.
    // Purpose          :   Validate the Street address textfield.
    //>--------------------------------------------------------------------------------------------------
    
    func validateStreetAddress () -> Bool
    {
        var valid: Bool = true
        self.street = self.street.trimmingCharacters(in: .whitespaces)

        if self.street.isEmpty
        {
            valid = false
            self.alertMessage = "Street Address required"
        }
        
        return valid
    }
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Oct, 30 2017
    // Input Parameters :   N/A.
    // Purpose          :   Validate the City textfield.
    //>--------------------------------------------------------------------------------------------------
    
    func validateCity () -> Bool
    {
        var valid: Bool = true
        self.city = self.city.trimmingCharacters(in: .whitespaces)

        if self.city.isEmpty
        {
            valid = false
            self.alertMessage = "City required"
        }
        
        return valid
    }
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Oct, 30 2017
    // Input Parameters :   N/A.
    // Purpose          :   Validate the State textfield.
    //>--------------------------------------------------------------------------------------------------
    
    func validateState () -> Bool
    {
        var valid: Bool = true
        self.state = self.state.trimmingCharacters(in: .whitespaces)
        
        if self.state.isEmpty
        {
            valid = false
            self.alertMessage = "State required"
        }
        
        return valid
    }
    
    
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Oct, 30 2017
    // Input Parameters :   N/A.
    // Purpose          :   Validate the Zipcode textfield.
    //>--------------------------------------------------------------------------------------------------
    
    func validateZipcode () -> Bool
    {
        var valid: Bool = true
        self.pinCode = self.pinCode.trimmingCharacters(in: .whitespaces)
        if self.pinCode.isEmpty
        {
            valid = false
            self.alertMessage = "Zipcode required"
        }
        else
        {
            
            if self.country == "India" {
                if self.pinCode.count < 6
                {
                    valid = false
                    self.alertMessage = "Zipcode number is not correct."
                }
                else
                {
                    valid = true
                }
            }else{
                
                
                if self.pinCode.count < 5
                {
                    valid = false
                    self.alertMessage = "Zipcode number is not correct."
                }
                else
                {
                    valid = true
                }
            }
            
        }
        
        return valid
    }
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Oct, 30 2017
    // Input Parameters :   N/A.
    // Purpose          :   Validate the Country textfield.
    //>--------------------------------------------------------------------------------------------------
    
    
    func validateCountry () -> Bool
    {
        var valid: Bool = true
        self.country = self.country.trimmingCharacters(in: .whitespaces)

        if self.country.isEmpty
        {
            valid = false
            self.alertMessage = "Country required"
        }
        
        return valid
    }
    
    
    
    
    func registerGuestUser(completion: @escaping (_ success: Bool)->Void) {
        
         var parameter = [String: String]()
        
        if mobileNumber.isEmpty {
            parameter = [
                
                "noOfServing" : noOfServing,
                "spiceLevel" : spiceLevel,
                "firstName" : firstname,
                "lastName" : lastname,
                "email" : userEmail,
                "streetAddress" : street,
                "city" : city,
                "state" : state,
                "zipCode" : pinCode,
                "country" : country,
                "specialInstruction" : specialInstruction,
                "deliveryType" : deliveryType,
                "deliveryFee" : deliveryFee,
                "pickUpTime" : deliveryDateTime,
                "nonce" : nonce,
                "chargeAmount" : chargeAmount,
                "paymentType" : paymentType,
                "recipeId" : recipeId,
                LATITUDE_KEY: String(currentLocationLatitude), // 30.3565759311799
                LONGITUDE_KEY: String(currentLocationLongitute)
                
            ]
            
        } else {
            
            parameter = [
                
                "noOfServing" : noOfServing,
                "spiceLevel" : spiceLevel,
                "firstName" : firstname,
                "lastName" : lastname,
                "email" : userEmail,
                "phoneNumber" : mobileNumber,
                "streetAddress" : street,
                "city" : city,
                "state" : state,
                "zipCode" : pinCode,
                "country" : country,
                "specialInstruction" : specialInstruction,
                "deliveryType" : deliveryType,
                "deliveryFee" : deliveryFee,
                "pickUpTime" : deliveryDateTime,
                "nonce" : nonce,
                "chargeAmount" : chargeAmount,
                "paymentType" : paymentType,
                "recipeId" : recipeId,
                LATITUDE_KEY: String(currentLocationLatitude), // 30.3565759311799
                LONGITUDE_KEY: String(currentLocationLongitute)
                
                
            ]
        }
        
        print(parameter)
        
        authServiceObj.synPostMethod(url: BASE_URL_KEY + "common/order/guest/create-purchase-recipe", parameter: parameter, header: Helper.headerWithToken(token: Helper.getUserDefault(key: TOKEN_KEY)!)) { (success, response) in
            
            print(response)
            
            if success {
                self.paymentResponse = response
                completion(true)
            } else{
                self.alertMessage = response[ERROR_KEY]["message"].stringValue
                completion(false)
            }
        }
    }
    
    
    
    
    func validateAddress(cookId:String, completion: @escaping (_ success: Bool)->Void) {
        
        
        let parameter = [
            "cookId" : cookId,
            "streetAddress" : street!,
            "city" : city!,
            "state" : state!,
            "zipCode" : pinCode!,
            "country" : country!,
            "email" : userEmail as String,
            "phone": mobileNumber as String,
            LATITUDE_KEY: String(currentLocationLatitude), // 30.3565759311799
            LONGITUDE_KEY: String(currentLocationLongitute) // 78.0850118542611
        ]
        
        
        authServiceObj.synPostMethod(url: BASE_URL_KEY + "common/order/guest/verify-address", parameter: parameter , header: Helper.headerWithToken(token: Helper.getUserDefault(key: TOKEN_KEY)!)) { (success, response) in
            
            print(response)
            
            if success {
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
