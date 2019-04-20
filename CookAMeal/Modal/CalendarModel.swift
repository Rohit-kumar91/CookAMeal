//
//  CalendarModel.swift
//  CookAMeal
//
//  Created by CYNOMAC001 on 04/04/18.
//  Copyright © 2018 Cynoteck. All rights reserved.
//

import UIKit
import SwiftyJSON

class CalendarModel: NSObject {

    let authServiceObj: AuthServices = AuthServices()
    var dateData = [JSON]()
    var tableDate = [JSON]()
    var dateTimeArray = [JSON]()
    
    var avialableDate: String!
    var startTime: String!
    var endTime: String!
    var alertMessage: String!
    var avaialablityResponse = JSON()
    var eventId = String()
    
    override init() {
        super.init()
        avialableDate = ""
        startTime = ""
        endTime = ""
        alertMessage = ""
    }
    
    
    
    func validateAvailableDate () -> Bool
    {
        var valid: Bool = true
        
        if self.avialableDate.isEmpty
        {
            valid = false
            self.alertMessage = "Available time cannot be blank."
        }
        
        return valid
    }
    
    
    
    func validateStartTime () -> Bool
    {
        var valid: Bool = true
        
        if self.startTime.isEmpty
        {
            valid = false
            self.alertMessage = "Start time cannot be blank."
        }
        
        return valid
    }
    
    
    
    func validateEndTime () -> Bool
    {
        var valid: Bool = true
        
        if self.endTime.isEmpty
        {
            valid = false
            self.alertMessage = "End time cannot be blank."
        }
        
        return valid
    }
    
    
    
    func getCustomerDatesForCalendar(completion: @escaping (_ success: Bool)->Void) {
        
        authServiceObj.synGetMethod(url:  BASE_URL_KEY + "auth/my-calendar", header: Helper.headerWithToken(token: Helper.getUserDefault(key: TOKEN_KEY)!)) { (success, response) in
            
            if success {
                print(response)
                self.dateData = response[DATA_KEY].arrayValue
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
    
    func getTableBookDatesDataForCalendar(date: String, completion: @escaping (_ success: Bool)->Void) {
        
        
        authServiceObj.synGetMethod(url:  BASE_URL_KEY + "auth/my-calendar/" + date, header: Helper.headerWithToken(token: Helper.getUserDefault(key: TOKEN_KEY)!)) { (success, response) in
            
            if success {
                print(response)
                self.tableDate.removeAll()
                self.tableDate = response[DATA_KEY].arrayValue
                completion(true)
            } else {
                self.alertMessage = response[ERROR_KEY]["message"].stringValue
                if (self.alertMessage == nil) {
                    self.alertMessage = response[ERROR_KEY].stringValue
                }
                print(self.alertMessage)
                completion(false)
            }
        }
    }
    
    
    
    func getCookDatesForCalendar(completion: @escaping (_ success: Bool)->Void) {
        
        Singleton.instance.isSimpleGetRequest = true
        authServiceObj.synGetMethod(url:  BASE_URL_KEY + "cook/availability", header: Helper.headerWithToken(token: Helper.getUserDefault(key: TOKEN_KEY)!)) { (success, response) in
            
            if success {
                Singleton.instance.isSimpleGetRequest = false
                print(response)
                self.dateData = response[DATA_KEY].arrayValue
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
    
    
    func calendarTableData(date: String, completion: @escaping (_ success: Bool)->Void) {
        
        
        authServiceObj.synGetMethod(url:  BASE_URL_KEY + "cook/availability/" + date, header: Helper.headerWithToken(token: Helper.getUserDefault(key: TOKEN_KEY)!)) { (success, response) in
            
            if success {
              
                print(response)
                self.dateTimeArray = response[DATA_KEY].arrayValue
                completion(true)
            } else {
                self.alertMessage = response[ERROR_KEY]["message"].stringValue
                if (self.alertMessage == nil) {
                    self.alertMessage = response[ERROR_KEY].stringValue
                }
                print(self.alertMessage)
                completion(false)
            }
        }
        
    }
    
    
    
    func addAvialabilty(isEdit: Bool, date: String, startTime: String, endTime: String, completion: @escaping (_ success: Bool)->Void) {
        
        let parameter = [
            DATE_KEY: date,
            START_TIME_KEY : startTime,
            END_TIME_KEY: endTime
        ]
        
        print(parameter)
        
        var eventUrl = String()
        if isEdit {
            eventUrl = BASE_URL_KEY + "cook/availability/" + eventId
            authServiceObj.synPutMethod(url: eventUrl, parameter: parameter, header: Helper.headerWithToken(token: Helper.getUserDefault(key: TOKEN_KEY)!)) { (success, response) in
                if success {
                    self.avaialablityResponse = response
                    completion(true)
                } else {
                    self.alertMessage = response[ERROR_KEY]["message"].stringValue
                    if (self.alertMessage == nil) {
                        self.alertMessage = response[ERROR_KEY].stringValue
                    }
                    completion(false)
                }
            }
            
        } else {
            eventUrl = BASE_URL_KEY + "cook/availability"
            authServiceObj.synPostMethod(url: eventUrl, parameter: parameter, header: Helper.headerWithToken(token: Helper.getUserDefault(key: TOKEN_KEY)!)) { (success, response) in
                if success {
                    self.avaialablityResponse = response
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
    
    
    
    
    func deleteEvent(eventId: String, completion: @escaping (_ success: Bool)->Void) {
       
        authServiceObj.syndeleteMethod(url: BASE_URL_KEY + "cook/availability/" + eventId , header: Helper.headerWithToken(token: Helper.getUserDefault(key: TOKEN_KEY)!)) { (success, response) in
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
