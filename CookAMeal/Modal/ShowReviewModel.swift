//
//  ShowReviewModel.swift
//  CookAMeal
//
//  Created by Cynoteck on 08/06/18.
//  Copyright © 2018 Cynoteck. All rights reserved.
//

import UIKit
import SwiftyJSON


class ShowReviewModel: NSObject {

    let authServiceObj: AuthServices = AuthServices()
    var reviewArray = [JSON]()
    var alertMessage : String!
    
    
    override init() {
        alertMessage = ""
    }
    
    func getReviewDataToShow(userType: String, completion: @escaping (_ success: Bool)->Void) {
        
        authServiceObj.synGetMethod(url:  BASE_URL_KEY + "auth/my-reviews", header: Helper.headerWithToken(token: Helper.getUserDefault(key: TOKEN_KEY)!)) { (success, response) in
            if success {
                print(response)
                self.reviewArray = response["data"].arrayValue
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
