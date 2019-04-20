//
//  CheckOutVC.swift
//  CookAMeal
//
//  Created by Cynoteck on 13/06/18.
//  Copyright © 2018 Cynoteck. All rights reserved.
//

import UIKit
import JGProgressHUD
import SwiftyJSON

class CheckOutCell: UITableViewCell {
    
    @IBOutlet weak var parentStackview: UIStackView!
    @IBOutlet weak var recipeNameLabelOutlet: UILabel!
    @IBOutlet weak var shopingSelectionTextfield: UITextField!
    @IBOutlet weak var ingredientCostTextField: UITextField!
    @IBOutlet weak var ingredientButtonOutlet: UIButton!
    @IBOutlet weak var preparationTime: UILabel!
    @IBOutlet weak var cookTime: UILabel!
    
}


class CheckOutVC: UIViewController {

    var recipeId = String()
    var cookId = String()
    
    var startTime = String()
    var endTime = String()
    var date = String()
    var totalAmount = Double()
    var amount = Double()
    var totalTaxAmount = Double()
    
    var eventId = String()
    var finalRecipeArray = [[String: String]]()
    var tempFinalDict = [String: [[String: String]]]()
    var selectedValue = String()
    let PickerView = UIPickerView()
    let toolbar = UIToolbar()
    var arrayIndex = Int()
    var totalBookHours = String()
    var totalHours = Float()
    var flag = 0
    var boolCheck = Bool()
    var totalIngredientCost = Double()
    
    let hud = JGProgressHUD(style: .light)
    var ingredientSelcetionType = ["Cook will buy ingredients", "Ingredients provided by me"]
    let checkOutModelObj : CheckOutModel = CheckOutModel()
    
    @IBOutlet weak var tax: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var subTotalLabel: UILabel!
    @IBOutlet weak var cookFeeLabel: UILabel!
    @IBOutlet weak var IngredientCost: UILabel!
    @IBOutlet weak var totalHourLabel: UILabel!
    
    @IBOutlet weak var cookImageView: UIImageViewX!
    @IBOutlet weak var cookNameLabel: UILabel!
    @IBOutlet weak var checkOutTableview: UITableView!
    @IBOutlet weak var perHourChargeAmount: UILabel!
    @IBOutlet weak var totalBookedHours: UILabel!
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var detailsStackView: UIStackView!
    @IBOutlet weak var itemDetailsLabel: UILabel!
    @IBOutlet weak var FirstSeparator: UIView!
    @IBOutlet weak var bottomStackView: UIStackView!
    @IBOutlet weak var bottomSeperator: UIView!
    @IBOutlet weak var checkOutButtonOutlet: RoundedButton!
    @IBOutlet weak var profileImageBackground: UIView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
    
        Singleton.instance.notUpdateTimeSlot = false
        selectedValue = ingredientSelcetionType[1]
        totalIngredientCost = 0
        self.IngredientCost.text = Helper.getUserDefaultValue(key: CURRENCY_SYMBOL_KEY)! + "0.0"
        
        let cancelButton = UIBarButtonItem (barButtonSystemItem: .cancel, target: nil, action: #selector(pickerCancelPressed))
        let doneButton = UIBarButtonItem (barButtonSystemItem: .done, target: nil, action: #selector(pickerDonePressed))
        let flexButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([cancelButton,flexButton, doneButton], animated: true)
        
        doneButton.tintColor = #colorLiteral(red: 0.8862745098, green: 0.1725490196, blue: 0.168627451, alpha: 1)
        cancelButton.tintColor = #colorLiteral(red: 0.8862745098, green: 0.1725490196, blue: 0.168627451, alpha: 1)
        toolbar.sizeToFit()
        boolCheck = false
        
        self.PickerView.delegate = self
        let row  = ingredientSelcetionType.index(of: selectedValue)
        PickerView.selectRow(row!, inComponent: 0, animated: false)
        
        print(Singleton.instance.cookBookingSlot)
        
        for element in Singleton.instance.cookBookingSlot {
            let temp = [
                "recipeId" : element["recipeId"]
            ]
            finalRecipeArray.append(temp as! [String : String])
        }
        
        tempFinalDict = [
            "recipes" : finalRecipeArray
        ]
        
        hud.textLabel.text = PROGRESS_HUD.HUD_LABEL_KEY
        hud.show(in: self.view)
        checkOutModelObj.getCookTimeAvailbility(recipes: tempFinalDict, cookId: cookId) { (success) in
            self.hud.dismiss()
            if success {
                
                self.hideViews(value: false)
                
                let startTime = Singleton.instance.cookBookingSlot[0]["startTime"]
                if let endTime = Singleton.instance.cookBookingSlot.last {
                    self.totalBookedHours.text = "Total book hours: " + self.convertTime12HourFormat(date: startTime!) + " to " + self.convertTime12HourFormat(date: endTime["endTime"]!) //self.calculateTotalHours(startTime: startTime!, endTime: endTime["endTime"]!)
                    
                    self.totalHourLabel.text = self.calculateTotalHours(startTime: startTime!, endTime: endTime["endTime"]!) + "hours"
                 }
                
                
                print(self.checkOutModelObj.profileUrl)
                
                //self.calculateTotalHours
                self.cookImageView.sd_setImage(with: URL(string: self.checkOutModelObj.profileUrl), placeholderImage:UIImage(named: "profilePlaceholder"), options: .refreshCached)
                
                self.cookNameLabel.text = self.checkOutModelObj.fullName
                self.tax.text = self.checkOutModelObj.tax + "%"
                
                
                self.totalAmountLabel.text = Helper.getUserDefaultValue(key: CURRENCY_SYMBOL_KEY)! + String(self.roundDown(self.calculateTotalAmount(totalHours: self.totalHours, totalIngredientsCost: 0.0, taxPercentage: Float(self.checkOutModelObj.tax)!, hireAmount:  Float(self.checkOutModelObj.cookPrice)!), toNearest: 0.01))
                
                
                self.perHourChargeAmount.text = "Per hour charges: " + Helper.getUserDefaultValue(key: CURRENCY_SYMBOL_KEY)! + self.checkOutModelObj.cookPrice
                self.cookFeeLabel.text = Helper.getUserDefaultValue(key: CURRENCY_SYMBOL_KEY)! + self.checkOutModelObj.cookPrice
                
                
                
                
                self.checkOutTableview.reloadData()
                
                
            } else {
                
                self.hideViews(value: true)
                
                //self.showAlertWithMessage(alertMessage: self.checkOutModelObj.alertMessage)
                self.present(Helper.globalAlertView(with: LOGIN_CONSTANT.ALERT_HEADER_MESSAGE_KEY, message: self.checkOutModelObj.alertMessage), animated: true, completion: nil)
            }
        }
    }
    
    
    func hideViews(value: Bool) {
        
        profileImageBackground.isHidden = value
        cookNameLabel.isHidden = value
        detailsStackView.isHidden = value
        itemDetailsLabel.isHidden = value
        checkOutTableview.isHidden = value
        FirstSeparator.isHidden = value
        bottomStackView.isHidden = value
        bottomSeperator.isHidden = value
        checkOutButtonOutlet.isHidden = value
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
    }
    
    func roundDown(_ value: Double, toNearest: Double) -> Double {
        return floor(value / toNearest) * toNearest
    }
    
    
    func calculateTotalAmount(totalHours: Float, totalIngredientsCost: Float, taxPercentage: Float, hireAmount: Float ) -> Double  {
        
        amount = Double(totalHours * hireAmount) + Double(totalIngredientsCost)
        totalTaxAmount = amount + (amount * Double((taxPercentage/100)))
        //totalAmount = Double(totalTaxAmount + totalIngredientsCost)
        
        return Double(String(format: "%.2f", totalTaxAmount))!  //TotalTaxAmount

    }
    
    
    @objc func pickerDonePressed() {
        let indexPath = IndexPath(row: arrayIndex, section: 0)
        let cell: CheckOutCell = self.checkOutTableview.cellForRow(at: indexPath) as! CheckOutCell
        let row  = ingredientSelcetionType.index(of: selectedValue)
        cell.shopingSelectionTextfield.text = ingredientSelcetionType[row!]
        
        PickerView.selectRow(row!, inComponent: 0, animated: false)
        
        let rowValue  = ingredientSelcetionType.index(of: selectedValue)
            if rowValue == 0 {
                if !checkOutModelObj.recipeData[arrayIndex]["isCookBringIngredients"].boolValue {
                    checkOutModelObj.recipeData[arrayIndex]["isCookBringIngredients"] = true
                    let ingredientAmount = checkOutModelObj.recipeData[arrayIndex]["totalCostOfIngredients"].doubleValue
                    
                    totalIngredientCost = totalIngredientCost + ingredientAmount
                    IngredientCost.text = Helper.getUserDefaultValue(key: CURRENCY_SYMBOL_KEY)! + String(totalIngredientCost)
                    totalTaxAmount = totalTaxAmount + ingredientAmount
                    totalAmountLabel.text = Helper.getUserDefaultValue(key: CURRENCY_SYMBOL_KEY)! + String(roundDown( calculateTotalAmount(totalHours: self.totalHours, totalIngredientsCost: Float(totalIngredientCost), taxPercentage: Float(self.checkOutModelObj.tax)!, hireAmount:  Float(self.checkOutModelObj.cookPrice)!), toNearest: 0.01))
                }
                
            } else {
                
                if checkOutModelObj.recipeData[arrayIndex]["isCookBringIngredients"].boolValue {
                    checkOutModelObj.recipeData[arrayIndex]["isCookBringIngredients"] = false
                    let ingredientAmount = checkOutModelObj.recipeData[arrayIndex]["totalCostOfIngredients"].doubleValue
                    
                    IngredientCost.text = Helper.getUserDefaultValue(key: CURRENCY_SYMBOL_KEY)! + String(totalIngredientCost - ingredientAmount)  //Helper.getUserDefaultValue(key: CURRENCY_SYMBOL_KEY)! + String(totalIngredientCost)
                    totalTaxAmount = totalTaxAmount - ingredientAmount - (ingredientAmount * Double((Float(self.checkOutModelObj.tax)!/100)))
                    totalAmountLabel.text = Helper.getUserDefaultValue(key: CURRENCY_SYMBOL_KEY)! + String(roundDown(totalTaxAmount, toNearest: 0.01))
                }
            }
        
        self.view.endEditing(true)
    }
    
    
    @objc func pickerCancelPressed() {
        self.view.endEditing(true)
    }
    
    
    
    @IBAction func ingredientsTapped(_ sender: Any) {
        arrayIndex = (sender as AnyObject).tag
        let indexPath = IndexPath(row: (sender as AnyObject).tag, section: 0)
        let cell: CheckOutCell = self.checkOutTableview.cellForRow(at: indexPath) as! CheckOutCell
        cell.shopingSelectionTextfield.becomeFirstResponder()
        PickerView.reloadAllComponents()
    }
    
    
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func checkOutButtonTapped(_ sender: RoundedButton) {
        
        for (index, _) in checkOutModelObj.recipeData.enumerated() {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = self.checkOutTableview.cellForRow(at: indexPath) as? CheckOutCell {
                // do what you need with cell
                if cell.shopingSelectionTextfield.text == "" {
                    self.showAlertWithMessage(alertMessage: "All ingredient field is mendatory.")
                    self.boolCheck = false
                    break
                } else {
                    self.boolCheck = true
                }
            }
        }
        
        
        if boolCheck {
           self.performSegue(withIdentifier: "toCheckOutToAddressSelection", sender: nil)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toCheckOutToAddressSelection" {
            
            
            var hireDict = [String: Any]()
            var recipeArray = [[String: Any]]()
            
            for element in checkOutModelObj.recipeData {
                let tempDict: [String: Any] = [
                    "recipeId" : element["id"].stringValue,
                    "isCookBringIngredients" : element["isCookBringIngredients"].boolValue
                ]
                
                recipeArray.append(tempDict)
            }
            
            //let totalTax = Double(self.checkOutModelObj.tax)!
            let totalAmount = String(roundDown(totalTaxAmount, toNearest: 0.01))
            print(totalAmount)
            
            print(Singleton.instance.cookBookingSlot)
            
            let finalStartTime = Singleton.instance.cookBookingSlot[0]["startTime"]
            
            let endIndex =  Singleton.instance.cookBookingSlot.endIndex
            
            print(endIndex)
            let finalEndTime = Singleton.instance.cookBookingSlot[endIndex-1]["endTime"]
            
            print(finalStartTime!)
            print(finalEndTime!)
            
            hireDict = [
                    "cookName" : self.checkOutModelObj.fullName,
                    "tax" : self.checkOutModelObj.tax,
                    "chargeAmount" : String(totalAmount),
                    "paymentType" : "BrainTree",
                    "recipeId" : recipeArray,
                    "startTime" : date + " " + finalStartTime!, //dateTime(date: date, time: startTime),
                    "endTime" : date + " " + finalEndTime!,//dateTime(date: date, time: endTime),
                    "cookId" : cookId,
                    "eventId" : eventId,
                    "localStartTime" : startTime,
                    "localEndTime" : endTime,
                    "date" :  date,
                    "deliveryType" : "1"
                ]
            
            print(hireDict)
            
            let destinationVC = segue.destination as! SelectDeliveryAddressVC
            destinationVC.cookId = cookId
            destinationVC.singleOrder =  true
            destinationVC.cartDict = hireDict
            destinationVC.forHireCook = true
            destinationVC.hireRecipeArray = checkOutModelObj.recipeData
            
        }
    }
    
    
    func dateTime(date: String, time: String)  -> String{
        let dateTime = date + " " + time
        let dateFormatter = DateFormatter()
        var localTimeZoneAbbreviation: String { return TimeZone.current.abbreviation() ?? "" }
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        dateFormatter.timeZone = NSTimeZone(name: localTimeZoneAbbreviation) as TimeZone?
        let finaldatetime = dateFormatter.date(from: dateTime)
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.timeZone = NSTimeZone.local
        return dateFormatter.string(from: finaldatetime!)
    }
    
    func getTime(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"//this your string date format
        var localTimeZoneAbbreviation: String { return TimeZone.current.abbreviation() ?? "" }
        
        dateFormatter.timeZone = NSTimeZone(name: localTimeZoneAbbreviation) as TimeZone?
        let date = dateFormatter.date(from: date)
        
        dateFormatter.dateFormat = "hh:mm a"///this is what you want to convert format
        dateFormatter.timeZone = NSTimeZone(name: localTimeZoneAbbreviation) as TimeZone?
        
        if let date = date {
            return dateFormatter.string(from: date)
        } else {
            return "Invalid date"
        }
    }
    
    
}

extension CheckOutVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checkOutModelObj.recipeData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CheckOutCell
        
        cell.recipeNameLabelOutlet.text = checkOutModelObj.recipeData[indexPath.row]["dishName"].stringValue
        cell.ingredientButtonOutlet.tag = indexPath.row
        
        cell.shopingSelectionTextfield.inputAccessoryView = toolbar
        cell.shopingSelectionTextfield.inputView = PickerView
        
        
        print(checkOutModelObj.recipeData)
        
        if checkOutModelObj.recipeData[indexPath.row]["isCookBringIngredients"].boolValue {
            cell.shopingSelectionTextfield.text = ingredientSelcetionType[0]
        } else {
            cell.shopingSelectionTextfield.text = ingredientSelcetionType[1]
        }
       
        
        
        let ingredientArray = checkOutModelObj.recipeData[indexPath.row]["Ingredients"].arrayValue
        let currencySymbol = checkOutModelObj.recipeData[indexPath.row]["currencySymbol"].stringValue
        
        cell.ingredientCostTextField.text =  currencySymbol + checkOutModelObj.recipeData[indexPath.row]["totalCostOfIngredients"].stringValue
        cell.preparationTime.text = checkOutModelObj.recipeData[indexPath.row]["preparationTimeInMinute"].stringValue
        cell.cookTime.text = checkOutModelObj.recipeData[indexPath.row]["cookTimeInMinute"].stringValue
        
        if checkOutModelObj.recipeData[indexPath.row]["totalCostOfIngredients"].intValue == 0 {
             cell.shopingSelectionTextfield.isUserInteractionEnabled = false
        }else {
             cell.shopingSelectionTextfield.isUserInteractionEnabled = true
        }
        
        var totalCost = 0
        if flag <= checkOutModelObj.recipeData.count {
            
            flag = flag + 1
            for element in ingredientArray {
                
                
                print(element)
                totalCost = totalCost + element["cost"].intValue
                
                //cell.ingredientCostTextField.text = currencySymbol + String(totalCost)
                let textLabel = UILabel()
                textLabel.textAlignment = .left
                //"● " +
                textLabel.text = element["qty"].stringValue + " " + element["Unit"]["sortName"].stringValue
                textLabel.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                textLabel.font = UIFont(name: "HelveticaNeue", size: 15)
                
                let textLabel2 = UILabel()
                textLabel2.textAlignment = .left
                textLabel2.text = element["name"].stringValue
                textLabel2.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                textLabel2.font = UIFont(name: "HelveticaNeue", size: 15)
                
                let child1stackView   = UIStackView()
                child1stackView.axis  = .horizontal
                child1stackView.distribution  = .fillEqually
                child1stackView.alignment = .center
                child1stackView.spacing   = 5.0
                child1stackView.addArrangedSubview(textLabel)
                child1stackView.addArrangedSubview(textLabel2)
                
                let child2stackView   = UIStackView()
                child2stackView.axis  = .vertical
                child2stackView.distribution  = .fill
                child2stackView.alignment = .fill
                child2stackView.spacing   = 0.0
                
                let seperatorView = UIView(frame: CGRect(x: 0, y: 0, width: cell.parentStackview.frame.width, height: 1))
                seperatorView.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
                child2stackView.addArrangedSubview(child1stackView)
                child2stackView.addArrangedSubview(seperatorView)
                cell.parentStackview.addArrangedSubview(child1stackView)
            }
        }
        
        

        
        return cell
    }
    
}




extension CheckOutVC : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return ingredientSelcetionType.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return ingredientSelcetionType[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            selectedValue = ingredientSelcetionType[row]
    }
    
    
    func showAlertWithMessage(alertMessage:String )
    {
        let alertController = UIAlertController(title:ALERT_TITLE.APP_NAME, message:alertMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action:UIAlertAction!) in
        }))
        self.present(alertController, animated: true, completion: nil)
    }
}


extension CheckOutVC {
    func calculateTotalHours(startTime: String, endTime: String) -> String {
        let timeformatter = DateFormatter()
        timeformatter.dateFormat = "HH:mm"
        
        let time1 = timeformatter.date(from: startTime)
        let time2 = timeformatter.date(from: endTime)
        
        //You can directly use from here if you have two dates
        
        let interval = time2?.timeIntervalSince(time1!)
        let hour = interval! / 3600;
        let minute = interval!.truncatingRemainder(dividingBy: 3600) / 60
        //let intervalInt = Int(interval!)
        
        //"\(intervalInt < 0 ? "-" : "+") \(Int(hour)) Hours \(Int(minute)) Minutes"
        
        let totalBookHours = "\(Int(hour))"
        print("\(Int(hour)) Hours \(Int(minute)) Minutes")
        totalHours = Float(Int(hour))
        return totalBookHours

    }
    
    
    func convertTime12HourFormat(date: String) -> String {
       
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"//this your string date format
            var localTimeZoneAbbreviation: String { return TimeZone.current.abbreviation() ?? "" }
            
            dateFormatter.timeZone = NSTimeZone(name: localTimeZoneAbbreviation) as TimeZone?
            let date = dateFormatter.date(from: date)
            
            dateFormatter.dateFormat = "hh:mm a"///this is what you want to convert format
            dateFormatter.timeZone = NSTimeZone(name: localTimeZoneAbbreviation) as TimeZone?
            return dateFormatter.string(from: date!)
       
    }
    
}



