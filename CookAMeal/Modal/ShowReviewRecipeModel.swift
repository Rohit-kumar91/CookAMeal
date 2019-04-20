//
//  ShowReviewRecipeModel.swift
//  CookAMeal
//
//  Created by cyno on 10/25/18.
//  Copyright © 2018 Cynoteck. All rights reserved.
//

import UIKit
import SwiftyJSON


class ShowReviewRecipeModel: NSObject {
    
    
    var alertMessage: String!
    let authServiceObj: AuthServices = AuthServices()
    var reviewDataArray = [JSON]()
    
    override init() {
        super.init()
       
        self.alertMessage = ""
    }
    
    
    func getReviewData(id: String, completion: @escaping (_ success: Bool)->Void) {
        
        
        //http://192.168.5.126:8081/api/auth/get-all-reviews/35c8cc3c-ba4c-4630-b759-996368bae50b
        authServiceObj.synGetMethod(url: BASE_URL_KEY + "auth/get-all-reviews/" + id, header: Helper.headerWithToken(token: Helper.getUserDefault(key: TOKEN_KEY)!)) { (success, response) in
            
            if success {
                print(response)
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
