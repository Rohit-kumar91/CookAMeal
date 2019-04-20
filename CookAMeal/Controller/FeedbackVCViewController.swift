//
//  FeedbackVCViewController.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 03/01/18.
//  Copyright © 2018 Cynoteck. All rights reserved.
//

import UIKit
import JGProgressHUD


class FeedbackVCViewController: UIViewController {
    
    
    @IBOutlet weak var feedbackTypeTextfield: UITextField!
    @IBOutlet weak var feedbackAsTetxfield: UITextField!
    @IBOutlet weak var menuButtonOutlet: UIButton!
    @IBOutlet weak var detailTextview: UITextView!
    
  
    let feedBackArray = ["Report A Bug", "Give Product Feedback"]
    let PickerView = UIPickerView()
    var selectedPickerValue = String()
    var reportBug = String()
    let feedbackModelObj: FeedbackVCModel = FeedbackVCModel()
    let hud = JGProgressHUD(style: .light)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.revealViewController().delegate = self
        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 80
        menuButtonOutlet.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        
        detailTextview.layer.borderWidth = 1
        detailTextview.layer.borderColor =  #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        selectedPickerValue = "Report A Bug"
        
        //User Role
        //2 - customer
        //1 - cook
        if Helper.getUserDefaultValue(key: USER_ROLE_KEY) == "2" {
            feedbackAsTetxfield.text = "Customer"
        } else if Helper.getUserDefaultValue(key: USER_ROLE_KEY) == "1" {
            feedbackAsTetxfield.text = "Cook"
        }
        
        //Creating Picker For Selection.
        //Toolbar for pickerview
        self.PickerView.delegate = self
        let toolbar = UIToolbar()
        let cancelButton = UIBarButtonItem (barButtonSystemItem: .cancel, target: nil, action: #selector(pickerCancelPressed))
        let doneButton = UIBarButtonItem (barButtonSystemItem: .done, target: nil, action: #selector(pickerDonePressed))
        let flexButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([cancelButton,flexButton, doneButton], animated: true)
        
        doneButton.tintColor =  #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        cancelButton.tintColor =  #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        toolbar.sizeToFit()
        feedbackTypeTextfield.inputAccessoryView = toolbar
        feedbackTypeTextfield.inputView = PickerView


    }
    
    override func viewWillAppear(_ animated: Bool)  {
        super.viewWillAppear(animated)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
    }

   
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        
        if selectedPickerValue == "Report A Bug" {
            reportBug = "1"
        } else {
            reportBug = "2"
        }
        
        
        let viewsText = detailTextview.text
        if feedbackTypeTextfield.text == "" || viewsText?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            //self.showAlertWithMessage(alertMessage: "All field are required.")
            self.present(Helper.globalAlertView(with: LOGIN_CONSTANT.ALERT_HEADER_MESSAGE_KEY, message: "All field are required."), animated: true, completion: nil)
        } else {
            hud.show(in: self.view)
            hud.textLabel.text = "Loading"
            feedbackModelObj.postFeedback(reportBug: reportBug, feedbackAs: feedbackAsTetxfield.text!, comment: detailTextview.text!) { (success) in
               self.hud.dismiss()
                if success {
                    self.feedbackTypeTextfield.text = ""
                    self.detailTextview.text = ""
                    
                    self.present(Helper.globalAlertView(with: LOGIN_CONSTANT.ALERT_HEADER_MESSAGE_KEY, message: self.feedbackModelObj.alertMessage), animated: true, completion: nil)
                } else {
                    self.present(Helper.globalAlertView(with: LOGIN_CONSTANT.ALERT_HEADER_MESSAGE_KEY, message: self.feedbackModelObj.alertMessage), animated: true, completion: nil)
                }
            }
        }
    }
 
    
    
    @objc func pickerDonePressed() {
        feedbackTypeTextfield.text = selectedPickerValue
        self.view.endEditing(true)
    }
    
    
    
    @objc func pickerCancelPressed() {
        self.view.endEditing(true)
    }
    
    
    
    func showAlertWithMessage(alertMessage:String)
    {
        let alertController = UIAlertController(title:ALERT_TITLE.APP_NAME, message:alertMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action:UIAlertAction!) in
        }))
        self.present(alertController, animated: true, completion: nil)
    }
}




extension FeedbackVCViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return feedBackArray.count
       
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
       
        return feedBackArray[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       
        selectedPickerValue = feedBackArray[row]
        
    }
    
}

extension FeedbackVCViewController: SWRevealViewControllerDelegate {
    
    func revealController(_ revealController: SWRevealViewController!, willMoveTo position: FrontViewPosition) {
        if(position == FrontViewPosition.left) {
            self.feedbackTypeTextfield.isUserInteractionEnabled = true;
            self.detailTextview.isUserInteractionEnabled = true;
        } else {
            self.feedbackTypeTextfield.isUserInteractionEnabled = false;
            self.detailTextview.isUserInteractionEnabled = false;
            
        }
    }
    
    
    func revealController(_ revealController: SWRevealViewController!, didMoveTo position: FrontViewPosition) {
        if(position == FrontViewPosition.left) {
            self.feedbackTypeTextfield.isUserInteractionEnabled = true;
            self.detailTextview.isUserInteractionEnabled = true;
        } else {
            self.feedbackTypeTextfield.isUserInteractionEnabled = false;
            self.detailTextview.isUserInteractionEnabled = false;
            
        }
    }
}


extension UITextField {
    
    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
}

