//
//  RejectRepaymentModel.swift
//  CookAMeal
//
//  Created by Cynoteck on 24/07/18.
//  Copyright © 2018 Cynoteck. All rights reserved.
//

import UIKit
import SwiftyJSON


class RejectRepaymentModel: NSObject {

    
    let authServiceObj: AuthServices = AuthServices()
    var alertMessage : String!

    
    override init() {
        alertMessage = ""
    }
    

    
    func rePaymentForOrder(orderId: String, completion: @escaping (_ success: Bool)->Void) {
        
        let parameter = [
            "orderId" : orderId
        ]
        
        
        authServiceObj.synPutMethod(url: BASE_URL_KEY + "cook/re-payment/" + orderId , parameter: parameter, header:  Helper.headerWithToken(token: Helper.getUserDefault(key: TOKEN_KEY)!)) { (success, response) in
            
            print(response)
            
            if success {
                self.alertMessage = response[ERROR_KEY][MESSAGE_KEY].stringValue
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
