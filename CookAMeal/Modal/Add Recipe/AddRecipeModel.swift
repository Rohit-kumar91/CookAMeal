 //
//  AddRecipeModel.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 01/12/17.
//  Copyright © 2017 Cynoteck. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire


class AddRecipeModel: NSObject {
    
    var nameOfDish: String!
    var ingredientArray:[[String: String]]!
    var preparationMethod: String!
    var preparationTime: String!
    var cookTime: String!
    var category: String!
    var categoryId: String!
    var subCategory: String!
    var subCategoryId: String!
    var searchableTagsArray:[String]!
    
    var costPerServing: String!
    var availableServing: String!
    var orderDateTime: String!
    var pickDateTime: String!
    var deliveryFee: String!
    var serve: String!
    var eligibleFor: String!
    var tagString: String!
    var foodType: String!
    
    var alertMessage: String!
    let authServiceObject:AuthServices = AuthServices()
    var commonCategoryArray = [JSON]()
    var commonCategoryNameArray = [String]()
    
    var subcategoryArray = [JSON]()
    var subCategoryNameArray = [String]()
    
    var recipeImage = [UIImage]()
    var recipeImageData = [Data]()
    var editRecipeResponse = JSON()
    var editRecipeImage = [JSON]()
    var editIngredientArray = [JSON]()
    
  
    

    //Days Array
    var daysArray = [["dayName": "sun", "selected": 0],
                     ["dayName": "mon", "selected": 0],
                     ["dayName": "tue", "selected": 0],
                     ["dayName": "wed", "selected": 0],
                     ["dayName": "thu", "selected": 0],
                     ["dayName": "fri", "selected": 0],
                     ["dayName": "sat", "selected": 0]]
    
    
    //food Type
    var foodTypeArray = ["Veg", "Non-Veg"]
    
    
    
    //update field
    var updateRecipeName: String?
    var updatePreparationTime: String?
    var updateCookTime: String?
    var updateCategory: String?
    var updateSubcategory: String?
    var updateServe: String?
    var updateCostPerServing: String?
    var updateAvailableServing: String?
    var updateOrderByDateTime: String?
    var updatePickUpDatetime: String?
    var updateDeliveryFee: String?
    var updateFoodType: String?
    var updateEligibleFor: String?
    var updateIngredientArray: [[String: String]]?
    var updatePreparationMethod: [[String: String]]?

    override init() {
        super.init()
        
        self.nameOfDish = ""
        self.preparationMethod = ""
        self.preparationTime = ""
        self.cookTime = ""
        self.category = ""
        self.subCategory = ""
        self.costPerServing = ""
        self.availableServing = ""
        self.orderDateTime = ""
        self.pickDateTime = ""
        self.deliveryFee = ""
        self.serve = ""
        self.eligibleFor  = ""
        self.alertMessage = ""
        self.foodType = ""
        
    }
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 30 2017
    // Input Parameters :   N/A.
    // Purpose          :   Validate the Serve textfield.
    //>--------------------------------------------------------------------------------------------------
    func serveDishValidate () -> Bool
    {
        var valid: Bool = true
        if self.serve.isEmpty
        {
            valid = false
            self.alertMessage = "Serve is empty."
        }
        
        return valid
    }
    
    
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 30 2017
    // Input Parameters :   N/A.
    // Purpose          :   Validate the name of dish textfield.
    //>--------------------------------------------------------------------------------------------------
    func nameOfDishValidate () -> Bool
    {
        var valid: Bool = true
        if self.nameOfDish.isEmpty
        {
            valid = false
            self.alertMessage = "Dish name is empty."
        }
        
        return valid
    }
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 30 2017
    // Input Parameters :   N/A.
    // Purpose          :   Validate the Preparation Method textfield.
    //>--------------------------------------------------------------------------------------------------
    func ingredientsMethodValidate () -> Bool
    {
        var valid: Bool = true
        if Singleton.instance.ingredientFinalArray.count == 0
        {
            valid = false
            self.alertMessage = "Ingredient are empty."
        }
        
        return valid
    }
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 30 2017
    // Input Parameters :   N/A.
    // Purpose          :   Validate the Preparation Method textfield.
    //>--------------------------------------------------------------------------------------------------
    func preparationMethodValidate () -> Bool
    {
        var valid: Bool = true
        if Singleton.instance.prepartionMethodStrArray.count == 0
        {
            valid = false
            self.alertMessage = "Preparation Method is empty."
        }
        
        return valid
    }
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 30 2017
    // Input Parameters :   N/A.
    // Purpose          :   Validate the Preparation Time textfield.
    //>--------------------------------------------------------------------------------------------------
    func preparationTimeValidate () -> Bool
    {
        var valid: Bool = true
        if self.preparationTime.isEmpty
        {
            valid = false
            self.alertMessage = "Preparation Time is empty."
        }
//        else if self.preparationTime.isTimeValid {
//
//            valid = false
//            self.alertMessage = "Preparation Time is not valid."
//        }
        
        return valid
    }
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 30 2017
    // Input Parameters :   N/A.
    // Purpose          :   Validate the Cook Time textfield.
    //>--------------------------------------------------------------------------------------------------
    func cookTimeValidate () -> Bool
    {
        var valid: Bool = true
        if self.cookTime.isEmpty
        {
            valid = false
            self.alertMessage = "Cook Time is empty."
            
        }
        
//        else if self.cookTime.isTimeValid {
//
//            valid = false
//            self.alertMessage = "Preparation Time is not valid."
//        }
        
        return valid
    }
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 30 2017
    // Input Parameters :   N/A.
    // Purpose          :   Validate the Category textfield.
    //>--------------------------------------------------------------------------------------------------
    func categoryValidate () -> Bool
    {
        var valid: Bool = true
        if self.category.isEmpty
        {
            valid = false
            self.alertMessage = "Category is empty."
        }
        
        return valid
    }
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 30 2017
    // Input Parameters :   N/A.
    // Purpose          :   Validate the Sub Category textfield.
    //>--------------------------------------------------------------------------------------------------
    func subCategoryValidate () -> Bool
    {
        var valid: Bool = true
        if self.subCategory.isEmpty
        {
            valid = false
            self.alertMessage = "Sub Category is empty."
        }
        
        return valid
    }
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 30 2017
    // Input Parameters :   N/A.
    // Purpose          :   Validate the Searchable textfield.
    //>--------------------------------------------------------------------------------------------------
    func searchableTagValidate () -> Bool
    {
        var valid: Bool = true
        if self.searchableTagsArray.count == 0
        {
            valid = false
            self.alertMessage = "Searchable Tag is empty."
        }
        
        return valid
    }
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 30 2017
    // Input Parameters :   N/A.
    // Purpose          :   Validate the Cost per serving textfield.
    //>--------------------------------------------------------------------------------------------------
    func costPerServingValidate () -> Bool
    {
        var valid: Bool = true
        if self.costPerServing.isEmpty
        {
            valid = false
            self.alertMessage = "Cost Per Serving is empty."
        }
        return valid
    }
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 30 2017
    // Input Parameters :   N/A.
    // Purpose          :   Validate the Available serving textfield.
    //>--------------------------------------------------------------------------------------------------
    func availableServingValidate () -> Bool
    {
        var valid: Bool = true
        if self.availableServing.isEmpty
        {
            valid = false
            self.alertMessage = "Available Per Serving is empty."
        }
        return valid
    }
    
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 30 2017
    // Input Parameters :   N/A.
    // Purpose          :   Validate the Order date/time textfield.
    //>--------------------------------------------------------------------------------------------------
    func orderDateTimeValidate () -> Bool
    {
        var valid: Bool = true
        if self.orderDateTime.isEmpty
        {
            valid = false
            self.alertMessage = "Order Date Time is empty."
        }
        return valid
    }
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 30 2017
    // Input Parameters :   N/A.
    // Purpose          :   Validate Food type.
    //>--------------------------------------------------------------------------------------------------
    func foodTypeValidate () -> Bool
    {
        var valid: Bool = true
        if self.foodType.isEmpty
        {
            valid = false
            self.alertMessage = "Food type is empty."
        }
        return valid
    }
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 30 2017
    // Input Parameters :   N/A.
    // Purpose          :   Validate the Pick date/time textfield.
    //>--------------------------------------------------------------------------------------------------
    func pickDateTimeValidate () -> Bool
    {
        var valid: Bool = true
        if self.pickDateTime.isEmpty
        {
            valid = false
            self.alertMessage = "Pick Date Time is empty."
        }
        return valid
    }
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 30 2017
    // Input Parameters :   N/A.
    // Purpose          :   Validate the delivery fee textfield.
    //>--------------------------------------------------------------------------------------------------
    func deliveryFeeValidate () -> Bool
    {
        var valid: Bool = true
        if self.deliveryFee.isEmpty
        {
            valid = false
            self.alertMessage = "Delivery Fee is empty."
        }
        return valid
    }
    
    
    
    
    func getEditRecipeData(recipeId: String, completion: @escaping (_ success: Bool)->Void) {
        
        let header: [String: String] = [
            AUTHORIZATION_KEY : Helper.getUserDefault(key: TOKEN_KEY)!
        ]
        
        
        authServiceObject.synGetMethod(url: BASE_URL_KEY + "cook/edit/recipe/" + recipeId, header: header) { (success, response) in
            print(response)

            if success {
                
                self.editRecipeResponse = response["data"]
                print(self.editRecipeResponse["id"].stringValue)
                Singleton.instance.preparationRecipeId = self.editRecipeResponse["id"].stringValue
                
                let eligibleType: String?  =  response["data"]["eligibleFor"].stringValue
                
                if let someValue = eligibleType {
                    print(someValue)
                    self.eligibleFor = someValue
                }
                
                //Dish Name
                self.nameOfDish = response["data"]["dishName"].stringValue
                
                //Ingredient
                self.editIngredientArray = response["data"]["Ingredients"].arrayValue
                
                
                
                
                //Preperation Method.
                for preperationMethod in response["data"]["PreparationMethods"].arrayValue {
                    let tempPreperation = [
                        "method" : preperationMethod["method"].stringValue,
                        "id" :  preperationMethod["id"].stringValue
                    ]
                    
                    Singleton.instance.prepartionMethodStrArray.append(tempPreperation)
                }
                
                //Perperation Time
                self.preparationTime = response["data"]["preparationTime"].stringValue
                
                //Cook Time
                self.cookTime = response["data"]["cookTime"].stringValue
                
                //CategoryId
                self.categoryId = response["data"]["categoryId"].stringValue
                
                //SubCategoryId
                self.subCategoryId = response["data"]["subCategoryId"].stringValue
                
                //Serve
                self.serve = response["data"]["serve"].stringValue
                
                //SearchableTag
                let searchableTags = response["data"]["tags"].stringValue
                let newString = searchableTags.replacingOccurrences(of: "[", with: "", options: .literal, range: nil)
                let secondNewString = newString.replacingOccurrences(of: "]", with: "", options: .literal, range: nil)
                
                print(secondNewString)
                
                let finalString = secondNewString.replacingOccurrences(of: "\"", with: "", options: .literal, range: nil)
                print(finalString)
                self.tagString = finalString
               
                let array =  self.tagString.components(separatedBy: ", ")
                Singleton.instance.searchableTagsArray = array
                self.searchableTagsArray = array
                print(array)
                
                //recipeImages
                self.editRecipeImage = response["data"]["MediaObjects"].arrayValue
                
                //Cost Per Serving
                self.costPerServing = response["data"]["costPerServing"].stringValue
                
                //Available Serving
                self.availableServing = response["data"]["availableServings"].stringValue
                
                //OrderByDateTime
                self.orderDateTime = response["data"]["orderByDateTime"].stringValue
                
                //PickupByDateTime
                self.pickDateTime = response["data"]["pickUpByDateTime"].stringValue
                
                //Delivery Fee
                self.deliveryFee = response["data"]["deliveryFee"].stringValue
                
                //food type
                self.foodType = response["data"]["foodType"].stringValue
                
                
                //Days Array
                //Sunday
                if response["data"]["Day"]["sun"].boolValue {
                    let daytemp : [String : Any] =  ["dayName": "sun",
                                   "selected": 1]
                    self.daysArray[0] = daytemp
                } else {
                    let daytemp : [String : Any] =  ["dayName": "sun",
                                                     "selected": 0]
                    self.daysArray[0] = daytemp
                }
                
                //Monday
                if response["data"]["Day"]["mon"].boolValue {
                    let daytemp : [String : Any] =  ["dayName": "mon",
                                                     "selected": 1]
                    self.daysArray[1] = daytemp
                } else {
                    let daytemp : [String : Any] =  ["dayName": "mon",
                                                     "selected": 0]
                    self.daysArray[1] = daytemp
                }
                
                //Tuesday
                if response["data"]["Day"]["tue"].boolValue {
                    let daytemp : [String : Any] =  ["dayName": "tue",
                                                     "selected": 1]
                    self.daysArray[2] = daytemp
                } else {
                    let daytemp : [String : Any] =  ["dayName": "tue",
                                                     "selected": 0]
                    self.daysArray[2] = daytemp
                }
                
                //Wednesday
                if response["data"]["Day"]["wed"].boolValue {
                    let daytemp : [String : Any] =  ["dayName": "wed",
                                                     "selected": 1]
                    self.daysArray[3] = daytemp
                } else {
                    let daytemp : [String : Any] =  ["dayName": "wed",
                                                     "selected": 0]
                    self.daysArray[3] = daytemp
                }
                
                //Thursday
                if response["data"]["Day"]["thu"].boolValue {
                    let daytemp : [String : Any] =  ["dayName": "thu",
                                                     "selected": 1]
                    self.daysArray[4] = daytemp
                } else {
                    let daytemp : [String : Any] =  ["dayName": "thu",
                                                     "selected": 0]
                    self.daysArray[4] = daytemp
                }
                
                //Friday
                if response["data"]["Day"]["fri"].boolValue {
                    let daytemp : [String : Any] =  ["dayName": "fri",
                                                     "selected": 1]
                    self.daysArray[5] = daytemp
                } else {
                    let daytemp : [String : Any] =  ["dayName": "fri",
                                                     "selected": 0]
                    self.daysArray[5] = daytemp
                }
                
                //Saturday
                if response["data"]["Day"]["sat"].boolValue {
                    let daytemp : [String : Any] =  ["dayName": "sat",
                                                     "selected": 1]
                    self.daysArray[6] = daytemp
                } else {
                    let daytemp : [String : Any] =  ["dayName": "sat",
                                                     "selected": 0]
                    self.daysArray[6] = daytemp
                }
                
                
                print(self.daysArray)
                
                
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
    
    
    
    
    func getCategory(completion: @escaping (_ success: Bool)->Void) {
        
        let header: [String: String] = [
            AUTHORIZATION_KEY : Helper.getUserDefault(key: TOKEN_KEY)!
        ]
        
        authServiceObject.synGetMethod(url: BASE_URL_KEY + COMMON_CATEGORY, header: header) { (success, response) in
            
            print(success)
            
            if success {
                
                print(response)
                self.commonCategoryArray = response[DATA_KEY].arrayValue
                for elements in self.commonCategoryArray {
                    self.commonCategoryNameArray.append(elements["name"].stringValue)
                }
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
    
    
    
    func getSubCategory(completion: @escaping (_ success: Bool)->Void) {
        let header: [String: String] = [
            AUTHORIZATION_KEY : Helper.getUserDefault(key: TOKEN_KEY)!
        ]
        
        authServiceObject.synGetMethod(url: BASE_URL_KEY + "auth/subcategory", header: header) { (success, response) in
            
            if success {
                
                print(response)
                self.subcategoryArray = response[DATA_KEY].arrayValue
                for elements in self.subcategoryArray {
                    self.subCategoryNameArray.append(elements["name"].stringValue)
                }
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
    
    
  
    
        
    func addRecipe(completion: @escaping (_ success: Bool)->Void) {
        
        recipeImageData.removeAll()
        
        //Getting Ingredient
        let ingredientjsonData = try? JSONSerialization.data(withJSONObject: Singleton.instance.ingredientFinalArray, options: JSONSerialization.WritingOptions())
        let ingredientArray = NSString(data: ingredientjsonData!, encoding: String.Encoding.utf8.rawValue)
        
        
        //Getting the Selected Days.
        var tempSelectedDays =  [String: Any]()
        for (index, _) in daysArray.enumerated(){
            if daysArray[index]["selected"] as! Int == 1{
                tempSelectedDays[daysArray[index]["dayName"]! as! String] = daysArray[index]["selected"]!
            }
        }
        
        let servingDaysjsonData = try? JSONSerialization.data(withJSONObject: tempSelectedDays, options: JSONSerialization.WritingOptions())
        let servingDaysArray = NSString(data: servingDaysjsonData!, encoding: String.Encoding.utf8.rawValue)
        
        
        //Getting Alergied Data.
       
        var tempSelectedAllergiesArray = [[String: Any]]()
        print(Singleton.instance.ingredientAllergiesArray)
        
        for (index, _) in Singleton.instance.ingredientAllergiesArray.enumerated(){
            var tempSelectedAllergies =  [String: Any]()
            if Singleton.instance.ingredientAllergiesArray[index]["selected"]  == "1" {
                tempSelectedAllergies["allergyId"] = Singleton.instance.ingredientAllergiesArray[index][ID_KEY]!
                tempSelectedAllergiesArray.append(tempSelectedAllergies)
            }
        }
        
        print(tempSelectedAllergiesArray)
        
        let allergiesJsonData = try? JSONSerialization.data(withJSONObject: tempSelectedAllergiesArray, options: JSONSerialization.WritingOptions())
        let finalAllergiesArray = NSString(data: allergiesJsonData!, encoding: String.Encoding.utf8.rawValue)
               
        let preprationJsonData = try? JSONSerialization.data(withJSONObject: Singleton.instance.prepartionMethodStrArray, options: JSONSerialization.WritingOptions())
        let finalPreprationArray = NSString(data: preprationJsonData!, encoding: String.Encoding.utf8.rawValue)
        
        
        Helper.dateTime(dateTime: orderDateTime) { (success, date) in
            if success {
                print("helper date\(date)")
            } else {
                print("Invalid date")
            }
        }
        
        
        var addRecipeParameterDict = [String: Any]()
        addRecipeParameterDict = [
        
            "dishName": nameOfDish as String,
            
            "preparationMethod": finalPreprationArray! as String,
            
            "categoryId": categoryId as String,
            
            "subCategoryId": subCategoryId as String,
            
            "tags": Singleton.instance.searchableTagsArray as [String],
            
            "costPerServing": costPerServing as String,
            
            "availableServings": availableServing as String,
            
            "orderByDateTime": dateTime(date: orderDateTime) as String,  // orderDateTime
            
            "pickUpByDateTime": dateTime(date: pickDateTime) as String,  // pickDateTime
            
            "deliveryFee": deliveryFee as String,
            
            "foodType": foodType! as String,
            
            "totalCostOfIngredients": Singleton.instance.totalCostOfIngredient,
            
            "ingredients": ingredientArray! as String,
            
            "servingDays": servingDaysArray! as String,
            
            "baseAllergies": finalAllergiesArray! as String,
            
            "serve": serve as String,
            
            "eligibleFor": eligibleFor as String
            
            ]
        
        
        if eligibleFor == "1" || eligibleFor == "3" {
            addRecipeParameterDict["preparationTime"] = preparationTime as String
            addRecipeParameterDict["cookTime"] = cookTime as String
            
        } 
        
        print(addRecipeParameterDict)
        
        for image in recipeImage {
            let image = image.resizeImage(targetSize: CGSize(width: 400, height: 400))
            recipeImageData.append(UIImageJPEGRepresentation(image, 1.0)!)
        }
        
        
        let headers: HTTPHeaders = [
            AUTHORIZATION_KEY : Helper.getUserDefaultValue(key: TOKEN_KEY)!,
            "Content-type": "multipart/form-data"
        ]
        
        authServiceObject.synPostMultipartWithDifferentWithSeperatedKeys(methodType: .post, url: BASE_URL_KEY + "cook/recipe", parameters: addRecipeParameterDict, imageData: recipeImageData, imageName: ["recipe"], headers: headers) { (success, response) in
            
            if success {
                print(response)
                
                if !response["success"].boolValue {
                    self.alertMessage = response[ERROR_KEY]["message"].stringValue
                    if (self.alertMessage == nil) {
                        self.alertMessage = response[ERROR_KEY].stringValue
                    }
                    completion(false)
                } else {
                    self.alertMessage = response[DATA_KEY][MESSAGE_KEY].stringValue
                    completion(true)
                }
                
            }else {
                print(response)
                self.alertMessage = response[ERROR_KEY]["message"].stringValue
                if (self.alertMessage == nil) {
                    self.alertMessage = response[ERROR_KEY].stringValue
                }
                print(self.alertMessage)
                completion(false)
            }
        }
    }
    
    
    
    func uploadEditImage(recipeId: String, mediaObjectId: String, completion: @escaping (_ success: Bool)->Void) {
        
        for image in recipeImage {
            let image = image.resizeImage(targetSize: CGSize(width: 400, height: 400))
            recipeImageData.append(UIImageJPEGRepresentation(image, 1.0)!)
        }
        
        
        let headers: HTTPHeaders = [
            AUTHORIZATION_KEY : Helper.getUserDefaultValue(key: TOKEN_KEY)!,
            "Content-type": "multipart/form-data"
        ]
        
        
        //http://192.168.5.126:8081/api/cook/recipe-image/:recipeId/:mediaObjectId
        authServiceObject.synPostMultipartWithDifferentWithSeperatedKeys(methodType: .post, url: BASE_URL_KEY + "/cook/recipe-image/" + recipeId + "/" + mediaObjectId, parameters: [:], imageData: recipeImageData, imageName: ["recipe"], headers: headers) { (success, response) in
            
            if success {
                print(response)
                
                if !response["success"].boolValue {
                    self.alertMessage = response[ERROR_KEY]["message"].stringValue
                    if (self.alertMessage == nil) {
                        self.alertMessage = response[ERROR_KEY].stringValue
                    }
                    completion(false)
                } else {
                    self.alertMessage = response[DATA_KEY][MESSAGE_KEY].stringValue
                    completion(true)
                }
                
            } else {
                print(response)
                self.alertMessage = response[ERROR_KEY]["message"].stringValue
                if (self.alertMessage == nil) {
                    self.alertMessage = response[ERROR_KEY].stringValue
                }
                print(self.alertMessage)
                completion(false)
            }
        }
    }
    
    
    
    func editRecipe(  recipeId: String, completion: @escaping (_ success: Bool)->Void) {
        
        var editRecipeParameterDict = [String: Any]()
        
        //Elgible for
        if let updateEligibleFor = updateEligibleFor {
            editRecipeParameterDict["eligibleFor"] = updateEligibleFor
            
            if updateEligibleFor == "1" || updateEligibleFor == "2" {
                updateCookTime = nil
                updatePreparationTime = nil
            }
            
        }
        
        //Recipe name
        if let updateRecipeName = updateRecipeName {
             editRecipeParameterDict["dishName"] = updateRecipeName
        }
        
        //PreparationTime
        if let updatePreparationTime = updatePreparationTime {
            editRecipeParameterDict["preparationTime"] = updatePreparationTime
        }
        
        //Cook Time
        if let updateCookTime = updateCookTime {
            editRecipeParameterDict["cookTime"] = updateCookTime
        }
        
        //Serve
        if let updateServe = updateServe {
            editRecipeParameterDict["serve"] = updateServe
        }
        
        //Cost Per Serving
        if let updateCostServing = updateCostPerServing {
            editRecipeParameterDict["costPerServing"] = updateCostServing
        }
        
        //Avaialable Serving
        if let updateAvailableServing = updateAvailableServing {
            editRecipeParameterDict["availableServings"] = updateAvailableServing
        }
        
        //orderByDateTime
        if let updateOrderByDateTime = updateOrderByDateTime {
            editRecipeParameterDict["orderByDateTime"] = updateOrderByDateTime
        }
        
        //pickUpByDateTime
        if let updatePickUpByDateTime = updatePickUpDatetime {
            editRecipeParameterDict["pickUpByDateTime"] = updatePickUpByDateTime
        }
        
        //Delivery Fee
        if let updateDeliveryFee = updateDeliveryFee {
            editRecipeParameterDict["deliveryFee"] = updateDeliveryFee
        }
        
        //Ingredient
        if let inregredient = updateIngredientArray {
            editRecipeParameterDict["ingredients"] = inregredient
        }
        
        
        //Preparation Method
        if let preparationMethod =  updatePreparationMethod {
            editRecipeParameterDict["preparationMethod"] = preparationMethod
        }
        
        //Food type
        if let foodType = updateFoodType {
            editRecipeParameterDict["foodType"] = foodType
        }
        
        
        
        //Getting the Selected Days.
        var tempSelectedDays =  [String: Any]()
        for (index, _) in daysArray.enumerated(){
            if daysArray[index]["selected"] as! Int == 1{
                tempSelectedDays[daysArray[index]["dayName"]! as! String] = daysArray[index]["selected"]!
            }
        }
        
        let servingDaysjsonData = try? JSONSerialization.data(withJSONObject: tempSelectedDays, options: JSONSerialization.WritingOptions())
        let servingDaysArray = NSString(data: servingDaysjsonData!, encoding: String.Encoding.utf8.rawValue)
         editRecipeParameterDict["servingDays"] = servingDaysArray
        
        
        
        
        let finalEditDict = [
            "newRecipeData" : editRecipeParameterDict
        ]

        
        print("Final Dict\(finalEditDict)")
        print(editRecipeParameterDict)

        let headers: HTTPHeaders = [
            AUTHORIZATION_KEY : Helper.getUserDefaultValue(key: TOKEN_KEY)!,
             "Content-Type": "application/json"
        ]
        //http://192.168.5.126:8081/api/cook/edit/recipe/:recipeId
        authServiceObject.synPutMethod(url: BASE_URL_KEY + "cook/edit/recipe/" + recipeId, parameter: finalEditDict, header: headers) { (success, response) in
            
            if success {
                print(response)
                
                if !response["success"].boolValue {
                    
                    self.updateRecipeName = nil
                    self.updateServe = nil
                    self.updateCategory = nil
                    self.updateCookTime = nil
                    self.updateDeliveryFee = nil
                    self.updateSubcategory = nil
                    self.updateCostPerServing = nil
                    self.updatePickUpDatetime = nil
                    self.updateEligibleFor = nil
                    self.updateFoodType = nil
                    
                    self.alertMessage = response[ERROR_KEY]["message"].stringValue
                    if (self.alertMessage == nil) {
                        self.alertMessage = response[ERROR_KEY].stringValue
                    }
                    completion(false)
                    
                } else {
                    self.alertMessage = response[DATA_KEY][MESSAGE_KEY].stringValue
                    completion(true)
                }
                
            }else {
                print(response)
                self.alertMessage = response[ERROR_KEY]["message"].stringValue
                if (self.alertMessage == nil) {
                    self.alertMessage = response[ERROR_KEY].stringValue
                }
                print(self.alertMessage)
                completion(false)
            }
        }
    }
    
    
    
    
    
    
    func dateTime(date: String) -> String {
        let dateFormatter = DateFormatter()
        var localTimeZoneAbbreviation: String { return TimeZone.current.abbreviation() ?? "" }
        dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
        dateFormatter.timeZone = NSTimeZone(name: localTimeZoneAbbreviation) as TimeZone?
        
        var finaldatetime : Date? = dateFormatter.date(from: date)
        
       // finaldatetime = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"  // yyyy-MM-dd'T'HH:mm:ss.SSSZ
        dateFormatter.timeZone = NSTimeZone.local
        
        if let finalDate = finaldatetime {
            let date = dateFormatter.string(from: finalDate)
            return date
        } else {
            return date
        }
    }
    
    
}
    
    
  
    
    


