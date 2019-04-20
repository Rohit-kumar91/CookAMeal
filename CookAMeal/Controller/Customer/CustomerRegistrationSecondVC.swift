//
//  CustomerRegistrationSecondVC.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 09/11/17.
//  Copyright © 2017 Cynoteck. All rights reserved.
//

import UIKit
import FacebookLogin
import FBSDKLoginKit
import JGProgressHUD


class CustomerRegistrationSecondVC: UIViewController, UITableViewDataSource {
    
    
    @IBOutlet weak var uploadOfficialIdOutlet: UIButton!
    @IBOutlet weak var allergiesTableview: UITableView!
    @IBOutlet weak var facebookConnectionOutlet: UIButton!
    @IBOutlet weak var acceptingTermsOutlet: RoundedButton!
    var dict : [String : AnyObject]!
     let userVerificationObj: UserVerificationModel = UserVerificationModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        Singleton.instance.facebookConnectforCustomer = "0"
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //Check for the user select official identity or not
        
        if Singleton.instance.issuingCountry != "" && Singleton.instance.identificationType != "" && Singleton.instance.choosenTypeId != "" && Singleton.instance.identificationPhoto != nil {
            uploadOfficialIdOutlet.setTitle("Uploaded", for: .normal)
        }
        
        allergiesTableview.layer.borderWidth = 1
        allergiesTableview.layer.borderColor = #colorLiteral(red: 0.737254902, green: 0.737254902, blue: 0.737254902, alpha: 1)
        allergiesTableview.dataSource = self
        self.allergiesTableview.rowHeight = UITableViewAutomaticDimension
    }

    
    
    
     // MARK: Tableview Delegate and Datasource method.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return customerRegistrationConstant.AllergiesArray.allergiesName.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AllergiesTableviewCellTableViewCell
        
        if customerRegistrationConstant.AllergiesArray.allergiesName[indexPath.row]["selectionType"] == "uncheck" {
            cell.customCellLabelOutlet.text = customerRegistrationConstant.AllergiesArray.allergiesName[indexPath.row]["name"]
            cell.checkButtonOutlet.setImage(UIImage(named:"uncheck_icon.png"), for: .normal)
            cell.checkButtonOutlet.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cell.checkButtonOutlet.tag = indexPath.row;
        }
        else if customerRegistrationConstant.AllergiesArray.allergiesName[indexPath.row]["selectionType"]  == "check" {
            cell.customCellLabelOutlet.text = customerRegistrationConstant.AllergiesArray.allergiesName[indexPath.row]["name"]
            cell.checkButtonOutlet.setImage(UIImage(named:"check_icon.png"), for: .normal)
            cell.checkButtonOutlet.tintColor = #colorLiteral(red: 0.9568627451, green: 0.262745098, blue: 0.2117647059, alpha: 1)
            cell.checkButtonOutlet.tag = indexPath.row;
        }
        
        return cell
    }
    

    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Oct, 16 2017
    // Input Parameters :   N/A.
    // Purpose          :   For Adding new allergies.
    //>--------------------------------------------------------------------------------------------------
    @IBAction func addNewAllergiesButton(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Add  Allergy", message: "", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: {
            alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
          
            
            if firstTextField.text != "" {
                let tempDict = ["name":firstTextField.text!, "selectionType" : "uncheck"]
                customerRegistrationConstant.AllergiesArray.allergiesName.insert(tempDict, at: 0)
                self.allergiesTableview.reloadData()
            }
        })
        
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
     
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Allergy Name"
        }
        
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        self.present(alertController, animated: true, completion: nil)
        alertController.view.tintColor = UIColor(named: "Button_Red")

    }
    
    
    
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Oct, 16 2017
    // Input Parameters :   N/A.
    // Purpose          :   For Select or deselect the allergies.
    //>--------------------------------------------------------------------------------------------------
    @IBAction func tableviewButton(_ sender: UIButton) {
        
        if customerRegistrationConstant.AllergiesArray.allergiesName[sender.tag]["selectionType"] == "uncheck" {
            //creating local dictionary
            let tempDict = ["name":customerRegistrationConstant.AllergiesArray.allergiesName[sender.tag]["name"], "selectionType" : "check"]
            customerRegistrationConstant.AllergiesArray.allergiesName[sender.tag] = tempDict as! [String : String]
        }
        else if customerRegistrationConstant.AllergiesArray.allergiesName[sender.tag]["selectionType"] == "check" {
            let tempDict = ["name":customerRegistrationConstant.AllergiesArray.allergiesName[sender.tag]["name"], "selectionType" : "uncheck"]
            customerRegistrationConstant.AllergiesArray.allergiesName[sender.tag] = tempDict as! [String : String]
        }
        
       allergiesTableview.reloadData()
    
    }
    
    
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Oct, 16 2017
    // Input Parameters :   N/A.
    // Purpose          :   Allow user to fetch facebook data.
    //>--------------------------------------------------------------------------------------------------
    @IBAction func facebookConnectionButton(_ sender: UIButton) {
        FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile"], from: self) { (result, err) in
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
        }
    }
    
    
    
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Oct, 16 2017
    // Input Parameters :   Facebook Delegate methods.
    // Purpose          :   Function is fetching the user data through Facebook.
    //>--------------------------------------------------------------------------------------------------
    // MARK: Function to get the facebook user data......
    func getFBUserData(){
        NotificationCenter.default.post(name: Notification.Name("NotificationShowHud"), object: nil)
        
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, picture.type(large), email, first_name, last_name, gender,verified"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    self.dict = result as? [String : AnyObject]
                    print(result!)
                    print(self.dict)
                    
                    if let fbID = self.dict[ID_KEY] {
                        Singleton.instance.fbId = fbID as? String
                    }
                    
                    if let email = self.dict["email"] {
                        Singleton.instance.fbEmail = email as? String
                    }
                    
                    
                    print("Connected To Facebook")
                    NotificationCenter.default.post(name: Notification.Name("NotificationHideHud"), object: nil)
                    
                    
                    var email = String()
                    
                    if Singleton.instance.fbEmail == nil {
                        email = ""
                    } else {
                        email = Singleton.instance.fbEmail
                    }
                    
                    self.userVerificationObj.verifyFacebookUser(facbookID: Singleton.instance.fbId, facebookEmailId:  email, completion: { (fbUserExist, success) in
                        if success {
                            
                            if fbUserExist{
                                Singleton.instance.fbId = ""
                                self.facebookConnectionOutlet.setTitle("Connect", for: .normal)
                                self.showAlertWithMessage(alertMessage: self.userVerificationObj.alertMessage)
                            } else {
                                self.facebookConnectionOutlet.setTitle("Connected", for: .normal)
                            }
                        } else {
                            self.showAlertWithMessage(alertMessage: self.userVerificationObj.alertMessage)
                        }
                    })
                }
            })
        } else {
            NotificationCenter.default.post(name: Notification.Name("NotificationHideHud"), object: nil)
        }
    }
    
    
    
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 23 2017
    // Input Parameters :   N/A.
    // Purpose          :   Function is fetching the user data through Linkedin.
    //>--------------------------------------------------------------------------------------------------
    //"https://api.linkedin.com/v1/people/~:(id,first-name,last-name,email-address,picture-url,picture-urls::(original),positions,date-of-birth,phone-numbers,location)?format=json"
    @IBAction func signUpWithLinkndinTapped(_ sender: Any) {
//        LISDKSessionManager.createSession(withAuth: [LISDK_BASIC_PROFILE_PERMISSION], state: nil, showGoToAppStoreDialog: true, successBlock: { (success) in
//            let url = "https://api.linkedin.com/v1/people/~"
//            if(LISDKSessionManager.hasValidSession()) {
//                LISDKAPIHelper.sharedInstance().getRequest(url, success: { (response) in
//
//                    let dict = self.stringToDictionary(text: (response?.data)!)
//                    print("Response\(String(describing: response))")
//                    print("Dictionary\(String(describing: dict))")
//                    print("your last name is\(String(describing: dict?["lastName"]!))")
//
//                }, error: { (error) in
//                    print(error!)
//                })
//            }
//        }) { (error) in
//            print("error\(String(describing: error))")
//        }
    }

    
    
    
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 23 2017
    // Input Parameters :   Linkndin Response.
    // Purpose          :   convert response to Dictonary type.
    //>--------------------------------------------------------------------------------------------------
    func stringToDictionary(text: String)-> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return (try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any])!
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 23 2017
    // Input Parameters :   Message String.
    // Purpose          :   Show alert when error occur.
    //>--------------------------------------------------------------------------------------------------
    func showAlertWithMessage(alertMessage:String )
    {
        let alertController = UIAlertController(title:ALERT_TITLE.APP_NAME, message:alertMessage, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action:UIAlertAction!) in
            
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 23 2017
    // Input Parameters :   N/A.
    // Purpose          :   Dismiss View Controller.
    //>--------------------------------------------------------------------------------------------------
    @IBAction func uploadIdButtonTapped(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "uploadCertificateID") as! UploadYourIdVC
        vc.flagCheck = true
        Singleton.instance.issuingCountry = ""
        self.present(vc, animated: true, completion: nil)
    }
    
    
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 23 2017
    // Input Parameters :   N/A.
    // Purpose          :   Accepting Terms.
    //>--------------------------------------------------------------------------------------------------
    @IBAction func acceptingTermsButtonTapped(_ sender: RoundedButton) {
        if (acceptingTermsOutlet.currentImage?.isEqual(UIImage(named:"uncheck_icon.png")))! {
            
            acceptingTermsOutlet.setImage(UIImage(named:"check_icon.png"), for: .normal)
            acceptingTermsOutlet.tintColor = #colorLiteral(red: 0.9568627451, green: 0.262745098, blue: 0.2117647059, alpha: 1)
            Singleton.instance.acceptingTermValidate = true
            
        } else if (acceptingTermsOutlet.currentImage?.isEqual(UIImage(named:"check_icon.png")))!{
            
            acceptingTermsOutlet.setImage(UIImage(named:"uncheck_icon.png"), for: .normal)
            acceptingTermsOutlet.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            Singleton.instance.acceptingTermValidate = false

        }
    }
    
    
}
