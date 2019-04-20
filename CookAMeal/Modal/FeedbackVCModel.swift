//
//  FeedbackVCModel.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 04/01/18.
//  Copyright © 2018 Cynoteck. All rights reserved.
//

import UIKit

class FeedbackVCModel: NSObject {

    let authServiceObj:AuthServices = AuthServices()
    
    var isBug: String!
    var bugcomment: String!
    var rating: String!
    var feedbackAs: String!
    var comment: String!
    var alertMessage: String!
    
    
    
    override init() {
        super.init()
        
        self.isBug = ""
        self.bugcomment = ""
        self.rating = ""
        self.feedbackAs = ""
        self.comment = ""
        self.alertMessage = ""
        
    }
    
    
    /*
    func getFeedBack(completion: @escaping (_ success: Bool)->Void) {
        let header: [String: String] = [
            AUTHORIZATION_KEY : Helper.getUserDefault(key: TOKEN_KEY)!,
            "content-type": "application/json"
        ]
        
        authServiceObj.synGetMethod(url: BASE_URL_KEY + "auth/feedback", header: header) { (success, response) in
            print(response)
            if success {
                
                if response[DATA_KEY].null == NSNull() {
                    print("Null Response.")
                } else {
                    self.comment = response[DATA_KEY]["comments"].stringValue
                    self.rating = response[DATA_KEY]["rating"].stringValue
                    self.feedbackAs = response[DATA_KEY]["feedbackAs"].stringValue
                    completion(true)
                }
                
                
                
               
            } else {
                self.alertMessage = response[ERROR_KEY].stringValue
                completion(false)
            }
        }
    } */
    
    
    
    func postFeedback(reportBug: String, feedbackAs: String, comment: String, completion: @escaping (_ success: Bool)->Void) {
        
        var feedbackDict = [String: String]()
        
            feedbackDict = [
                "isBug": reportBug,
                "userType": feedbackAs,
                "comments": comment,
            ]
      
        print(feedbackDict)
       
        authServiceObj.synPostMethod(url: BASE_URL_KEY + "auth/feedback", parameter: feedbackDict, header: Helper.headerWithToken(token: Helper.getUserDefault(key: TOKEN_KEY)!)) { (success, response) in
            if success {
                print(response)
                self.alertMessage = response[DATA_KEY][MESSAGE_KEY].stringValue
                completion(true)
            } else{
                self.alertMessage = response[ERROR_KEY]["message"].stringValue
                if (self.alertMessage == nil) {
                    self.alertMessage = response[ERROR_KEY].stringValue
                }
                completion(false)
            }
        }
    }
}
    

    

