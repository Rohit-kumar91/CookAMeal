//
//  FavourateModel.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 14/12/17.
//  Copyright © 2017 Cynoteck. All rights reserved.
//

import UIKit
import SwiftyJSON

class FavourateModel: NSObject {
    
    let authServiceObject:AuthServices = AuthServices()
    var favorite: Bool!
    
    func favourateRecipeData(recipeId: String, completion: @escaping (_ success: Bool)->Void) {
        let parameterDict = [
            RECIPE_ID_KEY: recipeId
        ]
        
        authServiceObject.synPostMethod(url: BASE_URL_KEY + key_Favorite_Recipe, parameter: parameterDict, header: Helper.headerWithToken(token: Helper.getUserDefault(key: TOKEN_KEY)!)) { (success, response) in
            
            if success {
                self.favorite = response[DATA_KEY][FAVORITE_KEY].boolValue
                completion(true)
            }else {
                completion(false)
            }
        }
    }
}
