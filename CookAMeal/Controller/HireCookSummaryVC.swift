//
//  HireCookSummaryVC.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 11/01/18.
//  Copyright © 2018 Cynoteck. All rights reserved.
//

import UIKit

class HireCookSummaryVC: UIViewController {
    
    
    @IBOutlet weak var spiceLevelTextfield: ImageTextfield!
    @IBOutlet weak var orderServingTextfield: ImageTextfield!
    @IBOutlet weak var specialInstructionTextview: UITextviewX!
    @IBOutlet weak var addedFeaturesTextfield: ImageTextfield!
    @IBOutlet weak var dateTimeTextfield: ImageTextfield!
    @IBOutlet weak var dailyTextfield: ImageTextfield!
    @IBOutlet weak var weekDaysTextfield: ImageTextfield!
    @IBOutlet weak var cleaningTimeLabel: UILabel!
    @IBOutlet weak var cookingtTimeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    var hireCookSummaryObj: HireCookSummaryModel = HireCookSummaryModel()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())

        // Do any additional setup after loading the view.
        specialInstructionTextview.layer.borderWidth = 1
        specialInstructionTextview.layer.borderColor  = #colorLiteral(red: 0.7233663201, green: 0.7233663201, blue: 0.7233663201, alpha: 1)
    }

    
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    
    
    @IBAction func submitButtonTapped(_ sender: RoundedButton) {
        
        hireCookSummaryObj.spiceLevel = spiceLevelTextfield.text
        hireCookSummaryObj.orderServing = orderServingTextfield.text
        hireCookSummaryObj.specialInstruction = specialInstructionTextview.text
        hireCookSummaryObj.addedFeatures = addedFeaturesTextfield.text
        hireCookSummaryObj.dateTime = dateTimeTextfield.text
        hireCookSummaryObj.frequency = dailyTextfield.text
        hireCookSummaryObj.weekDays = weekDaysTextfield.text
        
        if !hireCookSummaryObj.validateSpiceLevel() {
            self.showAlertWithMessage(alertMessage: self.hireCookSummaryObj.alertMessage)
        } else if !hireCookSummaryObj.validateOrderServing() {
            self.showAlertWithMessage(alertMessage: self.hireCookSummaryObj.alertMessage)
        } else if !hireCookSummaryObj.validateSpecialInstruction() {
            self.showAlertWithMessage(alertMessage: self.hireCookSummaryObj.alertMessage)
        } else if !hireCookSummaryObj.validateAddedFeatures() {
            self.showAlertWithMessage(alertMessage: self.hireCookSummaryObj.alertMessage)
        } else if !hireCookSummaryObj.validateDateTime() {
            self.showAlertWithMessage(alertMessage: self.hireCookSummaryObj.alertMessage)
        } else if !hireCookSummaryObj.validateWorkingTimePeriod() {
            self.showAlertWithMessage(alertMessage: self.hireCookSummaryObj.alertMessage)
        } else if !hireCookSummaryObj.validateWeekDays() {
            self.showAlertWithMessage(alertMessage: self.hireCookSummaryObj.alertMessage)
        } else {
            
        }
        
    }
    
    
    //AlertController.
    func showAlertWithMessage(alertMessage:String)
    {
        let alertController = UIAlertController(title:ALERT_TITLE.APP_NAME, message:alertMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action:UIAlertAction!) in
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
}
