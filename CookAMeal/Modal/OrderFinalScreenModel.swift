//
//  OrderFinalScreenModel.swift
//  CookAMeal
//
//  Created by CYNOMAC001 on 12/04/18.
//  Copyright © 2018 Cynoteck. All rights reserved.
//

import UIKit
import SwiftyJSON

class OrderFinalScreenModel: NSObject {

    let authServiceObj:AuthServices = AuthServices()
    var alertMessage :String!
    var clientToken = String()
    var paymentResponse = JSON()
    var statusCode = String()
    var cookData = JSON()
        
    
    override init() {
        alertMessage = ""
    }
    
    func getPaymentNounce(id: String, orderType: String, completion: @escaping (_ success: Bool)->Void){
        
        let param = [
            "orderType" : orderType,
            "id" : id
        ]
        
        
        authServiceObj.synPostMethod(url: BASE_URL_KEY + "common/order/client-token", parameter: param, header: Helper.headerWithToken(token: Helper.getUserDefault(key: TOKEN_KEY)!)) { (success, response) in
            if success {
                self.clientToken =  response[DATA_KEY]["token"].stringValue
                completion(true)
            } else {
                self.alertMessage = response[ERROR_KEY]["message"].stringValue
                if (self.alertMessage == nil) {
                    self.alertMessage = response[ERROR_KEY].stringValue
                }
                completion(false)
            }
        }
        
        /*
        authServiceObj.synGetMethod(url: BASE_URL_KEY + "common/order/client-token/" + orderType + "/" + id, header: Helper.headerWithToken(token: Helper.getUserDefault(key: TOKEN_KEY)!)) { (success, response) in
            print(response)
            if success {
                self.clientToken =  response[DATA_KEY]["token"].stringValue
                completion(true)
            } else {
                self.alertMessage = response[ERROR_KEY]["message"].stringValue
                if (self.alertMessage == nil) {
                    self.alertMessage = response[ERROR_KEY].stringValue
                }
                completion(false)
            }
        } */
    }
    
    
    
    func submitOrderToMakePayment(isHire: Bool, paymentNounce: String, orderType: Bool, completeDetails: [String: Any], completion: @escaping (_ success: Bool)->Void) {
        
        print(completeDetails)
        
        var parameter = [String: Any]()
        var specialInstruction = String()
        var paymentUrl = String()
        var paymentType = String()
        var deliverAddress = String()
        var deliveryType = String()
        var pickUpTime = String()
        var chargeAmount = String()
        var cookId = String()
        var eventId = String()
        var startDateTime = String()
        var endDateTime = String()

        
        let header: [String: String] = [
            AUTHORIZATION_KEY : Helper.getUserDefault(key: TOKEN_KEY)!
        ]
        
        print(completeDetails)
        paymentType = completeDetails["paymentType"] as! String
        deliverAddress = completeDetails[ID_KEY] as! String
        chargeAmount = completeDetails["chargeAmount"] as! String
        deliveryType = completeDetails["deliveryType"] as! String
       
       

        //2018-04-17T10:43:00.000Z
        
        if orderType {
            
            if isHire {
                
                endDateTime = completeDetails["endTime"] as! String
                startDateTime = completeDetails["startTime"] as! String
                eventId = completeDetails["eventId"] as! String
                cookId = completeDetails["cookId"] as! String
                
                let arrayRecipe = completeDetails["recipeId"] as! NSArray
                let dictRecipie = arrayRecipe[0] as! [String:Any]
                print(dictRecipie["recipeId"] as! String )
                
                if arrayRecipe.count == 1 {
                    paymentUrl = "auth/order/direct/hire-cook"
                    parameter = [
                        "nonce": paymentNounce,
                        "chargeAmount": chargeAmount,
                        "recipeId": dictRecipie["recipeId"] as! String,
                        "recipes" : completeDetails["recipeId"]!,
                        "paymentType" : paymentType ,
                        "deliveryAddress": deliverAddress,
                        "deliveryType": deliveryType,
                        "eventId" : eventId,
                        "startDateTime" : dateTime(date: startDateTime, isHire: true),
                        "endDateTime" : dateTime(date: endDateTime, isHire: true),
                        "cookId" : cookId
                    ]
                    
                } else {
                    paymentUrl = "auth/order/multiple/hire-cook"
                    cookId = completeDetails["cookId"] as! String
                   
                    print(parameter)
                    
                    parameter = [
                        "nonce": paymentNounce,
                        "chargeAmount": chargeAmount,
                        "cookId" : cookId,
                        "recipeId": "",
                        "recipes" : completeDetails["recipeId"]!,
                        "paymentType" : paymentType ,
                        "deliveryAddress": deliverAddress,
                        "deliveryType": deliveryType,
                        "eventId" : eventId,
                        "startDateTime" : dateTime(date: startDateTime, isHire: true),
                        "endDateTime" : dateTime(date: endDateTime,  isHire: true),
                        
                    ]
                }
                
                print(parameter)
                
            } else {
                
                paymentUrl = "auth/order/create-purchase-recipe"
                specialInstruction = completeDetails["specialInstruction"] as! String
                pickUpTime = dateTime(date: completeDetails["pickUpBy"] as! String, isHire: false)

                let spiceLevel = completeDetails["spiceLevel"]!
                let recipes = completeDetails["recipeId"]!
                let noOfServing = completeDetails["noOfServing"]!
                let spiceLevelArr = (noOfServing as AnyObject).components(separatedBy: " ")
                
                parameter = [
                    "nonce": paymentNounce,
                    "chargeAmount": chargeAmount,
                    "recipeId" : recipes,
                    "noOfServing" : spiceLevelArr[0],
                    "spiceLevel" : spiceLevel,
                    "paymentType": paymentType ,
                    "deliveryAddress": deliverAddress,
                    "specialInstruction": specialInstruction,
                    "deliveryType": deliveryType,
                    "pickUpTime": dateTime(date: pickUpTime, isHire: false),   //"2018-04-16T11:18:00Z"
                ]
                
            }
            
        } else {
            
            paymentUrl = "auth/order/create-purchase-cart"
            let cartID = completeDetails["cartId"]!
            let cookId =  completeDetails["cookId"]!
            specialInstruction = completeDetails["specialInstruction"] as! String
            pickUpTime = dateTime(date: completeDetails["pickUpBy"] as! String, isHire: false)
            
            parameter = [
                "nonce": paymentNounce,
                "chargeAmount": chargeAmount,
                "paymentType": paymentType ,
                "deliveryAddress": deliverAddress,
                "cartId": cartID,         //Recipe Id
                "specialInstruction": specialInstruction ,
                "deliveryType": deliveryType ,
                "pickUpTime": dateTime(date: pickUpTime, isHire: false),
                "cookId" : cookId
            ]
            
        }
        
        
        print(parameter)
        authServiceObj.synPostMethod(url: BASE_URL_KEY + paymentUrl, parameter: parameter, header: header) { (success, response) in
            print(response)
            if success {
                self.paymentResponse =  response[DATA_KEY]
                self.statusCode =  response["status"].stringValue
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
    
    
    
    func getCookData(cookId: String, completion: @escaping (_ success: Bool)->Void){
        
        let header: [String: String] = [
            AUTHORIZATION_KEY : Helper.getUserDefault(key: TOKEN_KEY)!
        ]
        
        print(BASE_URL_KEY + "common/order/cook-address/" + cookId)
        
        authServiceObj.synGetMethod(url: BASE_URL_KEY + "common/order/cook-address/" + cookId, header: header) { (success, response) in
            print(response)
            if success {
                self.cookData = response[DATA_KEY]
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
    
    
    func dateTime(date: String, isHire: Bool)  -> String{
        
        let dateFormatter = DateFormatter()
        var localTimeZoneAbbreviation: String { return TimeZone.current.abbreviation() ?? "" }
        dateFormatter.dateFormat = "MMM d,yyyy hh:mm a"   //MMM d,yyyy HH:mm a    //yyyy-MM-dd HH:mm a
        
        if isHire {
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        } else {
            dateFormatter.dateFormat = "MMM d,yyyy hh:mm a"
        }
        
        dateFormatter.timeZone = NSTimeZone(name: localTimeZoneAbbreviation) as TimeZone?
        
        let finaldatetime : Date? = dateFormatter.date(from: date)
        
        // finaldatetime = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"  // yyyy-MM-dd'T'HH:mm:ss.SSSZ
        dateFormatter.timeZone = NSTimeZone.local
        
        if let finalDate = finaldatetime {
            let date = dateFormatter.string(from: finalDate)
            return date
        } else {
            return date
        }
    }
    
    
    
    
    /*
     func dateTime(date: String) -> String {
     let dateFormatter = DateFormatter()
     var localTimeZoneAbbreviation: String { return TimeZone.current.abbreviation() ?? "" }
     dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
     dateFormatter.timeZone = NSTimeZone(name: localTimeZoneAbbreviation) as TimeZone?
     
     var finaldatetime : Date? = dateFormatter.date(from: date)
     
     // finaldatetime = dateFormatter.date(from: date)
     dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"  // yyyy-MM-dd'T'HH:mm:ss.SSSZ
     dateFormatter.timeZone = NSTimeZone.local
     
     if let finalDate = finaldatetime {
     let date = dateFormatter.string(from: finalDate)
     return date
     } else {
     return date
     }
     }
     
     
     
     
     
     
     
     
     let dateTime = date
     print(dateTime)
     let dateFormatter = DateFormatter()
     var localTimeZoneAbbreviation: String { return TimeZone.current.abbreviation() ?? "" }
     dateFormatter.dateFormat = "MMM d,yyyy hh:mm a"
     dateFormatter.timeZone = NSTimeZone(name: localTimeZoneAbbreviation) as TimeZone?
     let finaldatetime = dateFormatter.date(from: dateTime)
     
     //yyyy-MM-dd'T'HH:mm:ss.SSSZ
     //old-yyyy-MM-dd'T'HH:mm:ss'Z'
     dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"//"yyyy-MM-dd'T'HH:mm:ss'Z'.ZZZ"
     return dateFormatter.string(from: finaldatetime!)
     
     
     */
    
    
    
}
