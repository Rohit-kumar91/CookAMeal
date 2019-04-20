//
//  CustomerRegisterationMainVC.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 09/11/17.
//  Copyright © 2017 Cynoteck. All rights reserved.
//

import UIKit
import MBProgressHUD

class CustomerRegisterationMainVC: UIViewController,UIImagePickerControllerDelegate,UIPopoverControllerDelegate,UINavigationControllerDelegate, CustomerRegisterationDelegate {
    

    var container: CookContainerViewController!
    @IBOutlet weak var oneMoreStepLabel: UILabel!
    @IBOutlet weak var nextButtonOutlet: UIButton!
    @IBOutlet weak var registerationButtonOutlet: UIButton!
    
    let userVerificationObj: UserVerificationModel = UserVerificationModel()
    var registrationObj: CustomerRegistrationModel = CustomerRegistrationModel()
    var progressHud: MBProgressHUD = MBProgressHUD()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(CustomerRegisterationMainVC.handleShowHudNotification), name: Notification.Name("NotificationShowHud"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(CustomerRegisterationMainVC.handleHideHudNotification), name: Notification.Name("NotificationHideHud"), object: nil)

    }
    
    
    
    
    @objc func handleShowHudNotification() {
        print("RECEIVED ANY NOTIFICATION")
        progressHud = MBProgressHUD.showAdded(to: self.view, animated: true)
        progressHud.label.text = "Loading"
        //NotificationCenter.default.removeObserver(self, name: Notification.Name("NotificationShowHud"), object: nil)
        
    }
    
    
    
    @objc func handleHideHudNotification() {
       progressHud.hide(animated: true)
        //NotificationCenter.default.removeObserver(self, name: Notification.Name("NotificationHideHud"), object: nil)

    }

    
    
    
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Oct, 30 2017
    // Input Parameters :   N/A.
    // Purpose          :   Move back to the view.
    //>--------------------------------------------------------------------------------------------------
    @IBAction func backButtonTapped(_ sender: UIButton) {
        //dismiss(animated: true, completion: nil)
        
        if container.currentViewController.isKind(of: CustomerRegistrationSecondVC.self) {
            oneMoreStepLabel.isHidden = false
            nextButtonOutlet.isHidden = false
            registerationButtonOutlet.isHidden = true
            
            //reset allergies array to intial value.
            customerRegistrationConstant.AllergiesArray.allergiesName = [["name" : "Milk", "selectionType" : "uncheck"],
                                                                          ["name" : "Eggs", "selectionType" : "uncheck"],
                                                                          ["name" : "Fish(e.g, bass, flounder, cod)", "selectionType" : "uncheck"],
                                                                          ["name" : "Crustacean Shellfish", "selectionType" : "uncheck"],
                                                                          ["name" : "Tree nuts(e.g, almonds, walnuts, pecans)", "selectionType" : "uncheck"],
                                                                          ["name" : "Peanuts", "selectionType" : "uncheck"],
                                                                          ["name" : "Wheat", "selectionType" : "uncheck"],
                                                                          ["name" : "Soyabeans", "selectionType" : "uncheck"]]
            
            
            container!.segueIdentifierReceivedFromParent("first")
        }else{
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    
    
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Oct, 30 2017
    // Input Parameters :   N/A.
    // Purpose          :   Helps to validate the textfield and also help in to change UIview of container.
    //>--------------------------------------------------------------------------------------------------
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        
        
         if container.currentViewController.isKind(of: CustomerRegistrationFirstVC.self) {
           if let getFirstVCObject = self.container.currentViewController as? CustomerRegistrationFirstVC {
            
                let emailStr = getFirstVCObject.emailTextfield.text
                let firstnameStr = getFirstVCObject.firstnameTextfield.text
                let lastnameStr = getFirstVCObject.lastnameTextfield.text
                let createPasswordStr = getFirstVCObject.createPasswordTextfield.text
                let phoneStr = getFirstVCObject.phoneNumberTextfield.text
                let dietPreference = getFirstVCObject.dietPreferencePicker.text
                let streetAddress = getFirstVCObject.streetAddressTextfield.text
                let city = getFirstVCObject.cityTextfield.text
                let state = getFirstVCObject.stateTextfield.text
                let zipcode = getFirstVCObject.zipcodeTextfield.text
                let country = getFirstVCObject.countryTextfield.text
                let profileImage = getFirstVCObject.profilePictureImageview.image
                let phoneCountryCode = getFirstVCObject.countryCodeTextfield.text
            
                registrationObj.userEmail = emailStr
                registrationObj.firstname = firstnameStr
                registrationObj.lastname = lastnameStr
                registrationObj.createPassword = createPasswordStr
                registrationObj.phoneNumber = phoneStr
                registrationObj.dietPreference = dietPreference
                registrationObj.streetAddress = streetAddress
                registrationObj.city = city
                registrationObj.state = state
                registrationObj.zipcode = zipcode
                registrationObj.country = country
                registrationObj.profileImage = profileImage
                registrationObj.phoneCode = phoneCountryCode
                registrationObj.gender = getFirstVCObject.gender
            
            
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
                else if !registrationObj.validateCreatepassword()
                {
                    NotificationCenter.default.post(name: Notification.Name("passwordValidationCustomer"), object: nil)
                }
                else if !registrationObj.validatePhone()
                {
                    showAlertWithMessage(alertMessage: registrationObj.alertMessage)
                }
                else if !registrationObj.validateGender()
                {
                    showAlertWithMessage(alertMessage: registrationObj.alertMessage)
                }
                else if !registrationObj.validateDietPreference(){
                    showAlertWithMessage(alertMessage: registrationObj.alertMessage)
                }
                else if !registrationObj.validateStreetAddress(){
                    showAlertWithMessage(alertMessage: registrationObj.alertMessage)
                }
                else if !registrationObj.validateCity(){
                    showAlertWithMessage(alertMessage: registrationObj.alertMessage)
                }
                else if !registrationObj.validateState(){
                    showAlertWithMessage(alertMessage: registrationObj.alertMessage)
                }
                else if !registrationObj.validateZipcode(){
                    showAlertWithMessage(alertMessage: registrationObj.alertMessage)
                }
                else if !registrationObj.validateCountry(){
                    showAlertWithMessage(alertMessage: registrationObj.alertMessage)
                }
                
                else{
                    
                    // verify user exist or not.
                  
                    progressHud = MBProgressHUD.showAdded(to: self.view, animated: true)
                    progressHud.label.text = "Loading"
                    
                    userVerificationObj.verifyUser(email: emailStr!, phone: phoneStr!, completion: { (flag, success) in
                        self.progressHud.hide(animated: true)
                        if success {
                            self.container!.segueIdentifierReceivedFromParent("second")
                            self.oneMoreStepLabel.isHidden = true
                            self.nextButtonOutlet.isHidden = true
                            self.registerationButtonOutlet.isHidden = false
//                            if flag == "0" {
//                                //Complete registeration.
//                                self.oneMoreStepLabel.isHidden = true
//                                self.nextButtonOutlet.isHidden = true
//                                self.registerationButtonOutlet.isHidden = false
//                                self.container!.segueIdentifierReceivedFromParent("second")
//                                
//                            } else if flag == "1" {
//                                //Forgot Password.
//                                self.performSegue(withIdentifier: "forgotPasswordCustomerId", sender: nil)
//                                
//                            } else if flag == "2" {
//                                //DashBoard.
//                                print("DashBoard")
//                            }
                            
                        } else {
                            self.showAlertWithMessage(alertMessage: self.userVerificationObj.alertMessage)
                        }
                    })
                }
            }
        } else if container.currentViewController.isKind(of: CustomerRegistrationSecondVC.self) {
            
            if self.container.currentViewController is CustomerRegistrationSecondVC {
                
                if !registrationObj.validateIssuingIdentification(){
                    showAlertWithMessage(alertMessage: registrationObj.alertMessage)
                } else {
                   
                    registrationObj.delegate = self
                    progressHud = MBProgressHUD.showAdded(to: self.view, animated: true)
                    progressHud.label.text = "Loading"
                    registrationObj.registerUser(completion: { (message, success, emailVerification) in
                        
                       self.progressHud.hide(animated: true)
                        if success{
                            
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
                            self.showAlertWithMessage(alertMessage: message, okButtonCheck: false)
                        }
                    })
                }
            }
        }
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
    // Date             :   Oct, 30 2017
    // Input Parameters :   Alert message String.
    // Purpose          :   Show the alert on view controller.
    //>--------------------------------------------------------------------------------------------------
    func showAlertWithMessage(alertMessage:String , okButtonCheck: Bool)
    {
        let alertController = UIAlertController(title:ALERT_TITLE.APP_NAME, message:alertMessage, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action:UIAlertAction!) in
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func uploadProgress(progress: Float) {
        print("Final Progress\(progress)")
        progressHud.mode = .annularDeterminate
        progressHud.progress = progress
        progressHud.label.text = "Uploading \(Int(progress * 100)) %"
    }

}

