//
//  MyProfileModel.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 30/01/18.
//  Copyright © 2018 Cynoteck. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire


class MyProfileModel: NSObject {
    
    var profileName: String
    var ratingValue : Int
    var email: String
    var gender: String
    var contactNumber: String
    var street: String
    var city: String
    var state: String
    var zipCode: String
    var country: String
    var introduction: String
    var safetlyLicense: String
    var foodLicense: String
    var coverImageUrl: String
    var profileImageUrl: String
    var firstname: String
    var lastname: String
    let genderArray = ["Male", "Female"]
    var flagGender: String
    var certificate: String
    var drivingDistanceArray = [Int]()
    var drivingDistance: String
    var allergies: String
    var allergiesArray = [String]()
    var tempAllergiesArray = [[String: String]]()
    var finalAllergies = [[String: String]]()
    var dietPreference : String
    var identificationCard = JSON()
    var facebookConnected = Bool()
    let authServiceObj: AuthServices = AuthServices()
    var alertMessage: String!
    
    override init() {
        
        self.dietPreference = ""
        self.profileName = ""
        self.alertMessage = ""
        self.ratingValue = 0
        self.email = ""
        self.gender = ""
        self.contactNumber = ""
        self.street = ""
        self.city = ""
        self.state = ""
        self.zipCode = ""
        self.country = ""
        self.introduction = ""
        self.safetlyLicense = ""
        self.foodLicense = ""
        self.coverImageUrl = ""
        self.profileImageUrl = ""
        self.firstname = ""
        self.lastname = ""
        self.flagGender = ""
        self.certificate = ""
        self.drivingDistanceArray =  Array(1...25)
        self.drivingDistance = ""
        self.allergies = ""
        
    }
    

    func validateIntroduction () -> Bool
    {
        var valid: Bool = true
        
        if self.introduction.isEmpty
        {
            valid = false
            self.alertMessage = "Introduction required"
        }
        
        return valid
    }
    
    
    
    func validatePhone () -> Bool
    {
        var valid: Bool = true
        if self.contactNumber.isEmpty
        {
            valid = false
            self.alertMessage = "Phone number required"
        }
        else
        {
            if self.contactNumber.count > 0 && self.contactNumber.count < 10
            {
                valid = false
                self.alertMessage = "Phone number is not correct."
            }else
            {
                valid = true
            }
        }
        return valid
    }
    
    
    
    
    func getProfileData(completion: @escaping (_ success: Bool)->Void) {
        
        let header: [String: String] = [
            AUTHORIZATION_KEY : Helper.getUserDefault(key: TOKEN_KEY)!
        ]
        
        authServiceObj.synGetMethod(url: BASE_URL_KEY + "auth/profile" , header: header) { (success, response) in
            if success {
                self.setDataToVariables(response: response)
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
    
    
    
    func setDataToVariables(response: JSON) {
        
        print(response)
        
        self.profileName = response[DATA_KEY][PROFILE2_KEY][FULL_NAME_KEY].stringValue
        Helper.saveUserDefaultValue(key: FULL_NAME_KEY, value: self.profileName)

        //self.ratingValue = response[DATA_KEY]
        self.email = response[DATA_KEY][PROFILE2_KEY][EMAIL_KEY].stringValue
        Helper.saveUserDefaultValue(key: EMAIL_KEY, value: self.email)

        self.gender = response[DATA_KEY][PROFILE2_KEY]["genderFull"].stringValue
        self.contactNumber = response[DATA_KEY][PROFILE2_KEY][PHONE_KEY].stringValue
        self.profileImageUrl = response[DATA_KEY][PROFILE2_KEY][PROFILE_URL_KEY].stringValue
        self.coverImageUrl = response[DATA_KEY][PROFILE2_KEY][COVER_PHOTO_URL].stringValue
        self.street = response[DATA_KEY][PROFILE2_KEY]["Address"][STREET_KEY].stringValue
        self.city = response[DATA_KEY][PROFILE2_KEY]["Address"][CITY_KEY].stringValue
        self.state = response[DATA_KEY][PROFILE2_KEY]["Address"][STATE_KEY].stringValue
        self.zipCode = response[DATA_KEY][PROFILE2_KEY]["Address"][ZIPCODE_KEY].stringValue
        self.country = response[DATA_KEY][PROFILE2_KEY]["Address"][COUNTRY_KEY].stringValue
        self.introduction = response[DATA_KEY][PROFILE2_KEY]["description"].stringValue
        self.firstname = response[DATA_KEY][PROFILE2_KEY][FIRST_NAME_KEY].stringValue
        self.lastname = response[DATA_KEY][PROFILE2_KEY][LAST_NAME_KEY].stringValue
        self.certificate = response[DATA_KEY][PROFILE2_KEY]["Certificate"]["MediaObject"]["imageUrl"].stringValue
        
        
        //set label text.
        let locale = Locale.current
        if locale.currencyCode == "USD" {
            self.drivingDistance = response[DATA_KEY][PROFILE2_KEY][DRIVING_DISTANCE_KEY].stringValue
        } else {
            self.drivingDistance = response[DATA_KEY][PROFILE2_KEY][DRIVING_DISTANCE_KEY].stringValue
        }
        
        
        
        
        
        let aString = response[DATA_KEY][PROFILE2_KEY]["allergies"].stringValue
        let newString = aString.replacingOccurrences(of: "[", with: "", options: .literal, range: nil)
        let secondNewString = newString.replacingOccurrences(of: "]", with: "", options: .literal, range: nil)
        
        print(secondNewString)
        
        let finalString = secondNewString.replacingOccurrences(of: "\"", with: "", options: .literal, range: nil)
        print(finalString)
        
        self.allergies = finalString
        self.dietPreference = response[DATA_KEY][PROFILE2_KEY]["dietPreference"].stringValue
        self.identificationCard = response[DATA_KEY][PROFILE2_KEY]["IdentificationCard"]
        self.facebookConnected = response[DATA_KEY][PROFILE2_KEY]["isFacebookConnected"].boolValue
        
        
        Singleton.instance.issuingCountry = response[DATA_KEY][PROFILE2_KEY]["IdentificationCard"]["country"].stringValue
        Singleton.instance.identificationType = response[DATA_KEY][PROFILE2_KEY]["IdentificationCard"]["type"].stringValue
        Singleton.instance.identificationImageUrl = response[DATA_KEY][PROFILE2_KEY]["IdentificationCard"]["MediaObjects"][0]["imageUrl"].stringValue
        Singleton.instance.choosenTypeId = response[DATA_KEY][PROFILE2_KEY]["IdentificationCard"]["typeId"].stringValue
        
        
        let data = self.allergies.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        
        do {
           allergiesArray = try JSONSerialization.jsonObject(with: data, options: []) as! [String]
           
        } catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
        }
        
        tempAllergiesArray = customerRegistrationConstant.AllergiesArray.allergiesName
        
        for (index, _) in allergiesArray.enumerated() {
            let temp = ["name" : allergiesArray[index], "selectionType" : "check"]
            tempAllergiesArray.insert(temp, at:0)
        }
        finalAllergies = getFinalArray()
        
        
    }
    
    
    func getFinalArray() -> [[String: String]] {
        
        tempAllergiesArray = tempAllergiesArray.enumerated()
            .filter { (idx, dict) in !tempAllergiesArray[0..<idx].contains(where: {$0 == dict}) }
            .map { $1 }
        
        tempAllergiesArray.sort{
            (($0 as Dictionary<String, AnyObject>)["selectionType"] as? Int) == (($1 as Dictionary<String, AnyObject>)["selectionType"] as? Int)
        }
        
        let finalArray = self.noDuplicates(tempAllergiesArray)
        return finalArray
    }
    
    func noDuplicates(_ arrayOfDicts: [[String: String]]) -> [[String: String]] {
        
        var noDuplicates = [[String: String]]()
        var usedNames = [String]()
        for dict in arrayOfDicts {
            if let name = dict["name"], !usedNames.contains(name) {
                noDuplicates.append(dict)
                usedNames.append(name)
            }
        }
        return noDuplicates
    }
    
    
   
    
    func updateProfileData(userType: String, completion: @escaping (_ success: Bool)->Void) {
        
        let header: [String: String] = [
            AUTHORIZATION_KEY : Helper.getUserDefault(key: TOKEN_KEY)!,
            "Content-Type": "application/json"
        ]
        
        var profile = [String: String]()
        
        if userType == "1" {
            
            profile = [
                FIRST_NAME_KEY: firstname.trimmingCharacters(in: .whitespaces),
                LAST_NAME_KEY: lastname.trimmingCharacters(in: .whitespaces),
                GENDER_KEY: flagGender,
                PHONE_KEY: contactNumber,
                DESCRIPTION_KEY: introduction,
                DRIVING_DISTANCE_KEY: drivingDistance
            ]
            
        } else {
            
            print(finalAllergies)
            
            var tempAllergies = [String]()
            for element in finalAllergies {
                if element["selectionType"] == "check" {
                    tempAllergies.append(element["name"]!)
                }
            }
            
            let allergiesJsonData = try? JSONSerialization.data(withJSONObject: tempAllergies, options: JSONSerialization.WritingOptions())
            let finalArray = NSString(data: allergiesJsonData!, encoding: String.Encoding.utf8.rawValue)
            
           profile = [
                FIRST_NAME_KEY: firstname.trimmingCharacters(in: .whitespaces),
                LAST_NAME_KEY: lastname.trimmingCharacters(in: .whitespaces),
                GENDER_KEY: flagGender,
                PHONE_KEY: contactNumber,
                DIET_PREFERENCE_KEY: dietPreference,
                ALLERGIES_KEY: finalArray! as String
            ]
        }
        
       
        
        let address: [String: String] = [
            STREET_KEY : street,
            CITY_KEY : city,
            STATE_KEY : state,
            ZIPCODE_KEY : zipCode,
            COUNTRY_KEY : country,
            LATITUDE_KEY: String(currentLocationLatitude), // 30.3565759311799
            LONGITUDE_KEY: String(currentLocationLongitute) // 78.0850118542611
            
        ]
        
        let params: [String: [String: String]] = [
            ADDRESS_KEY : address,
            PROFILE_KEY: profile
        ]
        
        
        print(params)
        
        authServiceObj.synPostMethod(url: BASE_URL_KEY + "auth/profile", parameter: params, header: header) { (success, response) in

            print(response)
            if success {
                self.setDataToVariables(response: response)
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
    
    
    
    
    func editCoverProfilePicture(editCoverImage: UIImage, url: String, profileImageType: String, completion: @escaping (_ success: Bool)->Void) {
        
        let image = editCoverImage.resizeImage(targetSize: CGSize(width: 400, height: 400))
        let coverImageData = UIImageJPEGRepresentation(image, 1.0)!
        
        let headers: HTTPHeaders = [
            AUTHORIZATION_KEY : Helper.getUserDefaultValue(key: TOKEN_KEY)!,
            "Content-type": "multipart/form-data"
        ]
        
        authServiceObj.synPostMultipartWithDifferentWithSeperatedKeys(methodType: .post, url: BASE_URL_KEY + url , parameters: nil, imageData: [coverImageData], imageName: [profileImageType], headers: headers) { (success, response) in
            
            if success {
                print(response)
                
                if !response[SUCCESS_KEY].boolValue {
                    self.alertMessage = response[ERROR_KEY].stringValue
                    completion(false)
                } else {
                    if profileImageType == "profile" {
                        Helper.saveUserDefaultValue(key: PROFILE_URL_KEY, value: response[DATA_KEY][PROFILE_URL_KEY].stringValue)
                    }
                    self.alertMessage = response[DATA_KEY][MESSAGE_KEY].stringValue
                    
                    completion(true)
                }
                
            }else {
                self.alertMessage = response[ERROR_KEY]["message"].stringValue
                if (self.alertMessage == nil) {
                    self.alertMessage = response[ERROR_KEY].stringValue
                }
                completion(false)
            }
        }
    }
}

