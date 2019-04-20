//
//  RssetPasswordModel.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 30/11/17.
//  Copyright © 2017 Cynoteck. All rights reserved.
//

import UIKit

class RssetPasswordModel: NSObject {
    
    var newPassword: String!
    var retypePassword: String!
    var temperoryPassword: String!
    var alertMessage: String!
    let authServiceObj: AuthServices = AuthServices()
    
    override init() {
        super.init()
        
        self.newPassword = ""
        self.retypePassword = ""
        self.temperoryPassword = ""
        self.alertMessage = ""
        
    }
    
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 30 2017
    // Input Parameters :   N/A.
    // Purpose          :   Validate the temperory textfield.
    //>--------------------------------------------------------------------------------------------------
    func temperoryPasswordValidate () -> Bool
    {
        var valid: Bool = true
        
        if self.temperoryPassword.isEmpty
        {
            valid = false
            self.alertMessage = "Current password required"
        } else if !self.temperoryPassword.isPasswordStrong {
            valid = false
            self.alertMessage = "Password Should have two uppercase letters, one special case character, digits, lowercase letters. Ensure string is of length 9."
        }
        
        return valid
    }
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 30 2017
    // Input Parameters :   N/A.
    // Purpose          :   Validate the newPassword textfield.
    //>--------------------------------------------------------------------------------------------------
    func newPasswordValidate () -> Bool
    {
        var valid: Bool = true
        
        if self.newPassword.isEmpty
        {
            valid = false
            self.alertMessage = "New password is empty."
        }
        else if !self.newPassword.isPasswordStrong {
            valid = false
            self.alertMessage = "Password Should have two uppercase letters, one special case character, digits, lowercase letters. Ensure string is of length 9."
        }
        
        return valid
    }
    
    

    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 30 2017
    // Input Parameters :   N/A.
    // Purpose          :   Validate the retype password textfield.
    //>--------------------------------------------------------------------------------------------------
    func retypePasswordValidate () -> Bool
    {
        var valid: Bool = true
        
        if self.retypePassword.isEmpty
        {
            valid = false
            self.alertMessage = "Confirm password is empty."
        }
        else if !self.retypePassword.isPasswordStrong {
            valid = false
            self.alertMessage = "Password Should have two uppercase letters, one special case character, digits, lowercase letters. Ensure string is of length 9."
        }
        
        return valid
    }
    
    
    func checkNewPasswordAndretypePasswordAreSame() -> Bool {
        var valid: Bool = true
        
        if self.newPassword != self.retypePassword
        {
            valid = false
            self.alertMessage = "New password and confirm password are not same."
        }
        
        return valid
    }
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 30 2017
    // Input Parameters :   N/A.
    // Purpose          :   Check passowrd are samr or not.
    //>--------------------------------------------------------------------------------------------------
    func checkPasswordFieldAreSame () -> Bool {
        var valid: Bool = true
        
        if self.temperoryPassword == self.newPassword && self.temperoryPassword == self.retypePassword
        {
            valid = false
            self.alertMessage = "New password should be different from the current password."
        }
        
        
        return valid
    }
    
    
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 30 2017
    // Input Parameters :   N/A.
    // Purpose          :   Helps in to get the data from web and also validate data.
    //>--------------------------------------------------------------------------------------------------
    func changeUserPassword(completion: @escaping (_ success: Bool)->Void){
        
        let parameter: [String: String] = [
            "newPassword": newPassword,
            "oldPassword": temperoryPassword,
            "time": dateTime(date: Date())
        ]
        
        authServiceObj.synPostMethod(url: BASE_URL_KEY + CHANGE_PASSWORD, parameter: parameter, header: Helper.headerWithToken(token: Helper.getUserDefault(key: TOKEN_KEY)!)) { (success, response) in
            if success {
                if response[SUCCESS_KEY].boolValue {
                     self.alertMessage = response["data"]["message"].stringValue
                    completion(true)
                } else{
                    self.alertMessage = response["data"]["message"].stringValue
                    if (self.alertMessage == nil) {
                        self.alertMessage = response["data"].stringValue
                    }
                    completion(false)
                }
            } else{
                self.alertMessage = response[ERROR_KEY]["message"].stringValue
                if (self.alertMessage == nil) {
                    self.alertMessage = response[ERROR_KEY].stringValue
                }
                completion(false)
            }
        }
    }
    
    
    func dateTime(date: Date)  -> String{
       
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let result = formatter.string(from: date)
        print(result)
        return result
    }
}
