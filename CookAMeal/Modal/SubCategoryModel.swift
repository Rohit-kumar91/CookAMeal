//
//  SubCategoryModel.swift
//  CookAMeal
//
//  Created by Cynoteck on 02/07/18.
//  Copyright © 2018 Cynoteck. All rights reserved.
//

import UIKit
import SwiftyJSON

class SubCategoryModel: NSObject {
    let authServiceObj: AuthServices = AuthServices()
    var subCategoryArray = [JSON]()
    var subCategoryFinalArray = [[String: String]]()
    var alertMessage : String!
    
    
    override init() {
        alertMessage = ""
    }
    
    func getSubcategoryData(completion: @escaping (_ success: Bool)->Void) {
        
        //http://192.168.5.126:8081/api/common/filter/sub-category
        authServiceObj.synGetMethod(url:  BASE_URL_KEY + "common/filter/sub-category", header: Helper.headerWithToken(token: Helper.getUserDefault(key: TOKEN_KEY)!)) { (success, response) in
            if success {
                print(response)
                self.subCategoryArray = response["data"].arrayValue
                
                for subCategory in self.subCategoryArray {
                    var temp = [String: String]()
                    temp["id"] = subCategory["id"].stringValue
                    temp["name"] = subCategory["name"].stringValue
                    temp["selected"] = "0"
                    
                    self.subCategoryFinalArray.append(temp)
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
