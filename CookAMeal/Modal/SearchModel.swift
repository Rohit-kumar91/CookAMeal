//
//  SearchModel.swift
//  CookAMeal
//
//  Created by Cynoteck on 15/05/18.
//  Copyright © 2018 Cynoteck. All rights reserved.
//

import UIKit
import SwiftyJSON

class SearchModel: NSObject {

    let authServiceObj: AuthServices = AuthServices()
    var searchArray = [JSON]()
    
    
    func countryName(from countryCode: String) -> String {
        if let name = (Locale.current as NSLocale).displayName(forKey: .countryCode, value: countryCode) {
            // Country name was found
            return name
        } else {
            // Country name cannot be found
            return countryCode
        }
    }
    
    func getSearchdata(searchText: String,completion: @escaping (_ success: Bool)->Void) {
        
        let latitude = String(currentLocationLatitude)
        let longitude = String(currentLocationLongitute)
        let location = [
            "lat": latitude,
            "long" : longitude
        ]
        
        let locale = Locale.current
        let countryName = self.countryName(from: locale.regionCode!)
        
        let searchParameter = [
            "distance": 5000,
            "location": location,
            "unit": countryName
        
            ] as [String : Any]
        
        
        authServiceObj.synPostMethod(url: BASE_URL_KEY + "common/search/" + searchText, parameter: searchParameter, header: Helper.headerWithToken(token: Helper.getUserDefault(key: TOKEN_KEY)!)) { (success, response) in
            if success {
                print(response)
                self.searchArray = response["data"].arrayValue
                completion(true)
            } else {
                completion(false)
            }
        }
    }
}
