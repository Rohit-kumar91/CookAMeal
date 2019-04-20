//
//  EmailVerificationModel.swift
//  CookAMeal
//
//  Created by Cynoteck on 05/09/18.
//  Copyright © 2018 Cynoteck. All rights reserved.
//

import UIKit
import SwiftyJSON

class EmailVerificationModel: NSObject {

    let authServiceObject:AuthServices = AuthServices()

    var alertMessage: String!
    var authorizationToken = String()
    var responseJson = JSON()
    
    override init() {
        alertMessage = ""
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
                print(self.responseJson)
                completion(true)
            } else {
                self.alertMessage = response[ERROR_KEY]["message"].stringValue
                completion(false)
            }
            
        }
    }
    
    
    
    func resendOTP(id: String, emailId: String, completion: @escaping (_ success: Bool)->Void) {
        
        let param = [
            "id": id,
            "emailId": emailId

        ]
        
        print(param)
        
        print(BASE_URL_KEY + "resend-otp")
        authServiceObject.synPostMethod(url: BASE_URL_KEY + "resend-otp", parameter: param, header: HEADER) { (success, response) in
            print(response)
            
            if success {
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
    
    
}
