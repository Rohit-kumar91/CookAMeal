//
//  LoginModel.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 16/11/17.
//  Copyright © 2017 Cynoteck. All rights reserved.
//

import Foundation
import SwiftyJSON


class LoginModel: NSObject {

    var userEmail: String!
    var password: String!
    var alertMessage: String!
    var isDashboard: Bool! // true = Dashboard, false = ChangePassword
    let authServiceObject:AuthServices = AuthServices()
    var gender = String()
    var profileSelected: Bool!
    var token: String!
    var facebookFirstUser: Bool!
    var authorizationToken = String()
    var isFacebookEmailIsVerified = Bool()
    
    var email: String!
    var id: String!
    
    override init() {
        super.init()
        
        self.userEmail = ""
        self.password = ""
        self.facebookFirstUser = false
        self.alertMessage = ""
        
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
    // Purpose          :   Validate the password textfield.
    //>--------------------------------------------------------------------------------------------------
    func validatePassword () -> Bool
    {
        var valid: Bool = true
        
        if self.password.isEmpty
        {
            valid = false
            self.alertMessage = LOGIN_CONSTANT.PASSWORD_MESSAGE_KEY
        }
        
        return valid
    }
    
  
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   NOV, 18 2017
    // Input Parameters :   N/A.
    // Purpose          :   Allow to access the websevice data using login credential.
    //>---------------------------------------------------------------------------------------------------
    func loginUser(completion: @escaping (_ success: Bool, _ isEmailVarified: Bool, _ forgotPassword: Bool)->Void){
        
        let lowerCaseEmail = userEmail.lowercased()
        let params: [String: String] = [USERNAME_KEY: lowerCaseEmail, PASSWORD_KEY: password]
        let loginUrl = BASE_URL_KEY + LOGIN_CONSTANT.LOGIN_KEY
        
        authServiceObject.synPostMethod(url: loginUrl, parameter: params, header: HEADER) { (success, response) in
            
            if success {
                
                
                if response["data"]["user"]["isEmailAddressVerified"].boolValue {
                    
                    //Send to dashboard screen if email is varified.
                    let profileImageUrl = response[DATA_KEY][USER_KEY][PROFILE_URL_KEY].stringValue
                    let userRole = response[DATA_KEY][USER_KEY][USER_ROLE_KEY].stringValue
                    let userName = response[DATA_KEY][USER_KEY][FULL_NAME_KEY].stringValue
                    let userRegisterEmail = response[DATA_KEY][USER_KEY][EMAIL_KEY].stringValue
                    let userId = response[DATA_KEY][USER_KEY][ID_KEY].stringValue
                    let currencySymbol = response[DATA_KEY][USER_KEY][CURRENCY_SYMBOL_KEY].stringValue
                    
                    Helper.saveUserDefaultValue(key: PROFILE_URL_KEY, value: profileImageUrl)
                    Helper.saveUserDefaultValue(key: USER_ROLE_KEY, value: userRole)
                    Helper.saveUserDefaultValue(key: FULL_NAME_KEY, value: userName)
                    Helper.saveUserDefaultValue(key: EMAIL_KEY, value: userRegisterEmail)
                    Helper.saveUserDefaultValue(key: ID_KEY, value: userId)
                    Helper.saveUserDefaultValue(key: CURRENCY_SYMBOL_KEY, value: currencySymbol)
                    self.isFacebookEmailIsVerified = response["data"]["user"]["isEmailAddressVerified"].boolValue
                    
                    if  response[DATA_KEY][TYPE_KEY].boolValue {
                        //send to dashboard screen.
                        let token = response[DATA_KEY][TOKEN_KEY].stringValue
                        
                        Helper.saveUserDefault(key: TOKEN_KEY, value: token)
                        Helper.saveUserDefaultValue(key: GUEST_KEY, value: "0")
                        self.alertMessage = LOGIN_CONSTANT.LOGIN_SUCCESS
                        completion(true, true, false)
                    }else{
                        
                        //send to change password.
                        let token = response[DATA_KEY][TOKEN_KEY].stringValue
                        print(token)
                        Singleton.instance.tempTokenString = token
                        completion(true, true, true)
                    }
                        
                } else {
                    
                    //Email is not varified.
                    
                    let profileImageUrl = response[DATA_KEY][USER_KEY][PROFILE_URL_KEY].stringValue
                    let userRole = response[DATA_KEY][USER_KEY][USER_ROLE_KEY].stringValue
                    let userName = response[DATA_KEY][USER_KEY][FULL_NAME_KEY].stringValue
                    let userRegisterEmail = response[DATA_KEY][USER_KEY][EMAIL_KEY].stringValue
                    let userId = response[DATA_KEY][USER_KEY][ID_KEY].stringValue
                    let currencySymbol = response[DATA_KEY][USER_KEY][CURRENCY_SYMBOL_KEY].stringValue
                    let token = response[DATA_KEY][TOKEN_KEY].stringValue
                    self.authorizationToken = token
                    self.email = userRegisterEmail
                    self.id = userId
                    
                    Helper.saveUserDefaultValue(key: PROFILE_URL_KEY, value: profileImageUrl)
                    Helper.saveUserDefaultValue(key: USER_ROLE_KEY, value: userRole)
                    Helper.saveUserDefaultValue(key: FULL_NAME_KEY, value: userName)
                    Helper.saveUserDefaultValue(key: EMAIL_KEY, value: userRegisterEmail)
                    Helper.saveUserDefaultValue(key: ID_KEY, value: userId)
                    Helper.saveUserDefaultValue(key: CURRENCY_SYMBOL_KEY, value: currencySymbol)
                    
                    completion(true, false, false)
                }

            } else{
                self.alertMessage = response[ERROR_KEY]["message"].stringValue
                if (self.alertMessage == nil) {
                    self.alertMessage = response[ERROR_KEY].stringValue
                }
                completion(false, false, false)
            }
        
        }
     }
    
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   NOV, 20 2017
    // Input Parameters :   N/A.
    // Purpose          :   Facebook Login.
    //>---------------------------------------------------------------------------------------------------
    
   func loginUserWithFacebook(completion: @escaping (_ message: String, _ success: Bool)->Void) {
    
    if Singleton.instance.fbGender == "male" {
        self.gender = "m"
    } else {
        self.gender = "f"
    }
    
    var parameterDict = [String: String]()
    if Singleton.instance.fbEmail == nil {
        
        parameterDict = [
            FACEBOOK_ID_KEY: Singleton.instance.fbId,
            FIRST_NAME_KEY: Singleton.instance.fbfirstName,
            LAST_NAME_KEY: Singleton.instance.fblastName,
            GENDER_KEY: self.gender,
            IMAGE_URL_KEY: Singleton.instance.fbImage,
            VERIFIED_KEY: Singleton.instance.fbVerified
        ]
        
    } else {
        
        parameterDict = [
            FACEBOOK_ID_KEY: Singleton.instance.fbId,
            FIRST_NAME_KEY: Singleton.instance.fbfirstName,
            LAST_NAME_KEY: Singleton.instance.fblastName,
            EMAIL_KEY: Singleton.instance.fbEmail,
            GENDER_KEY: self.gender,
            IMAGE_URL_KEY: Singleton.instance.fbImage,
            VERIFIED_KEY: Singleton.instance.fbVerified
        ]
    }
    
    
   
    
    authServiceObject.synPostMethod(url: BASE_URL_KEY + FACEBOOK_SIGN, parameter: parameterDict, header: HEADER) { (success, response) in
        
        if success {
            print(response)
            if response[SUCCESS_KEY].boolValue {
                
                if response["data"]["isValidLogin"].boolValue {
                    
                    self.token = response[DATA_KEY][TOKEN_KEY].stringValue
                    let profileImageUrl = response[DATA_KEY][USER_KEY][PROFILE_URL_KEY].stringValue
                    let userRole = response[DATA_KEY][USER_KEY][USER_ROLE_KEY].stringValue
                    let userName = response[DATA_KEY][USER_KEY][FULL_NAME_KEY].stringValue
                    let userRegisterEmail = response[DATA_KEY][USER_KEY][EMAIL_KEY].stringValue
                    let userId = response[DATA_KEY][USER_KEY][ID_KEY].stringValue
                    let hasProfile = response[DATA_KEY][USER_KEY][HAS_PROFILE_KEY].boolValue
                    self.profileSelected = response[DATA_KEY][USER_KEY][PROFILE_SELECTED_KEY].boolValue
                    Singleton.instance.fbEmailIsVerified = response[DATA_KEY][USER_KEY]["isEmailAddressVerified"].boolValue
                    self.isFacebookEmailIsVerified = response["data"]["user"]["isEmailAddressVerified"].boolValue
                    
                    Helper.saveUserDefaultValue(key: ID_KEY, value: userId as String)
                    Helper.saveUserDefaultValue(key: PROFILE_URL_KEY, value: profileImageUrl as String)
                    Helper.saveUserDefaultValue(key: USER_ROLE_KEY, value: userRole as String)
                    Helper.saveUserDefaultValue(key: FULL_NAME_KEY, value: userName as String)
                    Helper.saveUserDefaultValue(key: EMAIL_KEY, value: userRegisterEmail as String)
                    Helper.saveUserDefaultValue(key: TOKEN_KEY, value: self.token as String)
                    Helper.saveUserDefaultValue(key: GUEST_KEY, value: "0")
                    Helper.saveUserDefaultValue(key: HAS_PROFILE_KEY, value: hasProfile as Bool )
                    
                    
                } else {
                    
                    print(response)
                    let facebookId = response["data"]["facebookId"].stringValue
                    
                    Singleton.instance.fbEmailIsVerified = response[DATA_KEY][USER_KEY]["isEmailAddressVerified"].boolValue
                    
                    self.facebookFirstUser = true
                    Helper.saveUserDefaultValue(key: "fbIdKey", value: facebookId as String)
                    
                }
                
                completion("", true)
            }
        }else{
            
            self.alertMessage = response[ERROR_KEY]["message"].stringValue
            if (self.alertMessage == nil) {
                self.alertMessage = response[ERROR_KEY].stringValue
            }
            
            completion(self.alertMessage, false)
        }
    }
 }
    
    
    func guestLoginUser(completion: @escaping (_ success: Bool)->Void) {
            authServiceObject.synGetMethod(url: BASE_URL_KEY + GUEST_LOGIN_KEY, header: HEADER) { (success, response) in
            if success {
                self.token = response[DATA_KEY][TOKEN_KEY].stringValue
                //For Guest login it will be "1" and rest login it will be "0"
                Helper.saveUserDefaultValue(key: GUEST_KEY, value: "1")
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

