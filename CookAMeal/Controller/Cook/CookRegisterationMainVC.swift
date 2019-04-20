//
//  CookRegisterationMainVC.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 26/10/17.
//  Copyright © 2017 Cynoteck. All rights reserved.
//

import UIKit
import MBProgressHUD

class CookRegisterationMainVC: UIViewController, CookRegisterationDelegate {
   
    
    var container: CookContainerViewController!
    var registrationObj: CookRegisterationModel = CookRegisterationModel()
    let authServiceObject:AuthServices = AuthServices()
    let loginObj: LoginModel = LoginModel()
    let userVerificationObj: UserVerificationModel = UserVerificationModel()
    
    
    @IBOutlet weak var oneMoreStepLabel: UILabel!
    @IBOutlet weak var registerButtonOutlet: UIButton!
    @IBOutlet weak var nextButtonOutlet: UIButton!
    var progressHud: MBProgressHUD = MBProgressHUD()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(CustomerRegisterationMainVC.handleShowHudNotification), name: Notification.Name("NotificationShowHudForCook"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(CustomerRegisterationMainVC.handleHideHudNotification), name: Notification.Name("NotificationHideHudForCook"), object: nil)
       
    }
    
    
    @objc func handleShowHudNotification() {
        print("RECEIVED ANY NOTIFICATION")
        progressHud = MBProgressHUD.showAdded(to: self.view, animated: true)
        progressHud.label.text = "Loading"
    }
    
    @objc func handleHideHudNotification() {
        progressHud.hide(animated: true)
        
    }
    
    

    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Oct, 13 2017
    // Input Parameters :   N/A
    // Purpose          :   Navigate Back.
    //>--------------------------------------------------------------------------------------------------
    @IBAction func backButtonTapped(_ sender: UIButton) {
        //dismiss(animated: true, completion: nil)
        if container.currentViewController.isKind(of: CookRegistrationSecondVC.self) {
            oneMoreStepLabel.isHidden = false
            nextButtonOutlet.isHidden = false
            registerButtonOutlet.isHidden = true
            container!.segueIdentifierReceivedFromParent("first")
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Oct, 13 2017
    // Input Parameters :   N/A
    // Purpose          :   Helps in to validate form.
    //>--------------------------------------------------------------------------------------------------
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        
        if container.currentViewController.isKind(of: CookRegistrationFirstVC.self) {
            
             if let getFirstVCObject = self.container.currentViewController as? CookRegistrationFirstVC {
                
                let emailStr = getFirstVCObject.emailTextfield.text
                let firstnameStr = getFirstVCObject.firstnameTextfield.text
                let lastnameStr = getFirstVCObject.lastnameTextfield.text
                let createPasswordStr = getFirstVCObject.createPasswordTextfield.text
                let phoneCodeStr = getFirstVCObject.countryCodeTextfield.text
                let phoneStr = getFirstVCObject.phoneNumberTextfield.text
                let introduceStr = getFirstVCObject.introduceTextview.text
                let profileImage = getFirstVCObject.profileImageview.image
                
                
                registrationObj.userEmail = emailStr
                registrationObj.firstname = firstnameStr
                registrationObj.lastname = lastnameStr
                registrationObj.createPassword = createPasswordStr
                registrationObj.phoneNumber = phoneStr
                registrationObj.introduceYourself = introduceStr
                registrationObj.gender = getFirstVCObject.gender
                registrationObj.profileImage = profileImage
                registrationObj.phoneCode = phoneCodeStr
                
                
                if !registrationObj.validateEmail()
                {
                    showAlertWithMessage(alertMessage: registrationObj.alertMessage)
                }
                else if !registrationObj.validateFirstname()
                {
                    showAlertWithMessage(alertMessage: registrationObj.alertMessage)
                }
                else if !registrationObj.validateLastname()
                {
                    showAlertWithMessage(alertMessage: registrationObj.alertMessage)
                }
                else if !(Singleton.instance.userRegisterationSelectionType == "Facebook") && !registrationObj.validateCreatepassword(){
//                    if !registrationObj.validateCreatepassword()
//                    {
                        //showAlertWithMessage(alertMessage: registrationObj.alertMessage)
                  //  }
                    NotificationCenter.default.post(name: Notification.Name("passwordValidation"), object: nil)
                }
          
                else if !registrationObj.validatePhone()
                {
                    showAlertWithMessage(alertMessage: registrationObj.alertMessage)
                }
                    
                else if !registrationObj.validateGender(){
                    showAlertWithMessage(alertMessage: registrationObj.alertMessage)
                }
                    
                else if !registrationObj.validateIntroduction(){
                    showAlertWithMessage(alertMessage: registrationObj.alertMessage)
                }
                
                
                else {
                    
                    progressHud = MBProgressHUD.showAdded(to: self.view, animated: true)
                    progressHud.label.text = "Loading"
                    
                    // verify user exist or not.
                    userVerificationObj.verifyUser(email: emailStr!, phone: phoneStr!, completion: { (flag, success) in
                        self.progressHud.hide(animated: true)
                        
                        if success {
                           self.container!.segueIdentifierReceivedFromParent("second")
                            self.oneMoreStepLabel.isHidden = true
                            self.nextButtonOutlet.isHidden = true
                            self.registerButtonOutlet.isHidden = false
                            
//                            if flag == "0" {
//                                //Complete registeration.
//                                self.oneMoreStepLabel.isHidden = true
//                                self.nextButtonOutlet.isHidden = true
//                                self.registerButtonOutlet.isHidden = false
//                                self.container!.segueIdentifierReceivedFromParent("second")
//
//                            } else if flag == "1" {
//                                //Forgot Password.
//                                //self.performSegue(withIdentifier: "forgotPasswordId", sender: nil)
//                                self.showAlertWithMessage(alertMessage: self.userVerificationObj.alertMessage)
//
//                            } else if flag == "2" {
//                                //DashBoard.
//                                print("DashBoard")
//
//                            }
                            
                        } else {
                            self.showAlertWithMessage(alertMessage: self.userVerificationObj.alertMessage)
                        }
                    })
                }
            }
 
            
        } else if container.currentViewController.isKind(of: CookRegistrationSecondVC.self){
            
            if let getSecondVCObject = self.container.currentViewController as? CookRegistrationSecondVC {
                
                let streetStr = getSecondVCObject.streetAddressTextfield.text
                let cityStr = getSecondVCObject.cityTextfield.text
                let stateStr = getSecondVCObject.stateTextfield.text
                let zipcodeStr = getSecondVCObject.zipcodeTextfield.text
                let countryStr = getSecondVCObject.countryTextfield.text
                let drivingDistanceStr = getSecondVCObject.drivingDistanceTextfield.text
                let licenseImage = getSecondVCObject.licenseImageview.image
                let drivingDistanceString  = drivingDistanceStr
                let drivingDistanceArr = drivingDistanceString?.components(separatedBy: " ")
                
                registrationObj.streetAddress = streetStr
                registrationObj.city = cityStr
                registrationObj.state = stateStr
                registrationObj.zipcode = zipcodeStr
                registrationObj.country = countryStr
                registrationObj.drivindDistance = drivingDistanceArr![0]
                registrationObj.licenseImage = licenseImage
                
               
                
                if !registrationObj.validateStreetAddress()
                {
                    showAlertWithMessage(alertMessage: registrationObj.alertMessage)
                }
                else if !registrationObj.validateCity()
                {
                    showAlertWithMessage(alertMessage: registrationObj.alertMessage)
                }
                else if !registrationObj.validateState()
                {
                    showAlertWithMessage(alertMessage: registrationObj.alertMessage)
                }
                else if !registrationObj.validateZipcode()
                {
                    showAlertWithMessage(alertMessage: registrationObj.alertMessage)
                }
                else if !registrationObj.validateCountry()
                {
                    showAlertWithMessage(alertMessage: registrationObj.alertMessage)
                }
                else if !registrationObj.validateDrivingDistance(){
                    showAlertWithMessage(alertMessage: registrationObj.alertMessage)
                    
                }
                else if !registrationObj.validateLicensePicture()
                {
                    showAlertWithMessage(alertMessage: registrationObj.alertMessage)
                }
                else if !registrationObj.validateIssuingIdentification(){
                    showAlertWithMessage(alertMessage: registrationObj.alertMessage)
                }
                else{
                    
                    registrationObj.delegate = self
                    progressHud = MBProgressHUD.showAdded(to: self.view, animated: true)
                    progressHud.label.text = "Loading"
                    
                    registrationObj.registerUser(completion: { (message, success, emailVerification) in
                            
                        self.progressHud.hide(animated: true)
                            
                        if success {
                                
                            if !emailVerification {
                                    
                                if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "emailVarificationId") as? EmailVarificationVC {
                                    vc.authorizationString = self.registrationObj.authorizationString
                                    vc.Id = self.registrationObj.id
                                    vc.email = self.registrationObj.email
                                    self.present(vc, animated: true, completion: nil)
                                }
                                    
                            } else {
                                print("Something happening wrong with email verification.")
                            }
                                
                        } else{
                                self.showAlertWithMessage(alertMessage: message)
                        }
                    })
                }
            }
        }
    }
    
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Oct, 30 2017
    // Input Parameters :   Alert message String.
    // Purpose          :   Show the alert on view controller.
    //>--------------------------------------------------------------------------------------------------
    func showAlertWithMessage(alertMessage:String)
    {
        let alertController = UIAlertController(title:ALERT_TITLE.APP_NAME, message:alertMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Oct, 26 2017
    // Input Parameters :   Storyboard Segue.
    // Purpose          :   Responsible for switching the view in container.
    //>--------------------------------------------------------------------------------------------------
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "container"{
            container = segue.destination as! CookContainerViewController
        }
    }
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Oct, 26 2017
    // Input Parameters :   Storyboard Segue.
    // Purpose          :   Show Upload Progress
    //>--------------------------------------------------------------------------------------------------
    func uploadProgress(progress: Float) {
        print("Final Progress\(progress)")
        progressHud.mode = .annularDeterminate
        progressHud.progress = progress
        progressHud.label.text = "Uploading \(Int(progress * 100)) %"
    }
    
    

}
