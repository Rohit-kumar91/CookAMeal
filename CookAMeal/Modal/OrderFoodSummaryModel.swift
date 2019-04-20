 //
//  OrderFoodSummaryModel.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 05/01/18.
//  Copyright © 2018 Cynoteck. All rights reserved.
//

import UIKit
import SwiftyJSON

class OrderFoodSummaryModel: NSObject {
    
    var recipeDetails = JSON()
    var deliveryFeeArray = [String]()
    var tax = String()
    var costPerServing = Float()
    var specialInstruction: String!
    var deliveryFee: String!
    var pickupBy: String!
    var alertMessage: String!
    let authServiceObj: AuthServices = AuthServices()
    var recipeId : String!
    var totalAmount: String!
    var count = Int()
    var cookId = String()
    var currencySymbol = String()
    
    var orderSummaryDataForCart = [JSON]()

    
    
    override init() {
        recipeId = ""
        specialInstruction = ""
        deliveryFee = ""
        pickupBy = ""
        costPerServing = 0.0
        alertMessage = ""
        totalAmount = ""
        currencySymbol = ""
    }
    
    
    
    
    func validateSpecialInstruction () -> Bool
    {
        var valid: Bool = true
        self.specialInstruction = self.specialInstruction.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if self.specialInstruction.isEmpty
        {
            valid = false
            self.alertMessage = "Special Instruction is empty."
        }
        
        return valid
    }
    
    
    
    func validateDeliveryFee () -> Bool
    {
        var valid: Bool = true
        
        if self.deliveryFee.isEmpty
        {
            valid = false
            self.alertMessage = "Delivery Fee is empty."
        }
        
        return valid
    }
    
    
    
    func validatePickupBy () -> Bool
    {
        var valid: Bool = true
        
        if self.pickupBy.isEmpty
        {
            valid = false
            self.alertMessage = "Pickup By is empty."
        }
        
        return valid
    }
    
    
    
    func getPrepareData(recipeId: String, completion: @escaping (_ success: Bool)->Void) {
        
        let header: [String: String] = [
            AUTHORIZATION_KEY : Helper.getUserDefault(key: TOKEN_KEY)!
        ]
        
        authServiceObj.synGetMethod(url: BASE_URL_KEY + key_Prepare_Order_Data + recipeId, header: header) { (success, response) in
            print(response)

            if success {
                
                print(response)
                self.recipeDetails = response[DATA_KEY]["RecipeDetails"]
                self.currencySymbol = self.recipeDetails["currencySymbol"].stringValue
                
                self.count = 1
                                self.deliveryFeeArray.append("Pickup-Free")
                self.deliveryFeeArray.append(response[DATA_KEY]["RecipeDetails"]["recipeData"]["deliveryFee"].stringValue) //"Delivery " + currencySymbol! +
                
                self.tax = response[DATA_KEY]["Tax"].stringValue
                self.costPerServing = response[DATA_KEY]["RecipeDetails"]["recipeData"]["costPerServing"].floatValue
                
                print(response[DATA_KEY]["RecipeDetails"]["cookProfile"][ID_KEY].stringValue)
                self.cookId =  response[DATA_KEY]["RecipeDetails"]["cookProfile"][ID_KEY].stringValue
                

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
    
    
    func getOrderSummaryCartData(cookId: String, completion: @escaping (_ success: Bool)->Void) {
        
        let header: [String: String] = [
            AUTHORIZATION_KEY : Helper.getUserDefault(key: TOKEN_KEY)!
        ]
        
        authServiceObj.synGetMethod(url: BASE_URL_KEY + "common/order/order-summary/cart/" + cookId, header: header) { (success, response) in
            
            print(response)
            if success {
                
                self.orderSummaryDataForCart = response[DATA_KEY].arrayValue
                self.count = response[DATA_KEY][0]["CartItems"].count
                self.currencySymbol = response[DATA_KEY][0]["currencySymbol"].stringValue
                print(self.currencySymbol)
                
                self.deliveryFeeArray.append("Pickup-Free")
                self.deliveryFeeArray.append(response[DATA_KEY][0]["maxDeliverFees"]["deliveryfees"].stringValue)
                
                self.tax = response[DATA_KEY][0]["tax"].stringValue
            
                
                
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
