//
//  OrderModel.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 29/11/17.
//  Copyright © 2017 Cynoteck. All rights reserved.
//

import UIKit
import SwiftyJSON

class OrderModel: NSObject {

    let authServiceObj: AuthServices = AuthServices()
    var categoryId = String()
    var categoryName = String()
    var recipeArray = [JSON]()
    
    var recipeCategoryName = [[String: JSON]]()
    var recipeCategoryData = [JSON]()
    var alertMessage: String!
    
    func getOrderData(orderType: String, completion: @escaping (_ success: Bool)->Void) {
        
        let header: [String: String] = [
            AUTHORIZATION_KEY : Helper.getUserDefault(key: TOKEN_KEY)!
        ]
        
        ///lat/30.3631352/long/78.063471
       
        
        if let country = Helper.getUserDefaultValue(key: "CountryName") {
            
            let latitude = String(currentLocationLatitude)
            let longitude = String(currentLocationLongitute)
            let countryTrimmedString = country.replacingOccurrences(of: " ", with: "")
            
            
            print(header)
            print( BASE_URL_KEY + COMMON_CATEGORY + "/" + categoryId + "/sub-category/recipe-list/" +  orderType + "/lat/" + latitude + "/long/" + longitude + "/unit/" + countryTrimmedString + "/filter/" + "5")
            
            authServiceObj.synGetMethod(url: BASE_URL_KEY + COMMON_CATEGORY + "/" + categoryId + "/sub-category/recipe-list/" +  orderType + "/lat/" + latitude + "/long/" + longitude + "/unit/" + countryTrimmedString + "/filter/" + "5", header: header) { (success, response) in
                
                
               
                print(response)
                if success {
                    
                    self.recipeArray.removeAll()
                    self.recipeCategoryData.removeAll()
                    self.recipeCategoryName.removeAll()
                    self.recipeArray = response[DATA_KEY].arrayValue
                    
                    
                    
                    for element in self.recipeArray {
                        
                        if !(element["Recipes"].count == 0) {
                            let tempRecipeCategory = ["name": element["name"], ID_KEY: element[ID_KEY]]
                            self.recipeCategoryName.append(tempRecipeCategory)
                            self.recipeCategoryData.append(element["Recipes"])
                        }
                    }
                    
                    completion(true)
                    
                } else{
                    self.alertMessage = response[ERROR_KEY]["message"].stringValue
                    if (self.alertMessage == nil) {
                        self.alertMessage = response[ERROR_KEY].stringValue
                    }
                    completion(false)
                }
            }
        } else {
             self.alertMessage = "Your location cannot be fetch, go to your setting and enable location services."
             completion(false)
        }
        

    }
    
}
