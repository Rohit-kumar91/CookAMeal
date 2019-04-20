//
//  AddRecipeVC.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 28/11/17.
//  Copyright © 2017 Cynoteck. All rights reserved.
//

import UIKit
import AAPickerView
import JGProgressHUD
import BEMCheckBox

class AddRecipeVC: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UIPopoverControllerDelegate,UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
   
    @IBOutlet weak var IngredientButtonOutlet: UIButton!
    @IBOutlet weak var dishNameTextfield: UITextField!
    @IBOutlet weak var preparationTimeTextfield: UITextField!
    @IBOutlet weak var cookTimeTextfield: UITextField!
    @IBOutlet weak var categoryTextfield: AAPickerView!
    @IBOutlet weak var subcategoryTetxfield: AAPickerView!
    @IBOutlet weak var costPerServingTextfield: UITextField!
    @IBOutlet weak var availableServingTextfield: UITextField!
    @IBOutlet weak var orderByDateTimeTextfield: UITextField!
    @IBOutlet weak var pickupDateTimeTextfield: UITextField!
    @IBOutlet weak var deliveryFeeTextfield: UITextField!
    @IBOutlet weak var firstRecipeImage: UIImageView!
    @IBOutlet weak var secondRecipeImage: UIImageView!
    @IBOutlet weak var daysCollectionview: UICollectionView!
    @IBOutlet weak var preparationButtonOutlet: UIButton!
    @IBOutlet weak var searableTagButtonOutlet: UIButton!
    @IBOutlet weak var serveTextfield: UITextField!
    @IBOutlet weak var isEligibleTypeForRecipe: UISegmentedControl!
    @IBOutlet weak var ingredientCheck: BEMCheckBox!
    @IBOutlet weak var preparationMethodCheck: BEMCheckBox!
    
    @IBOutlet weak var doneButtonOutlet: RoundedButton!
    @IBOutlet weak var editRecipeButtonOutlet: RoundedButton!
    
    @IBOutlet weak var costPerServingStackviewOutlet: UIStackView!
    @IBOutlet weak var availableServingStackViewOutlet: UIStackView!
    @IBOutlet weak var orderByDateTimeStackViewOutlet: UIStackView!
    @IBOutlet weak var pickupDateTimeStackViewOutlet: UIStackView!
    @IBOutlet weak var deliveryFeeStackViewOutlet: UIStackView!
    @IBOutlet weak var decriptionLabelOutlet: UILabel!
    @IBOutlet weak var seperatorLabelHeightOutlet: NSLayoutConstraint!
    @IBOutlet weak var labelVerticalConstraintOutlet: NSLayoutConstraint!
    @IBOutlet weak var labelBottomConstraintOutlet: NSLayoutConstraint!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var preperationTimeStackview: UIStackView!
    @IBOutlet weak var cookTimeStackView: UIStackView!
    @IBOutlet weak var foodTypeTextfield: AAPickerView!
    
    
    
    var addRecipeModelObj: AddRecipeModel  = AddRecipeModel()
    var imagePicker:UIImagePickerController?=UIImagePickerController()
    let datePickerDateAndTime = UIDatePicker()
    let datePickerTime = UIDatePicker()
    var textfieldType: Bool = false
    var imageIndex: Int!
    var valueClearCheck: Bool = false
    var isRecipeEditable : Bool = false
    var imageCheck = Bool()
    var recipeId = String()
    let authServiceObject:AuthServices = AuthServices()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //here we are removing all object....because this view will loade once user will enter this view.....
        Singleton.instance.prepartionMethodStrArray.removeAll()
        hideBelowSectionInAddRecipe(value: true, descriptionText: "", heightConstant: 0)
        
        //Reset the Singleton Variable.
        if  Singleton.instance.ingredientCheck == "2" {
            //For Edit
            Singleton.instance.ingredientFinalArray.removeAll()
            Singleton.instance.searchableTagsArray.removeAll()
            //Singleton.instance.prepartionMethodStr = ""
        } else {
            //For Order
            Singleton.instance.ingredientArray.removeAll()
            Singleton.instance.ingredientFinalArray.removeAll()
            Singleton.instance.searchableTagsArray.removeAll()
            Singleton.instance.ingredientAllergiesArray.removeAll()
            Singleton.instance.prepartionMethodStrArray.removeAll()
            Singleton.instance.totalCostOfIngredient = ""
            //Singleton.instance.prepartionMethodStr = ""
        }
        
       
        addRecipeModelObj.eligibleFor = "1"
        createDateAndTimePicker()
        createTimePicker()
        daysCollectionview.delegate = self
        daysCollectionview.dataSource = self
        
        //Get Category Data
        let hud = JGProgressHUD(style: .light)
        hud.show(in: self.view)
        hud.textLabel.text = "Loading"
        
       
        addRecipeModelObj.getCategory { (success) in
            if success {
                self.getCommonCategoryNames()
                self.getFoodType()
                //get SubCategory Data.
                self.addRecipeModelObj.getSubCategory(completion: { (success) in
                    if success {
                       
                        self.getCommonSubCategoryNames()
                        
                        //If user want to edit the recipe.
                        if self.isRecipeEditable {
                            self.addRecipeModelObj.getEditRecipeData(recipeId: self.recipeId, completion: { (success) in
                                hud.dismiss()
                                if success {
                                    self.organizeDataToDisplayAndManage()
                                } else {
                                    self.showAlertWithMessage(alertMessage: self.addRecipeModelObj.alertMessage)
                                }
                            })
                        } else {
                             hud.dismiss()
                        }
                        
                    }else {
                        hud.dismiss()
                        self.showAlertWithMessage(alertMessage: self.addRecipeModelObj.alertMessage)
                    }
                })
            }else{
                hud.dismiss()
                self.showAlertWithMessage(alertMessage: self.addRecipeModelObj.alertMessage)
            }
        }
        
        
        //Set the button title.
        if Singleton.instance.editRecipe {
            //Singleton.instance.editRecipe = false
            editRecipeButtonOutlet.isHidden = false
            doneButtonOutlet.isHidden = true
        } else {
            editRecipeButtonOutlet.isHidden = true
            doneButtonOutlet.isHidden = false
        }
        
        
        
        
    }
    
    
    
    func createIngredientFinalArray() {
        Singleton.instance.ingredientFinalArray.removeAll()
        
        var alertMessage =  String()
        var flagCheck = Bool()
        
        for (index, _) in Singleton.instance.ingredientArray.enumerated() {
            
            //Singleton.instance.ingredientArray[index]["cost"] == "" &&
            if Singleton.instance.ingredientArray[index]["unitId"] == "" && Singleton.instance.ingredientArray[index]["name"] == "" &&  Singleton.instance.ingredientArray[index]["qty"] == "" &&
                Singleton.instance.ingredientArray[index]["sortName"] == "" {
                flagCheck = false
                
            }
                // Singleton.instance.ingredientArray[index]["cost"] == "" ||
            else if Singleton.instance.ingredientArray[index]["unitId"] == "" ||
                Singleton.instance.ingredientArray[index]["name"] == "" ||
                
                Singleton.instance.ingredientArray[index]["qty"] == "" ||
                Singleton.instance.ingredientArray[index]["sortName"] == "" {
                //Not add to the final array.
                if Singleton.instance.ingredientArray[index]["name"] == "" {
                    alertMessage = "Ingredient name is empty"
                    flagCheck = true
                    
                } else if Singleton.instance.ingredientArray[index]["qty"] == "" {
                    
                    alertMessage = "Quantity of " + Singleton.instance.ingredientArray[index]["name"]! + " is empty."
                    flagCheck = true
                    
                } else if Singleton.instance.ingredientArray[index]["sortName"] == "" {
                    
                    alertMessage = "Unit of " + Singleton.instance.ingredientArray[index]["name"]! + " is empty."
                    flagCheck = true
                    
                }
                
                break
                
            } else {
                
                flagCheck = false
                Singleton.instance.ingredientFinalArray.append(Singleton.instance.ingredientArray[index])
            }
        }
    }
    
    
    func organizeDataToDisplayAndManage () {
        
        if let selectedIndex = addRecipeModelObj.eligibleFor {
            print(selectedIndex)
            isEligibleTypeForRecipe.selectedSegmentIndex = Int(selectedIndex)! - 1
            
            let result = Int(selectedIndex)! - 1
            switch result {
                case 0:
                print("For Hire")
                preperationTimeStackview.isHidden = false
                cookTimeStackView.isHidden = false
                addRecipeModelObj.eligibleFor = "1"
                hideBelowSectionInAddRecipe(value: true, descriptionText: "", heightConstant: 0)
                case 1:
                print("For Order")
                preperationTimeStackview.isHidden = true
                cookTimeStackView.isHidden = true
                addRecipeModelObj.eligibleFor = "2"
                hideBelowSectionInAddRecipe(value: false, descriptionText: "Fill below section if you are selling food from home", heightConstant: 10)
                case 2:
                print("For Both")
                preperationTimeStackview.isHidden = false
                cookTimeStackView.isHidden = false
                addRecipeModelObj.eligibleFor = "3"
                hideBelowSectionInAddRecipe(value: false, descriptionText: "Fill below section if you are selling food from home", heightConstant: 10)
                
            default:
                print("Nothing to do.")
            }
        }
        
        //Name of dish
        dishNameTextfield.text = addRecipeModelObj.nameOfDish
        
        //Ingredients
        createIngredientFinalArray()
        
        if !(Singleton.instance.ingredientArray.count == 0) {
            
            let count =  Singleton.instance.ingredientArray.count
            let buttonTitle = String(count) + " ingredients are added"
            IngredientButtonOutlet.setTitle(buttonTitle, for: .normal)
            IngredientButtonOutlet.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            
            for (index, _) in  Singleton.instance.ingredientArray.enumerated() {
                if index == 0 {
                    if Singleton.instance.ingredientArray[index]["name"]! != "" {
                        ingredientCheck.on = true
                        ingredientCheck.isHidden = false
                    }
                }
            }
            
        } else {
            IngredientButtonOutlet.setTitle("Ingredients", for: .normal)
            IngredientButtonOutlet.setTitleColor(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), for: .normal)
            ingredientCheck.isHidden = true
        }
        
        
        
        //Preperation Method
        print("preperationMethod \(Singleton.instance.prepartionMethodStrArray)")
        if Singleton.instance.prepartionMethodStrArray.count == 0 {
            
            preparationMethodCheck.isHidden = true
            preparationButtonOutlet.setTitle("Preparation Method", for: .normal)
            preparationButtonOutlet.setTitleColor(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), for: .normal)
            
        } else {
            
            let count =  Singleton.instance.prepartionMethodStrArray.count
            let buttonTitle = String(count) + " Preparation steps are added"
            preparationButtonOutlet.setTitle(buttonTitle, for: .normal)
            preparationButtonOutlet.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            preparationMethodCheck.on = true
            preparationMethodCheck.isHidden = false
            
        }
        
        //Preperation Time
        preparationTimeTextfield.text = addRecipeModelObj.preparationTime
        
        //Cook Time
        cookTimeTextfield.text = addRecipeModelObj.cookTime
        
        //Category
        //Fetch the category name by Id
        for category in addRecipeModelObj.commonCategoryArray {
            if addRecipeModelObj.categoryId == category["id"].stringValue {
                categoryTextfield.text = category["name"].stringValue
            }
        }
        
        
        
        //SubCategory
        //Fetch the subcategory name by Id
        
        for subCategory in addRecipeModelObj.subcategoryArray {
            if addRecipeModelObj.subCategoryId == subCategory["id"].stringValue  {
                subcategoryTetxfield.text = subCategory["name"].stringValue
            }
        }
    
        
        //Food Type
        for foodType in addRecipeModelObj.foodTypeArray {
            if addRecipeModelObj.foodType == foodType {
                foodTypeTextfield.text = foodType
            }
        }
        
        
        //Serve
        serveTextfield.text = addRecipeModelObj.serve
        
        //Searchable Tags
        searableTagButtonOutlet.setTitle(addRecipeModelObj.tagString, for: .normal)
        searableTagButtonOutlet.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        
        
        //Images
        for (index, image) in addRecipeModelObj.editRecipeImage.enumerated() {
            if index == 0 {
                firstRecipeImage.sd_setImage(with: URL(string: image["imageUrl"].stringValue), placeholderImage:UIImage(named: "recipePlaceholder"), options: .refreshCached)
            }
            
            if index == 1 {
               secondRecipeImage.sd_setImage(with: URL(string: image["imageUrl"].stringValue), placeholderImage:UIImage(named: "recipePlaceholder"), options: .refreshCached)
            }
        }
        
        
        //Cost Per Serving
        costPerServingTextfield.text = addRecipeModelObj.costPerServing
        
        //Available Serving
        availableServingTextfield.text = addRecipeModelObj.availableServing
        
        //Order By Date
        orderByDateTimeTextfield.text =  getTime(date: addRecipeModelObj.orderDateTime)  //addRecipeModelObj.orderDateTime
        
        //Pick Up By Date
        pickupDateTimeTextfield.text =  getTime(date: addRecipeModelObj.pickDateTime) //addRecipeModelObj.pickDateTime
        
        //Delivery Fee
        deliveryFeeTextfield.text = addRecipeModelObj.deliveryFee
        
        //Days
        //Reload days collectionView
        daysCollectionview.reloadData()
        
        
        
    }
    
    
    func getTime(date: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"//this your string date format
        var localTimeZoneAbbreviation: String { return TimeZone.current.abbreviation() ?? "" }
        
        dateFormatter.timeZone = NSTimeZone(name: localTimeZoneAbbreviation) as TimeZone?
        let date = dateFormatter.date(from: date)
        
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm a"///this is what you want to convert format
        dateFormatter.timeZone = NSTimeZone(name: localTimeZoneAbbreviation) as TimeZone?
        
        if let date = date {
            return dateFormatter.string(from: date)
        } else {
            return ""
        }
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        imagePicker?.delegate=self
        
        if Singleton.instance.prepartionMethodStrArray.count == 0 {
            preparationMethodCheck.isHidden = true
            preparationButtonOutlet.setTitle("Preparation Method", for: .normal)
            preparationButtonOutlet.setTitleColor(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), for: .normal)
            
        }else{
            let count =  Singleton.instance.prepartionMethodStrArray.count
            let buttonTitle = String(count) + " Preparation steps are added"
            preparationButtonOutlet.setTitle(buttonTitle, for: .normal)
            preparationButtonOutlet.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            preparationMethodCheck.on = true
            preparationMethodCheck.isHidden = false
        }
        
        
        if !(Singleton.instance.ingredientFinalArray.count == 0) {
            
            let count =  Singleton.instance.ingredientFinalArray.count
            let buttonTitle = String(count) + " ingredients are added"
            IngredientButtonOutlet.setTitle(buttonTitle, for: .normal)
            IngredientButtonOutlet.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            
            for (index, _) in  Singleton.instance.ingredientFinalArray.enumerated() {
                if index == 0 {
                    if Singleton.instance.ingredientArray[index]["name"]! != "" {
                       ingredientCheck.on = true
                       ingredientCheck.isHidden = false
                    }
                }
            }
            
        }else {
            IngredientButtonOutlet.setTitle("Ingredients", for: .normal)
            IngredientButtonOutlet.setTitleColor(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), for: .normal)
            ingredientCheck.isHidden = true
        }

        
        if !(Singleton.instance.searchableTagsArray.count == 0){
            
            var searableTagString: String = ""
            for (index, _) in Singleton.instance.searchableTagsArray.enumerated() {
                if index == 0{
                    searableTagString = Singleton.instance.searchableTagsArray[index]
                }else{
                    searableTagString = searableTagString + "," + Singleton.instance.searchableTagsArray[index]
                }
            }
            
            searableTagButtonOutlet.setTitle(searableTagString, for: .normal)
            searableTagButtonOutlet.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
         }
    }
    

    
    
    
    
    
    @IBAction func isEligibleForRecipeTypeSegment(_ sender: Any) {
        switch isEligibleTypeForRecipe.selectedSegmentIndex {
            case 0:
                print("For Hire")
                preperationTimeStackview.isHidden = false
                cookTimeStackView.isHidden = false
                addRecipeModelObj.eligibleFor = "1"
                hideBelowSectionInAddRecipe(value: true, descriptionText: "", heightConstant: 0)
            case 1:
                print("For Order")
                preperationTimeStackview.isHidden = true
                cookTimeStackView.isHidden = true
                addRecipeModelObj.eligibleFor = "2"
                hideBelowSectionInAddRecipe(value: false, descriptionText: "Fill below section if you are selling food from home", heightConstant: 10)
            case 2:
                print("For Both")
                preperationTimeStackview.isHidden = false
                cookTimeStackView.isHidden = false
                addRecipeModelObj.eligibleFor = "3"
                hideBelowSectionInAddRecipe(value: false, descriptionText: "Fill below section if you are selling food from home", heightConstant: 10)
            default:
                 print("default")
        }
    }
    
    
    @IBAction func btnClear(_ sender: Any) {
        
        // MARK: SUBODH3
        self.clearTextFields()
        
        // here also need to handle the check uncheck image.
        Singleton.instance.ingredientArray.removeAll()
        IngredientButtonOutlet.setTitle("Add ingredients", for: .normal)
        IngredientButtonOutlet.setTitleColor(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), for: .normal)
        
        // here also need to handle the check uncheck image.
        Singleton.instance.prepartionMethodStrArray.removeAll()
        preparationButtonOutlet.setTitle("Preparation Method", for: .normal)
        preparationButtonOutlet.setTitleColor(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), for: .normal)
        
        Singleton.instance.searchableTagsArray.removeAll()
        searableTagButtonOutlet.setTitle("Searchable tags for food", for: .normal)
        searableTagButtonOutlet.setTitleColor(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), for: .normal)
        
    }
    
    
    
    func clearTextFields() {
        dishNameTextfield.text = nil
        preparationTimeTextfield.text = nil
        cookTimeTextfield.text = nil
        categoryTextfield.text = nil
        subcategoryTetxfield.text = nil
        costPerServingTextfield.text = nil
        availableServingTextfield.text = nil
        orderByDateTimeTextfield.text = nil
        pickupDateTimeTextfield.text = nil
        deliveryFeeTextfield.text = nil
        serveTextfield.text = nil
    }
    
    
    func hideBelowSectionInAddRecipe(value: Bool, descriptionText: String, heightConstant: Int) {
        costPerServingStackviewOutlet.isHidden = value
        availableServingStackViewOutlet.isHidden = value
        orderByDateTimeStackViewOutlet.isHidden = value
        pickupDateTimeStackViewOutlet.isHidden = value
        deliveryFeeStackViewOutlet.isHidden = value
        decriptionLabelOutlet.text = descriptionText
        seperatorLabelHeightOutlet.constant = CGFloat(heightConstant)
        labelVerticalConstraintOutlet.constant = CGFloat(heightConstant)
        labelBottomConstraintOutlet.constant = CGFloat(heightConstant)
        collectionViewHeightConstraint.constant = CGFloat(heightConstant)
    }

  
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField.tag == 1 {
            textfieldType = true
        } else if textField.tag == 2 {
            textfieldType = false
        }
        return true
    }
    
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 29 2017
    // Input Parameters :   N/A.
    // Purpose          :   Close view controller
    //>--------------------------------------------------------------------------------------------------
    @IBAction func closeAddRecipeButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 29 2017
    // Input Parameters :   N/A.
    // Purpose          :   time picker view
    //>--------------------------------------------------------------------------------------------------
    
    func createTimePicker(){
        let toolbar = UIToolbar()
        let cancelButton = UIBarButtonItem (barButtonSystemItem: .cancel, target: nil, action: #selector(pickerCancelPressed))
        let doneButton = UIBarButtonItem (barButtonSystemItem: .done, target: nil, action: #selector(pickerTimeDonePressed))
        let flexButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([cancelButton,flexButton, doneButton], animated: true)
        
        doneButton.tintColor = #colorLiteral(red: 0.8862745098, green: 0.1725490196, blue: 0.168627451, alpha: 1)
        cancelButton.tintColor = #colorLiteral(red: 0.8862745098, green: 0.1725490196, blue: 0.168627451, alpha: 1)
        toolbar.sizeToFit()
        
        datePickerTime.datePickerMode = .time
        datePickerTime.locale = Locale.init(identifier: "NL")
        
        preparationTimeTextfield.inputAccessoryView = toolbar
        preparationTimeTextfield.inputView = datePickerTime
        preparationTimeTextfield.tag = 1
        
        cookTimeTextfield.inputAccessoryView = toolbar
        cookTimeTextfield.inputView = datePickerTime
        cookTimeTextfield.tag = 2

    }
    
    
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 29 2017
    // Input Parameters :   N/A.
    // Purpose          :   Create Date and time picker view
    //>--------------------------------------------------------------------------------------------------
    
    func createDateAndTimePicker() {
        let toolbar = UIToolbar()
        let cancelButton = UIBarButtonItem (barButtonSystemItem: .cancel, target: nil, action: #selector(pickerCancelPressed))
        let doneButton = UIBarButtonItem (barButtonSystemItem: .done, target: nil, action: #selector(pickerDonePressed))
        let flexButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([cancelButton,flexButton, doneButton], animated: true)
        
        doneButton.tintColor = #colorLiteral(red: 0.8862745098, green: 0.1725490196, blue: 0.168627451, alpha: 1)
        cancelButton.tintColor = #colorLiteral(red: 0.8862745098, green: 0.1725490196, blue: 0.168627451, alpha: 1)
        toolbar.sizeToFit()
        
        
        
        let calendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let currentDate = NSDate()
        let dateComponents = NSDateComponents()
        let minDate = calendar.date(byAdding: dateComponents as DateComponents, to: currentDate as Date, options: NSCalendar.Options(rawValue: 0))
        
        dateComponents.month = 3 //or you can change month = day(90)
        
        let maxDate = calendar.date(byAdding: dateComponents as DateComponents, to: currentDate as Date, options: NSCalendar.Options(rawValue: 0))
        self.datePickerDateAndTime.maximumDate = maxDate
        self.datePickerDateAndTime.minimumDate = minDate
        
        
        orderByDateTimeTextfield.inputAccessoryView = toolbar
        orderByDateTimeTextfield.inputView = datePickerDateAndTime
        orderByDateTimeTextfield.tag = 1
        
        //Pickup Date time
        pickupDateTimeTextfield.inputAccessoryView = toolbar
        pickupDateTimeTextfield.inputView = datePickerDateAndTime
        pickupDateTimeTextfield.tag = 2
    }
    
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 01 2017
    // Input Parameters :   N/A.
    // Purpose          :   Picker toobar done action for dismiss picker.
    //>--------------------------------------------------------------------------------------------------
    @objc func pickerCancelPressed() {
        self.view.endEditing(true)
    }
    
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 01 2017
    // Input Parameters :   N/A.
    // Purpose          :   Picker toobar done action for dismiss picker.
    //>--------------------------------------------------------------------------------------------------
    @objc func pickerDonePressed() {
        //format date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
        
        if textfieldType {
             orderByDateTimeTextfield.text = dateFormatter.string(from: datePickerDateAndTime.date)
        } else{
             pickupDateTimeTextfield.text = dateFormatter.string(from: datePickerDateAndTime.date)
        }
        self.view.endEditing(true)
    }
    
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 01 2017
    // Input Parameters :   N/A.
    // Purpose          :   Picker toobar done action for dismiss picker.
    //>--------------------------------------------------------------------------------------------------
    @objc func pickerTimeDonePressed() {
        //format date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        if textfieldType {
            preparationTimeTextfield.text = dateFormatter.string(from: datePickerTime.date)
        } else{
            cookTimeTextfield.text = dateFormatter.string(from: datePickerTime.date)
        }
        
        self.view.endEditing(true)
    }
    
    
    
    func getFoodType() {
        
        foodTypeTextfield.pickerType = .string(data: addRecipeModelObj.foodTypeArray)
        foodTypeTextfield.toolbar.tintColor = #colorLiteral(red: 0.9568627451, green: 0.262745098, blue: 0.2117647059, alpha: 1)
        foodTypeTextfield.valueDidSelected = { index in
            print("selectedString ", self.addRecipeModelObj.foodTypeArray[index as! Int] )
            self.addRecipeModelObj.foodType = self.addRecipeModelObj.foodTypeArray[index as! Int]
        }
        
        
//        foodTypeTextfield.stringPickerData = addRecipeModelObj.foodTypeArray
//        foodTypeTextfield.pickerType = .StringPicker
//        foodTypeTextfield.toolbar.tintColor = #colorLiteral(red: 0.9568627451, green: 0.262745098, blue: 0.2117647059, alpha: 1)
//        foodTypeTextfield.stringDidChange = { index in
//            print("selectedString ", self.addRecipeModelObj.foodTypeArray[index])
//            self.addRecipeModelObj.foodType  = self.addRecipeModelObj.foodTypeArray[index]
//        }
        
    }
    
    
    
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Oct, 31 2017
    // Input Parameters :   N/A
    // Purpose          :   Create string selection picker.
    //>--------------------------------------------------------------------------------------------------
    func getCommonCategoryNames() {
        
        categoryTextfield.pickerType = .string(data: addRecipeModelObj.commonCategoryNameArray)
        categoryTextfield.toolbar.tintColor = #colorLiteral(red: 0.9568627451, green: 0.262745098, blue: 0.2117647059, alpha: 1)
        categoryTextfield.valueDidSelected = { index in
            print("selectedString ", self.addRecipeModelObj.commonCategoryArray[index as! Int][ID_KEY])
            self.addRecipeModelObj.categoryId = self.addRecipeModelObj.commonCategoryArray[index as! Int][ID_KEY].stringValue
        }
        
//        categoryTextfield.stringPickerData = addRecipeModelObj.commonCategoryNameArray
//        categoryTextfield.pickerType = .StringPicker
//        categoryTextfield.toolbar.tintColor = #colorLiteral(red: 0.9568627451, green: 0.262745098, blue: 0.2117647059, alpha: 1)
//        categoryTextfield.stringDidChange = { index in
//            print("selectedString ", self.addRecipeModelObj.commonCategoryArray[index][ID_KEY])
//            self.addRecipeModelObj.categoryId = self.addRecipeModelObj.commonCategoryArray[index][ID_KEY].stringValue
//        }
    }
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Oct, 31 2017
    // Input Parameters :   N/A
    // Purpose          :   Create string selection picker.
    //>--------------------------------------------------------------------------------------------------
    func getCommonSubCategoryNames() {
        
        subcategoryTetxfield.pickerType = .string(data: addRecipeModelObj.subCategoryNameArray)
        subcategoryTetxfield.toolbar.tintColor = #colorLiteral(red: 0.9568627451, green: 0.262745098, blue: 0.2117647059, alpha: 1)
        subcategoryTetxfield.valueDidSelected = { index in
            print("selectedString ", self.addRecipeModelObj.subcategoryArray[index as! Int][ID_KEY])
            self.addRecipeModelObj.subCategoryId = self.addRecipeModelObj.subcategoryArray[index as! Int][ID_KEY].stringValue
        }
        
//        subcategoryTetxfield.stringPickerData = addRecipeModelObj.subCategoryNameArray
//        subcategoryTetxfield.pickerType = .StringPicker
//        subcategoryTetxfield.toolbar.tintColor = #colorLiteral(red: 0.9568627451, green: 0.262745098, blue: 0.2117647059, alpha: 1)
//        subcategoryTetxfield.stringDidChange = { index in
//            print("selectedString ", self.addRecipeModelObj.subcategoryArray[index][ID_KEY])
//            self.addRecipeModelObj.subCategoryId = self.addRecipeModelObj.subcategoryArray[index][ID_KEY].stringValue
//        }
        
    }
    
    
    
    
    @IBAction func addFoodImageButtonTapped(_ sender: RoundedButton) {
        
        imageIndex = sender.tag
        
        let alertController = UIAlertController(title: nil, message: "Action", preferredStyle: .actionSheet)
        
        let gallery = UIAlertAction(title: "Gallery", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            //  Do some action here.
            self.openGallary()
        })
        
        let camera = UIAlertAction(title: "Camera", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            //  Do some destructive action here.
            self.openCamera()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (alert: UIAlertAction!) -> Void in
            //  Do something here upon cancellation.
        })
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
        }
        
        alertController.addAction(gallery)
        alertController.addAction(camera)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 13 2017
    // Input Parameters :   N/A.
    // Purpose          :   open imagepicker.
    //>--------------------------------------------------------------------------------------------------
    func openGallary()
    {
        imagePicker!.allowsEditing = false
        imagePicker!.sourceType = .photoLibrary
        present(imagePicker!, animated: true, completion: nil)
    }
    
    
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 13 2017
    // Input Parameters :   N/A.
    // Purpose          :   open camera.
    //>--------------------------------------------------------------------------------------------------
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            imagePicker!.allowsEditing = false
            imagePicker!.sourceType = .camera
            imagePicker!.cameraCaptureMode = .photo
            present(imagePicker!, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: "Camera Not Found", message: "This device has no Camera", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style:.default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }
    }
    
    
    
    // MARK: Imagepicker Delegate method.
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        if imageIndex == 0{
            firstRecipeImage.contentMode = .scaleAspectFit
            firstRecipeImage.image = chosenImage
            
            //Edit Image
            if Singleton.instance.editRecipe {
                
                print(addRecipeModelObj.editRecipeImage)
                
                var mediaObjectId = String()
                if addRecipeModelObj.editRecipeImage.count == 0  {
                    mediaObjectId = ""
                } else {
                    mediaObjectId = addRecipeModelObj.editRecipeImage[0]["id"].stringValue
                }
                
               
                addRecipeModelObj.recipeImage.append(firstRecipeImage.image!)
                
                addRecipeModelObj.uploadEditImage(recipeId: recipeId, mediaObjectId: mediaObjectId) { (success) in
                    if success {
                        self.showAlertWithMessage(alertMessage: self.addRecipeModelObj.alertMessage)
                    } else {
                        self.showAlertWithMessage(alertMessage: self.addRecipeModelObj.alertMessage)
                    }
                }
            }
            
            
        }else if imageIndex == 1{
            secondRecipeImage.contentMode = .scaleAspectFit
            secondRecipeImage.image = chosenImage
            
            //Edit Image
            if Singleton.instance.editRecipe {
                
                var mediaObjectId = String()
                if addRecipeModelObj.editRecipeImage.count == 2 {
                    mediaObjectId = addRecipeModelObj.editRecipeImage[1]["id"].stringValue
                }
                
               
                addRecipeModelObj.recipeImage.append(firstRecipeImage.image!)
                
                addRecipeModelObj.uploadEditImage(recipeId: recipeId, mediaObjectId: mediaObjectId) { (success) in
                    if success {
                        self.showAlertWithMessage(alertMessage: self.addRecipeModelObj.alertMessage)
                    } else {
                        self.showAlertWithMessage(alertMessage: self.addRecipeModelObj.alertMessage)
                    }
                }
            }
            
        }
        
        
        print(addRecipeModelObj.recipeImage.count)
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
   
    
    
    
    
    @IBAction func editButtonTapped(_ sender: RoundedButton) {
        
        addRecipeModelObj.recipeImage.removeAll()
        addRecipeModelObj.nameOfDish = dishNameTextfield.text
        addRecipeModelObj.serve = serveTextfield.text
        addRecipeModelObj.preparationTime = preparationTimeTextfield.text
        addRecipeModelObj.cookTime = cookTimeTextfield.text
        addRecipeModelObj.category = categoryTextfield.text
        addRecipeModelObj.subCategory =  subcategoryTetxfield.text
        addRecipeModelObj.costPerServing = costPerServingTextfield.text
        addRecipeModelObj.availableServing = availableServingTextfield.text
        addRecipeModelObj.orderDateTime = orderByDateTimeTextfield.text
        addRecipeModelObj.pickDateTime = pickupDateTimeTextfield.text
        addRecipeModelObj.deliveryFee = deliveryFeeTextfield.text
        addRecipeModelObj.foodType = foodTypeTextfield.text
        
        
        if !(firstRecipeImage.image == UIImage(named: "liciense_icon")){
            addRecipeModelObj.recipeImage.append(firstRecipeImage.image!)
            imageCheck = false
        } else {
            imageCheck = true
        }
        
        if !(secondRecipeImage.image == UIImage(named: "liciense_icon")) {
            addRecipeModelObj.recipeImage.append(secondRecipeImage.image!)
        } else {
            
        }
        
        
        if !addRecipeModelObj.nameOfDishValidate(){
            
            showAlertWithMessage(alertMessage: addRecipeModelObj.alertMessage)
            
        }else if !addRecipeModelObj.ingredientsMethodValidate(){
            
            showAlertWithMessage(alertMessage: addRecipeModelObj.alertMessage)
            
        }else if !addRecipeModelObj.preparationMethodValidate(){
            
            showAlertWithMessage(alertMessage: addRecipeModelObj.alertMessage)
            
        }else if !addRecipeModelObj.preparationTimeValidate(){
            
            showAlertWithMessage(alertMessage: addRecipeModelObj.alertMessage)
            
        }else if !addRecipeModelObj.cookTimeValidate(){
            
            showAlertWithMessage(alertMessage: addRecipeModelObj.alertMessage)
            
        }else if !addRecipeModelObj.categoryValidate(){
            
            showAlertWithMessage(alertMessage: addRecipeModelObj.alertMessage)
            
        }else if !addRecipeModelObj.subCategoryValidate(){
            
            showAlertWithMessage(alertMessage: addRecipeModelObj.alertMessage)
            
        }else if !addRecipeModelObj.searchableTagValidate(){
            
            showAlertWithMessage(alertMessage: addRecipeModelObj.alertMessage)
            
        }else if !addRecipeModelObj.serveDishValidate(){
            
            showAlertWithMessage(alertMessage: addRecipeModelObj.alertMessage)
            
        } else if !addRecipeModelObj.foodTypeValidate(){
            
            showAlertWithMessage(alertMessage: addRecipeModelObj.alertMessage)
            
        }else if imageCheck {
            showAlertWithMessage(alertMessage: "Image is Required")
        }
        
        else {
            
            //for ingredient only.
            let localIngredient = Singleton.instance.ingredientFinalArray
            let serverIngredient = addRecipeModelObj.editRecipeResponse["Ingredients"].arrayValue
            var editIngredeint =  [[String: String]]()
            
            if localIngredient.count == serverIngredient.count {
                for (index,ingredient) in serverIngredient.enumerated() {
                    if ingredient["name"].stringValue != localIngredient[index]["name"] ||
                        ingredient["cost"].stringValue != localIngredient[index]["cost"] ||
                        ingredient["qty"].stringValue != localIngredient[index]["qty"] ||
                        ingredient["unitId"].stringValue != localIngredient[index]["unitId"] {
                        
                        editIngredeint.append(localIngredient[index])
                        
                    }
                }
                
                print(editIngredeint)
                
            } else if localIngredient.count > serverIngredient.count {
                
                
                for (index,ingredient) in serverIngredient.enumerated() {
                    if ingredient["name"].stringValue != localIngredient[index]["name"] ||
                        ingredient["cost"].stringValue != localIngredient[index]["cost"] ||
                        ingredient["qty"].stringValue != localIngredient[index]["qty"] ||
                        ingredient["unitId"].stringValue != localIngredient[index]["unitId"] {
                        editIngredeint.append(localIngredient[index])
                        
                    }
                }
                
                let localArrayCount = localIngredient.count
                let serverIngredientCount = serverIngredient.count
                let ingredientValueArray = localIngredient[serverIngredientCount..<localArrayCount]
                print(ingredientValueArray)

                for ingredient in ingredientValueArray {
                    editIngredeint.append(ingredient)
                }
                
                print(editIngredeint)
                
            }
            
            
            //Preparation Method
            var editPreparationMethod = [[String: String]]()
            let localPreparationMethod =  Singleton.instance.prepartionMethodStrArray
            let serverPreparationMethod = addRecipeModelObj.editRecipeResponse["PreparationMethods"].arrayValue
            
            if localPreparationMethod.count == serverPreparationMethod.count {
                
                for(index,preparation) in  serverPreparationMethod.enumerated() {
                    if preparation["method"].stringValue != localPreparationMethod[index]["method"] {
                        editPreparationMethod.append(localPreparationMethod[index])
                    }
                }
            }
            
            
            
            
            if addRecipeModelObj.nameOfDish != addRecipeModelObj.editRecipeResponse["dishName"].stringValue {
                addRecipeModelObj.updateRecipeName = addRecipeModelObj.nameOfDish
            }
            else if addRecipeModelObj.preparationTime != addRecipeModelObj.editRecipeResponse["preparationTime"].stringValue {
                addRecipeModelObj.updatePreparationTime = addRecipeModelObj.preparationTime
            }
            else if addRecipeModelObj.cookTime != addRecipeModelObj.editRecipeResponse["cookTime"].stringValue {
                addRecipeModelObj.updateCookTime = addRecipeModelObj.cookTime
            }
            else if addRecipeModelObj.serve != addRecipeModelObj.editRecipeResponse["serve"].stringValue {
                addRecipeModelObj.updateServe = addRecipeModelObj.serve
            }
            else if addRecipeModelObj.costPerServing != addRecipeModelObj.editRecipeResponse["costPerServing"].stringValue {
                addRecipeModelObj.updateCostPerServing = addRecipeModelObj.costPerServing
            }
            else if addRecipeModelObj.availableServing != addRecipeModelObj.editRecipeResponse["availableServings"].stringValue {
                addRecipeModelObj.updateAvailableServing = addRecipeModelObj.availableServing
            }
            else if addRecipeModelObj.orderDateTime != addRecipeModelObj.editRecipeResponse["orderByDateTime"].stringValue {
                addRecipeModelObj.updateOrderByDateTime = addRecipeModelObj.availableServing
            }
            else if addRecipeModelObj.pickDateTime != addRecipeModelObj.editRecipeResponse["pickUpByDateTime"].stringValue {
                addRecipeModelObj.updatePickUpDatetime = addRecipeModelObj.pickDateTime
            }
            else if addRecipeModelObj.deliveryFee != addRecipeModelObj.editRecipeResponse["deliveryFee"].stringValue {
                addRecipeModelObj.updateDeliveryFee = addRecipeModelObj.deliveryFee
            }
            else if addRecipeModelObj.foodType !=  addRecipeModelObj.editRecipeResponse["foodType"].stringValue {
                addRecipeModelObj.updateFoodType = addRecipeModelObj.foodType
            }
            else if editIngredeint.count != 0 {
                addRecipeModelObj.updateIngredientArray = editIngredeint
            }
            else if editPreparationMethod.count != 0 {
                addRecipeModelObj.updatePreparationMethod = editPreparationMethod
            }
            
            
            let hud = JGProgressHUD(style: .light)
            hud.show(in: self.view)
            hud.textLabel.text = "Loading"
            
            addRecipeModelObj.editRecipe(recipeId: recipeId) { (success) in
                hud.dismiss()
                if success {
                    self.showAlertWithMessageAndClearData(alertMessage: "Recipe Updated Successfully.")
                } else {
                    self.showAlertWithMessage(alertMessage: "Recipe cannot be updated.")
                }
            }
        }
    }
    
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        
        
        addRecipeModelObj.recipeImage.removeAll()
        addRecipeModelObj.nameOfDish = dishNameTextfield.text
        addRecipeModelObj.serve = serveTextfield.text
        addRecipeModelObj.preparationTime = preparationTimeTextfield.text
        addRecipeModelObj.cookTime = cookTimeTextfield.text
        addRecipeModelObj.category = categoryTextfield.text
        addRecipeModelObj.subCategory =  subcategoryTetxfield.text
        addRecipeModelObj.costPerServing = costPerServingTextfield.text
        addRecipeModelObj.availableServing = availableServingTextfield.text
        addRecipeModelObj.orderDateTime = orderByDateTimeTextfield.text
        addRecipeModelObj.pickDateTime = pickupDateTimeTextfield.text
        addRecipeModelObj.deliveryFee = deliveryFeeTextfield.text
        addRecipeModelObj.foodType = foodTypeTextfield.text
        addRecipeModelObj.ingredientArray = Singleton.instance.ingredientArray
        //addRecipeModelObj.preparationMethod = Singleton.instance.prepartionMethodStr
        addRecipeModelObj.searchableTagsArray = Singleton.instance.searchableTagsArray
        
        

        
        if !(firstRecipeImage.image == UIImage(named: "liciense_icon")){
             imageCheck = false
            addRecipeModelObj.recipeImage.append(firstRecipeImage.image!)
        } else {
             imageCheck = true
        }

        if !(secondRecipeImage.image == UIImage(named: "liciense_icon")) {
            imageCheck = false
            addRecipeModelObj.recipeImage.append(secondRecipeImage.image!)
        }
        
        
        print(addRecipeModelObj.recipeImage)
        
        if addRecipeModelObj.eligibleFor == "1" {
            //For Hire Cook
            if !addRecipeModelObj.nameOfDishValidate(){
                
                showAlertWithMessage(alertMessage: addRecipeModelObj.alertMessage)
                
            }else if !addRecipeModelObj.ingredientsMethodValidate(){
                
                showAlertWithMessage(alertMessage: addRecipeModelObj.alertMessage)
                
            }else if !addRecipeModelObj.preparationMethodValidate(){
                
                showAlertWithMessage(alertMessage: addRecipeModelObj.alertMessage)
                
            }else if !addRecipeModelObj.preparationTimeValidate(){
                
                showAlertWithMessage(alertMessage: addRecipeModelObj.alertMessage)
                
            }else if !addRecipeModelObj.cookTimeValidate(){
                
                showAlertWithMessage(alertMessage: addRecipeModelObj.alertMessage)
                
            }else if !addRecipeModelObj.categoryValidate(){
                
                showAlertWithMessage(alertMessage: addRecipeModelObj.alertMessage)
                
            }else if !addRecipeModelObj.subCategoryValidate(){
                
                showAlertWithMessage(alertMessage: addRecipeModelObj.alertMessage)
                
            }else if !addRecipeModelObj.serveDishValidate(){
                
                showAlertWithMessage(alertMessage: addRecipeModelObj.alertMessage)
                
            }else if !addRecipeModelObj.foodTypeValidate(){
                
                showAlertWithMessage(alertMessage: addRecipeModelObj.alertMessage)
                
            }else if !addRecipeModelObj.searchableTagValidate(){
                
                showAlertWithMessage(alertMessage: addRecipeModelObj.alertMessage)
                
            } else if imageCheck {
                 showAlertWithMessage(alertMessage: "Image is required.")
            }
            else {
                
                let hud = JGProgressHUD(style: .light)
                hud.show(in: self.view)
                hud.textLabel.text = "Loading"
                
                addRecipeModelObj.addRecipe(completion: { (success) in
                    if success {
                        hud.dismiss()
                        self.showAlertWithMessageAndClearData(alertMessage: self.addRecipeModelObj.alertMessage)
                        self.preparationMethodCheck.isHidden = true
                        self.ingredientCheck.isHidden = true
                    } else {
                        hud.dismiss()
                        self.showAlertWithMessage(alertMessage: self.addRecipeModelObj.alertMessage)
                    }
                })
            }
            
        } else if addRecipeModelObj.eligibleFor == "2" {
          
            //For Order
            if !addRecipeModelObj.nameOfDishValidate(){
                
                showAlertWithMessage(alertMessage: addRecipeModelObj.alertMessage)
                
            }else if !addRecipeModelObj.ingredientsMethodValidate(){
                
                showAlertWithMessage(alertMessage: addRecipeModelObj.alertMessage)
                
            }else if !addRecipeModelObj.preparationMethodValidate(){
                
                showAlertWithMessage(alertMessage: addRecipeModelObj.alertMessage)
                
            }else if !addRecipeModelObj.categoryValidate(){
                
                showAlertWithMessage(alertMessage: addRecipeModelObj.alertMessage)
                
            }else if !addRecipeModelObj.subCategoryValidate(){
                
                showAlertWithMessage(alertMessage: addRecipeModelObj.alertMessage)
                
            }else if !addRecipeModelObj.serveDishValidate(){
                
                showAlertWithMessage(alertMessage: addRecipeModelObj.alertMessage)
                
            }else if !addRecipeModelObj.foodTypeValidate(){
                
                showAlertWithMessage(alertMessage: addRecipeModelObj.alertMessage)
                
            }else if !addRecipeModelObj.searchableTagValidate(){
                
                showAlertWithMessage(alertMessage: addRecipeModelObj.alertMessage)
                
            }else if imageCheck {
                showAlertWithMessage(alertMessage: "Image is required.")
            }else if !addRecipeModelObj.costPerServingValidate(){
                
                showAlertWithMessage(alertMessage: addRecipeModelObj.alertMessage)
                
            }else if !addRecipeModelObj.availableServingValidate(){
                
                showAlertWithMessage(alertMessage: addRecipeModelObj.alertMessage)
                
            }else if !addRecipeModelObj.orderDateTimeValidate(){
                
                showAlertWithMessage(alertMessage: addRecipeModelObj.alertMessage)
                
            }else if !addRecipeModelObj.pickDateTimeValidate(){
                
                showAlertWithMessage(alertMessage: addRecipeModelObj.alertMessage)
                
            }else if !addRecipeModelObj.deliveryFeeValidate(){
                
                showAlertWithMessage(alertMessage: addRecipeModelObj.alertMessage)
                
            }else if !addRecipeModelObj.serveDishValidate(){
                
                showAlertWithMessage(alertMessage: addRecipeModelObj.alertMessage)
            }
            else {
                
                let hud = JGProgressHUD(style: .light)
                hud.show(in: self.view)
                hud.textLabel.text = "Loading"
                
                addRecipeModelObj.addRecipe(completion: { (success) in
                    if success {
                        hud.dismiss()
                        self.showAlertWithMessageAndClearData(alertMessage: self.addRecipeModelObj.alertMessage)
                        self.preparationMethodCheck.isHidden = true
                        self.ingredientCheck.isHidden = true
                    } else {
                        hud.dismiss()
                        self.showAlertWithMessage(alertMessage: self.addRecipeModelObj.alertMessage)
                    }
                })
            }
            
            
            
        } else if addRecipeModelObj.eligibleFor == "3" {
            
            //For Order Food and Both.
            if !addRecipeModelObj.nameOfDishValidate(){
                
                showAlertWithMessage(alertMessage: addRecipeModelObj.alertMessage)
                
            }else if !addRecipeModelObj.ingredientsMethodValidate(){
                
                showAlertWithMessage(alertMessage: addRecipeModelObj.alertMessage)
                
            }else if !addRecipeModelObj.preparationMethodValidate(){
                
                showAlertWithMessage(alertMessage: addRecipeModelObj.alertMessage)
                
            }else if !addRecipeModelObj.preparationTimeValidate(){
                
                showAlertWithMessage(alertMessage: addRecipeModelObj.alertMessage)
                
            }else if !addRecipeModelObj.cookTimeValidate(){
                
                showAlertWithMessage(alertMessage: addRecipeModelObj.alertMessage)
                
            }else if !addRecipeModelObj.categoryValidate(){
                
                showAlertWithMessage(alertMessage: addRecipeModelObj.alertMessage)
                
            }else if !addRecipeModelObj.subCategoryValidate(){
                
                showAlertWithMessage(alertMessage: addRecipeModelObj.alertMessage)
                
            }else if !addRecipeModelObj.serveDishValidate(){
                
                showAlertWithMessage(alertMessage: addRecipeModelObj.alertMessage)
                
            }else if !addRecipeModelObj.foodTypeValidate(){
                
                showAlertWithMessage(alertMessage: addRecipeModelObj.alertMessage)
                
            }else if !addRecipeModelObj.searchableTagValidate(){
                
                showAlertWithMessage(alertMessage: addRecipeModelObj.alertMessage)
                
            }else if imageCheck {
                
                showAlertWithMessage(alertMessage: "Image is required.")
                
            }else if !addRecipeModelObj.costPerServingValidate(){
                
                showAlertWithMessage(alertMessage: addRecipeModelObj.alertMessage)
                
            }else if !addRecipeModelObj.availableServingValidate(){
                
                showAlertWithMessage(alertMessage: addRecipeModelObj.alertMessage)
                
            }else if !addRecipeModelObj.orderDateTimeValidate(){
                
                showAlertWithMessage(alertMessage: addRecipeModelObj.alertMessage)
                
            }else if !addRecipeModelObj.pickDateTimeValidate(){
                
                showAlertWithMessage(alertMessage: addRecipeModelObj.alertMessage)
                
            }else if !addRecipeModelObj.deliveryFeeValidate(){
                
                showAlertWithMessage(alertMessage: addRecipeModelObj.alertMessage)
                
            }else if !addRecipeModelObj.serveDishValidate(){
                
                showAlertWithMessage(alertMessage: addRecipeModelObj.alertMessage)
                
            }
            else {
                
                let hud = JGProgressHUD(style: .light)
                hud.show(in: self.view)
                hud.textLabel.text = "Loading"
                
                addRecipeModelObj.addRecipe(completion: { (success) in
                    if success {
                        hud.dismiss()
                        self.showAlertWithMessageAndClearData(alertMessage: self.addRecipeModelObj.alertMessage)
                        self.preparationMethodCheck.isHidden = true
                        self.ingredientCheck.isHidden = true
                    } else {
                        hud.dismiss()
                        self.showAlertWithMessage(alertMessage: self.addRecipeModelObj.alertMessage)
                    }
                })
            }
        }
    }
    
    
    
    //MARK: Collectionview delegate and datasource.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return addRecipeModelObj.daysArray.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? DaysCollectionviewCell
        
        if addRecipeModelObj.daysArray[indexPath.row]["selected"] as! Int  == 0 {
            cell?.checkButtonOutlet.setImage(UIImage(named:"uncheck_icon.png"), for: .normal)
        } else{
            cell?.checkButtonOutlet.setImage(UIImage(named:"check_icon.png"), for: .normal)
        }
        
        cell?.dayCellLabel.text = addRecipeModelObj.daysArray[indexPath.row]["dayName"] as? String
        cell?.checkButtonOutlet.tag = indexPath.row
        
        return cell!
        
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      
    }
    
    
    
    
    
    @IBAction func checkDaysButton(_ sender: RoundedButton) {
        
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let cell: DaysCollectionviewCell = self.daysCollectionview.cellForItem(at: indexPath) as! DaysCollectionviewCell
        
        if (cell.checkButtonOutlet.currentImage?.isEqual(UIImage(named:"uncheck_icon.png")))! {
            cell.checkButtonOutlet.setImage(UIImage(named:"check_icon.png"), for: .normal)
            let tempDict = ["dayName": addRecipeModelObj.daysArray[sender.tag]["dayName"]!, "selected": 1] as [String : Any]
            addRecipeModelObj.daysArray[sender.tag] = tempDict
        } else{
            cell.checkButtonOutlet.setImage(UIImage(named:"uncheck_icon.png"), for: .normal)
            let tempDict = ["dayName": addRecipeModelObj.daysArray[sender.tag]["dayName"]!, "selected": 0] as [String : Any]
            addRecipeModelObj.daysArray[sender.tag] = tempDict
        }
        
        
        daysCollectionview.reloadData()
        print(addRecipeModelObj.daysArray)
        
    }
    
    
    
    
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Oct, 30 2017
    // Input Parameters :   Alert message String.
    // Purpose          :   Show the alert on view controller.
    //>--------------------------------------------------------------------------------------------------
    func showAlertWithMessage(alertMessage:String)
    {
        let alertController = UIAlertController(title:ALERT_TITLE.APP_NAME, message:alertMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Oct, 30 2017
    // Input Parameters :   Alert message String.
    // Purpose          :   Show the alert on view controller.
    //>--------------------------------------------------------------------------------------------------
    func showAlertWithMessageAndClearData(alertMessage:String)
    {
        let alertController = UIAlertController(title:ALERT_TITLE.APP_NAME, message:alertMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
            
            Singleton.instance.ingredientArray.removeAll()
            Singleton.instance.ingredientFinalArray.removeAll()
            Singleton.instance.searchableTagsArray.removeAll()

            self.dishNameTextfield.text = ""
            self.IngredientButtonOutlet.setTitle("Ingredients", for: .normal)
            self.IngredientButtonOutlet.setTitleColor(#colorLiteral(red: 0.5921568627, green: 0.5960784314, blue: 0.6, alpha: 1), for: .normal)
            self.preparationButtonOutlet.setTitle("Preparation Method", for: .normal)
            self.preparationButtonOutlet.setTitleColor(#colorLiteral(red: 0.5921568627, green: 0.5960784314, blue: 0.6, alpha: 1), for: .normal)
            self.preparationTimeTextfield.text = ""
            self.cookTimeTextfield.text = ""
            self.categoryTextfield.text = ""
            self.subcategoryTetxfield.text = ""
            self.foodTypeTextfield.text = ""
            self.searableTagButtonOutlet.setTitle("Ingredients", for: .normal)
            self.searableTagButtonOutlet.setTitleColor(#colorLiteral(red: 0.5921568627, green: 0.5960784314, blue: 0.6, alpha: 1), for: .normal)

            self.firstRecipeImage.image = #imageLiteral(resourceName: "liciense_icon")
            self.firstRecipeImage.contentMode = .center
            self.secondRecipeImage.image = #imageLiteral(resourceName: "liciense_icon")
            self.secondRecipeImage.contentMode = .center

            self.costPerServingTextfield.text = ""
            self.availableServingTextfield.text = ""
            self.orderByDateTimeTextfield.text = ""
            self.pickupDateTimeTextfield.text = ""
            self.deliveryFeeTextfield.text = ""
            self.serveTextfield.text = ""

            var tempdaysArray = [["dayName": "Sun", "selected": 0], ["dayName": "Mon", "selected": 0], ["dayName": "Tue", "selected": 0],["dayName": "Wed", "selected": 0], ["dayName": "Thu", "selected": 0], ["dayName": "Fri", "selected": 0],["dayName": "Sat", "selected": 0]]

            for (index, _) in tempdaysArray.enumerated(){
               self.addRecipeModelObj.daysArray[index] = tempdaysArray[index]
            }
            self.daysCollectionview.reloadData()
            
            //Dismiss the add recipe view controller
            self.dismiss(animated: true, completion: nil)
            
            
        })
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
}
