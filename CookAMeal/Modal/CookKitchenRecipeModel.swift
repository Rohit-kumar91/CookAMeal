//
//  CookKitchenRecipeModel.swift
//  CookAMeal
//
//  Created by Cynoteck on 06/07/18.
//  Copyright © 2018 Cynoteck. All rights reserved.
//

import UIKit
import SwiftyJSON

class CookKitchenRecipeModel: NSObject {
    
    let authServiceObj: AuthServices = AuthServices()
    var alertMessage : String!
    
    
    override init() {
        alertMessage = ""
    }
    
    func kitchenData(cookId: String, completion: @escaping (_ success: Bool)->Void) {
        
        //http://192.168.5.126:8081/api/common/filter
        //auth/cook/all-recipes/:cookId
        
        authServiceObj.synGetMethod(url: BASE_URL_KEY + "auth/cook/all-recipes/" + cookId, header: Helper.headerWithToken(token: Helper.getUserDefault(key: TOKEN_KEY)!)) { (success, response) in
            
            if success {
                print(response)
                Singleton.instance.kitchenData = response["data"]["Recipes"].arrayValue
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
