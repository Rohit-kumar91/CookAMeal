//
//  FilterModel.swift
//  CookAMeal
//
//  Created by Cynoteck on 02/07/18.
//  Copyright © 2018 Cynoteck. All rights reserved.
//

import UIKit
import SwiftyJSON

class FilterModel: NSObject {
    
    let authServiceObj: AuthServices = AuthServices()
    var alertMessage : String!
    var filterData = [JSON]()
    
    
    override init() {
        alertMessage = ""
    }
    
    func filterData(filterParameter: [String: Any], completion: @escaping (_ success: Bool)->Void) {

        //http://192.168.5.126:8081/api/common/filter
        
        authServiceObj.synPostMethod(url: BASE_URL_KEY + "common/filter", parameter: filterParameter, header: Helper.headerWithToken(token: Helper.getUserDefault(key: TOKEN_KEY)!)) { (success, response) in
            if success {
                print(response)
                self.filterData = response["data"].arrayValue
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
