//
//  SortingModel.swift
//  CookAMeal
//
//  Created by Cynoteck on 02/07/18.
//  Copyright © 2018 Cynoteck. All rights reserved.
//

import UIKit
import SwiftyJSON

class SortingModel: NSObject {

    
    let authServiceObj: AuthServices = AuthServices()
    var alertMessage : String!
    var sortingData = [JSON]()
    
    
    override init() {
        alertMessage = ""
    }

    
    
    func countryName(from countryCode: String) -> String {
        if let name = (Locale.current as NSLocale).displayName(forKey: .countryCode, value: countryCode) {
            // Country name was found
            return name
        } else {
            // Country name cannot be found
            return countryCode
        }
    }
    
    
    func sortingData(categoryId: String, sortingType: String, completion: @escaping (_ success: Bool)->Void) {
        
        print("SortingType\(sortingType)")
        
        let locale = Locale.current
        let countryName = self.countryName(from: locale.regionCode!)
        print(countryName)
        
        let latitude = String(currentLocationLatitude)
        let longitude = String(currentLocationLongitute)
        let location = [
            "lat": latitude,
            "long" : longitude
        ]
        
        //let locationJsonData = try? JSONSerialization.data(withJSONObject: location, options: JSONSerialization.WritingOptions())
        //let locationJsonStringArray = NSString(data: locationJsonData!, encoding: String.Encoding.utf8.rawValue)
        
        
        let sortingParameter = [
            "categoryId": categoryId as String,
            "distance": "10",
            "location": location,
            "unit": countryName
            
            ] as [String : Any]
        
        print(sortingParameter)
        
        authServiceObj.synPostMethod(url: BASE_URL_KEY + "common/sorting/" + sortingType, parameter: sortingParameter , header: Helper.headerWithToken(token: Helper.getUserDefault(key: TOKEN_KEY)!)) { (success, response) in
            if success {
                print(response)
                self.sortingData = response["data"].arrayValue
                
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
