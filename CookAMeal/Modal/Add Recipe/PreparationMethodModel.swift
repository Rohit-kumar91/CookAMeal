//
//  PreparationMethodModel.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 05/12/17.
//  Copyright © 2017 Cynoteck. All rights reserved.
//

import UIKit
import SwiftyJSON


class PreparationMethodModel: NSObject {
    
    let authServiceObject:AuthServices = AuthServices()

    
    func deletePreparationMethod(preparationId: String, recipeId: String, completion: @escaping (_ success: Bool)->Void) {
        let header: [String: String] = [
            AUTHORIZATION_KEY : Helper.getUserDefault(key: TOKEN_KEY)!
        ]
        
        //http://192.168.5.126:8081/api/cook/recipe/:recipeId/preparation/ :P reparationId
        let url = BASE_URL_KEY + "cook/recipe/" + recipeId + "/preparation-method/" +  preparationId
        print(url)
        
        authServiceObject.syndeleteMethod(url: url, header: header) { (success, response) in
            
            print(response)
            if success {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    
    func addPreparationMethod(step: String, method: String, recipeId: String, completion: @escaping (_ response: JSON, _ success: Bool)->Void) {
        let header: [String: String] = [
            AUTHORIZATION_KEY : Helper.getUserDefault(key: TOKEN_KEY)!
        ]
        
        let url = BASE_URL_KEY + "cook/recipe/preparation-method"
        
        let param = [
            "step" : step,
            "method" : method,
            "recipeId" : recipeId
        ]
        
        authServiceObject.synPostMethod(url: url, parameter: param, header: header) { (success, response) in
            if success {
                completion(response, true)
            } else {
                completion(response, false)
            }
        }
    }
    
    
    
    

}
