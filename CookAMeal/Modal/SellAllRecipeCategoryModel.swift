//
//  SellAllRecipeCategoryModel.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 09/12/17.
//  Copyright © 2017 Cynoteck. All rights reserved.
//

import UIKit
import SwiftyJSON


class SellAllRecipeCategoryModel: NSObject {
    
    let authServiceObject:AuthServices = AuthServices()
    var alertMessage: String!
    var seeAllCategoryData = [JSON]()
    var subCategoryName: String!
    
    override init() {
        alertMessage = ""
    }

    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Dec, 9 2017
    // Input Parameters :   N/A.
    // Purpose          :   Get data on the bases of category and subcategory.
    //>--------------------------------------------------------------------------------------------------
    func getAllRecipeListOnBasesOfCategortAndSubcategory(categoryId: String!, subcategoryId: String!, completion: @escaping (_ success: Bool)->Void) {
        
        //http://192.168.5.126:8081/api/common/see-all/category/54037edb-ecd5-40c3-859e-5544b9da1a09/sub-category/b8835c02-208c-44a0-b25b-e99f52f22f71/recipe-list/1/lat/30.365617000000004/long/78.082743/unit/india/filter/5
        
        let header: [String: String] = [
            AUTHORIZATION_KEY : Helper.getUserDefault(key: TOKEN_KEY)!
        ]
        
        let categoryUrl = "common/see-all/category/" + categoryId
        let subCategoryUrl = "/sub-category/" + subcategoryId
        let recipeListUrl = "/recipe-list/"
        let orderType = "1"
        let lat = "/lat/\(currentLocationLatitude)"
        let long = "/long/\(currentLocationLongitute)"
        let unit = "/unit/\("india")"
        let filter = "/filter/\("5")"
        
        authServiceObject.synGetMethod(url: BASE_URL_KEY + categoryUrl + subCategoryUrl + recipeListUrl + orderType + lat + long + unit + filter, header: header) { (success, response) in
            
            print(response)
            
            if success {
                
                self.seeAllCategoryData = response[DATA_KEY].arrayValue
                completion(true)
            }else{
                self.alertMessage = response[ERROR_KEY]["message"].stringValue
                if (self.alertMessage == nil) {
                    self.alertMessage = response[ERROR_KEY].stringValue
                }
                completion(false)
            }
        }
    }
}
