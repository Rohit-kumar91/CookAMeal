//
//  LoginVC.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 13/10/17.
//  Copyright © 2017 Cynoteck. All rights reserved.
//

import UIKit
import FacebookLogin
import FBSDKLoginKit
import JGProgressHUD


class LoginVC: UIViewController {
    
    var dict : [String : AnyObject]!
    var loginObj: LoginModel = LoginModel()
    var customLoginCheck: Bool!
   
    @IBOutlet weak var emailTextfield: ImageTextfield!
    @IBOutlet weak var passwordTextfield: ImageTextfield!
    @IBOutlet weak var loginButtonOutlet: RoundedButton!
    @IBOutlet weak var facbookButtonOutlet: UIButton!
    @IBOutlet weak var createAccountButtonOutlet: UIButton!
    @IBOutlet weak var guestButtonOutlet: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.view.isMultipleTouchEnabled = false
        loginButtonOutlet.isExclusiveTouch = true
        facbookButtonOutlet.isExclusiveTouch = true
        createAccountButtonOutlet.isExclusiveTouch = true
        guestButtonOutlet.isExclusiveTouch = true
        
    }
    
    
    
    @IBAction func termAndConditionButtonTapped(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "term&ConditionId") as! TermsAndConditionVC
        self.present(vc, animated: true, completion: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
       
    }
    
    
    @IBAction func guestLoginButtonTapped(_ sender: UIButton) {
        
        self.view.endEditing(true)
        let hud = JGProgressHUD(style: .light)
        hud.textLabel.text = PROGRESS_HUD.HUD_LABEL_KEY
        hud.show(in: self.view)
        Singleton.instance.isSimpleGetRequest = true 
        loginObj.guestLoginUser(completion: { (success) in
            
            if success {
                hud.dismiss()
                Helper.saveUserDefault(key: TOKEN_KEY, value: self.loginObj.token)
               // Helper.getUserDefaultValue(key: USER_ROLE_KEY) == "2"
                Helper.saveUserDefaultValue(key: USER_ROLE_KEY, value: "0")
            } else {
                 hud.dismiss()
                self.present(Helper.globalAlertView(with: LOGIN_CONSTANT.ALERT_HEADER_MESSAGE_KEY, message: self.loginObj.alertMessage), animated: true, completion: nil)
            }
        })
    }
    
    
    @IBAction func facebookLoginTapped(_ sender: UIButton) {
        
        customLoginCheck = false
        FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile"], from: self) { (result, err) in
            
            if result != nil {
                if (result?.isCancelled)! {
                    print("cancceleeddddddd")
                }else{
                    if err != nil {
                        print("Custom FB Login Failed", err!)
                        return
                    }else {
                        self.getFBUserData()
                    }
                }
            } else {
                self.present(Helper.globalAlertView(with: LOGIN_CONSTANT.ALERT_HEADER_MESSAGE_KEY, message: "Something happening wrong."), animated: true, completion: nil)
            }
        }
    }
    
    

  
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Oct, 16 2017
    // Input Parameters :   Facebook Delegate methods.
    // Purpose          :   Function is fetching the user data through Facebook.
    //>--------------------------------------------------------------------------------------------------
    // MARK: Function to get the facebook user data.
    func getFBUserData(){
        
        let hud = JGProgressHUD(style: .light)
        hud.textLabel.text = PROGRESS_HUD.HUD_LABEL_KEY
        hud.show(in: self.view)
        
        if((FBSDKAccessToken.current()) != nil) {
            
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, picture.type(large), email, first_name, last_name, gender,verified"]).start(completionHandler: { (connection, result, error) -> Void in
                
                
                if (error == nil){
                    Singleton.instance.fbVerified = "1"
                    self.dict = result as? [String : AnyObject]
                    print(result!)
                    print(self.dict )
                    
                    if let email = self.dict["email"] {
                        Singleton.instance.fbEmail = email as? String
                    }
                    
                    if let firstName = self.dict["first_name"] {
                        Singleton.instance.fbfirstName = firstName as? String
                    }
                    
                    if let lastName = self.dict["last_name"] {
                        Singleton.instance.fblastName = lastName as? String
                    }
                    
                    if let gender = self.dict["gender"] {
                        Singleton.instance.fbGender = gender as? String
                    }
                    
                    if let fbID = self.dict[ID_KEY] {
                        Singleton.instance.fbId = fbID as? String
                    }
                    
                    if let fbImageURL = ((self.dict["picture"] as? [String: Any])?[DATA_KEY] as? [String: Any])?["url"] as? String {
                        //Download image from imageURL
                        Singleton.instance.fbImage = fbImageURL
                    }
                    
                    
                    //Push the user to the user selection type screen after getting the facebook data.
                    //self.performSegue(withIdentifier: "toUserSelection", sender: nil)
                    self.loginObj.loginUserWithFacebook(completion: { (message, success) in
                        
                        hud.dismiss()
                        if success {
                            
                            if self.loginObj.facebookFirstUser {
                                
                                self.performSegue(withIdentifier: "toUserSelection", sender: nil)
                                
                            } else {
                                
                                if !self.loginObj.isFacebookEmailIsVerified {
                                    
                                    if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "facebookViewID") as? FacebookEmailVerification {
                                        
                                        print(Singleton.instance.fbEmail)
                                        
                                        if Singleton.instance.fbEmail != nil {
                                            vc.email = Singleton.instance.fbEmail
                                           
                                        }
                                         self.present(vc, animated: true, completion: nil)
                                    }
                                    
                                    
                                } else {
                                    if !self.loginObj.profileSelected {
                                        
                                        Helper.saveUserDefaultValue(key: GUEST_KEY, value: "0")
                                        Singleton.instance.temperoryToken = self.loginObj.token as String
                                        self.performSegue(withIdentifier: "toUserSelection", sender: nil)
                                        
                                    } else {
                                        Helper.saveUserDefaultValue(key: GUEST_KEY, value: "0")
                                        Helper.saveUserDefault(key: TOKEN_KEY, value: self.loginObj.token as String)
                                    }
                                }
                                
                                
                            }
                            
                        } else {
                            
                            // show alert
                            //self.performSegue(withIdentifier: "toUserSelection", sender: nil)
                            self.present(Helper.globalAlertView(with: LOGIN_CONSTANT.ALERT_HEADER_MESSAGE_KEY, message: self.loginObj.alertMessage), animated: true, completion: nil)
                        }
                    })
                   
                } else{
                    hud.dismiss()
                }
            })
        } else {
            
             hud.dismiss()
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toUserSelection" {
            
            if !customLoginCheck {
                customLoginCheck = false
                let destinationVC = segue.destination as! UserSelectionTypeVC
                //destinationVC.token = self.loginObj.token
            } else {
                let destinationVC = segue.destination as! UserSelectionTypeVC
                destinationVC.customLogin = true
            }
        }
    }

    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Oct, 16 2017
    // Input Parameters :   N/A.
    // Purpose          :   To login user.
    //>--------------------------------------------------------------------------------------------------
    @IBAction func loginButtonTapped(_ sender: RoundedButton) {
        
        self.view.endEditing(true)
        loginObj.userEmail = emailTextfield.text
        loginObj.password = passwordTextfield.text
        Singleton.instance.userRegisterationSelectionType = "customLogin"
        
        if !loginObj.validateEmail()
        {
           self.present(Helper.globalAlertView(with: LOGIN_CONSTANT.ALERT_HEADER_MESSAGE_KEY, message: loginObj.alertMessage), animated: true, completion: nil)
        } else if passwordTextfield.text == "" {
            self.present(Helper.globalAlertView(with: LOGIN_CONSTANT.ALERT_HEADER_MESSAGE_KEY, message:
            "Enter your password."), animated: true, completion: nil)
        }
        
        else{
           
            let hud = JGProgressHUD(style: .light)
            hud.textLabel.text = PROGRESS_HUD.HUD_LABEL_KEY
            hud.show(in: self.view)
            
            loginObj.loginUser(completion: { (success, emailVarification, forgotPassword) in
                
                hud.dismiss()
                if success {
                    
                    if !emailVarification {
                        
                        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "emailVarificationId") as? EmailVarificationVC
                        {
                            vc.authorizationString = self.loginObj.authorizationToken
                            vc.Id = self.loginObj.id
                            vc.email = self.loginObj.email
                            self.present(vc, animated: true, completion: nil)
                        }
                    } else if forgotPassword {
                        
                        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "changePasswordId") as? ChangePasswordVC  {
                           
                            self.present(vc, animated: true, completion: nil)
                        }
                    }
                    
                } else {
                    
                    self.present(Helper.globalAlertView(with: LOGIN_CONSTANT.ALERT_HEADER_MESSAGE_KEY, message: self.loginObj.alertMessage), animated: true, completion: nil)
                }
            })
        }
    }
    
    
    @IBAction func unwindToForgotPassword(segue:UIStoryboardSegue) { }
    
    
    @IBAction func forgetPasswordButtonTapped(_ sender: UIButton) {
    }
    
    
    @IBAction func createAccoutnButtonTapped(_ sender: UIButton) {
        
        customLoginCheck = true
        Singleton.instance.fbEmail = nil
        Singleton.instance.fbId = nil
        performSegue(withIdentifier: "toUserSelection", sender: nil)
        
    }
}
