//
//  FacebookEmailVerificationModel.swift
//  CookAMeal
//
//  Created by Cynoteck on 06/09/18.
//  Copyright © 2018 Cynoteck. All rights reserved.
//

import UIKit
import SwiftyJSON

class FacebookEmailVerificationModel: NSObject {

    var userEmail: String!
    
    let authServiceObject:AuthServices = AuthServices()
    var alertMessage: String!
    var responseJson = JSON()
    
    
    
    override init() {
        super.init()
        self.userEmail = ""
        self.alertMessage = ""
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
        else  if !lowerCasedEmail.isValidEmail()  {
            valid = false
            self.alertMessage = LOGIN_CONSTANT.EMAIL_AUTHENTICATION_MESSAGE_KEY
        }
        
        return valid
    }
    
    
    
    
    func verifyFbEmailAddress(userId: String, emailId: String, facebookEmailId:String, facebookId: String, completion: @escaping (_ success: Bool)->Void) {
        
        let parameter = [
            "userId": userId,
            "emailId": emailId,
            "facebookEmailId" : facebookEmailId,
            "facebookId" : facebookId
        ]
        
        authServiceObject.synPostMethod(url: BASE_URL_KEY + "send-otp-for-verification", parameter: parameter, header: HEADER) { (success, response) in
            print(response)
            
            if success {
                //Save Token Here.
                self.alertMessage = response["data"]["message"].stringValue
                completion(true)
            } else {
                self.alertMessage = response[ERROR_KEY].stringValue
                completion(false)
            }
        }
    }
    
    
    
    
    func resendOTP(id: String, emailId: String, completion: @escaping (_ success: Bool)->Void) {
        
        let param = [
            "id": id,
            "emailId": emailId
            
        ]
        
        print(BASE_URL_KEY + "resend-otp")
        authServiceObject.synPostMethod(url: BASE_URL_KEY + "resend-otp", parameter: param, header: HEADER) { (success, response) in
            print(response)
            
            if success {
                //Save Token Here.
                self.alertMessage = response["data"]["message"].stringValue
                completion(true)
            } else {
                self.alertMessage = response[ERROR_KEY]["message"].stringValue
                if (self.alertMessage == nil) {
                    self.alertMessage = response[ERROR_KEY].stringValue
                }
                completion(false)
            }
        }
    }
    
    
    
    
    
    func verifyOtp(authorizationToken: String, otpString: String, completion: @escaping (_ success: Bool)->Void) {
        
        let param = [
            "otpCode" : otpString
        ]
        
        let HeaderValue = [
            "Content-Type" : "application/json",
            "Authorization" : authorizationToken
        ]
        
        
        authServiceObject.synPostMethod(url: BASE_URL_KEY + "common/email-verification", parameter: param, header: HeaderValue) { (success, response) in
            
            print(response)
            
            if success {
                //Save Token Here.
                self.responseJson = response
                completion(true)
            } else {
                self.alertMessage = response[ERROR_KEY]["message"].stringValue
                if (self.alertMessage == nil) {
                    self.alertMessage = response[ERROR_KEY].stringValue
                }
                completion(false)
            }
        }
    }
    
}
