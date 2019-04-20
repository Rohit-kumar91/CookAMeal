//
//  OrderFoodSummaryVC.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 05/01/18.
//  Copyright © 2018 Cynoteck. All rights reserved.
//

import UIKit
import SwiftyJSON
import JGProgressHUD
import BraintreeDropIn
import Braintree
import JGProgressHUD

class OrderFoodSummaryVC: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var pickUpByLabel: UILabel!
    @IBOutlet weak var currencySymbolLabel: UILabel!
    @IBOutlet weak var stackViewOutlet: UIStackView!
    let orderFoodSummaryModelObj: OrderFoodSummaryModel = OrderFoodSummaryModel()
    @IBOutlet weak var specialInstructionTextview: UITextviewX!
    @IBOutlet weak var deliveryFeeTextfield: UITextField!
    @IBOutlet weak var pickupByTextfield: UITextField!
    @IBOutlet weak var stackviewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var profileImageview: UIImageView!
    @IBOutlet weak var cookNameLabel: UILabel!
    @IBOutlet weak var totaltaxesTextfield: UITextField!
    @IBOutlet weak var totalAmountTextfield: UITextField!
    @IBOutlet weak var submitButtonOutlet: RoundedButton!
    
    let PickerView = UIPickerView()
    var recipeId = String()
    var spiceLevel = String()
    var orderServing = String()
    
    var serviceCallCheck = Bool()
    var cookId = String()
    var cartId = String()
    var price = Double()
    var pickerIndex = 0
    
    let toolbar = UIToolbar()
    var cancelButton = UIBarButtonItem()
    var doneButton = UIBarButtonItem()
    var flexButton = UIBarButtonItem()
    let datePickerDateAndTime = UIDatePicker()
    var textfieldTagValue = Int()
    
    let hud = JGProgressHUD(style: .light)
    var deliveryFeeSelectedValue = String()
    let count = [1,2]
    var recipeArray = [JSON]()
    var cookName = String()
    var amountIncludingDeliveryFee = String()
    var singleOrder = Bool()
    
    
    
    override func viewDidLayoutSubviews() {
        var stackHeight = 0
        let count = orderFoodSummaryModelObj.count
        for _ in 0..<count{
            stackHeight = stackHeight + 100
        }
        stackviewHeightConstraint.constant = CGFloat(stackHeight)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("CookId\(cookId)")
        
        print(String(format: "%.2f", Double(ceil(82.625*100)/100)))  // 1.57
        

        //Toolbar for pickerview
        self.PickerView.delegate = self
        cancelButton = UIBarButtonItem (barButtonSystemItem: .cancel, target: nil, action: #selector(pickerCancelPressed))
        doneButton = UIBarButtonItem (barButtonSystemItem: .done, target: nil, action: #selector(pickerDonePressed))
        flexButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([cancelButton,flexButton, doneButton], animated: true)
        
        if serviceCallCheck {
            
            let totalPrice = String(format: "%.2f", Double(ceil(price*100)/100))
            totalAmountTextfield.text = self.orderFoodSummaryModelObj.currencySymbol +  String(totalPrice)
        }
        
        doneButton.tintColor =  #colorLiteral(red: 0.8862745098, green: 0.1725490196, blue: 0.168627451, alpha: 1)
        cancelButton.tintColor = #colorLiteral(red: 0.8862745098, green: 0.1725490196, blue: 0.168627451, alpha: 1)
        toolbar.sizeToFit()
        createDateAndTimePicker()
        
        orderFoodSummaryModelObj.recipeId = recipeId
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        hud.textLabel.text = PROGRESS_HUD.HUD_LABEL_KEY
        hud.show(in: self.view)
        
        //Service Call Check.
        if serviceCallCheck {
            
            orderFoodSummaryModelObj.getOrderSummaryCartData(cookId: cookId, completion: { (success) in
                self.hud.dismiss()
                if success {
                    
                    self.submitButtonOutlet.isUserInteractionEnabled = true
                    self.submitButtonOutlet.alpha = 1.0
                
                    self.backgroundView.isHidden = false
                    self.recipeArray = self.orderFoodSummaryModelObj.orderSummaryDataForCart[0]["CartItems"].arrayValue
                    self.profileImageview.sd_setImage(with: URL(string: self.orderFoodSummaryModelObj.orderSummaryDataForCart[0]["profileUrl"].stringValue), placeholderImage:UIImage(named: "recipePlaceholder"), options: .refreshCached)
                    self.cookName = self.orderFoodSummaryModelObj.orderSummaryDataForCart[0]["fullName"].stringValue
                    self.cookNameLabel.text = self.orderFoodSummaryModelObj.orderSummaryDataForCart[0]["fullName"].stringValue
                    self.totaltaxesTextfield.text = self.orderFoodSummaryModelObj.orderSummaryDataForCart[0]["tax"].stringValue + "%"
                    
                    self.PickerView.selectRow(1, inComponent: 0, animated: false)
                    
                    //calculate total price according to the selected value.
                    self.deliveryFeeSelectedValue = self.orderFoodSummaryModelObj.deliveryFeeArray[1]
                    
                    self.pickUpByLabel.text = "Delivery Date/Time:"
                    self.pickerIndex = 1
                    self.deliveryFeeTextfield.text = self.orderFoodSummaryModelObj.currencySymbol + String(self.deliveryFeeSelectedValue)
                    self.amountPaidByCustomer()
                    
                    for recipeData in self.recipeArray {
                        self.setupViews(recipeData: recipeData)
                    }
                    
                } else {
                    
                    //self.showAlertWithMessage(alertMessage: self.orderFoodSummaryModelObj.alertMessage)
                    self.present(Helper.globalAlertView(with: LOGIN_CONSTANT.ALERT_HEADER_MESSAGE_KEY, message: self.orderFoodSummaryModelObj.alertMessage), animated: true, completion: nil)
                    self.submitButtonOutlet.isUserInteractionEnabled = false
                    self.submitButtonOutlet.alpha = 0.5
                }
            })
            
            
        } else {
            
            
            //Getting Intial Data to load.
            orderFoodSummaryModelObj.getPrepareData(recipeId: recipeId) { (success) in
                
                if success {
                    
                    self.submitButtonOutlet.isUserInteractionEnabled = true
                    self.submitButtonOutlet.alpha = 1.0
                    self.backgroundView.isHidden = false
                    self.hud.dismiss()
                    self.recipeArray.append(self.orderFoodSummaryModelObj.recipeDetails["recipeData"])
                    self.profileImageview.sd_setImage(with: URL(string: self.orderFoodSummaryModelObj.recipeDetails["cookProfile"]["profileUrl"].stringValue), placeholderImage:UIImage(named: "recipePlaceholder"), options: .refreshCached)
                    self.cookNameLabel.text = self.orderFoodSummaryModelObj.recipeDetails["cookProfile"]["fullName"].stringValue
                    self.cookName = self.orderFoodSummaryModelObj.recipeDetails["cookProfile"]["fullName"].stringValue
                    self.totaltaxesTextfield.text = self.orderFoodSummaryModelObj.tax + "%"
                    self.PickerView.selectRow(1, inComponent: 0, animated: false)
                    
                    //calculate total price according to the selected value.
                    self.deliveryFeeSelectedValue = self.orderFoodSummaryModelObj.deliveryFeeArray[1]
                    self.pickUpByLabel.text = "Delivery Date/Time:"
                    self.pickerIndex = 1
                    self.deliveryFeeTextfield.text  = self.orderFoodSummaryModelObj.currencySymbol + String(self.deliveryFeeSelectedValue)
                    self.amountPaidByCustomer()
                   
                    
                    //Call Customview to show Recipe data.
                    for recipeData in self.recipeArray {
                        self.setupViews(recipeData: recipeData)
                    }
                    
                } else {
                    self.hud.dismiss()
                    //self.showAlertWithMessage(alertMessage: self.orderFoodSummaryModelObj.alertMessage)
                    self.present(Helper.globalAlertView(with: LOGIN_CONSTANT.ALERT_HEADER_MESSAGE_KEY, message: self.orderFoodSummaryModelObj.alertMessage), animated: true, completion: nil)
                    self.submitButtonOutlet.isUserInteractionEnabled = false
                    self.submitButtonOutlet.alpha = 0.5
                }
            }
        }
        
        
        
        //Set border color of textview.
        specialInstructionTextview.layer.borderWidth = 1
        specialInstructionTextview.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        //For Delivery fee
        deliveryFeeTextfield.inputAccessoryView = toolbar
        deliveryFeeTextfield.inputView = PickerView
        
        
        
    }
    
    
    var customPreviewView: OrderSummaryView = {
        let v = OrderSummaryView()
        return v
    }()
    
    
    func setupViews(recipeData: JSON) {
        
        if serviceCallCheck {
            //For my cart order.
            customPreviewView = OrderSummaryView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width - 36, height: 100))
            customPreviewView.setData(recipeName: recipeData["recipeDetails"]["dishName"].stringValue, img: recipeData["recipeDetails"]["MediaObjects"][0]["imageUrl"].stringValue, available: recipeData["recipeDetails"]["availableServings"].stringValue, costPerServing: recipeData["recipeDetails"]["costPerServing"].stringValue, deliveryFee: recipeData["recipeDetails"]["deliveryFee"].stringValue, currencySymbol: self.orderFoodSummaryModelObj.currencySymbol)
            stackViewOutlet.addArrangedSubview(customPreviewView)
        } else {
            //For Single Order
            customPreviewView = OrderSummaryView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width - 36, height: 100))
            customPreviewView.setData(recipeName: recipeData["dishName"].stringValue, img: recipeData["MediaObjects"][0]["imageUrl"].stringValue, available: recipeData["availableServings"].stringValue, costPerServing: recipeData["costPerServing"].stringValue, deliveryFee: recipeData["deliveryFee"].stringValue, currencySymbol: self.orderFoodSummaryModelObj.currencySymbol)
            stackViewOutlet.addArrangedSubview(customPreviewView)
        }
    }
    
    
    
    @objc func pickerDonePressed() {
        
        
        print("Picker done button tapped.")
        
        let index =  orderFoodSummaryModelObj.deliveryFeeArray.index(of: deliveryFeeSelectedValue)!
        if index == 0 {
            pickUpByLabel.text = "PickUp By:"
            deliveryFeeTextfield.text =   deliveryFeeSelectedValue
        } else {
            pickUpByLabel.text = "Delivery Date/Time:"
            deliveryFeeTextfield.text = self.orderFoodSummaryModelObj.currencySymbol + deliveryFeeSelectedValue
        }
        
        
         if textfieldTagValue == 3 {
          
            amountPaidByCustomer()
            
        } else if textfieldTagValue == 4 {
            
            print("DateTime", datePickerDateAndTime.date)
            print("current date", Date())
            
            let dateTimeWithAdditionalTimeInterval = Date().adding(minutes: 30)
            print("Bt AddingTime", dateTimeWithAdditionalTimeInterval)
            
            
             if datePickerDateAndTime.date < dateTimeWithAdditionalTimeInterval {
                self.showAlertWithMessage(alertMessage: "There must 30 minutes difference between delivery Date/Time and Current Date/Time.")
                
            } else {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM d,yyyy hh:mm a"
                pickupByTextfield.text = dateFormatter.string(from: datePickerDateAndTime.date)
            }
            
            
        }
        self.view.endEditing(true)
    }
    
    
    func amountPaidByCustomer() {
        
        print(pickerIndex)
        //orderFoodSummaryModelObj.deliveryFeeArray
        pickerIndex =  orderFoodSummaryModelObj.deliveryFeeArray.index(of: deliveryFeeSelectedValue)!
        print(pickerIndex)
        
        if pickerIndex == 1 {
            
            if serviceCallCheck {
                
                print(Float(deliveryFeeSelectedValue)!)
                print(Float(orderFoodSummaryModelObj.tax)!)
                print(Float(price))
                
                calculateCartTotalAmount(deliveryCharge: Double(deliveryFeeSelectedValue)!, taxPercentage: Double(orderFoodSummaryModelObj.tax)!, totalCartAmount: Double(price))
            } else {
                
                let orderServingArr = orderServing.components(separatedBy: " ")
                print(deliveryFeeTextfield.text!.suffix(3))
                print(orderFoodSummaryModelObj.costPerServing)
                print(orderFoodSummaryModelObj.tax)
                print(orderServingArr[0])
                
                calculateTotalAmount(deliveryCharge: Double(deliveryFeeSelectedValue)!, costPerServing: Double(orderFoodSummaryModelObj.costPerServing), taxPercentage: Double(orderFoodSummaryModelObj.tax)!, numberOfServing: Double(orderServingArr[0])!)
            }
            
        } else if pickerIndex == 0 {
            if serviceCallCheck {
                calculateCartTotalAmount(deliveryCharge: 0.0, taxPercentage: Double(orderFoodSummaryModelObj.tax)!, totalCartAmount: Double(price))
            }else {
                let orderServingArr = orderServing.components(separatedBy: " ")
                calculateTotalAmount(deliveryCharge: 0.0, costPerServing: Double(orderFoodSummaryModelObj.costPerServing), taxPercentage: Double(orderFoodSummaryModelObj.tax)!, numberOfServing: Double(orderServingArr[0])!)
            }
        }
    }
    
    
    func roundDown(_ value: Double, toNearest: Double) -> Double {
        return floor(value / toNearest) * toNearest
    }
    
    
//    func calculateTotalAmount(deliveryCharge: Float, costPerServing: Float, taxPercentage: Float, numberOfServing: Float)  {
//
//        let amount = costPerServing * numberOfServing
//        let totalTaxAmount = amount + (amount * (taxPercentage/100))
//
//        amountIncludingDeliveryFee = String(roundDown(Double(totalTaxAmount + deliveryCharge), toNearest: 0.01))
//        print("Amount",amountIncludingDeliveryFee)
//
//        let priceeee = totalTaxAmount + deliveryCharge
//        print("Price",priceeee)
//
//        let totalPrice = String(roundDown(Double(totalTaxAmount + deliveryCharge), toNearest: 0.01))
//        print("Total Price",totalPrice)
//        totalAmountTextfield.text = self.orderFoodSummaryModelObj.currencySymbol + String(priceeee)
//     }
    
    
    func calculateTotalAmount(deliveryCharge: Double, costPerServing: Double, taxPercentage: Double, numberOfServing: Double)  {
        
        let amount = costPerServing * numberOfServing
        let totalTaxAmount = amount + (amount * (taxPercentage/100))
        
        let priceeee = totalTaxAmount + deliveryCharge
        amountIncludingDeliveryFee = getTwoDecimalDigitValue(value: String(priceeee))
        print("Amount",amountIncludingDeliveryFee)
        print("Price",priceeee)
      
        let totalPrice = Double(totalTaxAmount + deliveryCharge)
        let roundedValue = round(totalPrice * 100) / 100
        print("Total Price",roundedValue) //5.68
        
        
        totalAmountTextfield.text = self.orderFoodSummaryModelObj.currencySymbol + getTwoDecimalDigitValue(value: String(priceeee))
    }
    
    
    
    func calculateCartTotalAmount(deliveryCharge: Double, taxPercentage: Double, totalCartAmount: Double) {
         let totalTaxAmount = totalCartAmount + (totalCartAmount * (taxPercentage/100))
          //String(format: "%.2f", Double(ceil((totalTaxAmount + deliveryCharge)*100)/100))
         let priceeee = totalTaxAmount + deliveryCharge
         amountIncludingDeliveryFee = getTwoDecimalDigitValue(value: String(priceeee))
        
        let totalPrice = Double(totalTaxAmount + deliveryCharge)
        let roundedValue = round(totalPrice * 100) / 100
      
        
        totalAmountTextfield.text = self.orderFoodSummaryModelObj.currencySymbol + getTwoDecimalDigitValue(value: String(roundedValue))
        
    }
    
    func getTwoDecimalDigitValue(value : String) -> String {
        var finalChar = [Character]()
        let character = Array(String(value))
        var count = 0
        var flag = Bool()
        for character in character {
            if character == "." {
                flag = true
                finalChar.append(character)
            } else {
                
                if count == 2 {
                    break
                } else {
                    if flag {
                        count += 1
                        finalChar.append(character)
                    } else {
                        finalChar.append(character)
                    }
                }
            }
        }
        
        return String(finalChar)
    }

    
    
    @objc func pickerCancelPressed(){
        self.view.endEditing(true)
    }


    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    @IBAction func pickerSelectionTypeButtonTapped(_ sender: UIButton) {
        
        if sender.tag == 3 {
            
            if orderFoodSummaryModelObj.deliveryFeeArray.count == 0 {
                 self.showAlertWithMessage(alertMessage: "Something Happening wrong please try to reload page.")
            } else {
                PickerView.tag  =  sender.tag
                deliveryFeeTextfield.becomeFirstResponder()
                deliveryFeeSelectedValue = orderFoodSummaryModelObj.deliveryFeeArray[0]
                //PickerView.reloadAllComponents()
                //PickerView.selectRow(orderFoodSummaryModelObj.deliveryFeeArray.index(of: deliveryFeeTextfield.text!)!, inComponent: 0, animated: true)
            }
            
        } else if sender.tag == 4 {
            
            PickerView.tag  =  sender.tag
            pickupByTextfield.becomeFirstResponder()
            PickerView.reloadAllComponents()
           
        }
    }
    
    
    
    
    @IBAction func submitButtonTapped(_ sender: RoundedButton) {
        
        orderFoodSummaryModelObj.specialInstruction = specialInstructionTextview.text
        orderFoodSummaryModelObj.deliveryFee = deliveryFeeTextfield.text
        orderFoodSummaryModelObj.pickupBy = pickupByTextfield.text
        orderFoodSummaryModelObj.totalAmount = totalAmountTextfield.text
        
        //Validate fields.
//        if !orderFoodSummaryModelObj.validateSpecialInstruction(){
//            //showAlertWithMessage(alertMessage: orderFoodSummaryModelObj.alertMessage)
//            self.present(Helper.globalAlertView(with: LOGIN_CONSTANT.ALERT_HEADER_MESSAGE_KEY, message: orderFoodSummaryModelObj.alertMessage), animated: true, completion: nil)
//        }
            
        if !orderFoodSummaryModelObj.validateDeliveryFee(){
            self.present(Helper.globalAlertView(with: LOGIN_CONSTANT.ALERT_HEADER_MESSAGE_KEY, message: orderFoodSummaryModelObj.alertMessage), animated: true, completion: nil)
        } else if !orderFoodSummaryModelObj.validatePickupBy(){
            self.present(Helper.globalAlertView(with: LOGIN_CONSTANT.ALERT_HEADER_MESSAGE_KEY, message: orderFoodSummaryModelObj.alertMessage), animated: true, completion: nil)
        } else {
            
            if Helper.getUserDefaultValue(key: GUEST_KEY) == "1" {
                //For Guest User
                self.performSegue(withIdentifier: "toOrderSummaryToGuestSignUP", sender: nil)
            } else if deliveryFeeTextfield.text == "Pickup-Free" {
                self.performSegue(withIdentifier: "orderFoodToOrderFinal", sender: nil)
            } else {
                self.performSegue(withIdentifier: "orderSummaryToDeliveryAddress", sender: nil)
            }
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "orderCompletionId" {
            
            //let destinationVC = segue.destination as! OrderCompletionVC
            
        } else if segue.identifier == "orderSummaryToDeliveryAddress" {
            
            let deliveryType = pickerIndex + 1
            var checkOutDict = [String: String]()
            if singleOrder {
                checkOutDict = [
                    "cookName" : self.cookName,
                    "specialInstruction" : specialInstructionTextview.text!,
                    "deliveryFee" : deliveryFeeTextfield.text!,
                    "pickUpBy" : pickupByTextfield.text!,
                    "tax" : totaltaxesTextfield.text!,
                    "chargeAmount" : amountIncludingDeliveryFee,
                    "paymentType" : "BrainTree",
                    "deliveryType": String(deliveryType),
                    "noOfServing" :  orderServing,
                    "spiceLevel" : spiceLevel,
                    "recipeId" : recipeId
                ]
                
                print(checkOutDict)
                let destinationVC = segue.destination as! SelectDeliveryAddressVC
                destinationVC.cartDict = checkOutDict
                destinationVC.cookId = orderFoodSummaryModelObj.cookId
                destinationVC.recipeArray = recipeArray
                destinationVC.singleOrder =  true
                
            } else {
                
                checkOutDict = [
                    "cookName" : self.cookName,
                    "cartId" : cartId,
                    "cookId" : cookId,
                    "specialInstruction" : specialInstructionTextview.text!,
                    "deliveryFee" : deliveryFeeTextfield.text!,
                    "pickUpBy" : pickupByTextfield.text!,
                    "tax" : totaltaxesTextfield.text!,
                    "chargeAmount" : amountIncludingDeliveryFee,
                    "paymentType" : "BrainTree",
                    "deliveryType": String(deliveryType)
                ]
                
                print(checkOutDict)
                let destinationVC = segue.destination as! SelectDeliveryAddressVC
                destinationVC.cartDict = checkOutDict
                
                print(recipeArray)
                destinationVC.recipeArray = recipeArray
                destinationVC.singleOrder =  false
                
            }
        } else if segue.identifier == "toOrderSummaryToGuestSignUP" {
            
            let deliveryType = pickerIndex + 1
            var checkOutDict = [String: String]()
            
            
            print(cookId)
            checkOutDict = [
                "cookId" : cookId,
                "cookName" : self.cookName,
                "specialInstruction" : specialInstructionTextview.text!,
                "deliveryFee" : deliveryFeeTextfield.text!,
                "pickUpBy" : pickupByTextfield.text!,
                "tax" : totaltaxesTextfield.text!,
                "chargeAmount" : amountIncludingDeliveryFee,
                "paymentType" : "BrainTree",
                "deliveryType": String(deliveryType),
                "noOfServing" :  orderServing,
                "spiceLevel" : spiceLevel,
                "recipeId" : recipeId
            ]
            
            let destinationVC = segue.destination as! GuestSignUPViewController
            destinationVC.recipeData = checkOutDict
            
        } else if segue.identifier == "orderFoodToOrderFinal" {
            
            //PICKUP FREE
             let destinationVC = segue.destination as! OrderFinalScreenVC
             destinationVC.pickUpFree = true
             var checkOutDict = [String: String]()
            
             if singleOrder {
                
                let deliveryType = pickerIndex + 1
                checkOutDict = [
                    "cookName" : self.cookName,
                    "specialInstruction" : specialInstructionTextview.text!,
                    "deliveryFee" : deliveryFeeTextfield.text!,
                    "pickUpBy" : pickupByTextfield.text!,
                    "tax" : totaltaxesTextfield.text!,
                    "chargeAmount" : amountIncludingDeliveryFee,
                    "paymentType" : "BrainTree",
                    "deliveryType": String(deliveryType),
                    "noOfServing" :  orderServing,
                    "spiceLevel" : spiceLevel,
                    "recipeId" : recipeId,
                    "cookId" : orderFoodSummaryModelObj.cookId,
                    
                ]
                
                destinationVC.finalCartdict = checkOutDict
                destinationVC.singleOrder =  true
                destinationVC.finalRecipeArray = recipeArray
                
             } else {
                
                let deliveryType = pickerIndex + 1
                checkOutDict = [
                    "cookName" : self.cookName,
                    "cartId" : cartId,
                    "cookId" : cookId,
                    "specialInstruction" : specialInstructionTextview.text!,
                    "deliveryFee" : deliveryFeeTextfield.text!,
                    "pickUpBy" : pickupByTextfield.text!,
                    "tax" : totaltaxesTextfield.text!,
                    "chargeAmount" : amountIncludingDeliveryFee,
                    "paymentType" : "BrainTree",
                    "deliveryType": String(deliveryType)
                ]
                
                destinationVC.finalCartdict = checkOutDict
                destinationVC.singleOrder =  false
                destinationVC.finalRecipeArray = recipeArray
             }
        }
    }
  
    
    
    
    func createDateAndTimePicker() {
       
        let calendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let currentDate = NSDate()
        let dateComponents = NSDateComponents()
        let minDate = calendar.date(byAdding: dateComponents as DateComponents, to: currentDate as Date, options: NSCalendar.Options(rawValue: 0))
        dateComponents.month = 3 //or you can change month = day(90)
        
        let maxDate = calendar.date(byAdding: dateComponents as DateComponents, to: currentDate as Date, options: NSCalendar.Options(rawValue: 0))
        self.datePickerDateAndTime.maximumDate = maxDate
        self.datePickerDateAndTime.minimumDate = minDate
        
        pickupByTextfield.inputAccessoryView = toolbar
        pickupByTextfield.inputView = datePickerDateAndTime
    }

    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textfieldTagValue = textField.tag
        return true
    }
    
    
    //AlertController.
    func showAlertWithMessage(alertMessage:String) {
        let alertController = UIAlertController(title:ALERT_TITLE.APP_NAME, message:alertMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action:UIAlertAction!) in
        }))
        self.present(alertController, animated: true, completion: nil)
    }
}




extension OrderFoodSummaryVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return orderFoodSummaryModelObj.deliveryFeeArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if row == 0 {
             return orderFoodSummaryModelObj.deliveryFeeArray[row]
        } else if row == 1 {
             return "Delivery " + orderFoodSummaryModelObj.currencySymbol + orderFoodSummaryModelObj.deliveryFeeArray[row]
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        deliveryFeeSelectedValue = orderFoodSummaryModelObj.deliveryFeeArray[row]
    }
}

extension Double {
    func roundTo(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension Date {
    func adding(minutes: Int) -> Date {
        return Calendar.current.date(byAdding: .minute, value: minutes, to: self)!
    }
}

