//
//  CookAvailabilityCalendarModel.swift
//  CookAMeal
//
//  Created by Cynoteck on 30/04/18.
//  Copyright © 2018 Cynoteck. All rights reserved.
//

import UIKit
import SwiftyJSON

class CookAvailabilityCalendarModel: NSObject {
    
    var dateData = [JSON]()
    var alertMessage: String!
    let authServiceObj: AuthServices = AuthServices()
    var tableDate = [[String: String]]()

    override init() {
        alertMessage = ""
    }
    
    
    func getCookDatesForCalendar(cookId: String, date: String, completion: @escaping (_ success: Bool)->Void) {
        
        Singleton.instance.isSimpleGetRequest = true
        authServiceObj.synGetMethod(url:  BASE_URL_KEY + "auth/cook/availability/" + cookId + "/" + date, header: Helper.headerWithToken(token: Helper.getUserDefault(key: TOKEN_KEY)!)) { (success, response) in
            
            if success {
                print(response)
                self.dateData = response[DATA_KEY].arrayValue
                completion(true)
            } else {
                self.alertMessage = response[ERROR_KEY].stringValue
                completion(false)
            }
        }
    }
    
    
    func calendarTableData(date: String, currentdate: String ,cookId: String ,completion: @escaping (_ success: Bool)->Void) {
        
        print(currentdate)
        Singleton.instance.isSimpleGetRequest = true
        authServiceObj.synGetMethod(url:  BASE_URL_KEY + "auth/cook/availability/" + cookId + "/" + date + "/" + currentdate, header: Helper.headerWithToken(token: Helper.getUserDefault(key: TOKEN_KEY)!)) { (success, response) in
            
            if success {
                print(response)
                self.tableDate.removeAll()
                for dayTimeArray in response[DATA_KEY].arrayValue {
                    let startTime =  dayTimeArray[START_TIME_KEY].stringValue
                    let endTime = dayTimeArray[END_TIME_KEY].stringValue
                    let id  = dayTimeArray[ID_KEY].stringValue
                    let isCheck = "0"
                    
                    let tempDict =  [
                        START_TIME_KEY : startTime,
                        END_TIME_KEY : endTime,
                        ID_KEY : id,
                        "isCheck" : isCheck
                    ]
                    self.tableDate.append(tempDict)
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
