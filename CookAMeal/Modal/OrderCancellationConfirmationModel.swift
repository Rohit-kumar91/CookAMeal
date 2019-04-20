//
//  OrderCancellationConfirmationModel.swift
//  CookAMeal
//
//  Created by Cynoteck on 19/04/18.
//  Copyright © 2018 Cynoteck. All rights reserved.
//

import UIKit

class OrderCancellationConfirmationModel: NSObject {
    
    let authServiceObj:AuthServices = AuthServices()
    var alertMessage: String!
    
    var orderCancellationResionArray = [
        "Sorry, unable to fullfill the order at this time.",
        "Other Reason"
    ]
    
    
    func cancelOrder(url: String, orderId: String, reason: String, description: String, completion: @escaping (_ success: Bool)->Void) {
        
        let parameter = [
            "orderId": orderId,
            "description": description,
            "reason": reason
        ]
        
        //BASE_URL_KEY + "auth/order/cancel-order/"
        authServiceObj.synPutMethod(url: url + orderId, parameter: parameter, header: Helper.headerWithToken(token: Helper.getUserDefault(key: TOKEN_KEY)!)) { (success, response) in
            print(response)
            if success {
                self.alertMessage = response[DATA_KEY][MESSAGE_KEY].stringValue
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
