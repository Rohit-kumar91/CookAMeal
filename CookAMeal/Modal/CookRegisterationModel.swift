//
//  CookRegisterationFirst.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 30/10/17.
//  Copyright © 2017 Cynoteck. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire


protocol CookRegisterationDelegate : class {
    func uploadProgress(progress: Float)
}


class CookRegisterationModel: NSObject, AuthServiceDelegate  {
    
    var userEmail: String!
    var firstname: String!
    var lastname: String!
    var createPassword: String!
    var phoneNumber: String!
    var phoneCode: String!
    var gender: String!
    var introduceYourself: String!
    var streetAddress: String!
    var city: String!
    var state: String!
    var zipcode: String!
    var country: String!
    var authorizationString: String!
    var email: String!
    var id: String!
    
    
    var drivindDistance: String!
    var profileImage: UIImage!
    var licenseImage: UIImage!
    
    var latitude: String!
    var longitude: String!
    
    var imageData = [Data]()
    var imageName = [String]()
    let authServiceObject:AuthServices = AuthServices()
    var alertMessage: String!
    var identificationImageData: Data? = nil
    
    weak var delegate: CookRegisterationDelegate?
    
    var detail = [String: [String:Any]]()
    var user = [String: Any]()

    override init() {
        super.init()
        
        self.userEmail = ""
        self.firstname = ""
        self.lastname = ""
        self.createPassword = ""
        self.phoneNumber = ""
        self.gender = ""
        self.introduceYourself = ""
        self.streetAddress = ""
        self.city = ""
        self.state = ""
        self.zipcode = ""
        self.country = ""
        self.drivindDistance = ""
        self.phoneCode = ""
        self.profileImage = nil
        self.licenseImage = nil
        
    }
    
    


    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Oct, 30 2017
    // Input Parameters :   N/A.
    // Purpose          :   Validate the email textfield.
    //>--------------------------------------------------------------------------------------------------
    
    
    func validateEmail () -> Bool
    {
        var valid: Bool = true
        let lowerCasedEmail = userEmail.lowercased()
        
        if lowerCasedEmail.isEmpty
        {
            valid = false
            self.alertMessage = LOGIN_CONSTANT.EMAIL_MISSING_KEY
        }
        else  if !lowerCasedEmail.isValidEmail()  {
            valid = false
            self.alertMessage = LOGIN_CONSTANT.EMAIL_AUTHENTICATION_MESSAGE_KEY
        }
        
        return valid
    }
    
    
  
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Oct, 30 2017
    // Input Parameters :   N/A.
    // Purpose          :   Validate the firstname textfield.
    //>--------------------------------------------------------------------------------------------------
    
    
    func validateFirstname () -> Bool
    {
        var valid: Bool = true
        self.firstname = self.firstname.trimmingCharacters(in: .whitespaces)
        
        if self.firstname.isEmpty
        {
            valid = false
            self.alertMessage = "First Name required"
        } else if self.firstname.validateTextfieldText {
            valid = false
            self.alertMessage = "Must not contain number or special character in firstname"
        }
        
        return valid
    }
    
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Oct, 30 2017
    // Input Parameters :   N/A.
    // Purpose          :   Validate the lastname textfield.
    //>--------------------------------------------------------------------------------------------------
    
    
    func validateLastname () -> Bool
    {
        var valid: Bool = true
        self.lastname = self.lastname.trimmingCharacters(in: .whitespaces)
        
        if self.lastname.isEmpty
        {
            valid = false
            self.alertMessage = "Last Name required"
        } else if self.lastname.validateTextfieldText {
            valid = false
            self.alertMessage = "Must not contain number or special character in lastname"
        }
        
        return valid
    }
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Oct, 30 2017
    // Input Parameters :   N/A.
    // Purpose          :   Validate the Create textfield.
    //>--------------------------------------------------------------------------------------------------
    
    func validateCreatepassword () -> Bool
    {
        var valid: Bool = true
        
        if self.createPassword.isEmpty
        {
            valid = false
            self.alertMessage = "Create password required"
        }
        else if !self.createPassword.isPasswordStrong {
            valid = false
            self.alertMessage = "Password Should have one uppercase letters, one special case character, digits, lowercase letters. Ensure string is of length 9."
        }
        
        return valid
    }
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Oct, 30 2017
    // Input Parameters :   N/A.
    // Purpose          :   Validate the phone number textfield.
    //>--------------------------------------------------------------------------------------------------
    
    func validatePhone () -> Bool
    {
        var valid: Bool = true
        
        print(self.phoneNumber.numberOnlyText)
        
        if self.phoneNumber.isEmpty
        {
            
            valid = false
            self.alertMessage = "Phone number required"
            
        } else if !self.phoneNumber.numberOnlyText {
            
            valid = false
            self.alertMessage = "Must not special character in phone number"
            
        } else if self.phoneNumber.count > 0 && self.phoneNumber.count < 10 {
            valid = false
            self.alertMessage = "Phone number is not correct."
        } else {
            valid = true
        }
        
        return valid
    }
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Oct, 30 2017
    // Input Parameters :   N/A.
    // Purpose          :   Validate the introduction textview.
    //>--------------------------------------------------------------------------------------------------
    
    
    func validateIntroduction () -> Bool
    {
        var valid: Bool = true
        self.introduceYourself = self.introduceYourself.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if self.introduceYourself.isEmpty
        {
            valid = false
            self.alertMessage = "Introduction required"
        }
        
        return valid
    }
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Oct, 30 2017
    // Input Parameters :   N/A.
    // Purpose          :   Validate the Street textfield.
    //>--------------------------------------------------------------------------------------------------
    
    
    func validateStreetAddress () -> Bool
    {
        var valid: Bool = true
        
        if self.streetAddress.isEmpty
        {
            valid = false
            self.alertMessage = "Street Address required"
        }
        
        return valid
    }
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Oct, 30 2017
    // Input Parameters :   N/A.
    // Purpose          :   Validate the City textfield.
    //>--------------------------------------------------------------------------------------------------
    
    
    func validateCity () -> Bool
    {
        var valid: Bool = true
        
        if self.city.isEmpty
        {
            valid = false
            self.alertMessage = "City required"
        }
        
        return valid
    }
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Oct, 30 2017
    // Input Parameters :   N/A.
    // Purpose          :   Validate the State textfield.
    //>--------------------------------------------------------------------------------------------------
    
    
    func validateState () -> Bool
    {
        var valid: Bool = true
        
        if self.state.isEmpty
        {
            valid = false
            self.alertMessage = "State required"
        }
        
        return valid
    }
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Oct, 30 2017
    // Input Parameters :   N/A.
    // Purpose          :   Validate the Zipcode textfield.
    //>--------------------------------------------------------------------------------------------------
    
    
    func validateZipcode () -> Bool
    {
        var valid: Bool = true
        
        if self.zipcode.isEmpty
        {
            valid = false
            self.alertMessage = "Zipcode required"
        }
        else
        {
            
            if self.country == "India" {
                if self.zipcode.count < 6
                {
                    valid = false
                    self.alertMessage = "Zipcode number is not correct."
                }
                else
                {
                    valid = true
                }
            }else{
                
                print(self.zipcode.count)
                
                if self.zipcode.count < 5
                {
                    valid = false
                    self.alertMessage = "Zipcode number is not correct."
                }
                else
                {
                    valid = true
                }
            }
           
        }
        
        return valid
    }
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Oct, 30 2017
    // Input Parameters :   N/A.
    // Purpose          :   Validate the Country textfield.
    //>--------------------------------------------------------------------------------------------------
    
    
    func validateCountry () -> Bool
    {
        var valid: Bool = true
        
        if self.country.isEmpty
        {
            valid = false
            self.alertMessage = "Country required"
        }
        
        return valid
    }
    
    
   
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Oct, 30 2017
    // Input Parameters :   N/A.
    // Purpose          :   Validate the Driving distance textfield.
    //>--------------------------------------------------------------------------------------------------
    
    
    func validateDrivingDistance () -> Bool
    {
        var valid: Bool = true
        
        if self.drivindDistance.isEmpty
        {
            valid = false
            self.alertMessage = "Driving Distance required"
        }
        
        return valid
    }
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 15 2017
    // Input Parameters :   N/A.
    // Purpose          :   Validate  Gender.
    //>--------------------------------------------------------------------------------------------------
    
    
    func validateGender () -> Bool
    {
        var valid: Bool = true
        
        if self.gender.isEmpty
        {
            valid = false
            self.alertMessage = "Please Select Gender."
        }
        
        return valid
    }
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 15 2017
    // Input Parameters :   N/A.
    // Purpose          :   Validate Profile Picture.
    //>--------------------------------------------------------------------------------------------------
    
    
    func validateProfilePicture () -> Bool
    {
        var valid: Bool = true

         authServiceObject.delegate = self
        if profileImage == UIImage(named:"recipePlaceholder")
        {
            valid = false
            self.alertMessage = "Please select profile image."
        }
        
        return valid
    }
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 15 2017
    // Input Parameters :   N/A.
    // Purpose          :   Validate License Picture.
    //>--------------------------------------------------------------------------------------------------
    
    
    func validateLicensePicture () -> Bool
    {
        var valid: Bool = true
        if licenseImage == UIImage(named:"liciense_icon")
        {
            valid = false
            self.alertMessage = "Please select License image."
        }
        
        return valid
    }
    
    func validateIssuingIdentification() -> Bool
    {
        var valid: Bool = true
        if Singleton.instance.issuingCountry == "" ||  Singleton.instance.identificationType == "" || Singleton.instance.choosenTypeId == "" || Singleton.instance.identificationPhoto == nil 
        {
            valid = false
            Singleton.instance.issuingCountry = ""
            self.alertMessage = "Please Upload Identification."
        }
        
        return valid
    }
    
    
    func serviceProgress(progress: Float) {
        print ("this is my progress \(progress)")
        self.delegate?.uploadProgress(progress: progress)
    }
    
    
    func registerUser(completion: @escaping (_ message: String, _ success: Bool,  _ isEmailVarified: Bool)->Void){
        
        let lowerCaseEmail = userEmail.lowercased()
        
        //clear array
        imageData.removeAll()
        imageName.removeAll()
        
        //Role = 1 Cook
        //Role = 2 Customer
        
        let address: [String: String] = [
            STREET_KEY: streetAddress,
            CITY_KEY: city,
            STATE_KEY: state,
            ZIPCODE_KEY: zipcode,
            COUNTRY_KEY: country,
            LATITUDE_KEY: String(currentLocationLatitude), // 30.3565759311799
            LONGITUDE_KEY: String(currentLocationLongitute) // 78.0850118542611
        ]
        
        var photoIdentification = [String: String]()
        if Singleton.instance.issuingCountry != ""  && Singleton.instance.identificationType != "" && Singleton.instance.choosenTypeId != ""  && Singleton.instance.identificationPhoto != nil {
            photoIdentification[COUNTRY_KEY] = Singleton.instance.issuingCountry
            photoIdentification[TYPE_KEY] = Singleton.instance.identificationType
            photoIdentification[TYPE_ID_KEY] = Singleton.instance.choosenTypeId
            
            //Getting Image
            identificationImageData = UIImageJPEGRepresentation(Singleton.instance.identificationPhoto, 1.0)
            print(identificationImageData!)
        }
        
        
        
        if Singleton.instance.fbId != nil {
            
            var facebook = [String: String]()
            
            if Singleton.instance.fbEmail == nil {
                facebook = [
                    FACEBOOK_ID_KEY: Singleton.instance.fbId
                ]
            } else {
                facebook = [
                    FACEBOOK_ID_KEY: Singleton.instance.fbId,
                    FACEBOOK_EMAIL_ID_KEY:  Singleton.instance.fbEmail
                ]
            }
            
            
            detail[FACEBOOK_KEY] = facebook
        }
        
        
        user[EMAIL_KEY] = lowerCaseEmail
        user[FIRST_NAME_KEY] = firstname
        user[LAST_NAME_KEY] = lastname
        user[PASSWORD_KEY] = createPassword
        user[COUNTRY_CODE_KEY] = phoneCode
        user[PHONE_KEY] =  phoneNumber
        user[GENDER_KEY] = gender
        user[DRIVING_DISTANCE_KEY] = drivindDistance
        user[USER_ROLE_KEY] = 1
        user[ALLOW_NOTIFICATION_KEY] = 1
        user[DESCRIPTION_KEY] = introduceYourself
        
        print(user)
        
        detail[USER_KEY] = user
        detail[ADDRESS_KEY] = address
        
        //Checking user Fill Identification
        if Singleton.instance.issuingCountry != "" {
            detail[IDENTIFICATION_CARD_KEY] = photoIdentification
        }
       
        
        
        print(detail)
        //For Profile Image
        var profileData: Data? = nil
        if profileImage != nil{
           
            let image = profileImage.resizeImage(targetSize: CGSize(width: 200, height: 200))
            profileData = UIImageJPEGRepresentation(image, 1.0)
           
        }
        
        if profileData != nil {
            imageData.append(profileData!)
            imageName.append(PROFILE_KEY)
        }
        
        
        //For License Image
        var licenseData: Data? = nil
        if licenseImage != nil {
             licenseData = UIImageJPEGRepresentation(licenseImage, 1.0)
        }
        
        
        if licenseData != nil {
            imageData.append(licenseData!)
            imageName.append(CERTIFCATE_KEY)
        }
        
        //For user Identification
        if identificationImageData != nil {
            imageData.append(identificationImageData!)
            imageName.append(IDENTIFICATION_CARD_KEY)
        }
        
        
        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data"
        ]
        
        authServiceObject.delegate = self
        
        print(detail)
        
        authServiceObject.synPostMultipart(methodType: .post, url: BASE_URL_KEY + SIGNUP_KEY, parameters: detail, imageData: imageData, imageName: imageName, headers: headers) { (success, response) in
            
            print(response)
            if response["success"].boolValue {
                
                if response["data"]["user"]["isEmailAddressVerified"].boolValue {
                    
                    let token = response[DATA_KEY][TOKEN_KEY].stringValue
                    
                    //This Notiification fired in CustomerRegisterationMainVC
                    NotificationCenter.default.removeObserver(self, name: Notification.Name("NotificationShowHudForCook"), object: nil)
                    NotificationCenter.default.removeObserver(self, name: Notification.Name("NotificationHideHudForCook"), object: nil)
                    
                    let profileImageUrl = response[DATA_KEY][USER_KEY][PROFILE_URL_KEY].stringValue
                    let userRole = response[DATA_KEY][USER_KEY][USER_ROLE_KEY].stringValue
                    let userName = response[DATA_KEY][USER_KEY][FULL_NAME_KEY].stringValue
                    let userRegisterEmail = response[DATA_KEY][USER_KEY][EMAIL_KEY].stringValue
                    let userId = response[DATA_KEY][USER_KEY][ID_KEY].stringValue
                    let currencySymbol = response[DATA_KEY][USER_KEY][CURRENCY_SYMBOL_KEY].stringValue
                    
                    //Save data in user default.
                    Helper.saveUserDefaultValue(key: PROFILE_URL_KEY, value: profileImageUrl)
                    Helper.saveUserDefaultValue(key: USER_ROLE_KEY, value: userRole)
                    Helper.saveUserDefaultValue(key: FULL_NAME_KEY, value: userName)
                    Helper.saveUserDefaultValue(key: EMAIL_KEY, value: userRegisterEmail)
                    Helper.saveUserDefault(key: TOKEN_KEY, value: token)
                    Helper.saveUserDefaultValue(key: ID_KEY, value: userId)
                    Helper.saveUserDefaultValue(key: GUEST_KEY, value: "0")
                    Helper.saveUserDefaultValue(key: CURRENCY_SYMBOL_KEY, value: currencySymbol)
                    
                    completion("User Successfully Register.", true, true)
                    
                } else {
                    
                    //This Notiification fired in CustomerRegisterationMainVC
                    NotificationCenter.default.removeObserver(self, name: Notification.Name("NotificationShowHudForCook"), object: nil)
                    NotificationCenter.default.removeObserver(self, name: Notification.Name("NotificationHideHudForCook"), object: nil)
                    
                    let profileImageUrl = response[DATA_KEY][USER_KEY][PROFILE_URL_KEY].stringValue
                    let userRole = response[DATA_KEY][USER_KEY][USER_ROLE_KEY].stringValue
                    let userName = response[DATA_KEY][USER_KEY][FULL_NAME_KEY].stringValue
                    let userRegisterEmail = response[DATA_KEY][USER_KEY][EMAIL_KEY].stringValue
                    let userId = response[DATA_KEY][USER_KEY][ID_KEY].stringValue
                    let currencySymbol = response[DATA_KEY][USER_KEY][CURRENCY_SYMBOL_KEY].stringValue
                    let token = response[DATA_KEY][TOKEN_KEY].stringValue
                    self.authorizationString  = token
                    self.email = userRegisterEmail
                    self.id = userId
                    
                    //Save data in user default.
                    Helper.saveUserDefaultValue(key: PROFILE_URL_KEY, value: profileImageUrl)
                    Helper.saveUserDefaultValue(key: USER_ROLE_KEY, value: userRole)
                    Helper.saveUserDefaultValue(key: FULL_NAME_KEY, value: userName)
                    Helper.saveUserDefaultValue(key: EMAIL_KEY, value: userRegisterEmail)
                    //Helper.saveUserDefault(key: TOKEN_KEY, value: token)
                    Helper.saveUserDefaultValue(key: ID_KEY, value: userId)
                    Helper.saveUserDefaultValue(key: GUEST_KEY, value: "0")
                    Helper.saveUserDefaultValue(key: CURRENCY_SYMBOL_KEY, value: currencySymbol)
                    
                    completion("User Successfully Register.", true, false)
                    
                }
                
                
            } else {
                completion(response[ERROR_KEY]["message"].stringValue, false, false)
            }
        }
    }
}
