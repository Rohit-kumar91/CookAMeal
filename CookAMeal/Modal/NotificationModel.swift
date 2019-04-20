//
//  NotificationModel.swift
//  CookAMeal
//
//  Created by Cynoteck on 16/05/18.
//  Copyright © 2018 Cynoteck. All rights reserved.
//

import UIKit
import SwiftyJSON


class NotificationModel: NSObject {

    let authServiceObj: AuthServices = AuthServices()
    var notificationArray = [JSON]()
    var alertMessage : String!
    var orderId = String()
    var Id = String()
    var isNotification = Bool()
    var notificationType = String()
    var maximumPage = Int()

    override init() {
        alertMessage = ""
    }
    
    func getNotificationdata(refresh: Bool, pageNumber: Int, completion: @escaping (_ success: Bool)->Void) {
        authServiceObj.synGetMethod(url:  BASE_URL_KEY + "auth/notification/" + String(pageNumber), header: Helper.headerWithToken(token: Helper.getUserDefault(key: TOKEN_KEY)!)) { (success, response) in
            print(response)
            if success {
                self.maximumPage = response["data"]["maxPage"].intValue
                
                if refresh {
                    self.notificationArray.removeAll()
                    self.notificationArray = response["data"]["rows"].arrayValue
                } else {
                    if self.notificationArray.count == 0 {
                        self.notificationArray = response["data"]["rows"].arrayValue
                    } else {
                        
                        for element in response["data"]["rows"].arrayValue {
                            self.notificationArray.append(element)
                        }
                    }
                }
                
               
                completion(true)
            } else {
                self.alertMessage = response[ERROR_KEY]["message"].stringValue
                completion(false)
            }
        }
    }
    
    
    func seeNotificationDetails(id: String, completion: @escaping (_ success: Bool)->Void) {
        
        let parameter = [
            "notificationId": id
        ]
        authServiceObj.synPutMethod(url: BASE_URL_KEY + "auth/notification/" + id, parameter: parameter, header: Helper.headerWithToken(token: Helper.getUserDefault(key: TOKEN_KEY)!)) { (success, response) in
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
