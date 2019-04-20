//
//  IngredientsModel.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 01/12/17.
//  Copyright © 2017 Cynoteck. All rights reserved.
//

import UIKit
import SwiftyJSON

class IngredientsModel: NSObject {
    
    
    let authServiceObject:AuthServices = AuthServices()
    var allergiesArray = [JSON]()
    var allergiesNameArray = [String]()
    var alertMessage: String!
    
    var ingredientUnitArray = [JSON]()
    var ingredientNameArray = [String]()
    var tempAllergies = [[String: String]]()
    
    var ingredientArray = [["name": "","qty": "","unitId": "","cost": "0", "sortName": ""],
                           ["name": "","qty": "","unitId": "","cost": "0", "sortName": ""]
                           ]
    
    
      override init() {
        alertMessage = ""
    }

    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 30 2017
    // Input Parameters :   N/A.
    // Purpose          :   get all allergies name and id from server.
    //>--------------------------------------------------------------------------------------------------
    
    func getAllergies(completion: @escaping (_ success: Bool)->Void) {
        
        let header: [String: String] = [
            AUTHORIZATION_KEY : Helper.getUserDefault(key: TOKEN_KEY)!
        ]
        
        
        authServiceObject.synGetMethod(url:  BASE_URL_KEY + "auth/allergy", header: header) { (success, response) in
            
            if success {
                self.allergiesArray = response[DATA_KEY].arrayValue
                for elements in self.allergiesArray {
                
                    let  allergyTemp = [
                        "name" : elements["name"].stringValue,
                        ID_KEY : elements[ID_KEY].stringValue,
                        "selected" : "0"
                    ]
                    
                    print(Singleton.instance.ingredientAllergiesArray)
                    self.tempAllergies.append(allergyTemp)
                    print( self.tempAllergies)
                   // Singleton.instance.ingredientAllergiesArray.append(allergyTemp)
                   
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
    
    
    
    
    
    func getIngredientUnits(completion: @escaping (_ success: Bool)->Void) {
        
        let header: [String: String] = [
            AUTHORIZATION_KEY : Helper.getUserDefault(key: TOKEN_KEY)!
        ]
        
        authServiceObject.synGetMethod(url: BASE_URL_KEY + "auth/unit", header: header) { (success, response) in
            
            if success {
                print(response)
                self.ingredientUnitArray = response[DATA_KEY].arrayValue
                
                for elements in self.ingredientUnitArray {
                   self.ingredientNameArray.append(elements["unitName"].stringValue)
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
    
    
    
    func deleteIngredientMethod(ingredientsId: String, recipeId: String, completion: @escaping (_ success: Bool)->Void) {
        
        let header: [String: String] = [
            AUTHORIZATION_KEY : Helper.getUserDefault(key: TOKEN_KEY)!
        ]
        
        //http://192.168.5.126:8081/api/cook/recipe/:recipeId/ingredients/ (idea) ngredientId
        let url = BASE_URL_KEY + "cook/recipe/" + recipeId + "/ingredients/" +  ingredientsId
        print(url)
        
        authServiceObject.syndeleteMethod(url: url, header: header) { (success, response) in
            
            print(response)
            if success {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
}
