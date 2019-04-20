//
//  MyWishlistModel.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 19/03/18.
//  Copyright © 2018 Cynoteck. All rights reserved.
//

import UIKit
import SwiftyJSON

class MyWishlistModel: NSObject {

    let authServiceObj: AuthServices = AuthServices()
    var commonRecipeArray = [JSON]()
    var alertMessage : String!
    var hireCook = [JSON]()
    var orderRecipe = [JSON]()
    
    
    override init() {
        alertMessage = ""
    }
    
    func getfavoriteRecipe(completion: @escaping (_ success: Bool)->Void) {
        
        authServiceObj.synGetMethod(url:  BASE_URL_KEY + "auth/recipe/wishlist", header: Helper.headerWithToken(token: Helper.getUserDefault(key: TOKEN_KEY)!)) { (success, response) in
            
            print(response)
            if success {
                self.orderRecipe = response[DATA_KEY].arrayValue
                
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
    
    func getfavoriteCook(completion: @escaping (_ success: Bool)->Void) {
        
        //http://192.168.5.126:8081/api/auth/profile/wishlist
        
        authServiceObj.synGetMethod(url:  BASE_URL_KEY + "auth/profile/wishlist", header: Helper.headerWithToken(token: Helper.getUserDefault(key: TOKEN_KEY)!)) { (success, response) in
            
            print(response)
            if success {
                self.orderRecipe = response[DATA_KEY].arrayValue
                
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
    
    
    func deleteRecipeFromWishlist(id: String, isCook: Bool ,completion: @escaping (_ success: Bool)->Void) {
        
        var url = String()
        if isCook {
            url = BASE_URL_KEY + "auth/profile/wishlist/" + id
        } else {
            url = BASE_URL_KEY + "auth/recipe/wishlist/" + id
        }
        
        authServiceObj.syndeleteMethod(url: url, header: Helper.headerWithToken(token: Helper.getUserDefault(key: TOKEN_KEY)!)) { (success, response) in
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
