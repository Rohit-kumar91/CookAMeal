//
//  CookAvailabilityModel.swift
//  CookAMeal
//
//  Created by Cynoteck on 14/06/18.
//  Copyright © 2018 Cynoteck. All rights reserved.
//

import UIKit
import SwiftyJSON

class CookAvailabilityModel: NSObject {

    var data = JSON()
    var alertMessage: String!
    var successMessage : String!
    let authServiceObj: AuthServices = AuthServices()
    var canBook = Bool()
    let bookingArray = [String: String]()
    var bookedSlots = [[String: String]]()
    
    override init() {
        alertMessage = ""
    }
    

    
    func getCookTimeAvailbility(eventId: String, cookId: String, date: String, completion: @escaping (_ success: Bool)->Void) {
        
        print(eventId)
        print(cookId)
        print(date)
        
        authServiceObj.synGetMethod(url:  BASE_URL_KEY + "auth/cook-time/availability/" + eventId + "/" + cookId + "/" + date, header: Helper.headerWithToken(token: Helper.getUserDefault(key: TOKEN_KEY)!)) { (success, response) in
            
            if success {
                print(response)
                self.data = response["data"]["data"]
                self.canBook = response["data"]["canBook"].boolValue
                
                //Fetching the already alocated booked slots.
                for element in self.data["BookedTimeSlots"].arrayValue {
                    
                    print("Time\(self.fetchTime(date: element["startTime"].stringValue))")
                    
                    let startTime = self.fetchTime(date: element["startTime"].stringValue)
                    let endTime = self.fetchTime(date: element["endTime"].stringValue)
                    
                    let tempStartAndTime = [
                        "startTime" : startTime,
                        "endTime" : endTime
                    ]
                    self.bookedSlots.append(tempStartAndTime)
                    
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
    
    
    
    func addAvailabilityToWeekViewCalendar(eventId: String, startDateTime: String, endDateTime: String, completion: @escaping (_ success: Bool)->Void) {
        
        let parameterDict = [
            "eventId": eventId,
            "startDateTime" : startDateTime,
            "endDateTime" : endDateTime
        ]


        print(parameterDict)
        authServiceObj.synPostMethod(url: BASE_URL_KEY + "auth/validate-hire-cook-order", parameter: parameterDict, header: Helper.headerWithToken(token: Helper.getUserDefault(key: TOKEN_KEY)!)) { (success, response) in
             print("Printing Response ",response)
            if success {
                completion(true)
            } else {
                self.successMessage = response[ERROR_KEY][MESSAGE_KEY].stringValue
                completion(false)
            }
        }
    }
    
    
    func fetchTime(date: String)  -> String{
       
        let dateFormatter = DateFormatter()
        var localTimeZoneAbbreviation: String { return TimeZone.current.abbreviation() ?? "" }
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.timeZone = NSTimeZone(name: localTimeZoneAbbreviation) as TimeZone?
        let finaldatetime = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = NSTimeZone.local
        return dateFormatter.string(from: finaldatetime!)
    }
    
}
