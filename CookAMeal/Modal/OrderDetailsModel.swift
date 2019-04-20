//
//  OrderDetailsModel.swift
//  CookAMeal
//
//  Created by Cynoteck on 18/04/18.
//  Copyright © 2018 Cynoteck. All rights reserved.
//

import UIKit
import SwiftyJSON

class OrderDetailsModel: NSObject {
    
    let authServiceObj:AuthServices = AuthServices()
    var alertMessage: String!
    var orderData = JSON()
    var recipeArray = [JSON]()
    var approveOrderId = String()
    var url = String()
    
    var clientToken = String()
    
    var rePaymentData = JSON()

    func getOrderDetails(isNotification: Bool ,type: String, orderId: String, completion: @escaping (_ success: Bool)->Void) {
        
        if isNotification {
            url = BASE_URL_KEY + "auth/order-details/" + orderId + "/" + type
        } else {
            url = BASE_URL_KEY + "auth/my-order/" + orderId + "/" + type
        }
        
        print(url)
        authServiceObj.synGetMethod(url: url, header: Helper.headerWithToken(token: Helper.getUserDefault(key: TOKEN_KEY)!)) { (success, response) in
            print(response)
            if success {
                self.orderData = response[DATA_KEY]
                self.recipeArray = response[DATA_KEY]["recipeDetails"].arrayValue
                completion(true)
            } else {
                self.alertMessage = response["error"][MESSAGE_KEY].stringValue
                completion(false)
            }
        }
    }
    
    
    
    func approveOrder(orderType: String, orderId: String, completion: @escaping (_ success: Bool)->Void) {
       
        var url = String()
        
        if orderType == "0" {
            url = BASE_URL_KEY + "cook/accept-order/" + orderId
        } else {
            url = BASE_URL_KEY + "cook/hire/accept-order/" + orderId
        }
        
        let parameter = [
            "orderId": orderId
        ]
        
        authServiceObj.synPutMethod(url: url, parameter: parameter, header: Helper.headerWithToken(token: Helper.getUserDefault(key: TOKEN_KEY)!)) { (success, response) in
            print(response)
            if success {
                self.orderData = response[DATA_KEY]
                self.approveOrderId =  response[DATA_KEY]["orderDetails"]["id"].stringValue
                completion(true)
            } else {
                self.alertMessage = response["error"][MESSAGE_KEY].stringValue
                completion(false)
            }
        }
    }
    
    
    
    func receiveOrder(orderId: String, completion: @escaping (_ success: Bool)->Void) {
        let parameter = [
            "orderId": orderId
        ]
        
        //http://192.168.5.126:8081/api/auth/order-recive/:orderId
        
        
        
        authServiceObj.synPutMethod(url: BASE_URL_KEY + "auth/order-receive/" + orderId, parameter: parameter, header: Helper.headerWithToken(token: Helper.getUserDefault(key: TOKEN_KEY)!)) { (success, response) in
            print(response)
            if success {
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
    
    
    
    
    func deliveredOrder(orderId: String, completion: @escaping (_ success: Bool)->Void) {
        let parameter = [
            "orderId": orderId
        ]
        
        //http://192.168.5.126:8081/api/auth/order-recive/:orderId
        authServiceObj.synPutMethod(url: BASE_URL_KEY + "cook/order-delivery/" + orderId, parameter: parameter, header: Helper.headerWithToken(token: Helper.getUserDefault(key: TOKEN_KEY)!)) { (success, response) in
            print(response)
            if success {
                completion(true)
            } else {
                self.alertMessage = response["error"].stringValue
                completion(false)
            }
        }
    }
    
    
    
    func deliverTheService(orderId: String, completion: @escaping (_ success: Bool)->Void) {
        
        let parameter = [
            "orderId": orderId
        ]
        
        authServiceObj.synPutMethod(url: BASE_URL_KEY + "cook/hire/order-delivery/" + orderId, parameter: parameter, header: Helper.headerWithToken(token: Helper.getUserDefault(key: TOKEN_KEY)!)) { (success, response) in
            print(response)
            if success {
                completion(true)
            } else {
                self.alertMessage = response["error"].stringValue
                completion(false)
            }
        }
    }
    
    
    func customerNotRecieveOrder(orderType: String, orderId: String, completion: @escaping (_ success: Bool)->Void) {
        let parameter = [
            "orderId": orderId
        ]
        
        var url = String()
        
        url = BASE_URL_KEY + "auth/order-not-receive/" + orderId

        authServiceObj.synPutMethod(url: url, parameter: parameter, header: Helper.headerWithToken(token: Helper.getUserDefault(key: TOKEN_KEY)!)) { (success, response) in
            print(response)
            if success {
                completion(true)
            } else {
                self.alertMessage = response["error"].stringValue
                completion(false)
            }
        }
    }

   
    func cookDeliverService(orderType: String, orderId: String, completion: @escaping (_ success: Bool)->Void) {
        let parameter = [
            "orderId": orderId
        ]
        
        var url = String()
        if orderType == "Order-Food" {
            url = BASE_URL_KEY + "auth/cook/order-delivery/" + orderId
        } else {
            print(BASE_URL_KEY + "auth/cook/hire/order-delivery/" + orderId)
            url = BASE_URL_KEY + "cook/hire/order-delivery/" + orderId
        }
        
        authServiceObj.synPutMethod(url: url, parameter: parameter, header: Helper.headerWithToken(token: Helper.getUserDefault(key: TOKEN_KEY)!)) { (success, response) in
            print(response)
            if success {
                completion(true)
            } else {
                self.alertMessage = response["error"].stringValue
                completion(false)
            }
        }
    }
    
    
    
    func customerRecieveTheService(orderType: String, orderId: String, completion: @escaping (_ success: Bool)->Void) {
        let parameter = [
            "orderId": orderId
        ]
        
        var url = String()
        
        if orderType == "Order-Food" {
            url = BASE_URL_KEY + "auth/cook/order-delivery/" + orderId
        } else {
            url = BASE_URL_KEY + "auth/hire/order-receive/" + orderId
        }
        
        authServiceObj.synPutMethod(url: url, parameter: parameter, header: Helper.headerWithToken(token: Helper.getUserDefault(key: TOKEN_KEY)!)) { (success, response) in
            print(response)
            if success {
                completion(true)
            } else {
                self.alertMessage = response["error"].stringValue
                completion(false)
            }
        }
    }
    
    
    
    
    func rePayment(orderId: String, completion: @escaping (_ success: Bool)->Void) {
        authServiceObj.synGetMethod(url: BASE_URL_KEY + "auth/order/re-payment/" + orderId, header: Helper.headerWithToken(token: Helper.getUserDefault(key: TOKEN_KEY)!), completion: { (success, response) in
            print(response)
            if success {
                self.rePaymentData = response["data"]
                completion(true)
            } else {
                completion(false)
            }
        })
    }
    
    
    
    
    func makePayment(orderId: String, nonce: String, amount: String, completion: @escaping (_ success: Bool)->Void) {
        
        let parameter = [
            "nonce": nonce,
            "amount": amount
        ]
        
        authServiceObj.synPutMethod(url: BASE_URL_KEY + "auth/order/re-payment/" + orderId, parameter: parameter, header: Helper.headerWithToken(token: Helper.getUserDefault(key: TOKEN_KEY)!)) { (success, response) in
            print(response)
            if success {
                completion(true)
            } else {
                self.alertMessage = response["error"].stringValue
                completion(false)
            }
        }
    }
    
    
    
    func getClientTokenOrderId(orderId: String ,completion: @escaping (_ success: Bool)->Void) {
        
        let param = [
            "orderId" : orderId
        ]
        
        
        authServiceObj.synPostMethod(url: BASE_URL_KEY + "common/order/get-client-token", parameter: param, header: Helper.headerWithToken(token: Helper.getUserDefault(key: TOKEN_KEY)!)) { (success, response) in
            print(response)
            if success {
                self.clientToken = response["data"]["token"].stringValue
                completion(true)
            } else {
                self.alertMessage = response["error"].stringValue
                completion(false)
            }
        }
        
        /*
        authServiceObj.synGetMethod(url: BASE_URL_KEY + "common/order/get-client-token/" + orderId, header: Helper.headerWithToken(token: Helper.getUserDefault(key: TOKEN_KEY)!)) { (success, response) in
            
            print(response)
            if success {
                self.clientToken = response["data"]["token"].stringValue
                completion(true)
            } else {
                self.alertMessage = response["error"].stringValue
                completion(false)
            }
        }*/
    }
}
