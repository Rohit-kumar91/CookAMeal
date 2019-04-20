//
//  OrderCancellationConfirmationVC.swift
//  CookAMeal
//
//  Created by Cynoteck on 19/04/18.
//  Copyright © 2018 Cynoteck. All rights reserved.
//

import UIKit
import CRNotifications


class OrderCancellationConfirmationVC: UIViewController {
    
    @IBOutlet weak var imageview: UIImageViewX!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var orderDateLabel: UILabel!
    @IBOutlet weak var orderIdLabel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var textview: UITextviewX!
    @IBOutlet weak var finishButtonOutlet: RoundedButton!
    @IBOutlet weak var cacellationTextview: UITextviewX!
    
    var orderId = String()
    var orderDate = String()
    var isCancellation = Bool()
    var profileImage = String()
    var cookName = String()
    var totalAmount = String()
    var selectedValue = String()
    let PickerView = UIPickerView()
    var orderType = String()
    
    let orderCancellationConfirmationObj: OrderCancellationConfirmationModel =  OrderCancellationConfirmationModel()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textview.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        textview.layer.borderWidth = 1
        
        selectedValue = orderCancellationConfirmationObj.orderCancellationResionArray[0]
        
        cacellationTextview.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        cacellationTextview.layer.borderWidth = 1
        imageview.sd_setImage(with: URL(string: profileImage), placeholderImage:UIImage(named: "recipePlaceholder"), options: .refreshCached)
        orderDateLabel.text = orderDate
        orderIdLabel.text = orderId
        nameLabel.text = cookName
        totalAmountLabel.text = Helper.getUserDefaultValue(key: CURRENCY_SYMBOL_KEY)! + totalAmount
        PickerView.delegate = self
        
        
        if isCancellation {
            finishButtonOutlet.backgroundColor = #colorLiteral(red: 0.8862745098, green: 0.1725490196, blue: 0.168627451, alpha: 1)
            finishButtonOutlet.setTitle("Cancel Order", for: .normal)
        } else {
            finishButtonOutlet.backgroundColor = #colorLiteral(red: 0.8862745098, green: 0.1725490196, blue: 0.168627451, alpha: 1)
            finishButtonOutlet.setTitle("Reject Order", for: .normal)
        }
        
        
        let toolbar = UIToolbar()
        let cancelButton = UIBarButtonItem (barButtonSystemItem: .cancel, target: nil, action: #selector(pickerCancelPressed))
        let doneButton = UIBarButtonItem (barButtonSystemItem: .done, target: nil, action: #selector(pickerDonePressed))
        let flexButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([cancelButton,flexButton, doneButton], animated: true)
        cacellationTextview.inputAccessoryView = toolbar
        cacellationTextview.inputView = PickerView
        cacellationTextview.tag = 1
        cacellationTextview.inputAccessoryView = toolbar
        cacellationTextview.inputView = PickerView
        
        doneButton.tintColor = #colorLiteral(red: 0.8862745098, green: 0.1725490196, blue: 0.168627451, alpha: 1)
        cancelButton.tintColor = #colorLiteral(red: 0.8862745098, green: 0.1725490196, blue: 0.168627451, alpha: 1)
        toolbar.sizeToFit()
        

    }
    
    
    
    @objc func pickerDonePressed() {
        cacellationTextview.text = selectedValue
        self.view.endEditing(true)
    }
    
    
    
    @objc func pickerCancelPressed() {
        self.view.endEditing(true)
    }
    
    
    
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    func showAlertWithMessage(alertMessage:String)
    {
        let alertController = UIAlertController(title:ALERT_TITLE.APP_NAME, message:alertMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func submitButtonTapped(_ sender: RoundedButton) {
        
        
        let cencellationText = cacellationTextview.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let descriptionText = textview.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if cencellationText.isEmpty {
            self.showAlertWithMessage(alertMessage: "Description cannot be empty.")
        } else if textview.text == "" || descriptionText == "" {
            self.showAlertWithMessage(alertMessage: "Description cannot be empty.")
        }else {
            
            if sender.titleLabel?.text == "Cancel Order" {
                
                var cancelOrderUrl = String()
                print(orderType)
                if orderType == "Order-Food" {
                    cancelOrderUrl = BASE_URL_KEY + "auth/order/cancel-order/"
                } else {
                    cancelOrderUrl = BASE_URL_KEY + "auth/hire/order/cancel-order/"
                }
                
                orderCancellationConfirmationObj.cancelOrder(url: cancelOrderUrl, orderId: orderId, reason: cacellationTextview.text!, description: textview.text! ) { (success) in
                    if success {
                        //toMyOrderID
                        self.performSegue(withIdentifier: "toMyOrderID", sender: self)
                    } else {
                        CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message: self.orderCancellationConfirmationObj.alertMessage, dismissDelay: 3)
                    }
                }
                
            } else if sender.titleLabel?.text == "Reject Order" {
                
                var rejectOrderUrl = String()
                
                if Helper.getUserDefaultValue(key: "orderType") == "0" {
                    rejectOrderUrl = BASE_URL_KEY + "cook/reject-order/"
                } else {
                    rejectOrderUrl = BASE_URL_KEY + "cook/hire/reject-order/"
                }
                
                
                orderCancellationConfirmationObj.cancelOrder(url: rejectOrderUrl, orderId: orderId, reason: cacellationTextview.text!, description: textview.text! ) { (success) in
                    if success {
                        //toMyOrderID
                        self.performSegue(withIdentifier: "toMyOrderID", sender: self)
                    } else {
                        CRNotifications.showNotification(type: CRNotifications.error, title: "Error!", message: self.orderCancellationConfirmationObj.alertMessage, dismissDelay: 3)
                    }
                }
            }
        }
    }
}




extension OrderCancellationConfirmationVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return orderCancellationConfirmationObj.orderCancellationResionArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(orderCancellationConfirmationObj.orderCancellationResionArray[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedValue = orderCancellationConfirmationObj.orderCancellationResionArray[row]
    }
}

