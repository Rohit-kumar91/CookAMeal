//
//  NotificationForAdmin.swift
//  CookAMeal
//
//  Created by Cynoteck on 05/10/18.
//  Copyright © 2018 Cynoteck. All rights reserved.
//

import UIKit
import SwiftyJSON
import JGProgressHUD

class NotificationForAdmin: UIViewController {
    
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var adminStatusLabelOutlet: UILabel!
    @IBOutlet weak var recipeImageOutlet: UIImageView!
    @IBOutlet weak var dishNameOutlet: UILabel!
    @IBOutlet weak var availableServingOutlet: UILabel!
    @IBOutlet weak var costPerServingOutlet: UILabel!
    @IBOutlet weak var reasonTextviewOutlet: UITextView!
    @IBOutlet weak var descriptionTextviewOutlet: UITextView!
    
    var notificationId = String()
    var notificationForAdminObj : NotificationForAdminModel = NotificationForAdminModel()
    let hud = JGProgressHUD(style: .light)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mainView.isHidden = true
        // Do any additional setup after loading the view.
        hud.textLabel.text = PROGRESS_HUD.HUD_LABEL_KEY
        hud.show(in: self.view)
        notificationForAdminObj.getNotificationAdminData(notificationId: notificationId) { (success) in
            self.hud.dismiss()
            if success {
                self.mainView.isHidden = false
                self.adminStatusLabelOutlet.text =  self.notificationForAdminObj.notificationData["message"].stringValue
                self.recipeImageOutlet.sd_setImage(with: URL(string: self.notificationForAdminObj.notificationData["recipeDetails"]["MediaObjects"][0]["imageUrl"].stringValue), placeholderImage:UIImage(named: "recipePlaceholder"), options: .refreshCached)
                self.dishNameOutlet.text = self.notificationForAdminObj.notificationData["recipeDetails"]["dishName"].stringValue
                self.availableServingOutlet.text = self.notificationForAdminObj.notificationData["recipeDetails"]["availableServings"].stringValue
                self.costPerServingOutlet.text = self.notificationForAdminObj.notificationData["recipeDetails"]["currencySymbol"].stringValue + self.notificationForAdminObj.notificationData["recipeDetails"]["costPerServing"].stringValue
                self.reasonTextviewOutlet.text = self.notificationForAdminObj.notificationData["reason"].stringValue
                
            } else {
                self.present(Helper.globalAlertView(with: LOGIN_CONSTANT.ALERT_HEADER_MESSAGE_KEY, message: self.notificationForAdminObj.alertMessage), animated: true, completion: nil)
            }
        }
    }
    

    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

}
