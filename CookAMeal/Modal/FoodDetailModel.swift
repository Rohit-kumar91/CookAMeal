//
//  FoodDetailModel.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 12/12/17.
//  Copyright © 2017 Cynoteck. All rights reserved.
//

import UIKit
import SwiftyJSON

class FoodDetailModel: NSObject {
    

    var alertMessage: String!
    var statusCode: String!
    let authServiceObj:AuthServices = AuthServices()
    var imageArray = [JSON]()
    var recipeDetailData = [String: JSON]()
    var cookRecipeData = [JSON]()
    var similarRecipeData = [JSON]()
    var ingredientArray = [JSON]()
    var rating:Float!
    var favorite:Bool!
    var details = [[String: Any]]()
    var tableviewArrayCount:Int!
    var cookName: String!
    var preperationMethod = [JSON]()
    var availableServing = String()
    var profile = [String: JSON]()
    var cookId  =  String()
    var recipeId = String()
    
    var preparationTime = String()
    var cookTime = String()
    var serve = String()
    var foodType = String()
    
    
    var firstFiveIngredient = [JSON]()
    var orderOfServing = [Int]()
    var jSONCheck: Bool!
    var totalDaily = [String : JSON]()
    
    override init() {
        alertMessage = ""
    }
    
    func getFoodDetailData(recipeId: String, completion: @escaping (_ success: Bool)->Void) {
        
        let header: [String: String] = [
            AUTHORIZATION_KEY : Helper.getUserDefault(key: TOKEN_KEY)!
        ]
        
        let latitude = String(currentLocationLatitude)
        let longitude = String(currentLocationLongitute)
        let country = Helper.getUserDefaultValue(key: "CountryName")!
        let countryTrimmedString = country.replacingOccurrences(of: " ", with: "")
        
        authServiceObj.synGetMethod(url: BASE_URL_KEY + "common/recipe/" + recipeId + "/lat/" + latitude + "/long/" + longitude + "/unit/" + countryTrimmedString + "/filter/" + "5" , header: header) { (success, response) in
            
            print(response)
            
            if success {
                
                if response[DATA_KEY].null != NSNull() {
                    
                    self.jSONCheck = false
                    self.favorite = response[DATA_KEY]["recipeDetails"]["favorite"].boolValue
                    self.cookId = response[DATA_KEY]["profile"][ID_KEY].stringValue
                    self.recipeDetailData = response[DATA_KEY]["recipeDetails"].dictionaryValue
                    self.imageArray = response[DATA_KEY]["recipeDetails"]["MediaObjects"].arrayValue
                    self.cookRecipeData = response[DATA_KEY]["cookRecipes"].arrayValue
                    self.similarRecipeData = response[DATA_KEY]["similarRecipes"].arrayValue
                    self.ingredientArray =  response[DATA_KEY]["recipeDetails"]["Ingredients"].arrayValue
                    self.preperationMethod = response[DATA_KEY]["recipeDetails"]["PreparationMethods"].arrayValue
                    self.foodType = response[DATA_KEY]["recipeDetails"]["foodType"].stringValue
                    self.availableServing =  response[DATA_KEY]["recipeDetails"]["availableServings"].stringValue
                    self.profile = response[DATA_KEY][PROFILE_KEY].dictionaryValue
                    self.recipeId = response[DATA_KEY]["recipeDetails"]["id"].stringValue
                    self.preparationTime = response[DATA_KEY]["recipeDetails"]["preparationTimeInMinute"].stringValue
                    self.cookTime = response[DATA_KEY]["recipeDetails"]["cookTimeInMinute"].stringValue
                    self.serve = response[DATA_KEY]["recipeDetails"]["serve"].stringValue
                    
                    
                    //getting details part
                    let recipeAvailable =  response[DATA_KEY]["recipeDetails"]["availableServings"].stringValue
                    let calories = "1665"
                    let orderDate = response[DATA_KEY]["recipeDetails"]["orderByDateTime"].stringValue
                    let cost =  response[DATA_KEY]["recipeDetails"]["currencySymbol"].stringValue + " " +  response[DATA_KEY]["recipeDetails"]["costPerServing"].stringValue
                    //Helper.getUserDefaultValue(key: CURRENCY_SYMBOL_KEY)! + " " +
                    
                    if response[DATA_KEY]["recipeDetails"]["availableServings"].intValue != 0 {
                        let servingCount = 1...response[DATA_KEY]["recipeDetails"]["availableServings"].intValue
                        self.orderOfServing = [Int](servingCount)
                    }
                    
                    
                    if  Helper.getUserDefaultValue(key: "orderType")! == "1" {
                        //Hire Cook
                        self.details.append(["typeText" : "30", "imagetype": #imageLiteral(resourceName: "avaliable_icon"), "type": "Minutes"])
                        self.details.append(["typeText" : calories, "imagetype": #imageLiteral(resourceName: "calories_icon"), "type": "Calories"])
                        
                    } else {
                        //Order Food
                        
                        
                        self.details.append(["typeText" : recipeAvailable, "imagetype": #imageLiteral(resourceName: "avaliable_icon"), "type": "Available"])
                        self.details.append(["typeText" : calories, "imagetype": #imageLiteral(resourceName: "calories_icon"), "type": "Calories"])
                        self.details.append(["typeText" : Helper.getDate(date: orderDate), "imagetype": #imageLiteral(resourceName: "order_icon"), "type": "Order By:"])
                        self.details.append(["typeText" : cost , "imagetype": #imageLiteral(resourceName: "price_icon"), "type": "Serving"])
                    }
                    
                   
                    
                    
                    //if the similar And Cook Recipe Is Empty.
                    if self.cookRecipeData.count == 0 && self.similarRecipeData.count == 0 {
                        
                        self.tableviewArrayCount = 6
                        
                    } else if self.cookRecipeData.count == 0 &&  self.similarRecipeData.count != 0 {
                        
                        self.tableviewArrayCount = 7
                        self.cookRecipeData = self.similarRecipeData
                        self.cookName = "Similar Items"
                        
                    } else  if self.cookRecipeData.count != 0 &&  self.similarRecipeData.count == 0 {
                        
                        self.tableviewArrayCount = 7
                        self.cookName =  self.profile[FIRST_NAME_KEY]!.stringValue
                        
                    } else {
                        
                        self.cookName =  self.profile[FIRST_NAME_KEY]!.stringValue
                        self.tableviewArrayCount = 8
                    }
                    
                    
                    print(self.ingredientArray)
                    //ingredient Part
                    for (index, value) in self.ingredientArray.enumerated() where index < 1 {
                        print(index)
                        self.firstFiveIngredient.append(value)
                    }
                    
                } else {
                    print("JSON is null.")
                    self.jSONCheck = true
                }
                
                completion(true)
                
            } else{
                print(response)
                self.alertMessage = response[ERROR_KEY]["message"].stringValue
                if (self.alertMessage == nil) {
                    self.alertMessage = response[ERROR_KEY].stringValue
                }
    
                completion(false)
            }
        }
    }
    
    
    
    func addToCart(recipeId: String, numberOfServing: String, completion: @escaping (_ success: Bool)->Void) {
        
        let header: [String: String] = [
            AUTHORIZATION_KEY : Helper.getUserDefault(key: TOKEN_KEY)!
        ]
        
        
        let parameter: [String: String] = [
            "recipeId": recipeId,
            "noOfServing": numberOfServing
        ]
        
        authServiceObj.synPostMethod(url: BASE_URL_KEY + "auth/cart/recipe", parameter: parameter, header: header) { (success, response) in
            print(response)
            if success {
               completion(true)
            } else{
                self.alertMessage = response[ERROR_KEY]["message"].stringValue
                if (self.alertMessage == nil) {
                    self.alertMessage = response[ERROR_KEY].stringValue
                }
                self.statusCode = response["status"].stringValue
                completion(false)
            }
        }
    }
    
    
    
    
    
    //Food Nutrition Data
    func getNutritionData(completion: @escaping (_ success: Bool)->Void) {
        
        var ingredientNutriArray = [String]()
        for (index, _) in self.ingredientArray.enumerated(){
            
            let qty = self.ingredientArray[index]["qty"].stringValue
            let sortName = self.ingredientArray[index]["Unit"]["sortName"].stringValue
            let name = self.ingredientArray[index]["name"].stringValue
            let combineStr = qty + " " + sortName + " " + name
            ingredientNutriArray.append(combineStr)
            
        }
        
        let parameterDict : [String: Any] = [
            "title": recipeDetailData["dishName"]!.stringValue,
            //"prep": preperationMethod,
            "yield": "About " + self.availableServing + " " + "servings" ,
            "ingr": ingredientNutriArray
        ]
        
        
        print(parameterDict)
        authServiceObj.synPostMethod(url: Edamam_GetNutrition_url, parameter: parameterDict , header: HEADER) { (success, response) in

            if response.null != NSNull() {
                print(response)
                self.totalDaily = response["totalDaily"].dictionaryValue
                completion(true)
            }else {
                print("Error in getting the recipe nutrition data.")
                completion(false)
            }
        }
    }
}





