//
//  RevealSliderVC.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 25/10/17.
//  Copyright © 2017 Cynoteck. All rights reserved.
//

import UIKit
import SDWebImage
import JGProgressHUD
import FacebookLogin
import FBSDKLoginKit


class RevealSliderVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var backgroungView: UIView!
    @IBOutlet weak var sliderTableview: UITableView!
    @IBOutlet weak var profileImageView: UIImageViewX!
    @IBOutlet weak var userNameLabelOutlet: UILabel!
    @IBOutlet weak var emailLabelOutlet: UILabel!
    var revealModalObj: RevealSliderModel = RevealSliderModel()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sliderTableview.dataSource = self
        sliderTableview.delegate = self
        
        
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if Helper.getUserDefaultValue(key: GUEST_KEY) == "0" {
            
            // For Normal Login
            let imageUrl = Helper.getUserDefaultValue(key: PROFILE_URL_KEY)
            let userName = Helper.getUserDefaultValue(key: FULL_NAME_KEY)
            let userEmail = Helper.getUserDefaultValue(key: EMAIL_KEY)
            
            
            userNameLabelOutlet.text = userName
            emailLabelOutlet.text = userEmail
            self.profileImageView.contentMode = .scaleAspectFill
            profileImageView.sd_setImage(with: URL(string: imageUrl!), placeholderImage:UIImage(named: "profilePlaceholder"), options: .refreshCached)
        } else {
            
            //For Guest Login
            userNameLabelOutlet.text = "Guest"
            emailLabelOutlet.text = ""
            self.profileImageView.contentMode = .scaleAspectFill
            profileImageView.sd_setImage(with: URL(string: ""), placeholderImage:UIImage(named: "profilePlaceholder"), options: .refreshCached)
        }
        
       
    }
    
    
    
    override func viewDidLayoutSubviews() {
        
        DispatchQueue.main.async {
            // Asynchronous code running on the main queue
            self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height / 2
            self.backgroungView.layer.cornerRadius = self.backgroungView.frame.size.height / 2
        }
        
    }

    
    
    // MARK: Tableview delegate tha datasource method.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if Helper.getUserDefaultValue(key: GUEST_KEY) == "0" {
            if Helper.getUserDefaultValue(key: USER_ROLE_KEY) == "1" {
                 return sliderConstant.sliderArray.count
            } else{
                return sliderConstant.sliderCustomerArray.count
            }
           
        } else {
            return sliderConstant.sliderGuestArray.count
        }
        
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SliderTableViewCell
        
        if indexPath.row == 4 {
            cell.seperatorView.isHidden = false
        }
        
        if Helper.getUserDefaultValue(key: GUEST_KEY) == "0" {
            
            if Helper.getUserDefaultValue(key: USER_ROLE_KEY) == "1" {
                // For Cook Login
                cell.tableLabel.text = sliderConstant.sliderArray[indexPath.row]["name"]
                cell.tableImageview.image = UIImage(named: sliderConstant.sliderArray[indexPath.row]["imageName"]!)
            } else {
                // For Customer Login
                cell.tableLabel.text = sliderConstant.sliderCustomerArray[indexPath.row]["name"]
                cell.tableImageview.image = UIImage(named: sliderConstant.sliderCustomerArray[indexPath.row]["imageName"]!)
            }
            
            
        } else {
            
            //For Guest Login
            
            cell.tableLabel.text = sliderConstant.sliderGuestArray[indexPath.row]["name"]
            cell.tableImageview.image = UIImage(named: sliderConstant.sliderGuestArray[indexPath.row]["imageName"]!)

            if indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 5 || indexPath.row == 6 || indexPath.row == 7 {
                cell.isUserInteractionEnabled =  false
                cell.tableLabel.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
                
            } else {
                cell.isUserInteractionEnabled =  true
            }
        }
        
        return cell
    }
    
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 50
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        var indexName = String()
        
        if Helper.getUserDefaultValue(key: USER_ROLE_KEY) == "1" {
            // For Cook Login
            indexName  = sliderConstant.sliderArray[indexPath.row]["name"]!
        } else if Helper.getUserDefaultValue(key: USER_ROLE_KEY) == "2" {
            // For Customer Login
            indexName  = sliderConstant.sliderCustomerArray[indexPath.row]["name"]!
        } else {
            //for guest
            indexName  = sliderConstant.sliderGuestArray[indexPath.row]["name"]!
        }
        
        if indexName == "Home" {
            self.performSegue(withIdentifier: "dashBoardId", sender: nil)
        }
        else if indexName == "Recipes" {
            self.performSegue(withIdentifier: "toCookRecipeViewId", sender: nil)
        }
        else if indexName == "Order" {
            self.performSegue(withIdentifier: "toYourOrders", sender: nil)
        }
        else if indexName == "Calendar" {
            self.performSegue(withIdentifier: "calendarIdentifier", sender: nil)
        }
        else if indexName == "Cart" {
            self.performSegue(withIdentifier: "toAddToCart", sender: nil)
        }
        else if indexName == "Favorite" {
            self.performSegue(withIdentifier: "toWishList", sender: nil)
        }
        else if indexName == "Reviews" {
            self.performSegue(withIdentifier: "showReviewId", sender: nil)
        }
        else if indexName == " Profile" {
            self.performSegue(withIdentifier: "myProfileID", sender: nil)
        }
        else if indexName == "Notifications" {
            self.performSegue(withIdentifier: "toNotification", sender: nil)
        }
        else if indexName == "Give Us Feedback" {
            self.performSegue(withIdentifier: "feedbackId", sender: nil)
        }
        else if indexName == "Change Password" {
            self.performSegue(withIdentifier: "toResetPassword", sender: nil)
        }
        else if indexName == "Get Help" {
            
        }
        else if indexName == "Sign Out" {
            logoutUser()
        }
        else if indexName == "Sign In" {
            Helper.removeUserDefault(key: TOKEN_KEY)
        }
  
    }
    
    
    func logoutUser() {
        let alertController = UIAlertController(title:ALERT_TITLE.APP_NAME, message: "Are you sure?", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action:UIAlertAction!) in }))
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action:UIAlertAction!) in
            // For Normal Login
            let hud = JGProgressHUD(style: .light)
            hud.show(in: self.view)
            hud.textLabel.text = "Loading"
            
            self.revealModalObj.logOutUser(completion: { (message, success) in
                hud.dismiss()
                if success {
                    
                    //FBSDKLoginManager().logOut()
                    UserDefaults.standard.removeObject(forKey: PROFILE_URL_KEY)
                    UserDefaults.standard.removeObject(forKey: USER_TYPE_KEY)
                    UserDefaults.standard.removeObject(forKey: USER_ROLE_KEY)
                    UserDefaults.standard.removeObject(forKey: FULL_NAME_KEY)
                    UserDefaults.standard.removeObject(forKey: EMAIL_KEY)
                    UserDefaults.standard.removeObject(forKey: ID_KEY)
                    Helper.removeUserDefault(key: TOKEN_KEY)
                    
                    URLCache.shared.removeAllCachedResponses()
                    URLCache.shared.diskCapacity = 0
                    URLCache.shared.memoryCapacity = 0
                    
                } else{
                    //self.showAlertWithMessage(alertMessage: message)
                    self.present(Helper.globalAlertView(with: LOGIN_CONSTANT.ALERT_HEADER_MESSAGE_KEY, message: message), animated: true, completion: nil)
                }
            })
        }))
        
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "userProfileID" {
            
            let nav = segue.destination as! UINavigationController
            let destinationVC = nav.topViewController as! ProfileVC
            destinationVC.profileId = Helper.getUserDefaultValue(key: ID_KEY)!
        }
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
    
    
}

