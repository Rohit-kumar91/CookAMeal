//
//  MapModel.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 19/01/18.
//  Copyright © 2018 Cynoteck. All rights reserved.
//

import UIKit
import SwiftyJSON

class MapModel: NSObject {

    
    let authServiceObj: AuthServices = AuthServices()
    var alertMessage: String!
    var mapData = [JSON]()
    var previewDemoData = [[String: JSON]]()
    var latLongData = [[String: JSON]]()
    var cookDataArray = [JSON]()
    var CooksDealWithCategories = [JSON]()
    
    
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
    
    
    func mapIntialValueOnViewLoad(lat: String, long: String, completion: @escaping (_ success: Bool)->Void) {
        
        let header: [String: String] = [
            AUTHORIZATION_KEY : Helper.getUserDefault(key: TOKEN_KEY)!
        ]
        
        print(currentLocationLongitute)
        print(currentLocationLatitude)
        let locale = Locale.current
        let countryName = self.countryName(from: locale.regionCode!)
        let countryTrimmedString = countryName.replacingOccurrences(of: " ", with: "")
        
        let urlfirst = BASE_URL_KEY + "common/map/lat/" + lat
        let urlfinal = urlfirst +  "/long/" + long + "/unit/" + countryTrimmedString
        
        
        authServiceObj.synGetMethod(url: urlfinal, header: header) { (success, response) in
            
            if success {
            
                self.mapData = response[DATA_KEY].arrayValue
            
                for (_, values) in self.mapData.enumerated() {
                
                    self.latLongData.append(values[PROFILE_KEY]["Address"].dictionaryValue)
                    let title = values[PROFILE_KEY][FIRST_NAME_KEY]
                    let img = values[PROFILE_KEY]["MediaObjects"][0][IMAGE_URL_KEY]
                    let distance = values["distance"]
                    let id  =  values[PROFILE_KEY][ID_KEY]
                    let temp = [ "title": title , "img": img , "distance": distance, ID_KEY: id]
                
                    self.previewDemoData.append(temp)
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
    
    
    
    func categoryWiseCookDetails(lat: String, long: String, completion: @escaping (_ success: Bool)->Void) {
        
        let header: [String: String] = [
            AUTHORIZATION_KEY : Helper.getUserDefault(key: TOKEN_KEY)!
        ]
        
        
        let locale = Locale.current
        let countryName = self.countryName(from: locale.regionCode!)
        let countryTrimmedString = countryName.replacingOccurrences(of: " ", with: "")

        
        authServiceObj.synGetMethod(url: BASE_URL_KEY + "/common/map/category-wise-cook-details" + "/lat/" + lat + "/long/" + long + "/unit/" + countryTrimmedString, header: header) { (success, response) in
            
            if success {
                print("response\(response)")
                self.cookDataArray = response[DATA_KEY].arrayValue
               
                for element in self.cookDataArray {
                    if !(element["CooksDealWithCategories"].count == 0) {
                        self.CooksDealWithCategories.append(element["CooksDealWithCategories"])
                    }
                }
                
                print(self.CooksDealWithCategories)
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
