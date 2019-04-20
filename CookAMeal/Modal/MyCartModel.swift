//
//  MyCartModel.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 06/03/18.
//  Copyright © 2018 Cynoteck. All rights reserved.
//

import UIKit
import SwiftyJSON


class MyCartModel: NSObject {
    
    let authServiceObj: AuthServices = AuthServices()
    var recipeArray = [JSON]()
    var cartDataArray = [[String: String]]()
    var alertMessage : String!
    var cartId = String()
    var totalPrice = String()
    var totalItem = String()
    var sections = [Section]()
    var cartDetailsItems = [[String : JSON]]()
    var responseData = [JSON]()
    var spiceLevelData = JSON()
    var noOfServing = JSON()
    var newJSONData = [JSON]()
    var cookId = String()
    var deleteJSON = JSON()
    var maxDeliveryFee = String()
    var statusCode = String()
    
    
    override init() {
        alertMessage = ""
    }
    
    func getCartRecipe(completion: @escaping (_ success: Bool)->Void) {
        
        authServiceObj.synGetMethod(url:  BASE_URL_KEY + "auth/cart/recipe", header: Helper.headerWithToken(token: Helper.getUserDefault(key: TOKEN_KEY)!)) { (success, response) in
            
            print(response)
            if success {
            
                self.responseData = response[DATA_KEY].arrayValue
                self.maxDeliveryFee = response[DATA_KEY][0]["maxDeliverFees"]["deliveryfees"].stringValue
                self.newJSONData.removeAll()
               
                
                //Create new temperory array.
                for (index, var response) in  self.responseData.enumerated() {
                    
                    for (cartIndex, var _) in response["CartItems"].enumerated(){
                        response["CartItems"][cartIndex]["recipeId"] = "0"
                    }
                    
                    //response["CartItems"][index]["recipeId"] = "0"
                    if index == 0 {
                        response["genderFull"] = "1"
                        self.newJSONData.append(response)
                    }else {
                         response["genderFull"] = "0"
                         self.newJSONData.append(response)
                    }
                }
 
                // Getting Price of selected cart
                for element in self.newJSONData {
                    if element["genderFull"].stringValue == "1"{
                        self.totalPrice = element["price"].stringValue
                        self.totalItem = element["item"].stringValue
                        self.cookId = element[ID_KEY].stringValue
                        self.cartId = element["cartId"].stringValue
                    }
                }
                

                
                //Make date for the section tableview.
                for (index,cart) in  self.newJSONData.enumerated() {
                    if index == 0 {
                        self.sections.append(Section(genre: cart["fullName"].stringValue,
                                                 profileImage: cart["profileUrl"].stringValue,
                                                 cartItemsData: cart["CartItems"].arrayValue,
                                                 radiocheck: cart["genderFull"].stringValue,
                                                 expanded: true))
                    } else{
                        self.sections.append(Section(genre: cart["fullName"].stringValue,
                                                     profileImage: cart["profileUrl"].stringValue,
                                                     cartItemsData: cart["CartItems"].arrayValue,
                                                     radiocheck: cart["genderFull"].stringValue,
                                                     expanded: true))
                    }
                }
                
                
                print(self.sections)
                
                completion(true)
            } else{
               
                 self.statusCode = response["status"].stringValue
                
                if self.statusCode == "200" {
                   
                    self.newJSONData = response["data"].arrayValue
                } else {
                    self.alertMessage = response[ERROR_KEY]["message"].stringValue
                    if (self.alertMessage == nil) {
                        self.alertMessage = response[ERROR_KEY].stringValue
                    }
                }
                
                
                completion(false)
            }
        }
    }
    
    
    
    func deleteRecipeFromCart(id: String ,completion: @escaping (_ success: Bool)->Void) {
       
        
        authServiceObj.syndeleteMethod(url:  BASE_URL_KEY + "auth/cart/" + id, header: Helper.headerWithToken(token: Helper.getUserDefault(key: TOKEN_KEY)!)) { (success, response) in
            print(response)
            if success {
                self.deleteJSON = response[DATA_KEY]
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
    


    func addServingLevel(cartId: String, recipeId: String, noOfServing: String, completion: @escaping (_ success: Bool)->Void) {
        
       
        
        let parameter = [
            "recipeId": recipeId,
            "noOfServing": noOfServing
        ]
        
        authServiceObj.synPutMethod(url: BASE_URL_KEY + "/auth/cart/serve/" + cartId, parameter: parameter, header: Helper.headerWithToken(token: Helper.getUserDefault(key: TOKEN_KEY)!)) { (success, response) in
            print(response)
            if success {
                self.noOfServing = response[DATA_KEY]["cartItem"]
                self.totalPrice = response[DATA_KEY]["cartItem"]["price"].stringValue
                
                print(self.totalPrice)
                completion(true)
            }else {
                self.alertMessage = response[ERROR_KEY]["message"].stringValue
                if (self.alertMessage == nil) {
                    self.alertMessage = response[ERROR_KEY].stringValue
                }
                completion(false)
            }
        }
    }
    
    
    func addSpiceLevel(cartId: String, recipeId: String, spiceLevel: String, completion: @escaping (_ success: Bool)->Void) {
        
        
        
        let parameter = [
            "recipeId": recipeId,
            "spiceLevel": spiceLevel
            
        ]
        
        
        authServiceObj.synPutMethod(url: BASE_URL_KEY + "/auth/cart/spice-level/" + cartId, parameter: parameter, header: Helper.headerWithToken(token: Helper.getUserDefault(key: TOKEN_KEY)!)) { (success, response) in
            print(response)
            if success {
                self.spiceLevelData = response[DATA_KEY]["cartItem"]
                completion(true)
            }else {
                self.alertMessage = response[ERROR_KEY]["message"].stringValue
                if (self.alertMessage == nil) {
                    self.alertMessage = response[ERROR_KEY].stringValue
                }
                completion(false)
            }
        }
    }
}
