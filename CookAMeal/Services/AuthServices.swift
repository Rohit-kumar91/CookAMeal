//
//  AuthServices.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 14/11/17.
//  Copyright © 2017 Cynoteck. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON



protocol AuthServiceDelegate : class {
    
    func serviceProgress(progress: Float)
}





class AuthServices {
   // static let instance = AuthServices()
    
    weak var delegate: AuthServiceDelegate?
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 15 2017
    // Input Parameters :   URL, Parameter, CompletionHandler.
    // Purpose          :   GET Webservice Implementation.
    //>--------------------------------------------------------------------------------------------------
    
    func synGetMethod(url: String, header: [String: String] , completion: @escaping CompletionHandler) {
        
        
        if Singleton.instance.isSimpleGetRequest {
            Singleton.instance.isSimpleGetRequest = false
            
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:header)
                .responseJSON { response in
                    
                    switch response.result {
                        
                    case .success(let value):
                        
                        let jsonDict  =  JSON(value)
                        
                        if jsonDict["success"].boolValue {
                            completion(true, jsonDict)
                        } else {
                            
                            //if the user is not authorize
                            if jsonDict["status"].intValue == 401 {
                                self.loginAgain()
                            }
                            completion(false, jsonDict)
                        }
                        
                        
                    case .failure(let error):
                        
                        let jsonDict  =  JSON([ERROR_KEY: error.localizedDescription])
                        completion(false, jsonDict)
                    }
            }
            
            
            
        } else {
            
            var urlRequest = URLRequest(url: URL(string: url)!,
                                        cachePolicy: .returnCacheDataElseLoad,
                                        timeoutInterval: 5) // 604800
            // AUTHORIZATION_KEY : Helper.getUserDefault(key: "token")!
            urlRequest.addValue(Helper.getUserDefault(key: "token")!, forHTTPHeaderField: AUTHORIZATION_KEY)
            
            
            if URLCache.shared.cachedResponse(for: urlRequest) != nil {
                URLCache.shared.removeCachedResponse(for: urlRequest)
                urlRequest.cachePolicy = .returnCacheDataElseLoad
            }
            
            
            
            
            
            
            Alamofire.request(urlRequest as URLRequestConvertible).validate().responseJSON { (response) in
                if response.result.isSuccess {
                    if let requestResponse = response.result.value {
                        let jsonDict  =  JSON(requestResponse)
                        
                        if jsonDict["success"].boolValue {
                            completion(true, jsonDict)
                        } else {
                            
                            //if the user is not authorize
                            if jsonDict["status"].intValue == 401 {
                                self.loginAgain()
                            }
                            completion(false, jsonDict)
                        }
                    }
                } else{
                    let jsonDict  =  JSON([ERROR_KEY: response.result.error])
                    completion(false, jsonDict)
                }
            }
        }
        
        
        }
    
    
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 15 2017
    // Input Parameters :   URL, Parameter, CompletionHandler.
    // Purpose          :   GET Webservice Implementation.
    //>--------------------------------------------------------------------------------------------------
    func syndeleteMethod(url: String, header: [String: String] , completion: @escaping CompletionHandler){
        
        Alamofire.request(url, method: .delete, parameters: nil, encoding: JSONEncoding.default, headers:header)
            .responseJSON { response in
                
                switch response.result {
                    
                case .success(let value):
                    
                    let jsonDict  =  JSON(value)
                    
                    if jsonDict["success"].boolValue {
                        completion(true, jsonDict)
                    } else {
                        completion(false, jsonDict)
                    }
                    
                    
                case .failure(let error):
                    
                    let jsonDict  =  JSON([ERROR_KEY: error.localizedDescription])
                    completion(false, jsonDict)
                }
        }
    }
    
    
    
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 15 2017
    // Input Parameters :   URL, Parameter, CompletionHandler.
    // Purpose          :   Webservice Implementation.
    //>--------------------------------------------------------------------------------------------------
    
    func synPostMethod(url: String, parameter: [String: Any], header: [String: String], completion: @escaping CompletionHandler) {
        
        Alamofire.request(url, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            
            switch response.result {
                case .success(let value):
                    let jsonDict  =  JSON(value)
                    print(jsonDict)
                    if jsonDict["success"].boolValue {
                        completion(true, jsonDict)
                    } else {
                        
                        //if the user is not authorize
                        if jsonDict["status"].intValue == 401 {
                            self.loginAgain()
                        }
                        
                        completion(false, jsonDict)
                    }
                
                case .failure(let error):
                    
                    print(error.localizedDescription)
                    let dictError: JSON = [ERROR_KEY : error.localizedDescription]
                    completion(false, dictError as JSON)
                
                }
            }
        }
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 15 2017
    // Input Parameters :   URL, Parameter, CompletionHandler.
    // Purpose          :   Webservice Implementation.
    //>--------------------------------------------------------------------------------------------------
    
    func synPutMethod(url: String, parameter: [String: Any], header: [String: String], completion: @escaping CompletionHandler) {
        
        Alamofire.request(url, method: .put, parameters: parameter, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                let jsonDict  =  JSON(value)
                print(jsonDict)
                if jsonDict["success"].boolValue {
                    completion(true, jsonDict)
                } else {
                    completion(false, jsonDict)
                }
                
            case .failure(let error):
                
                print(error.localizedDescription)
                let dictError: JSON = [ERROR_KEY : error.localizedDescription]
                completion(false, dictError as JSON)
                
            }
        }
    }
    
    
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 15 2017
    // Input Parameters :   URL, Parameter, ImageDataArray, CompletionHandler.
    // Purpose          :   Multipart service for web implementation.
    //>--------------------------------------------------------------------------------------------------
    func synPostMultipart( methodType: HTTPMethod, url: String, parameters: [String: Any], imageData: [Data], imageName: [String], headers: HTTPHeaders, completion: @escaping CompletionHandler) {
        
        //Convert dictionary to json string
        let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions())
        let jsonString = NSString(data: jsonData!, encoding: String.Encoding.utf8.rawValue)
        
        
        //optional handling
        guard let params = jsonString else{
            return
        }
        
        print(params)
     
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
//            If we want to pass dictionary then we will use this.
//            for (key, value) in params {
//                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
//            }
            //ye sahi karna hai.
            multipartFormData.append("\(params)".data(using: String.Encoding.utf8)!, withName: "details")
            
            
           
            for (index, _) in imageData.enumerated() {
               multipartFormData.append(imageData[index], withName: imageName[index], fileName: "\(Date().timeIntervalSince1970).jpg", mimeType: "image/jpg")
            }

        }, usingThreshold: UInt64.init(), to: url, method: methodType, headers: headers) { (result) in
            
            
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress { progress in
                    self.delegate?.serviceProgress(progress: Float(progress.fractionCompleted))
                }

                
                //Response
                upload.responseJSON { response in

                    print("response  \(response.result.isSuccess)")
                    
                    if response.result.isSuccess {
                        if let value = response.result.value {
                            completion(true, JSON(value))
                        }
                    } else {
                        let jsonDict  =  JSON([ERROR_KEY: response.result.error?.localizedDescription])
                        completion(false, jsonDict)
                    }
                }
                
            case .failure(let error):
                print(error)
                let jsonDict  =  JSON([ERROR_KEY: error.localizedDescription])
                completion(false, jsonDict)
            }
        }
    }
    
    
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 15 2017
    // Input Parameters :   URL, Parameter, ImageDataArray, CompletionHandler.
    // Purpose          :   Multipart service for web implementation.
    //>--------------------------------------------------------------------------------------------------
    func synPostMultipartWithDifferentWithSeperatedKeys(methodType: HTTPMethod, url: String, parameters: [String: Any]?, imageData: [Data], imageName: [String], headers: HTTPHeaders, completion: @escaping CompletionHandler) {
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            
            if parameters != nil {
                for (key, value) in parameters! {
                   multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                }
            }
            
            
            print(imageData.count)
            for (index, _) in imageData.enumerated() {
                multipartFormData.append(imageData[index], withName: imageName[0], fileName: "\(Date().timeIntervalSince1970).jpg", mimeType: "image/jpg")
            }
            
            
        }, usingThreshold: UInt64.init(), to: url, method: methodType, headers: headers) { (result) in
            
            print(result)
            switch result{
                
            case .success(let upload, _, _):
                
                upload.uploadProgress { progress in
                    self.delegate?.serviceProgress(progress: Float(progress.fractionCompleted))
                }
                
                //Response
                upload.responseJSON { response in
                    if let value: AnyObject = response.result.value as AnyObject{
                        
                        completion(true, JSON(value))
                    }
                    
                }
                
            case .failure(let error):
                
                let jsonDict  =  JSON([ERROR_KEY: error.localizedDescription])
                completion(false, jsonDict)
                
            }
        }
    }
    
    //Logout the user
    func loginAgain() {
        UserDefaults.standard.removeObject(forKey: PROFILE_URL_KEY)
        UserDefaults.standard.removeObject(forKey: USER_TYPE_KEY)
        UserDefaults.standard.removeObject(forKey: USER_ROLE_KEY)
        UserDefaults.standard.removeObject(forKey: FULL_NAME_KEY)
        UserDefaults.standard.removeObject(forKey: EMAIL_KEY)
        UserDefaults.standard.removeObject(forKey: ID_KEY)
        Helper.removeUserDefault(key: TOKEN_KEY)
    }
    
    
}
