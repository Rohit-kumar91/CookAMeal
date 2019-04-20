//
//  UserSelectionModel.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 30/01/18.
//  Copyright © 2018 Cynoteck. All rights reserved.
//

import UIKit
import SwiftyJSON


class UserSelectionModel: NSObject {

    let authServiceObj: AuthServices = AuthServices()
    var alertMessage: String!
    var response : JSON!
    var token: String!
    var profileSelected: Bool!

    
    override init() {
        alertMessage = ""
    }
    
    
    func changeProfile(userRole: String, tokenValue: String, completion: @escaping (_ success: Bool)->Void){
        
        let header = [
            "Content-Type": "application/json",
            AUTHORIZATION_KEY: tokenValue
        ]
        
        //Helper.saveUserDefaultValue(key: "fbIdKey", value: facebookId as String)
        
        let parameter = [
            USER_ROLE_KEY: userRole,
            "facebookId" :  Singleton.instance.fbId //Helper.getUserDefaultValue(key: "fbIdKey")
        ]
        
        print(parameter)
        
        authServiceObj.synPostMethod(url: BASE_URL_KEY + "change-profile", parameter: parameter as [String : Any], header: header) { (success, response) in
            
            if success {
                self.response = response
                
                print(response)
                self.token = response[DATA_KEY][TOKEN_KEY].stringValue
                let profileImageUrl = response[DATA_KEY][USER_KEY][PROFILE_URL_KEY].stringValue
                let userRole = response[DATA_KEY][USER_KEY][USER_ROLE_KEY].stringValue
                let userName = response[DATA_KEY][USER_KEY][FULL_NAME_KEY].stringValue
                let userRegisterEmail = response[DATA_KEY][USER_KEY][EMAIL_KEY].stringValue
                let userId = response[DATA_KEY][USER_KEY][ID_KEY].stringValue
                let hasProfile = response[DATA_KEY][USER_KEY][HAS_PROFILE_KEY].boolValue
                self.profileSelected = response[DATA_KEY][USER_KEY][PROFILE_SELECTED_KEY].boolValue
                
                Helper.saveUserDefaultValue(key: ID_KEY, value: userId as String)
                Helper.saveUserDefaultValue(key: PROFILE_URL_KEY, value: profileImageUrl as String)
                Helper.saveUserDefaultValue(key: USER_ROLE_KEY, value: userRole as String)
                Helper.saveUserDefaultValue(key: FULL_NAME_KEY, value: userName as String)
                Helper.saveUserDefaultValue(key: EMAIL_KEY, value: userRegisterEmail as String)
                //Helper.saveUserDefault(key: TOKEN_KEY, value: self.token as String)
                Helper.saveUserDefaultValue(key: HAS_PROFILE_KEY, value: hasProfile as Bool )
                Helper.saveUserDefaultValue(key: GUEST_KEY, value: "0")
                
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
