//
//  ChangePasswordModel.swift
//  CookAMeal
//
//  Created by Cynoteck on 25/09/18.
//  Copyright © 2018 Cynoteck. All rights reserved.
//

import UIKit

class ChangePasswordModel: NSObject {

    var currentPassword: String!
    var newPassword: String!
    var confirmPassword: String!
    var alertMessage: String!
    let authServiceObj: AuthServices = AuthServices()

    
    override init() {
        super.init()
        self.currentPassword = ""
        self.newPassword = ""
        self.confirmPassword = ""
        self.alertMessage = ""
    }
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 30 2017
    // Input Parameters :   N/A.
    // Purpose          :   Validate the newPassword textfield.
    //>--------------------------------------------------------------------------------------------------
    
    func validateCurrentPassword() -> Bool {
        var valid: Bool = true
        if self.currentPassword.isEmpty {
            valid = false
            self.alertMessage = "New password is empty."
        }else if !self.currentPassword.isPasswordStrong {
            valid = false
            self.alertMessage = "Password Should have atleast one uppercase letters, one special case character, digits, lowercase letters. Ensure string is of length 9."
        }
        
        return valid
    }
    
    
    
    func newPasswordValidate () -> Bool
    {
       
        var valid: Bool = true
        if self.newPassword.isEmpty {
            valid = false
            self.alertMessage = "New password is empty."
        } else if !self.newPassword.isPasswordStrong {
            valid = false
            self.alertMessage = "Password Should have atleast one uppercase letters, one special case character, digits, lowercase letters. Ensure string is of length 9."
        }
        
        return valid
    }
    
    
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 30 2017
    // Input Parameters :   N/A.
    // Purpose          :   Validate the retype password textfield.
    //>--------------------------------------------------------------------------------------------------
    func confirmPasswordValidate () -> Bool
    {
        var valid: Bool = true
        if self.confirmPassword.isEmpty
        {
            valid = false
            self.alertMessage = "Confirm Password is empty."
        }
        
        return valid
    }
    
    
    
    func bothPasswordSame() -> Bool {
        var valid: Bool = true
        if self.newPassword != self.confirmPassword
        {
            valid = false
            self.alertMessage = "New password and Confirm password is not same."
        }
        return valid
    }
    
    
    
    
    
    func changePassword(completion: @escaping (_ success: Bool)->Void) {
        
        
        
        let parameter: [String: String] = [
            "password": newPassword,
            "time": dateTime(date: Date())
        ]
        
        authServiceObj.synPostMethod(url: BASE_URL_KEY + "common/reset-password" , parameter: parameter, header: Helper.headerWithToken(token: Singleton.instance.tempTokenString)) { (success, response) in
            
            print(response)
            if success {
                self.alertMessage = response["data"]["message"].stringValue
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
    
    
    func dateTime(date: Date)  -> String{
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let result = formatter.string(from: date)
        print(result)
        return result
    }
    
}
