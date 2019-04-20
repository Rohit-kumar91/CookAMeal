//
//  ResetPasswordVC.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 30/11/17.
//  Copyright © 2017 Cynoteck. All rights reserved.
//

import UIKit
import JGProgressHUD


class ResetPasswordVC: UIViewController {
    
    @IBOutlet weak var temperoryPassword: UITextField!
    @IBOutlet weak var newPasswordTextfield: UITextField!
    @IBOutlet weak var retypePasswordTextfield: UITextField!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var passwordHintView: UIViewX!
    @IBOutlet weak var passwordHintVerticalConstraint: NSLayoutConstraint!
    
    
    var resetPasswordObj: RssetPasswordModel = RssetPasswordModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        passwordHintView.alpha = 0
        
        //Revealview Controller.
        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 80
        menuButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        
        
        self.revealViewController().frontViewShadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3131710123)
        self.revealViewController().frontViewShadowRadius = 2
        self.revealViewController().frontViewShadowOffset = CGSize(width: 0.0, height: 1.5)
        self.revealViewController().frontViewShadowOpacity = 0.8
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
    }

   
    @IBAction func passwordHintCloseButtonTapped(_ sender: UIButton) {
        passwordHintView.alpha = 0
    }
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 30 2017
    // Input Parameters :   N/A.
    // Purpose          :   Validate textfield and webservice implementation.
    //>--------------------------------------------------------------------------------------------------
    @IBAction func resetPasswordButtontapped(_ sender: RoundedButton) {
        
        self.view.endEditing(true)
        resetPasswordObj.temperoryPassword = temperoryPassword.text
        resetPasswordObj.newPassword = newPasswordTextfield.text
        resetPasswordObj.retypePassword = retypePasswordTextfield.text
        
        if !resetPasswordObj.temperoryPasswordValidate() {
             print("temperory Pasword")
           self.present(Helper.globalAlertView(with: LOGIN_CONSTANT.ALERT_HEADER_MESSAGE_KEY, message: self.resetPasswordObj.alertMessage), animated: true, completion: nil)
        }else if !resetPasswordObj.newPasswordValidate() {
            print("New Pasword")
            passwordHintView.alpha = 1
        } else if !resetPasswordObj.retypePasswordValidate() {
             print("retypr Pasword")
            passwordHintView.alpha = 1
        }else if !resetPasswordObj.checkNewPasswordAndretypePasswordAreSame() {
              self.present(Helper.globalAlertView(with: LOGIN_CONSTANT.ALERT_HEADER_MESSAGE_KEY, message: self.resetPasswordObj.alertMessage), animated: true, completion: nil)
        }else if !resetPasswordObj.checkPasswordFieldAreSame() {
             print("Notsame Pasword")
           self.present(Helper.globalAlertView(with: LOGIN_CONSTANT.ALERT_HEADER_MESSAGE_KEY, message: self.resetPasswordObj.alertMessage), animated: true, completion: nil)
        }
        else {
            
            let hud = JGProgressHUD(style: .light)
            hud.show(in: self.view)
            hud.textLabel.text = "Loading"
            
            passwordHintView.alpha = 0
            resetPasswordObj.changeUserPassword(completion: { (success) in
                hud.dismiss()
                if success {
                    self.temperoryPassword.text = ""
                    self.newPasswordTextfield.text = ""
                    self.retypePasswordTextfield.text = ""
                     self.present(Helper.globalAlertView(with: LOGIN_CONSTANT.ALERT_HEADER_MESSAGE_KEY, message: self.resetPasswordObj.alertMessage), animated: true, completion: nil)
                } else {
                    //self.showAlertWithMessage(alertMessage: self.resetPasswordObj.alertMessage)
                    self.present(Helper.globalAlertView(with: LOGIN_CONSTANT.ALERT_HEADER_MESSAGE_KEY, message: self.resetPasswordObj.alertMessage), animated: true, completion: nil)
                }
            })
        }
    }
    
   
    
    @IBAction func menuButtonTapped(_ sender: UIButton) {
    }
}


extension ResetPasswordVC: UITextFieldDelegate  {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 1 {
            passwordHintView.alpha = 1
        }
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 1 {
            passwordHintView.alpha = 0
        }
    }
}
