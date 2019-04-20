//
//  EmailVarificationVC.swift
//  CookAMeal
//
//  Created by Cynoteck on 27/08/18.
//  Copyright © 2018 Cynoteck. All rights reserved.
//

import UIKit
import JGProgressHUD

class EmailVarificationVC: UIViewController {
    
    
    @IBOutlet weak var otpTextfield: UITextField!
    @IBOutlet weak var submitButtonOutlet: UIButton!
    
    let emailVerificationModelObj : EmailVerificationModel =  EmailVerificationModel()
    var authorizationString = String()
    let hud = JGProgressHUD(style: .light)
    var email = String()
    var Id = String()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        print("authorization token\(authorizationString)")
        
    }
    
    @IBAction func resendOtpButtonTapped(_ sender: UIButton) {
        
        hud.show(in: self.view)
        hud.textLabel.text = "Loading"
        
        emailVerificationModelObj.resendOTP(id: Id, emailId: email) { (success) in
            self.hud.dismiss()
            if success {
               self.showAlertWithMessage(alertMessage: self.emailVerificationModelObj.alertMessage)
            } else {
               self.showAlertWithMessage(alertMessage: self.emailVerificationModelObj.alertMessage)
            }
        }
        
    }
    
    @IBAction func submitButton(_ sender: UIButton) {
        
        hud.show(in: self.view)
        hud.textLabel.text = "Loading"
        self.view.endEditing(true)
        emailVerificationModelObj.verifyOtp(authorizationToken: authorizationString, otpString: otpTextfield.text!) { (success) in
            self.hud.dismiss()
            if success {
                
                self.showAlertWithMessage(alertMessage: "You will receive an email after admin approves your account.")
                let token = self.emailVerificationModelObj.responseJson[DATA_KEY][TOKEN_KEY].stringValue
                Helper.saveUserDefault(key: TOKEN_KEY, value: token)
                
            } else {
                self.showAlertWithMessage(alertMessage: self.emailVerificationModelObj.alertMessage)
            }
        }
        
    }
    
    
    func showAlertWithMessage(alertMessage:String ) {
        let alertController = UIAlertController(title:ALERT_TITLE.APP_NAME, message:alertMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action:UIAlertAction!) in
            
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
}


extension EmailVarificationVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var maxLength = Int()
        var currentString = NSString()
        var newString = NSString()
        
        maxLength = 6
        currentString = textField.text! as NSString
        newString = currentString.replacingCharacters(in: range, with: string) as NSString
        
        
        print(newString.length)
        
        if newString.length > 5 {
            submitButtonOutlet.isUserInteractionEnabled = true
            submitButtonOutlet.alpha = 1.0
        } else {
            submitButtonOutlet.isUserInteractionEnabled = false
            submitButtonOutlet.alpha = 0.6
        }
        
        return newString.length <= maxLength
        
    }
}
