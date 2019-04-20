//
//  CookRecipeModel.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 02/02/18.
//  Copyright © 2018 Cynoteck. All rights reserved.
//

import UIKit
import SwiftyJSON

class CookRecipeModel: NSObject {
    
    let authServiceObj: AuthServices = AuthServices()
    var recipeArray =  [JSON]()
    var alertMessage : String!

    
    override init() {
        alertMessage = ""
    }
    
    func getCookRecipe(completion: @escaping (_ success: Bool)->Void) {
        
        authServiceObj.synGetMethod(url:  BASE_URL_KEY + "cook/recipe/my-recipes", header: Helper.headerWithToken(token: Helper.getUserDefault(key: TOKEN_KEY)!)) { (success, response) in
            
            print(response)
            if success {
                self.recipeArray = response[DATA_KEY].arrayValue
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
    
    
    func deleteRecipeFromCookKitchen(id: String, completion: @escaping (_ success: Bool)->Void) {
        
        authServiceObj.syndeleteMethod(url: BASE_URL_KEY + "cook/recipe/" + id, header: Helper.headerWithToken(token: Helper.getUserDefault(key: TOKEN_KEY)!)) { (success, response) in
            print(response)
            if success {
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
}
