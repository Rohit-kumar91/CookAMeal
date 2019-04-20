//
//  ReviewModel.swift
//  CookAMeal
//
//  Created by Cynoteck on 01/06/18.
//  Copyright © 2018 Cynoteck. All rights reserved.
//

import UIKit
import SwiftyJSON

class ReviewModel: NSObject {

    let authServiceObj: AuthServices = AuthServices()
    var reviewData = JSON()
    var alertMessage : String!
    var orderItemData = [[String : JSON]]()
    var comment = String()


    override init() {
        alertMessage = ""
    }

    
    func getReviewData(orderId: String, completion: @escaping (_ success: Bool)->Void) {
        authServiceObj.synGetMethod(url:  BASE_URL_KEY + "auth/order-data-for-review/" + orderId, header: Helper.headerWithToken(token: Helper.getUserDefault(key: TOKEN_KEY)!)) { (success, response) in
            if success {
                print(response)
                self.reviewData = response["data"]
                
                for orderItems in self.reviewData["orderedItems"].arrayValue {
                    
                    let id = orderItems["id"]
                    let dishName = orderItems["dishName"]
                    let imageUrl = orderItems["imageUrl"]
                    let recipeId = orderItems["recipeId"]
                    let tasteRating = JSON(0)
                    let quantityValue = JSON(0)
                    
                    let finalDict = [
                        "id" : id,
                        "dishName" : dishName,
                        "imageUrl" : imageUrl,
                        "recipeId" : recipeId,
                        "tasteRating" : tasteRating,
                        "quantityValue" : quantityValue
                        
                    ]
                    
                    self.orderItemData.append(finalDict)
                    
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
    
    
    
    func giveReviewToRecipe(orderId: String, completion: @escaping (_ success: Bool)->Void) {
        
        var tempArray = [[String: String]]()

        for orderData in orderItemData {

            let taste = orderData["tasteRating"]?.stringValue
            let value = orderData["quantityValue"]?.stringValue
            let recipeId = orderData["recipeId"]?.stringValue

            let dict  = [
                "taste" : taste! as String,
                "value" : value! as String,
                "recipeId" : recipeId! as String
            ]

            tempArray.append(dict)

        }
        
        let preprationJsonData = try? JSONSerialization.data(withJSONObject: tempArray, options: JSONSerialization.WritingOptions())
        let orderDetailArray = NSString(data: preprationJsonData!, encoding: String.Encoding.utf8.rawValue)
        
        let parameter = [
            "recipeDetails" : orderDetailArray! as String,
            "comments": comment,
            "orderId": orderId
        ]
        
        
        print("Parameter\(parameter)")
        
        authServiceObj.synPostMethod(url: BASE_URL_KEY + "auth/submit-review", parameter: parameter, header: Helper.headerWithToken(token: Helper.getUserDefault(key: TOKEN_KEY)!)) { (success, response) in
            if success {
                print(response)
                self.alertMessage = response["data"][MESSAGE_KEY].stringValue
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
