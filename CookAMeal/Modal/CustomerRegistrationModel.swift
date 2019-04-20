//
//  CustomerRegistrationModel.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 10/11/17.
//  Copyright © 2017 Cynoteck. All rights reserved.
//

import UIKit
import Alamofire



protocol CustomerRegisterationDelegate : class {
    func uploadProgress(progress: Float)
}


class CustomerRegistrationModel: NSObject, AuthServiceDelegate {
    
    
    

    var userEmail: String!
    var firstname: String!
    var lastname: String!
    var createPassword: String!
    var phoneNumber: String!
    var gender: String!
    var dietPreference: String!
    var streetAddress: String!
    var city: String!
    var state: String!
    var zipcode: String!
    var country: String!
    var alertMessage: String!
    var allergies = [String]()
    
    var profileImage: UIImage!
    var licenseImage: UIImage!
    
    var latitude: String!
    var longitude: String!
    
    var imageData = [Data]()
    var imageName = [String]()
    let authServiceObject:AuthServices = AuthServices()
    var identificationImageData: Data? = nil
    weak var delegate: CustomerRegisterationDelegate?

    
    var detail = [String: Any]()
    var user = [String: Any]()
    var phoneCode: String!
    var authorizationString: String!
    var email: String!
    var id: String!
   
    
    
    override init() {
        super.init()
        
        self.userEmail = ""
        self.firstname = ""
        self.lastname = ""
        self.createPassword = ""
        self.phoneNumber = ""
        self.gender = ""
        self.dietPreference = ""
        self.streetAddress = ""
        self.city = ""
        self.state = ""
        self.zipcode = ""
        self.country = ""
        self.phoneCode = ""
        
        
    }
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 10 2017
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
            self.alertMessage = "Email required."
        }
        else if !lowerCasedEmail.isValidEmail(){
            valid = false
            self.alertMessage = "Email is not correct."
        }
        
        return valid
    }
    
    
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 10 2017
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
    // Date             :   Nov, 10 2017
    // Input Parameters :   N/A.
    // Purpose          :   Validate the lastname textfield.
    //>---------------------------------------------------------------------------------------------------
    
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
    // Date             :   Nov, 10 2017
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
            self.alertMessage = "Password Should have two uppercase letters, one special character, digits, lowercase letters. Ensure string is of length 8."
        }
        
        return valid
    }
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 10 2017
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
    // Date             :   Nov, 10 2017
    // Input Parameters :   N/A.
    // Purpose          :   Validate the diet Preference textfield.
    //>--------------------------------------------------------------------------------------------------
    
    func validateDietPreference () -> Bool
    {
        var valid: Bool = true
        
        if self.dietPreference.isEmpty
        {
            valid = false
            self.alertMessage = "Diet Preference required"
        }
        
        return valid
    }
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 10 2017
    // Input Parameters :   N/A.
    // Purpose          :   Validate the streetAddress textfield.
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
    // Date             :   Nov, 10 2017
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
    // Date             :   Nov, 10 2017
    // Input Parameters :   N/A.
    // Purpose          :   Validate the Sate textfield.
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
    // Date             :   Nov, 10 2017
    // Input Parameters :   N/A.
    // Purpose          :   Validate the zipcode textfield.
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
            if self.zipcode.count > 0 && self.zipcode.count < 4
            {
                valid = false
                self.alertMessage = "Zipcode number is not correct."
            }
            else
            {
                valid = true
            }
        }
        
        
        return valid
    }
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 10 2017
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
    // Date             :   Nov, 15 2017
    // Input Parameters :   N/A.
    // Purpose          :   Validate Profile Picture.
    //>--------------------------------------------------------------------------------------------------
    
    
    func validateProfilePicture () -> Bool
    {
        var valid: Bool = true
        
        if profileImage == UIImage(named:"recipePlaceholder")
        {
            valid = false
            self.alertMessage = "Please select profile image."
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
    
    
    
    func registerUser(completion: @escaping (_ message: String, _ success: Bool, _ isEmailVarified: Bool)->Void){
        
        let lowerCaseEmail = userEmail.lowercased()
        
        //clear array
        imageData.removeAll()
        imageName.removeAll()
        
        
        let searchPredicate = NSPredicate(format: "selectionType MATCHES %@", "check")
        let allergies = (customerRegistrationConstant.AllergiesArray.allergiesName as NSArray).filtered(using: searchPredicate)
        
        var localAllergies = [String]()
        for (index, _) in allergies.enumerated() {
          
            if let pref = allergies[index] as? [String: Any] {
                localAllergies.append(pref["name"] as! String)
            }
            
        }
        
        print(localAllergies)
        let address: [String: Any] = [
            STREET_KEY: streetAddress as String,
            CITY_KEY: city as String,
            STATE_KEY: state as String,
            ZIPCODE_KEY: zipcode as String,
            COUNTRY_KEY: country as String,
            LATITUDE_KEY: String(currentLocationLatitude), // 30.3565759311799
            LONGITUDE_KEY: String(currentLocationLongitute)
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
        user[PHONE_KEY] = phoneNumber
        user[GENDER_KEY] = gender
        user[USER_ROLE_KEY] = 2
        user[DIET_PREFERENCE_KEY] = dietPreference as String
        user[ALLERGIES_KEY] = localAllergies
        user[ALLOW_NOTIFICATION_KEY] = 1
        
        detail[USER_KEY] = user
        detail[ADDRESS_KEY] = address
        
        //Checking user Fill Identification
        if Singleton.instance.issuingCountry != "" {
            detail[IDENTIFICATION_CARD_KEY] = photoIdentification
        }
        
        print(detail)
        
        var profileData: Data? = nil
        if profileImage != nil{
            let image = profileImage.resizeImage(targetSize: CGSize(width: 200, height: 200))
            profileData = UIImageJPEGRepresentation(image, 1.0)
        }
        
        if profileData != nil {
            imageData.append(profileData!)
            imageName.append(PROFILE_KEY)
        }
        
        if identificationImageData != nil {
            imageData.append(identificationImageData!)
            imageName.append(IDENTIFICATION_CARD_KEY)
        }
        
        
        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data"
        ]
        
        
        authServiceObject.delegate = self
        authServiceObject.synPostMultipart( methodType: .post, url: BASE_URL_KEY + SIGNUP_KEY, parameters: detail, imageData: imageData, imageName: imageName, headers: headers) { (success, response) in

            print(response)
            if response["success"].boolValue {

                if response["data"]["user"]["isEmailAddressVerified"].boolValue {
                    let token = response[DATA_KEY][TOKEN_KEY].stringValue
                    
                    //This Notiification fired in CustomerRegisterationMainVC
                    NotificationCenter.default.removeObserver(self, name: Notification.Name("NotificationShowHudForCustomer"), object: nil)
                    NotificationCenter.default.removeObserver(self, name: Notification.Name("NotificationHideHudForCustomer"), object: nil)
                    
                    let profileImageUrl = response[DATA_KEY][USER_KEY][PROFILE_URL_KEY].stringValue
                    let userType = response[DATA_KEY][USER_KEY][USER_TYPE_KEY].stringValue
                    let userRole = response[DATA_KEY][USER_KEY][USER_ROLE_KEY].stringValue
                    let userName = response[DATA_KEY][USER_KEY][FULL_NAME_KEY].stringValue
                    let userRegisterEmail = response[DATA_KEY][USER_KEY][EMAIL_KEY].stringValue
                    let userId = response[DATA_KEY][USER_KEY][ID_KEY].stringValue
                    let currencySymbol = response[DATA_KEY][USER_KEY][CURRENCY_SYMBOL_KEY].stringValue
                    
                    Helper.saveUserDefaultValue(key: ID_KEY, value: userId)
                    Helper.saveUserDefaultValue(key: PROFILE_URL_KEY, value: profileImageUrl)
                    Helper.saveUserDefaultValue(key: USER_TYPE_KEY, value: userType)
                    Helper.saveUserDefaultValue(key: USER_ROLE_KEY, value: userRole)
                    Helper.saveUserDefaultValue(key: FULL_NAME_KEY, value: userName)
                    Helper.saveUserDefaultValue(key: EMAIL_KEY, value: userRegisterEmail)
                    Helper.saveUserDefault(key: TOKEN_KEY, value: token)
                    Helper.saveUserDefaultValue(key: GUEST_KEY, value: "0")
                    Helper.saveUserDefaultValue(key: CURRENCY_SYMBOL_KEY, value: currencySymbol)
                    completion("User Successfully Register.", true,true)
                    
                } else {
                    
                    let token = response[DATA_KEY][TOKEN_KEY].stringValue
                    
                    //This Notiification fired in CustomerRegisterationMainVC
                    NotificationCenter.default.removeObserver(self, name: Notification.Name("NotificationShowHudForCustomer"), object: nil)
                    NotificationCenter.default.removeObserver(self, name: Notification.Name("NotificationHideHudForCustomer"), object: nil)
                    
                    let profileImageUrl = response[DATA_KEY][USER_KEY][PROFILE_URL_KEY].stringValue
                    let userType = response[DATA_KEY][USER_KEY][USER_TYPE_KEY].stringValue
                    let userRole = response[DATA_KEY][USER_KEY][USER_ROLE_KEY].stringValue
                    let userName = response[DATA_KEY][USER_KEY][FULL_NAME_KEY].stringValue
                    let userRegisterEmail = response[DATA_KEY][USER_KEY][EMAIL_KEY].stringValue
                    let userId = response[DATA_KEY][USER_KEY][ID_KEY].stringValue
                    let currencySymbol = response[DATA_KEY][USER_KEY][CURRENCY_SYMBOL_KEY].stringValue
                    self.authorizationString  = token
                    self.email = userRegisterEmail
                    self.id = userId
                    
                    Helper.saveUserDefaultValue(key: ID_KEY, value: userId)
                    Helper.saveUserDefaultValue(key: PROFILE_URL_KEY, value: profileImageUrl)
                    Helper.saveUserDefaultValue(key: USER_TYPE_KEY, value: userType)
                    Helper.saveUserDefaultValue(key: USER_ROLE_KEY, value: userRole)
                    Helper.saveUserDefaultValue(key: FULL_NAME_KEY, value: userName)
                    Helper.saveUserDefaultValue(key: EMAIL_KEY, value: userRegisterEmail)
                    Helper.saveUserDefaultValue(key: GUEST_KEY, value: "0")
                    Helper.saveUserDefaultValue(key: CURRENCY_SYMBOL_KEY, value: currencySymbol)
                    completion("User Successfully Register.", true,false)
                }
                
               
            } else{
                completion(response[ERROR_KEY][MESSAGE_KEY].stringValue, false,false)
            }
        }
    }
}
