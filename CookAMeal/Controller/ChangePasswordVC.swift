//
//  ChangePasswordVC.swift
//  CookAMeal
//
//  Created by Cynoteck on 25/09/18.
//  Copyright © 2018 Cynoteck. All rights reserved.
//

import UIKit
import JGProgressHUD


class ChangePasswordVC: UIViewController {
    
    
    
    @IBOutlet weak var newPasswordTextfield: UITextField!
    @IBOutlet weak var confirmPasswordTextfield: UITextField!
    @IBOutlet weak var passwordHintView: UIViewX!
    
    let changePasswordObj: ChangePasswordModel = ChangePasswordModel()
    let hud = JGProgressHUD(style: .light)


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        passwordHintView.alpha = 0
        newPasswordTextfield.tag = 1
        confirmPasswordTextfield.tag = 2
        
        
    }

    
    @IBAction func passwordHintCloseButton(_ sender: UIButton) {
        passwordHintView.alpha = 0
    }
    
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func resetPasswordButtonTapped(_ sender: UIButton) {
        
        self.view.endEditing( true)
        
        changePasswordObj.newPassword = newPasswordTextfield.text
        changePasswordObj.confirmPassword = newPasswordTextfield.text
        
        if !changePasswordObj.newPasswordValidate() {
            showAlertWithMessage(alertMessage: changePasswordObj.alertMessage)
        }else if !changePasswordObj.confirmPasswordValidate() {
            showAlertWithMessage(alertMessage: changePasswordObj.alertMessage)
        }else if !changePasswordObj.bothPasswordSame() {
            showAlertWithMessage(alertMessage: changePasswordObj.alertMessage)
        }else{
            
            hud.textLabel.text = PROGRESS_HUD.HUD_LABEL_KEY
            hud.show(in: self.view)
            changePasswordObj.changePassword { (success) in
                self.hud.dismiss()
                if success {
                    self.showAlert(alertMessage: self.changePasswordObj.alertMessage)
                } else {
                    self.showAlertWithMessage(alertMessage: self.changePasswordObj.alertMessage)
                }
            }
        }
    }
    


    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 22 2017
    // Input Parameters :   N/A.
    // Purpose          :   Alert Message.
    //>--------------------------------------------------------------------------------------------------
    func showAlertWithMessage(alertMessage:String )
    {
        let alertController = UIAlertController(title:ALERT_TITLE.APP_NAME, message:alertMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action:UIAlertAction!) in
            
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func showAlert(alertMessage:String )
    {
        let alertController = UIAlertController(title:ALERT_TITLE.APP_NAME, message:alertMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action:UIAlertAction!) in
              self.dismiss(animated: true, completion: nil)
        }))
        self.present(alertController, animated: true, completion: nil)
    }

}

extension ChangePasswordVC: UITextFieldDelegate  {
    
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
