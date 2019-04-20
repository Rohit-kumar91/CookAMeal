//
//  ForgotPasswordVC.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 31/01/18.
//  Copyright © 2018 Cynoteck. All rights reserved.
//

import UIKit
import JGProgressHUD

class ForgotPasswordVC: UIViewController {
    
    
    @IBOutlet weak var emailTextfield: UITextField!
    let forgotPasswordObj: ForgotPasswordModel = ForgotPasswordModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
       self.navigationController?.popViewController(animated: true)
    }
    
    
    
    @IBAction func resetPasswordButtonTapped(_ sender: UIButton) {
        
        forgotPasswordObj.userEmail =  emailTextfield.text
        
        if !forgotPasswordObj.validateEmail() {
             self.present(Helper.globalAlertView(with: LOGIN_CONSTANT.ALERT_HEADER_MESSAGE_KEY, message: forgotPasswordObj.alertMessage), animated: true, completion: nil)
        } else {
            
            let hud = JGProgressHUD(style: .light)
            hud.textLabel.text = PROGRESS_HUD.HUD_LABEL_KEY
            hud.show(in: self.view)
            
            //Hide Keybord
            self.view.endEditing(true)
            
            forgotPasswordObj.forgotPassword(completion: { (success) in
                hud.dismiss()
                if success {
                    
                    //self.(withIdentifier: "unwindSegueToLoginScreenID", sender: self)
                    //self.navigationController?.popViewController(animated: true)

                    self.present(Helper.globalAlertView(with: LOGIN_CONSTANT.ALERT_HEADER_MESSAGE_KEY, message: self.forgotPasswordObj.alertMessage), animated: true, completion: nil)
                    
                    
                } else {
                    
                    //Show Alert
                    //self.showAlertWithMessage(alertMessage: self.forgotPasswordObj.alertMessage)
                    self.present(Helper.globalAlertView(with: LOGIN_CONSTANT.ALERT_HEADER_MESSAGE_KEY, message: self.forgotPasswordObj.alertMessage), animated: true, completion: nil)
                }
            })
        }
    }
   
    func showAlertWithMessage(alertMessage:String )
    {
        let alertController = UIAlertController(title:ALERT_TITLE.APP_NAME, message:alertMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action:UIAlertAction!) in
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
}
