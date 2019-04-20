//
//  ProfileModel.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 18/12/17.
//  Copyright © 2017 Cynoteck. All rights reserved.
//

import UIKit
import SwiftyJSON


class ProfileModel: NSObject {
    
    let authServiceObj:AuthServices = AuthServices()
    var profileDetailData = JSON()
    var recipeCategoryName = [String]()
    var totalTableViewIndex = Int()
    var recipesArrayValues = [[JSON]]()
    var fovouriteCheck = Bool()
    var alertMessage: String!
    
    
    override init() {
        alertMessage = ""
    }

    
    func getProfileData(profileId: String, completion: @escaping (_ success: Bool)->Void) {
        
       
        
        authServiceObj.synGetMethod(url:  BASE_URL_KEY + "common/cook-profile/" + profileId, header: Helper.headerWithToken(token: Helper.getUserDefault(key: TOKEN_KEY)!)) { (success, response) in
            print(response)
            
            if success {
                
                self.profileDetailData = response
                self.totalTableViewIndex = response[DATA_KEY]["recipes"].arrayValue.count + 3
                
                
                //getting the recipecategory name
                for (index, _) in response[DATA_KEY]["recipes"].arrayValue.enumerated() {
                    self.recipeCategoryName.append(response[DATA_KEY]["recipes"][index]["name"].stringValue)
                }
                
                //Recipes.
                for (index, _) in response[DATA_KEY]["recipes"].arrayValue.enumerated() {
                    self.recipesArrayValues.append(response[DATA_KEY]["recipes"][index]["Recipes"].arrayValue)
                }
                
                print(self.recipesArrayValues.count)
                completion(true)
                
            } else{
                completion(false)
            }
        }
    }
    
    
    func markFavorite(profileId: String, completion: @escaping (_ success: Bool)->Void) {
       
        
        let parameter = [
          "profileId": profileId
        ]
        authServiceObj.synPostMethod(url: BASE_URL_KEY + "auth/favorite/profile", parameter: parameter, header: Helper.headerWithToken(token: Helper.getUserDefault(key: TOKEN_KEY)!)) { (success, response) in
            if success {
                
                if response[DATA_KEY]["favorite"].boolValue {
                   self.fovouriteCheck = true
                } else {
                  self.fovouriteCheck = false
                }
                
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
