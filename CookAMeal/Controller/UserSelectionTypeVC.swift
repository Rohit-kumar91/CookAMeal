//
//  UserSelectionTypeVC.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 20/11/17.
//  Copyright © 2017 Cynoteck. All rights reserved.
//

import UIKit
import SwiftyJSON

class UserSelectionTypeVC: UIViewController {
    
    @IBOutlet weak var cookButtonOutlet: UIButton!
    @IBOutlet weak var customerButtonOutlet: UIButton!
    var token = String()
    let userSelectionObj: UserSelectionModel =  UserSelectionModel()
    var customLogin: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.isMultipleTouchEnabled = false
        cookButtonOutlet.isExclusiveTouch = true
        customerButtonOutlet.isExclusiveTouch = true
        
    }

    
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 23 2017
    // Input Parameters :   N/A.
    // Purpose          :   Allow user to select the user type.
    //>--------------------------------------------------------------------------------------------------
    @IBAction func userSelectionTypeButtonTapped(_ sender: UIButton) {
        
        //Refresh singleton varaible used in registeration.
        Singleton.instance.issuingCountry = ""
        Singleton.instance.identificationType = ""
        Singleton.instance.choosenTypeId = ""
        Singleton.instance.identificationPhoto = nil
        
        if sender.tag == 1 {
            
            
            if customLogin {
                self.performSegue(withIdentifier: "cookRegistrationIdentifier", sender: nil)
            }else {
                
                userSelectionObj.changeProfile(userRole: "1", tokenValue: token, completion: { (success) in
                    
                    if success {
                        //Show OTP Page
                      
                        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "facebookViewID") as? FacebookEmailVerification {
                               // vc.authorizationString = self.loginObj.authorizationToken
                               // vc.Id = self.loginObj.id
                            
                            if Singleton.instance.fbEmail != nil {
                                 vc.email = Singleton.instance.fbEmail
                            }
                            
                            self.present(vc, animated: true, completion: nil)
                        }
                        
                    } else {
                        self.present(Helper.globalAlertView(with: LOGIN_CONSTANT.ALERT_HEADER_MESSAGE_KEY, message: self.userSelectionObj.alertMessage), animated: true, completion: nil)
                    }
                })
            }
            
            
        } else if sender.tag == 2  {
            
            //RESETING THE ALLERGIES ARRAY
            for (index, _) in customerRegistrationConstant.AllergiesArray.allergiesName.enumerated() {
                let tempDict = ["name":customerRegistrationConstant.AllergiesArray.allergiesName[index]["name"], "selectionType" : "uncheck"]
                customerRegistrationConstant.AllergiesArray.allergiesName[sender.tag] = tempDict as! [String : String]
            }
            
            
            if customLogin {
                self.performSegue(withIdentifier: "customerRegistrationIdentifier", sender: nil)
            }else {
                userSelectionObj.changeProfile(userRole: "2", tokenValue: token, completion: { (success) in
                    if success {
                    } else {
                        self.present(Helper.globalAlertView(with: LOGIN_CONSTANT.ALERT_HEADER_MESSAGE_KEY, message: self.userSelectionObj.alertMessage), animated: true, completion: nil)
                    }
                })
            }
        }
    }
}
