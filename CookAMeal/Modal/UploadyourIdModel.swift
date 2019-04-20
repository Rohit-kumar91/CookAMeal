//
//  UploadyourIdModel.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 14/03/18.
//  Copyright © 2018 Cynoteck. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class UploadyourIdModel: NSObject {

    
     let authServiceObject:AuthServices = AuthServices()
     var identificationImageData: Data? = nil
     var imageData = [Data]()
     var alertMessage : String!
    
    override init() {
        alertMessage = ""
    }
    
        func uploadUserIdentificationCard(completion: @escaping ( _ success: Bool)->Void) {
            
            let param : [String: Any] = [
                "type": Singleton.instance.identificationType as String,
                "typeId": Singleton.instance.choosenTypeId as String,
                "country": Singleton.instance.issuingCountry as String
            ]
            
            
            let headers: HTTPHeaders = [
                AUTHORIZATION_KEY : Helper.getUserDefaultValue(key: TOKEN_KEY)!,
                "Content-type": "multipart/form-data"
            ]
            
            
            identificationImageData = UIImageJPEGRepresentation(Singleton.instance.identificationPhoto, 1.0)
            print(identificationImageData!)
            
            if identificationImageData != nil {
                imageData.removeAll()
                imageData.append(identificationImageData!)
            }
            
            
            authServiceObject.synPostMultipartWithDifferentWithSeperatedKeys(methodType: .post, url: BASE_URL_KEY + identificationCardUrl, parameters: param, imageData: imageData, imageName: [IDENTIFICATION_CARD_KEY], headers: headers) { (success, response) in
                
                
                print(response)
                if success {
                    
                    if response[SUCCESS_KEY].boolValue {
                        
                        print ("Success")
                        self.alertMessage = response[DATA_KEY][MESSAGE_KEY].stringValue
                        completion( true)
                        
                    } else{
                        self.alertMessage = response[ERROR_KEY]["message"].stringValue
                        if (self.alertMessage == nil) {
                            self.alertMessage = response[ERROR_KEY].stringValue
                        }
                        completion( false)
                    }
                }
            }
        }
    
    
}
