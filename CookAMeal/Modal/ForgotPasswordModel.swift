//
//  ForgotPasswordModel.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 31/01/18.
//  Copyright © 2018 Cynoteck. All rights reserved.
//

import UIKit

class ForgotPasswordModel: NSObject {
    
    var userEmail: String!
    var alertMessage: String!
    
    let authServiceObject:AuthServices = AuthServices()
    
    override init() {
        userEmail = ""
    }
    
    
    
    
    func validateEmail () -> Bool
    {
        var valid: Bool = true
        let lowerCasedEmail = userEmail.lowercased()
        if lowerCasedEmail.isEmpty
        {
            valid = false
            self.alertMessage = LOGIN_CONSTANT.EMAIL_MISSING_KEY
        }
        else  if !self.userEmail.isValidEmail()  {
            valid = false
            self.alertMessage = LOGIN_CONSTANT.EMAIL_AUTHENTICATION_MESSAGE_KEY
        }
        
        return valid
    }
    
    
    func forgotPassword(completion: @escaping (_ success: Bool)->Void) {
        
        let parameterDict: [String: String] = [
            EMAIL_KEY: userEmail
        ]
        
        authServiceObject.synPostMethod(url: BASE_URL_KEY + FORGOT_PASSWORD, parameter: parameterDict, header: HEADER) { (success, response) in
            
            print(response)
            if success {
                
                self.alertMessage = response[DATA_KEY][MESSAGE_KEY].stringValue
                
                completion(true)
                
            }else{
                
                self.alertMessage = response[ERROR_KEY]["message"].stringValue
                if (self.alertMessage == nil) {
                    self.alertMessage = response[ERROR_KEY].stringValue
                }
                
                completion(false)
            }
        }
    }
}
