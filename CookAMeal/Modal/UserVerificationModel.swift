//
//  UserVerificationModel.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 30/01/18.
//  Copyright © 2018 Cynoteck. All rights reserved.
//

import UIKit
import SwiftyJSON

class UserVerificationModel: NSObject {

    let authServiceObj: AuthServices = AuthServices()
    var alertMessage: String!
    
    override init() {
        alertMessage = ""
        
    }
    
    
    func verifyUser(email: String, phone: String, completion: @escaping (_ flag: String, _ success: Bool)->Void) {
       
        let parameter: [String: String] = [
            "email": email,
            "phone" : phone
        ]
        
        authServiceObj.synPostMethod(url: BASE_URL_KEY + "validate-user", parameter: parameter, header: HEADER) { (success, response) in
            
            print(response)
            if success {
                
//                let flagValue = response[DATA_KEY]["flag"].stringValue
//                
//                if flagValue == "2" {
//                    let token = response[DATA_KEY][TOKEN_KEY].stringValue
//                    let profileImageUrl = response[DATA_KEY][USER_KEY]["profileUrl"].stringValue
//                    let userRole = response[DATA_KEY][USER_KEY][USER_ROLE_KEY].stringValue
//                    let userName = response[DATA_KEY][USER_KEY]["fullName"].stringValue
//                    let userRegisterEmail = response[DATA_KEY][USER_KEY]["email"].stringValue
//                    let userId = response[DATA_KEY][USER_KEY][ID_KEY].stringValue
//                    
//                    //Save data in user default.
//                    Helper.saveUserDefaultValue(key: PROFILE_URL_KEY, value: profileImageUrl)
//                    Helper.saveUserDefaultValue(key: USER_ROLE_KEY, value: userRole)
//                    Helper.saveUserDefaultValue(key: FULL_NAME_KEY, value: userName)
//                    Helper.saveUserDefaultValue(key: EMAIL_KEY, value: userRegisterEmail)
//                    Helper.saveUserDefault(key: TOKEN_KEY, value: token)
//                    Helper.saveUserDefaultValue(key: ID_KEY, value: userId)
//                    Helper.saveUserDefaultValue(key: GUEST_KEY, value: "0")
//                    
//                } else if flagValue == "1"{
//                    self.alertMessage = response[DATA_KEY]["message"].stringValue
//                }
                
                completion("", true)
                
            } else{
                
                self.alertMessage = response[ERROR_KEY]["message"].stringValue
                if (self.alertMessage == nil) {
                    self.alertMessage = response[ERROR_KEY].stringValue
                }
                completion("", false)
            }
        }
    }
    
    
    func verifyFacebookUser(facbookID: String, facebookEmailId: String, completion: @escaping (_ facebookExists: Bool, _ success: Bool)->Void) {
        
        
        var parameter =  [String: String]()
        
        if facebookEmailId == "" {
            parameter = [
                FACEBOOK_ID_KEY: facbookID
            ]
            
        } else {
            parameter = [
                FACEBOOK_ID_KEY: facbookID,
                FACEBOOK_EMAIL_ID_KEY: facebookEmailId
            ]
        }
        
       
        
        authServiceObj.synPostMethod(url: BASE_URL_KEY + "check-facebook", parameter: parameter, header: HEADER) { (success, response) in
            print(response)
            if success {
                self.alertMessage = response[DATA_KEY][MESSAGE_KEY].stringValue
                completion(response[DATA_KEY]["facebookExists"].boolValue, true)
            } else{
                self.alertMessage = response[ERROR_KEY]["message"].stringValue
                if (self.alertMessage == nil) {
                    self.alertMessage = response[ERROR_KEY].stringValue
                }
                completion(response[DATA_KEY]["facebookExists"].boolValue, false)
            }
        }
    }
    
}
