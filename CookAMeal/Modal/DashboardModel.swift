//
//  DashboardModel.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 28/11/17.
//  Copyright © 2017 Cynoteck. All rights reserved.
//

import UIKit
import SwiftyJSON



class DashboardModel: NSObject {

    let authServiceObj: AuthServices = AuthServices()
    var dashboardArray = [JSON]()
    var alertMessage : String!
    var errorCode = String()
    
    //var menuArray = ["Hire a cook", "Order food", "Add Recipe", "Map", "Filter"]
    
    override init() {
        alertMessage = ""
    }
    
    func getDashboardData(completion: @escaping (_ success: Bool)->Void) {
        
        let header: [String: String] = [
            AUTHORIZATION_KEY : Helper.getUserDefault(key: "token")!
        ]
        
        
        print("Header token",header)
        
        authServiceObj.synGetMethod(url: BASE_URL_KEY + COMMON_CATEGORY , header: header) { (success, response) in
            
            print(BASE_URL_KEY + COMMON_CATEGORY)
            print(response)
            
            if success {
                if response[DATA_KEY].count == 0 {
                    self.alertMessage = "Data does not exist."
                    completion(false)
                } else {
                    self.dashboardArray.removeAll()
                    self.dashboardArray = response[DATA_KEY].arrayValue
                    completion(true)
                }
              
            } else {
                self.errorCode = response[STATUS_KEY].stringValue
                self.alertMessage = response[ERROR_KEY]["message"].stringValue
                if (self.alertMessage == nil) {
                    self.alertMessage = response[ERROR_KEY].stringValue
                }
                completion(false)
            }
        }
    }
    
    
    func subscribeNotification(completion: @escaping (_ success: Bool)->Void) {
        
        let header: [String: String] = [
            AUTHORIZATION_KEY : Helper.getUserDefault(key: "token")!
        ]
        
        var param = [String : String]()
        
        if let deviceToken = Helper.getUserDefault(key: "deviceToken") {
            param = [
                //deviceToken
                "token" : deviceToken
            ]
        }
        
       
        
        print("Header token",header)
        print("Param",param)
        
        //http://192.168.5.126:8081/api/auth/subscribe-notification
        authServiceObj.synPostMethod(url: BASE_URL_KEY + "auth/subscribe-notification", parameter: param, header: header) { (success, response) in
            print(response)
            if success {
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
    

