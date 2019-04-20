//
//  FacebookEmailVerification.swift
//  CookAMeal
//
//  Created by Cynoteck on 06/09/18.
//  Copyright © 2018 Cynoteck. All rights reserved.
//

import UIKit
import JGProgressHUD

class FacebookEmailVerification: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var submitButtonOutlet: UIButton!
    @IBOutlet weak var otpTextField: UITextField!
    @IBOutlet weak var resendOtpButtonOutlet: UIButton!
    
    
    var email = String()
    var facbookEmailVerificationObj: FacebookEmailVerificationModel = FacebookEmailVerificationModel()
    let hud = JGProgressHUD(style: .light)

    override func viewDidLoad() {
        super.viewDidLoad()

        self.resendOtpButtonOutlet.isHidden = true
        self.otpTextField.isHidden = true
        self.submitButtonOutlet.tag = 1
        
        if email.isEmpty {
            
        } else {
            self.submitButtonOutlet.isUserInteractionEnabled = true
            self.submitButtonOutlet.alpha = 1.0
        }
    }
    
    
    
    
    @IBAction func resendOtpButtonTapped(_ sender: UIButton) {
        
        hud.show(in: self.view)
        hud.textLabel.text = "Loading"
        
        if let userID = Helper.getUserDefaultValue(key: ID_KEY),  let email = emailTextField.text {
            
            facbookEmailVerificationObj.resendOTP(id: userID, emailId: email) { (success) in
                self.hud.dismiss()
                if success {
                    self.showAlertWithMessage(alertMessage: self.facbookEmailVerificationObj.alertMessage)
                } else {
                    self.showAlertWithMessage(alertMessage: self.facbookEmailVerificationObj.alertMessage)
                }
            }
        }
    }
    
        
    
    
    
    @IBAction func verfyEmailAndOTP(_ sender: UIButton) {
        
        if sender.tag == 1 {
            
            facbookEmailVerificationObj.userEmail = emailTextField.text
            
            if !facbookEmailVerificationObj.validateEmail() {
                showAlertWithMessage(alertMessage: self.facbookEmailVerificationObj.alertMessage)
            } else {
                
                if let userID = Helper.getUserDefaultValue(key: ID_KEY),  let email = emailTextField.text {
                    
                    
                    hud.show(in: self.view)
                    hud.textLabel.text = "Loading"
                    facbookEmailVerificationObj.verifyFbEmailAddress(userId: userID, emailId: email, facebookEmailId: email, facebookId: Singleton.instance.fbId) { (success) in
                        self.hud.dismiss()
                        if success {
                            self.emailTextField.isUserInteractionEnabled = false
                            self.otpTextField.isHidden = false
                            self.resendOtpButtonOutlet.isHidden = false
                            self.otpTextField.becomeFirstResponder()
                            self.submitButtonOutlet.tag = 2
                            self.submitButtonOutlet.setTitle("Submit", for: .normal)
                            self.showAlertWithMessage(alertMessage: self.facbookEmailVerificationObj.alertMessage)
                        } else {
                            self.showAlertWithMessage(alertMessage: self.facbookEmailVerificationObj.alertMessage)
                        }
                    }
                } else {
                    self.showAlertWithMessage(alertMessage: "Something happenning wrong.")
                }
            }
            
        } else {
            
        
            
            self.view.endEditing(true)
            // Helper.saveUserDefaultValue(key: TOKEN_KEY, value: self.token as String)
            if let authorizationToken = Helper.getUserDefaultValue(key: TOKEN_KEY) , let otpText = otpTextField.text {
                
                hud.show(in: self.view)
                hud.textLabel.text = "Loading"
                facbookEmailVerificationObj.verifyOtp(authorizationToken: authorizationToken, otpString: otpText) { (success) in
                    if success {
                        self.hud.dismiss()
                        let token = self.facbookEmailVerificationObj.responseJson[DATA_KEY][TOKEN_KEY].stringValue
                        Helper.saveUserDefault(key: TOKEN_KEY, value: token)
                    } else {
                        self.showAlertWithMessage(alertMessage: self.facbookEmailVerificationObj.alertMessage)
                    }
                }
            } else {
                self.showAlertWithMessage(alertMessage: "Please enter OTP.")
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

