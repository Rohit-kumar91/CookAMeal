//
//  Constant.swift
//  CookAMeal
//  Created by cynoteck Mac Mini on 27/10/17.
//  Copyright © 2017 Cynoteck. All rights reserved.
//

import Foundation
import SwiftyJSON

typealias CompletionHandler = (_ Success: Bool, _ response:JSON)->()
let COVER_PHOTO_URL = "coverPhotoUrl"
let GUEST_KEY = "guest"
let FACEBOOK_ID_KEY = "facebookId"
let FACEBOOK_EMAIL_ID_KEY = "facebookEmailId"
let FIRST_NAME_KEY = "firstName"
let LAST_NAME_KEY = "lastName"
let EMAIL_KEY = "email"
let GENDER_KEY = "gender"
let IMAGE_URL_KEY = "imageUrl"
let VERIFIED_KEY = "verified"
let MESSAGE_KEY = "message"
let ERROR_KEY = "error"
let DATA_KEY = "data"
let TOKEN_KEY = "token"
let SUCCESS_KEY = "success"
let USER_KEY = "user"
let USER_ROLE_KEY = "userRole"
let PROFILE_URL_KEY = "profileUrl"
let FULL_NAME_KEY = "fullName"
let ID_KEY = "id"
let HAS_PROFILE_KEY = "hasProfile"
let PROFILE_SELECTED_KEY = "profileSelected"
let TYPE_KEY = "type"
let STREET_KEY = "street"
let CITY_KEY = "city"
let STATE_KEY = "state"
let ZIPCODE_KEY = "zipCode"
let COUNTRY_KEY = "country"
let LATITUDE_KEY = "latitude"
let LONGITUDE_KEY = "longitude"
let TYPE_ID_KEY = "typeId"
let FACEBOOK_KEY = "facebook"
let PASSWORD_KEY = "password"
let PHONE_KEY = "phone"
let ALLOW_NOTIFICATION_KEY = "allowNotification"
let ADDRESS_KEY = "address"
let IDENTIFICATION_CARD_KEY = "identificationCard"
let PROFILE_KEY = "profile"
let CERTIFCATE_KEY = "certificate"
let USER_TYPE_KEY = "userType"
let DIET_PREFERENCE_KEY = "dietPreference"
let ALLERGIES_KEY = "allergies"
let USERNAME_KEY = "username"
let DESCRIPTION_KEY = "description"
let PROFILE2_KEY = "Profile"
let DRIVING_DISTANCE_KEY = "drivingDistance"
let CURRENCY_SYMBOL_KEY = "currencySymbol"
let CART_ITEMS_KEY = "CartItems"
let TOTAL_PRICE_KEY = "totalPrice"
let TOTAL_ITEMS_KEY = "totalItems"
let RECIPE_KEY = "Recipe"
let DISH_NAME_KEY = "dishName"
let AVAILABLE_SERVING_KEY = "availableServings"
let COOK_KEY = "Cook"
let CATEGORY_NAME_KEY = "categoryName"
let DELIVERY_FEE_KEY = "deliveryFee"
let SPICE_LEVEL_KEY = "spiceLevel"
let NO_OF_SERVING_KEY = "noOfServing"
let PRICE_KEY = "price"
let MEDIA_OBJECTS_KEY = "MediaObjects"
let COST_PER_SERVING_KEY = "costPerServing"
let START_TIME_KEY = "startTime"
let END_TIME_KEY = "endTime"
let DATE_KEY = "date"
let FAVORITE_KEY = "favorite"
let RECIPE_ID_KEY = "recipeId"
let STATUS_KEY = "status"
let COUNTRY_CODE_KEY = "countryCode"


//Segue
let TO_LOGIN = "toLogin"
let To_Login_Varification = "toLoginVarification"

//User Defaults
let LOGGED_IN_KEY = "loggedIn"
let USER_EMAIL = "userEmail"


//Header
let HEADER = [
    "Content-Type": "application/json"
]


let AUTHORIZATION_KEY = "Authorization"


//Base Url
let BASE_URL_KEY = "https://api.domesticeat.com/api/"

 
//local Url
//Suri
//let BASE_URL_KEY = "http://192.168.5.126:8081/api/"

// upload IdentificationCard110
let identificationCardUrl = "cook/identificationCard"

//Login
let LOGIN_KEY = "authenticate"

//Dashboard
let COMMON_CATEGORY = "common/category"

//Reset Password
let CHANGE_PASSWORD = "auth/change-password"

//Facebook SignIN
let FACEBOOK_SIGN = "fbsign"

//Reset Password
let FORGOT_PASSWORD = "forgot-password"

//Guest Login
let GUEST_LOGIN_KEY = "guest-login"

//Sign Up
let SIGNUP_KEY = "signup"

//let key_ApiAuth = "auth/"
let key_Favorite_Recipe = "auth/favorite/recipe"
//http://192.168.5.110:8081/api/common/order/order-summary/992f7c17-39b1-4991-9cb5-04cc91a23d09
let key_Prepare_Order_Data = "common/order/order-summary/"
let key_Order_Check_Out = "auth/order/check-out"


//Edamam Nutrition API
let Edamam_Application_ID = "16ed664a"
let Edamam_Application_Keys = "86a7b11fec76dda8011b6eb5fe299fab"
let Edamam_GetNutrition_url = "https://api.edamam.com/api/nutrition-details?app_id=" + Edamam_Application_ID + "&app_key=" + Edamam_Application_Keys


//Spice Level
let SPICE_LEVEL = ["Mild", "Medium", "Hot"]
let HIRE_COOK = "HireCook"
let ORDER_FOOD = "OrderFood"



//Profile
let PROFILE_COVER_URL_KEY = "auth/profile-cover"
let PROFILE_IMAGE_URL_KEY = "auth/profile-image"
let ID_TYPE_ARRAY = ["Voter ID","Passport","Driver License"]


struct PROGRESS_HUD {
    static let HUD_LABEL_KEY = "Loading"
}


struct LOGIN_CONSTANT {
    static let LOGIN_KEY = "authenticate"
    static let PASSWORD_MESSAGE_KEY = "Enter your password."
    static let EMAIL_AUTHENTICATION_MESSAGE_KEY = "Incorrect email address."
    static let EMAIL_MISSING_KEY = "Enter your email address."
    static let USERNAME_KEY = "username"
    static let LOGIN_SUCCESS = "Successfully Login"
    static let ALERT_HEADER_MESSAGE_KEY = "DomesticEat"
}


struct ALERT_TITLE
{
    static let APP_NAME = "DomesticEat"
}


struct customerRegistrationConstant {
    struct dietPreferenceArray
    {
        static let dietType = ["Vegetarian","Non-Vegetarian","Vegan"]
    }
    
    struct AllergiesArray
    {
    
        static var allergiesName = [["name" : "Milk", "selectionType" : "uncheck"],
                                    ["name" : "Eggs", "selectionType" : "uncheck"],
                                    ["name" : "Fish(e.g, bass, flounder, cod)", "selectionType" : "uncheck"],
                                    ["name" : "Crustacean Shellfish", "selectionType" : "uncheck"],
                                    ["name" : "Tree nuts(e.g, almonds, walnuts, pecans)", "selectionType" : "uncheck"],
                                    ["name" : "Peanuts", "selectionType" : "uncheck"],
                                    ["name" : "Wheat", "selectionType" : "uncheck"],
                                    ["name" : "Soyabeans", "selectionType" : "uncheck"]]
    }
}




struct cookRegistrationConstant {
        static let drivingDistance = ["3","5","7","10","12","15","20","25"]
}



struct sliderConstant {
    
    static var sliderCustomerArray = [["name" : "Home", "imageName" : "Home"],
                              ["name" : "Order", "imageName" : "current_order_icon"],
                              ["name" : "Calendar", "imageName" : "payment_history_icon"],
                              ["name" : "Reviews", "imageName" : "reviews_icon"],
                              ["name" : " Profile", "imageName" : "my_profile_icon"],
                              ["name" : "Favorite", "imageName" : "wishList_icon"],
                              ["name" : "Cart", "imageName" : "myCart"],
                              ["name" : "Notifications", "imageName" : "notification_icon"],
                              ["name" : "Give Us Feedback", "imageName" : "feedback_icon"],
                              ["name" : "Change Password", "imageName" : "passwordIcon"],
                              ["name" : "Get Help", "imageName" : "help_icon"],
                              ["name" : "Sign Out", "imageName" : "signout_icon"]]
    
    
    
    static var sliderArray = [["name" : "Home", "imageName" : "Home"],
                              ["name" : "Recipes", "imageName" : "recipes_icon"],
                              ["name" : "Order", "imageName" : "current_order_icon"],
                              ["name" : "Calendar", "imageName" : "payment_history_icon"],
                              ["name" : "Reviews", "imageName" : "reviews_icon"],
                              ["name" : " Profile", "imageName" : "my_profile_icon"],
                              ["name" : "Favorite", "imageName" : "wishList_icon"],
                              ["name" : "Cart", "imageName" : "myCart"],
                              ["name" : "Notifications", "imageName" : "notification_icon"],
                              ["name" : "Give Us Feedback", "imageName" : "feedback_icon"],
                              ["name" : "Change Password", "imageName" : "passwordIcon"],
                              ["name" : "Get Help", "imageName" : "help_icon"],
                              ["name" : "Sign Out", "imageName" : "signout_icon"]]
    
    
    static var sliderGuestArray = [["name" : "Home", "imageName" : "Home"],
                              ["name" : "Order", "imageName" : "current_order_icon"], 
                              ["name" : "Calendar", "imageName" : "payment_history_icon"],
                              ["name" : "Reviews", "imageName" : "reviews_icon"],
                              ["name" : " Profile", "imageName" : "my_profile_icon"],
                              ["name" : "Cart", "imageName" : "myCart"],
                              ["name" : "Notifications", "imageName" : "notification_icon"],
                              ["name" : "Give Us Feedback", "imageName" : "feedback_icon"],
                              ["name" : "Get Help", "imageName" : "help_icon"],
                              ["name" : "Sign In", "imageName" : "signIn"]]
}





