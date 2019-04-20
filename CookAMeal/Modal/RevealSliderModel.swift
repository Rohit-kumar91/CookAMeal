//
//  RevealSliderModel.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 27/11/17.
//  Copyright © 2017 Cynoteck. All rights reserved.
//

import Foundation


class RevealSliderModel: NSObject {
    
    let authServiceObject:AuthServices = AuthServices()
    
    func logOutUser(completion: @escaping (_ message: String, _ success: Bool)->Void){
        
        
        let parameter: [String: String] = [
            "type": "logout",
            "deviceId": Singleton.instance.deviceToken
        ]
        
        authServiceObject.synPostMethod(url: BASE_URL_KEY + "auth/logout", parameter: parameter, header: Helper.headerWithToken(token: Helper.getUserDefault(key: TOKEN_KEY)!) ) { (success, response) in
            
            print(response)
            if success {
                completion(response[DATA_KEY][MESSAGE_KEY].stringValue, true)
            }else{
                completion("User Cannot be logout.", true)
            }
        }
    }
}
    
    

