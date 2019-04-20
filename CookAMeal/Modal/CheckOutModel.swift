//
//  CheckOutModel.swift
//  CookAMeal
//
//  Created by Cynoteck on 19/06/18.
//  Copyright © 2018 Cynoteck. All rights reserved.
//

import UIKit
import SwiftyJSON

class CheckOutModel: NSObject {

    var recipeData = [JSON]()
    var fullName = String()
    var tax = String()
    var profileUrl = String()
    var alertMessage: String!
    var cookPrice = String()
    var totalPriceOfIngredients = 0.0
    
    let authServiceObj: AuthServices = AuthServices()
   
    override init() {
        alertMessage = ""
    }
   
    func getCookTimeAvailbility(recipes: [String: [[String: String]]], cookId: String, completion: @escaping (_ success: Bool)->Void) {
        
        
        authServiceObj.synPostMethod(url: BASE_URL_KEY + "auth/hire-cook/direct/check-out/" + cookId, parameter: recipes , header: Helper.headerWithToken(token: Helper.getUserDefault(key: TOKEN_KEY)!)) { (success, response) in
            if success {
                
                print(response)
                self.tax = response["data"]["tax"].stringValue
                self.fullName = response["data"]["fullName"].stringValue
                self.recipeData = response["data"]["Recipes"].arrayValue
                self.cookPrice = response["data"]["cookPrice"].stringValue
                self.profileUrl =  response["data"]["profileUrl"].stringValue
                self.totalPriceOfIngredients = response["data"]["totalPriceExcludedTaxAndCookPrice"].doubleValue
                
                for recipe in self.recipeData {
                    self.totalPriceOfIngredients = self.totalPriceOfIngredients + recipe["totalCostOfIngredients"].doubleValue
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
