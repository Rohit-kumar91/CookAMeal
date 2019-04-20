//
//  IngredientsVC.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 30/11/17.
//  Copyright © 2017 Cynoteck. All rights reserved.
//

import UIKit
import SwiftyJSON
import JGProgressHUD


class IngredientsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var currecySymbolLabelOutlet: UILabel!
    @IBOutlet weak var ingredientsTableview: UITableView!
    @IBOutlet weak var allergiesTableview: UITableView!
    var ingredientModelObj: IngredientsModel  = IngredientsModel()
    var selectedUnit: Int?
    var textfieldtag: Int?
    var unitTextdoneCheck: Bool = false
    let unitPickerView = UIPickerView()
    var cost: Float?
    var editRecipe = Bool()
    let hud = JGProgressHUD(style: .light)
    
    @IBOutlet weak var totalCostOfIngrdients: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedUnit = 0
        Singleton.instance.totalCostOfIngredient = "0.0"
        let currencySymbol = Helper.getUserDefaultValue(key: CURRENCY_SYMBOL_KEY)!
        currecySymbolLabelOutlet.text = currencySymbol
       
    }

    
    override func viewWillAppear(_ animated: Bool) {
        
        
            hud.show(in: self.view)
            hud.textLabel.text = "Loading"
        
            totalCostOfIngrdients.text =  Singleton.instance.totalCostOfIngredient
      
            
            //Getting Allergies.
            ingredientModelObj.getAllergies { (success) in
                if success {
                    
                    if Singleton.instance.ingredientAllergiesArray.count == 0 {
                        Singleton.instance.ingredientAllergiesArray =  self.ingredientModelObj.tempAllergies
                    }
                    print(Singleton.instance.ingredientAllergiesArray)
                    
                    self.allergiesTableview.reloadData()
                    //Getting unit data
                    self.ingredientModelObj.getIngredientUnits(completion: { (success) in
                        if success {
                            self.hud.dismiss()
                            self.unitPickerView.delegate = self
                        } else {
                            self.hud.dismiss()
                        }
                    })
                    
                }else{
                    self.hud.dismiss()
                    print("Allergies cannot not loaded")
                }
            }
       
        
        
        
        // check if the singleton array is empty then add the value to that array
        print(Singleton.instance.ingredientArray)
        if Singleton.instance.ingredientArray.count == 0 {
            Singleton.instance.ingredientArray = ingredientModelObj.ingredientArray
        }
        
        
        
        //Calculate the ingredient price and pass the data to ingedient final array.
        //For Edit recipe
        if Singleton.instance.editRecipe {
            
            cost = 0.0
            //Update total cost of ingredients.
            for (index, _) in Singleton.instance.ingredientArray.enumerated() {
                
                if let costValue  = Singleton.instance.ingredientArray[index]["cost"], costValue != ""  {
                    cost  = Float(cost!) + Float(costValue)!
                    totalCostOfIngrdients.text = String(cost!)
                    Singleton.instance.totalCostOfIngredient = String(cost!)
                }
            }
        }
    }

    @IBAction func costInformationButtonTapped(_ sender: RoundedButton) {
//        self.showAlertWithMessage(alertMessage: "Cost of ingredients you will charge the customer when you bring non-perishable ingredients.(No Meats)")
        
        let alertController = UIAlertController(title: ALERT_TITLE.APP_NAME, message: "Cost of ingredients you will charge the customer when you bring non-perishable ingredients.(No Meats)", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
        }
      
        alertController.addAction(action1)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == allergiesTableview {
            
            return Singleton.instance.ingredientAllergiesArray.count
            
        } else  {
            
            return Singleton.instance.ingredientArray.count
        }
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if tableView == allergiesTableview {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! IngredientAllergiesTableviewCell
            
            if Singleton.instance.ingredientAllergiesArray[indexPath.row]["selected"] == "0" {
                cell.selectAllergiesButtonOutlet.setImage(UIImage(named:"uncheck_icon.png"), for: .normal)
                cell.allergiesNameLabel.text = Singleton.instance.ingredientAllergiesArray[indexPath.row]["name"]
                cell.selectAllergiesButtonOutlet.tag = indexPath.row
                
            } else {
                cell.selectAllergiesButtonOutlet.setImage(UIImage(named:"check_icon.png"), for: .normal)
                cell.allergiesNameLabel.text = Singleton.instance.ingredientAllergiesArray[indexPath.row]["name"]
                cell.selectAllergiesButtonOutlet.tag = indexPath.row
            }
            
           
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! IngredientsCell
            
            //Toolbar for pickerview
            let toolbar = UIToolbar()
            let cancelButton = UIBarButtonItem (barButtonSystemItem: .cancel, target: nil, action: #selector(pickerCancelPressed))
            let doneButton = UIBarButtonItem (barButtonSystemItem: .done, target: nil, action: #selector(pickerDonePressed))
            let flexButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            toolbar.setItems([cancelButton,flexButton, doneButton], animated: true)
            
            doneButton.tintColor = #colorLiteral(red: 0.8862745098, green: 0.1725490196, blue: 0.168627451, alpha: 1)
            cancelButton.tintColor = #colorLiteral(red: 0.8862745098, green: 0.1725490196, blue: 0.168627451, alpha: 1)
            toolbar.sizeToFit()
            cell.unitTextfield.inputAccessoryView = toolbar
            cell.unitTextfield.inputView = unitPickerView
            
            cell.unitTextfield.tag = indexPath.row
            cell.ingredientsNameTextfield.tag = indexPath.row
            cell.quantityTextfield.tag = indexPath.row
            cell.costTextfield.tag = indexPath.row
            
            cell.ingredientsNameTextfield.text = Singleton.instance.ingredientArray[indexPath.row]["name"]
            cell.quantityTextfield.text = Singleton.instance.ingredientArray[indexPath.row]["qty"]
            cell.unitTextfield.text = Singleton.instance.ingredientArray[indexPath.row]["sortName"]
            cell.costTextfield.text = Singleton.instance.ingredientArray[indexPath.row]["cost"]
            
            return cell
        }
    }
    
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return (UIScreen.main.bounds.size.height * 7.04) / 100
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if tableView != allergiesTableview {
//            if editingStyle == .delete {
//                Singleton.instance.ingredientArray.remove(at: indexPath.row)
//                self.ingredientsTableview.deleteRows(at: [indexPath], with: .automatic)
//                self.ingredientsTableview.reloadData()
//            }
            
          
            let alertController = UIAlertController(title:"Delete Ingredient Method.", message:"Are you sure you want to delete?", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action:UIAlertAction!) in
                self.hud.show(in: self.view)
                self.hud.textLabel.text = "Loading"
                self.ingredientModelObj.deleteIngredientMethod(ingredientsId: Singleton.instance.ingredientArray[indexPath.row]["unitId"]!, recipeId: Singleton.instance.preparationRecipeId) { (success) in
                    self.hud.dismiss()
                    if success {
                        Singleton.instance.ingredientArray.remove(at: indexPath.row)
                        self.ingredientsTableview.deleteRows(at: [indexPath], with: .automatic)
                        self.ingredientsTableview.reloadData()
                    }
                }
            }))
            
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action:UIAlertAction!) in
            }))
            self.present(alertController, animated: true, completion: nil)
            
        }
    }
    
    
    
    func showAlertWithMessage(alertMessage:String )
    {
        
        let alertController = UIAlertController(title: ALERT_TITLE.APP_NAME, message: alertMessage, preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
            Singleton.instance.ingredientArray.removeAll()
            Singleton.instance.ingredientFinalArray.removeAll()
            Singleton.instance.searchableTagsArray.removeAll()
            self.dismiss(animated: true, completion: nil)
        }
        
        let action2 = UIAlertAction(title: "Cancel", style: .default) { (action:UIAlertAction) in
            print("You've pressed cancel");
        }
        
        alertController.addAction(action1)
        alertController.addAction(action2)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    
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
        
        unitTextdoneCheck = true
        var tempDictionary = [String: String]()
        let indexPath = IndexPath(row: textfieldtag!, section: 0)
        let cell: IngredientsCell = self.ingredientsTableview.cellForRow(at: indexPath) as! IngredientsCell
        
        tempDictionary["name"] = cell.ingredientsNameTextfield.text
        tempDictionary["qty"] = cell.quantityTextfield.text
        tempDictionary["sortName"] = ingredientModelObj.ingredientUnitArray[selectedUnit!]["sortName"].stringValue
        tempDictionary["cost"] = cell.costTextfield.text
        tempDictionary["unitId"] = ingredientModelObj.ingredientUnitArray[selectedUnit!][ID_KEY].stringValue
        
        Singleton.instance.ingredientArray[textfieldtag!] = tempDictionary
        self.ingredientsTableview.reloadData()
        self.view.endEditing(true)
        
    }
    
    
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textfieldtag = textField.tag
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if !unitTextdoneCheck {
             updateIngredientsArray(index: textField.tag as Int)
        } else{
            unitTextdoneCheck = false
        }
    }
    
    
    
    @IBAction func addMoreIngredientsTapped(_ sender: Any) {
        let tempIngredientDictionary = [
            "name": "",
            "qty": "",
            "unitId": "",
            "cost": "0",
            "sortName":""
        ]

      Singleton.instance.ingredientArray.append(tempIngredientDictionary)
      ingredientsTableview.reloadData()
    }
    
    
    
    @IBAction func doneButtonTapped(_ sender: RoundedButton) {
        
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
                
//                else if Singleton.instance.ingredientArray[index]["cost"] == "" {
//                    alertMessage = "Cost of " + Singleton.instance.ingredientArray[index]["name"]! + " is empty."
//                    flagCheck = true
//
//                }
                break
                
            } else {
                
                flagCheck = false
                Singleton.instance.ingredientFinalArray.append(Singleton.instance.ingredientArray[index])
            }
        }
        
        
        print(Singleton.instance.ingredientFinalArray)
        
        if flagCheck {
             self.present(Helper.globalAlertView(with: "Ingredient", message: alertMessage), animated: true, completion: nil)
        } else {
            dismiss(animated: true, completion: nil)
        }
        
    }
    
    
    
    
    @IBAction func selectAllergiesButtonTapped(_ sender: RoundedButton) {
        
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let cell: IngredientAllergiesTableviewCell = self.allergiesTableview.cellForRow(at: indexPath) as! IngredientAllergiesTableviewCell
        
        if (cell.selectAllergiesButtonOutlet.currentImage?.isEqual(UIImage(named:"uncheck_icon.png")))! {
            cell.selectAllergiesButtonOutlet.setImage(UIImage(named:"check_icon.png"), for: .normal)
            let allergyTemp = [
                "name" : Singleton.instance.ingredientAllergiesArray[sender.tag]["name"],
                ID_KEY : Singleton.instance.ingredientAllergiesArray[sender.tag][ID_KEY],
                "selected" : "1"
            ]
            
            Singleton.instance.ingredientAllergiesArray[sender.tag] = allergyTemp as! [String : String]
        } else{
            cell.selectAllergiesButtonOutlet.setImage(UIImage(named:"uncheck_icon.png"), for: .normal)
            let allergyTemp = [
                "name" : Singleton.instance.ingredientAllergiesArray[sender.tag]["name"],
                ID_KEY : Singleton.instance.ingredientAllergiesArray[sender.tag][ID_KEY],
                "selected" : "0"
            ]
            
            Singleton.instance.ingredientAllergiesArray[sender.tag] = allergyTemp as! [String : String]
        }
        
        allergiesTableview.reloadData()
    }
    
    
    
    
    
    func updateIngredientsArray(index: Int) {
        
        var tempDictionary = [String: String]()
        let indexPath = IndexPath(row: index, section: 0)
        let cell: IngredientsCell = self.ingredientsTableview.cellForRow(at: indexPath) as! IngredientsCell
        
        tempDictionary["name"] = cell.ingredientsNameTextfield.text
        tempDictionary["qty"] = cell.quantityTextfield.text
        tempDictionary["cost"] = cell.costTextfield.text
        
        if let shortName = Singleton.instance.ingredientArray[index]["sortName"] {
            print("this is our shourt n ame ====\(shortName)")
            tempDictionary["sortName"] = shortName
            tempDictionary["unitId"] =  Singleton.instance.ingredientArray[index]["unitId"]
        }
        
       
        
        Singleton.instance.ingredientArray[textfieldtag!] = tempDictionary
        print("Singleton Array\(Singleton.instance.ingredientArray)")
        
        cost = 0.0
        //Update total cost of ingredients.
        for (index, _) in Singleton.instance.ingredientArray.enumerated() {
            
            if let costValue  = Singleton.instance.ingredientArray[index]["cost"], costValue != ""  {
                cost  = Float(cost!) + Float(costValue)!
                totalCostOfIngrdients.text = String(cost!)
                Singleton.instance.totalCostOfIngredient = String(cost!)
            }
        }
        
        self.ingredientsTableview.reloadData()
        self.view.endEditing(true)
    }
    
    
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
         self.view.endEditing(true)
         self.dismiss(animated: true, completion: nil)
         //showAlertWithMessage(alertMessage: "You will loose all enteries of ingredients.")
        
    }
    
    
    @IBAction func tapGestureAction(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        let maxLength = 4
//        let currentString: NSString = textField.text! as NSString
//        let newString: NSString =
//            currentString.replacingCharacters(in: range, with: string) as NSString
//        return newString.length <= maxLength
//    }
    
}




extension IngredientsVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ingredientModelObj.ingredientNameArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ingredientModelObj.ingredientNameArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedUnit = row
    }
    
}
