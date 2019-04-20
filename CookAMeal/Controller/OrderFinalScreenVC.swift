//
//  OrderFinalScreenVC.swift
//  CookAMeal
//
//  Created by CYNOMAC001 on 12/04/18.
//  Copyright © 2018 Cynoteck. All rights reserved.
//

import UIKit
import BraintreeDropIn
import Braintree
import JGProgressHUD
import SwiftyJSON







class OrderFinalScreenVC: UIViewController {
    
    let orderFinalObj: OrderFinalScreenModel = OrderFinalScreenModel()
    let guestModelObj: GuestSignUPModel = GuestSignUPModel()
    let orderFoodSummaryObj : OrderFoodSummaryModel =  OrderFoodSummaryModel()
    var finalCartdict = [String: Any]()
    var finalGuestOrderDict = [String: String]()
    var singleOrder = Bool()
    var guestOrder = Bool()
    var paymentStatus = Bool()
    var pickUpFree = Bool()
    var cookId = String()
    
    var hireCookForSingleRecipe = Bool()
    var forHire = Bool()
    var finalRecipeArray = [JSON]()
    var hireRecipeArray = [JSON]()
    
    var id = String()
    var orderType = String()
    var specialInstruction = String()
    var totalPrice = String()
    let hud = JGProgressHUD(style: .light)
    var serviceCallCheck = Bool()
    
    @IBOutlet weak var bookTimeStackView: UIStackView!
    @IBOutlet weak var startTimeStackView: UIStackView!
    @IBOutlet weak var endTimeStackView: UIStackView!
    
    @IBOutlet weak var stackViewHeightOutlet: NSLayoutConstraint!
    @IBOutlet weak var seperatorLineView: UIView!
    @IBOutlet weak var cookNameLabelOutlet: UILabel!
    @IBOutlet weak var specialInstructiontextview: UITextView!
    @IBOutlet weak var streetAddressLabel: UILabel!
    @IBOutlet weak var cityLabelOutlet: UILabel!
    @IBOutlet weak var stateLabelOutlet: UILabel!
    @IBOutlet weak var countrylabelOutlet: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var bookDateLabelOutlet: UILabel!
    @IBOutlet weak var startTimeLabelOutlet: UILabel!
    @IBOutlet weak var EndTimeLabelOutlet: UILabel!
    @IBOutlet weak var bookDateStaticLabel: UILabel!
    
    @IBOutlet weak var heightConstraintStackView: NSLayoutConstraint!
    @IBOutlet weak var specialInstructionTextviewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var specialInstructionTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var specialInstructionBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var specialInstructionLabelOutlet: UILabel!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackViewOutlet: UIStackView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var itemDetailsLabelOutlet: UILabel!
    
    
    
    
    override func viewDidLayoutSubviews() {
        var stackHeight = 0
        let count = finalRecipeArray.count
        for _ in 0..<count{
            stackHeight = stackHeight + 100
        }
        stackViewHeightOutlet.constant = CGFloat(stackHeight)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print(singleOrder)
        print(finalCartdict)
        print(finalGuestOrderDict)
        print("finalerewrewr",hireRecipeArray)
        
        for recipeData in finalRecipeArray {
            self.setupViews(recipeData: recipeData)
        }
        
        if hireRecipeArray.count != 0  {
            tableViewHeightConstraint.constant = UIScreen.main.bounds.size.height * 0.320
        } else {
            itemDetailsLabelOutlet.text = ""
            tableViewHeightConstraint.constant = 0
        }
        
        
        if guestOrder {
        
            bookTimeStackView.isHidden = true
            startTimeStackView.isHidden = true
            endTimeStackView.isHidden = true
            heightConstraint.constant = 0
            
            heightConstraintStackView.constant = 0
            cookNameLabelOutlet.text = finalCartdict["cookName"] as? String
            streetAddressLabel.text = finalGuestOrderDict["street"]
            cityLabelOutlet.text = finalGuestOrderDict["city"]! + ", " +  finalGuestOrderDict["zipcode"]!
            stateLabelOutlet.text = finalGuestOrderDict["state"]
            countrylabelOutlet.text =  finalGuestOrderDict["country"]
            
            
            if finalCartdict["specialInstruction"] as? String == "" {
               specialInstructionLabelOutlet.text = ""
                
            } else {
                specialInstructionLabelOutlet.text = "Special Instruction"
                specialInstructiontextview.text = finalCartdict["specialInstruction"] as? String
            }
            
            let chargeAmount = finalCartdict["chargeAmount"] as? String
            totalPriceLabel.text = "Total Amount: " + Helper.getUserDefaultValue(key: CURRENCY_SYMBOL_KEY)! + chargeAmount!
            
        } else if hireCookForSingleRecipe {
            
            print(finalCartdict)
            bookDateStaticLabel.isHidden = false
            bookDateLabelOutlet.isHidden = false
            specialInstructionLabelOutlet.isHidden = true
            specialInstructiontextview.isHidden = true
            specialInstructionTextviewHeightConstraint.constant = 0
            //specialInstructionTopConstraint.constant = 0
            specialInstructionBottomConstraint.constant = 0
            
            heightConstraintStackView.constant = 72.5
            cookNameLabelOutlet.text = finalCartdict["cookName"] as? String
            streetAddressLabel.text = finalCartdict["street"] as? String
            
            let city = finalCartdict["city"] as? String
            let zipCode = finalCartdict["zipCode"] as? String
            cityLabelOutlet.text = city! + ", " +  zipCode!
            stateLabelOutlet.text = finalCartdict["state"] as? String
            countrylabelOutlet.text =  finalCartdict["country"] as? String
            
            let chargeAmount = finalCartdict["chargeAmount"] as? String
            totalPriceLabel.text = "Total Amount: " + Helper.getUserDefaultValue(key: CURRENCY_SYMBOL_KEY)! + chargeAmount!
            bookDateLabelOutlet.text = finalCartdict["date"] as? String
            startTimeLabelOutlet.text = finalCartdict["localStartTime"] as? String
            EndTimeLabelOutlet.text = finalCartdict["localEndTime"] as? String
            
            
        } else if pickUpFree {
            
            heightConstraintStackView.constant = 0
            bookDateStaticLabel.isHidden = true
            bookDateLabelOutlet.isHidden = true
            
            hud.textLabel.text = PROGRESS_HUD.HUD_LABEL_KEY
            hud.show(in: self.view)
            orderFinalObj.getCookData(cookId: finalCartdict["cookId"] as! String) { (success) in
                self.hud.dismiss()
                if success {
                    
                    self.cookNameLabelOutlet.text = self.orderFinalObj.cookData["profile"]["fullName"].stringValue
                    self.streetAddressLabel.text = self.orderFinalObj.cookData["cookAddress"]["street"].stringValue
                    self.cityLabelOutlet.text = self.orderFinalObj.cookData["cookAddress"]["city"].stringValue + ", " +  self.orderFinalObj.cookData["cookAddress"]["zipCode"].stringValue
                    self.stateLabelOutlet.text = self.orderFinalObj.cookData["cookAddress"]["state"].stringValue
                    self.countrylabelOutlet.text =  self.orderFinalObj.cookData["cookAddress"]["country"].stringValue
                    self.specialInstructiontextview.text = self.finalCartdict["specialInstruction"] as? String
                    
                    let chargeAmount = self.finalCartdict["chargeAmount"] as! String
                    self.totalPriceLabel.text = "Total Amount: " + Helper.getUserDefaultValue(key: CURRENCY_SYMBOL_KEY)! +  chargeAmount
                    self.finalCartdict[ID_KEY] = self.orderFinalObj.cookData["cookAddress"][ID_KEY].stringValue
                    
                } else {
                    
                   // self.showAlertWithMessage(alertMessage: self.orderFinalObj.alertMessage)
                    self.present(Helper.globalAlertView(with: LOGIN_CONSTANT.ALERT_HEADER_MESSAGE_KEY, message: self.orderFinalObj.alertMessage), animated: true, completion: nil)
                }
            }
            
        } else {
            
            heightConstraintStackView.constant = 0
            bookDateStaticLabel.isHidden = true
            bookDateLabelOutlet.isHidden = true
            cookNameLabelOutlet.text = finalCartdict["cookName"] as? String
            streetAddressLabel.text = finalCartdict["street"] as? String
            
            let city = finalCartdict["city"] as? String
            let zipCode = finalCartdict["zipCode"] as? String
            
            cityLabelOutlet.text = city! + ", " +  zipCode!
            stateLabelOutlet.text = finalCartdict["state"] as? String
            countrylabelOutlet.text =  finalCartdict["country"] as? String
            specialInstructiontextview.text = finalCartdict["specialInstruction"] as? String
            
            let chargeAmount = finalCartdict["chargeAmount"] as? String
            totalPriceLabel.text = "Total Amount: " + Helper.getUserDefaultValue(key: CURRENCY_SYMBOL_KEY)! +  chargeAmount!
            
        }
    }
    
    
    var customPreviewView: OrderSummaryView = {
        let v = OrderSummaryView()
        return v
    }()
    
    
    func setupViews(recipeData: JSON) {
        
        if !singleOrder {
            
            //For my cart order.
            customPreviewView = OrderSummaryView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width - 36, height: 100))
            customPreviewView.setData(recipeName: recipeData["recipeDetails"]["dishName"].stringValue, img: recipeData["recipeDetails"]["MediaObjects"][0]["imageUrl"].stringValue, available: recipeData["recipeDetails"]["availableServings"].stringValue, costPerServing: recipeData["recipeDetails"]["costPerServing"].stringValue, deliveryFee: recipeData["recipeDetails"]["deliveryFee"].stringValue, currencySymbol: Helper.getUserDefaultValue(key: CURRENCY_SYMBOL_KEY)!)
            stackViewOutlet.addArrangedSubview(customPreviewView)
            
        } else {
            
            //For Single Order
            customPreviewView = OrderSummaryView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width - 36, height: 100))
            customPreviewView.setData(recipeName: recipeData["dishName"].stringValue, img: recipeData["MediaObjects"][0]["imageUrl"].stringValue, available: recipeData["availableServings"].stringValue, costPerServing: recipeData["costPerServing"].stringValue, deliveryFee: recipeData["deliveryFee"].stringValue, currencySymbol: Helper.getUserDefaultValue(key: CURRENCY_SYMBOL_KEY)!)
            stackViewOutlet.addArrangedSubview(customPreviewView)
            
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }

    @IBAction func payNowButtonTapped(_ sender: RoundedButton) {
        
        if guestOrder {
            id = finalCartdict["recipeId"] as! String
            orderType = "2"
        } else {
            if singleOrder {
                
                if let recipeId = finalCartdict["recipeId"] as? String {
                   id = recipeId
                   orderType = "2"  // Single Order
                } else {
                   id = finalCartdict["cookId"] as! String
                   orderType = "1"  // Single Order
                }
               
            } else {
                id = finalCartdict["cookId"] as! String
                orderType = "1" // Cart Order
            }
        }
        
        
        hud.textLabel.text = PROGRESS_HUD.HUD_LABEL_KEY
        hud.show(in: self.view)
        orderFinalObj.getPaymentNounce(id: id, orderType: orderType) { (success) in
            self.hud.dismiss()
            if success {
                self.showDropIn(clientTokenOrTokenizationKey: self.orderFinalObj.clientToken)
            } else {
                //self.showAlertWithMessage(alertMessage: self.orderFinalObj.alertMessage)
                self.present(Helper.globalAlertView(with: LOGIN_CONSTANT.ALERT_HEADER_MESSAGE_KEY, message: self.orderFinalObj.alertMessage), animated: true, completion: nil)
            }
        }
    }
    
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: RoundedButton) {
        
        if Singleton.instance.goBackToCart {
            Singleton.instance.goBackToCart = false
            //finalViewToCartViewId
            performSegue(withIdentifier: "backToMyCartID", sender: self)
        } else {
            performSegue(withIdentifier: "unwindToCancelOrder", sender: self)
        }
    }
    
    func showDropIn(clientTokenOrTokenizationKey: String) {
        
        let request =  BTDropInRequest()
        let dropIn = BTDropInController(authorization: clientTokenOrTokenizationKey, request: request)
        { (controller, result, error) in
            if (error != nil) {
                self.showAlertWithMessage(alertMessage: (error?.localizedDescription)!)
            } else if (result?.isCancelled == true) {
                self.showAlertWithMessage(alertMessage: "Cancelled")
            } else if let result = result {
                self.makePayment(paymentNounce: String(describing: result.paymentMethod!.nonce))
            }
            controller.dismiss(animated: true, completion: nil)
        }
        self.present(dropIn!, animated: true, completion: nil)
    }
    
    
    
    
    func makePayment(paymentNounce: String){
        
        if guestOrder {
            
            let noOfServingArr = (finalCartdict["noOfServing"]! as AnyObject).components(separatedBy: " ")
            guestModelObj.userEmail = finalGuestOrderDict["email"]
            guestModelObj.firstname = finalGuestOrderDict["firstName"]
            guestModelObj.lastname = finalGuestOrderDict["lastName"]
            guestModelObj.mobileNumber = finalGuestOrderDict["phone"]
            guestModelObj.street = finalGuestOrderDict["street"]
            guestModelObj.city = finalGuestOrderDict["city"]
            guestModelObj.state = finalGuestOrderDict["state"]
            guestModelObj.pinCode = finalGuestOrderDict["zipcode"]
            guestModelObj.country = finalGuestOrderDict["country"]
            guestModelObj.noOfServing = noOfServingArr[0]
            guestModelObj.spiceLevel = finalCartdict["spiceLevel"] as? String
            guestModelObj.specialInstruction = finalCartdict["specialInstruction"] as? String
            guestModelObj.deliveryType = finalCartdict["deliveryType"] as? String
            guestModelObj.deliveryFee = finalCartdict["deliveryFee"] as? String
            guestModelObj.deliveryDateTime = finalCartdict["pickUpBy"] as? String
            guestModelObj.nonce = paymentNounce
            guestModelObj.chargeAmount = finalCartdict["chargeAmount"] as? String
            guestModelObj.paymentType = finalCartdict["paymentType"] as? String
            guestModelObj.recipeId = finalCartdict["recipeId"] as? String
            
            hud.textLabel.text = PROGRESS_HUD.HUD_LABEL_KEY
            hud.show(in: self.view)
            guestModelObj.registerGuestUser { (success) in
                self.hud.dismiss()
                if success {
                     self.paymentStatus = true
                     self.performSegue(withIdentifier: "toOrderFinalToOrderCompletion", sender: nil)
                } else {
                    self.paymentStatus = false
                    //self.showAlertWithMessage(alertMessage: self.orderFinalObj.alertMessage)
                    self.present(Helper.globalAlertView(with: LOGIN_CONSTANT.ALERT_HEADER_MESSAGE_KEY, message: self.orderFinalObj.alertMessage), animated: true, completion: nil)
                }
            }
            
        } else {
            
            
            hud.textLabel.text = PROGRESS_HUD.HUD_LABEL_KEY
            hud.show(in: self.view)
            orderFinalObj.submitOrderToMakePayment(isHire: forHire, paymentNounce: paymentNounce, orderType: singleOrder, completeDetails: finalCartdict) { (success) in
                self.hud.dismiss()
                if success {
                    
                    if self.orderFinalObj.statusCode == "201" {
                        self.paymentStatus = true
                        self.performSegue(withIdentifier: "toOrderFinalToOrderCompletion", sender: nil)
                    } else {
                        self.paymentStatus = false
                        self.performSegue(withIdentifier: "toOrderFinalToOrderCompletion", sender: nil)
                    }
                    
                } else {
                    //self.showAlertWithMessage(alertMessage: self.orderFinalObj.alertMessage)
                    self.present(Helper.globalAlertView(with: LOGIN_CONSTANT.ALERT_HEADER_MESSAGE_KEY, message: self.orderFinalObj.alertMessage), animated: true, completion: nil)
                }
            }
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if guestOrder {
            if segue.identifier == "toOrderFinalToOrderCompletion" {
                let destinationVC = segue.destination as! OrderCompletionVC
                destinationVC.successStatus = self.paymentStatus
                destinationVC.successDict = guestModelObj.paymentResponse
                destinationVC.guestSuccess = true
            }
        } else {
            if segue.identifier == "toOrderFinalToOrderCompletion" {
                let destinationVC = segue.destination as! OrderCompletionVC
                destinationVC.successStatus = self.paymentStatus
                destinationVC.successDict = orderFinalObj.paymentResponse
            }
        }
    }
    

    //AlertController.
    func showAlertWithMessage(alertMessage:String)
    {
        let alertController = UIAlertController(title:ALERT_TITLE.APP_NAME, message:alertMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action:UIAlertAction!) in
        }))
        self.present(alertController, animated: true, completion: nil)
    }
}



class OrderFinalTableviewCell: UITableViewCell {
    
    @IBOutlet weak var ingredientCostLabelOutlet: UILabel!
    @IBOutlet weak var preperationTimeLabelOutlet: UILabel!
    @IBOutlet weak var cookTimeLabelOutlet: UILabel!
    @IBOutlet weak var ingredientStackViewOutlet: UIStackView!
    @IBOutlet weak var recipeNameLabelOutlet: UILabel!
    
}


extension OrderFinalScreenVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hireRecipeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! OrderFinalTableviewCell
        
        cell.recipeNameLabelOutlet.text = String(indexPath.row + 1) + ". " + hireRecipeArray[indexPath.row]["dishName"].stringValue
        
        
        for element in hireRecipeArray[indexPath.row]["Ingredients"].arrayValue {
            
            let textLabel = UILabel()
            textLabel.textAlignment = .left
            
            //"● " +
            textLabel.text = "• " + element["qty"].stringValue + " " + element["Unit"]["sortName"].stringValue
            textLabel.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            textLabel.font = UIFont(name: "HelveticaNeue", size: 15)
            
            let textLabel2 = UILabel()
            textLabel2.textAlignment = .left
            textLabel2.text =  "    " + element["name"].stringValue
            textLabel2.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            textLabel2.font = UIFont(name: "HelveticaNeue", size: 15)
            
            let child1stackView   = UIStackView()
            child1stackView.axis  = .horizontal
            child1stackView.distribution  = .fillProportionally
            child1stackView.alignment = .leading
            child1stackView.spacing   = 5.0
            child1stackView.addArrangedSubview(textLabel)
            child1stackView.addArrangedSubview(textLabel2)
            
            let child2stackView   = UIStackView()
            child2stackView.axis  = .vertical
            child2stackView.distribution  = .fill
            child2stackView.alignment = .fill
            child2stackView.spacing   = 0.0
            
            let seperatorView = UIView(frame: CGRect(x: 0, y: 0, width: cell.ingredientStackViewOutlet.frame.width, height: 1))
            seperatorView.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            child2stackView.addArrangedSubview(child1stackView)
            child2stackView.addArrangedSubview(seperatorView)
            cell.ingredientStackViewOutlet.addArrangedSubview(child1stackView)
            
            cell.ingredientCostLabelOutlet.text = element["cost"].stringValue
        }
        
        
        
        cell.preperationTimeLabelOutlet.text = hireRecipeArray[indexPath.row]["preparationTimeInMinute"].stringValue
        cell.cookTimeLabelOutlet.text = hireRecipeArray[indexPath.row]["cookTimeInMinute"].stringValue
       
        
        return cell
        
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
