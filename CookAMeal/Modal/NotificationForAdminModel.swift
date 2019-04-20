//
//  NotificationForAdminModel
//  CookAMeal
//
//  Created by Cynoteck on 05/10/18.
//  Copyright © 2018 Cynoteck. All rights reserved.
//

import UIKit
import SwiftyJSON


class NotificationForAdminModel: NSObject {
    
    let authServiceObj: AuthServices = AuthServices()
    var notificationData = JSON()
    var alertMessage : String!
    
    override init() {
        alertMessage = ""
    }
    
    func getNotificationAdminData(notificationId: String, completion: @escaping (_ success: Bool)->Void) {
        
        //http://192.168.5.126:8081/api/auth/other-notification/aa059632-9485-4fa0-9425-59292b1c7577
        //https://api.domesticeat.com/api/auth/other-notification/9de26c53-d00d-4a59-8415-b855bde4cc23
        print(BASE_URL_KEY + "auth/other-notification/" + notificationId)
        
        
        authServiceObj.synGetMethod(url:  BASE_URL_KEY + "auth/other-notification/" + notificationId, header: Helper.headerWithToken(token: Helper.getUserDefault(key: TOKEN_KEY)!)) { (success, response) in
            
            print(response)
            if success {
                self.notificationData =  response["data"]
                completion(true)
            } else {
                self.alertMessage = response[ERROR_KEY]["message"].stringValue
                completion(false)
            }
        }
    }
    
    

}
