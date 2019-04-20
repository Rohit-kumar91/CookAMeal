//
//  MyOrdersModel.swift
//  CookAMeal
//
//  Created by Cynoteck on 17/04/18.
//  Copyright © 2018 Cynoteck. All rights reserved.
//

import UIKit
import SwiftyJSON

class MyOrdersModel: NSObject {
    
    let authServiceObj:AuthServices = AuthServices()
    var alertMessage: String!
    var myOrderData = [JSON]()
    
    
    override init() {
        alertMessage = ""
    }

    
    func getOrderData(refresh: Bool, type: String, completion: @escaping (_ success: Bool)->Void) {
        
        authServiceObj.synGetMethod(url: BASE_URL_KEY + "/auth/all-order/" + type, header: Helper.headerWithToken(token: Helper.getUserDefault(key: TOKEN_KEY)!)) { (success, response) in
            print(response)
            if success {
                
                if refresh {
                    self.myOrderData.removeAll()
                    self.myOrderData = response[DATA_KEY].arrayValue
                    
                } else {
                    self.myOrderData = response[DATA_KEY].arrayValue
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
}
