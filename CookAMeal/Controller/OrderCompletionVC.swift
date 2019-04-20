//
//  OrderCompletionVC.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 12/01/18.
//  Copyright © 2018 Cynoteck. All rights reserved.
//

import UIKit
import SwiftyJSON

class OrderCompletionVC: UIViewController {
    
  
    var profileImage = String()
    var successStatus = Bool()
    var guestSuccess = Bool()
    var successDict = JSON()

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var yourIDLabel: UILabel!
    @IBOutlet weak var orderLabel: UILabel!
    @IBOutlet weak var transactionFailedLabel: UILabel!
    @IBOutlet weak var finishButtonOutlet: RoundedButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(successDict)
        
        if guestSuccess {
            transactionStatus(status: successStatus, orderId: successDict["data"]["orderId"].stringValue)
        } else {
            transactionStatus(status: successStatus, orderId: successDict["orderId"].stringValue)
        }
        
    }
    
    
    func transactionStatus(status: Bool , orderId: String) {
        
        if status {
            imageview.image = #imageLiteral(resourceName: "orderSuccess")
            backgroundView.backgroundColor = #colorLiteral(red: 0.2705882353, green: 0.6901960784, blue: 0.368627451, alpha: 1)
            transactionFailedLabel.isHidden = true
            descriptionLabel.isHidden = false
            descriptionLabel.text = "Your order has been placed successfully."
            yourIDLabel.text = "Your Order ID is: " + orderId
            orderLabel.isHidden = false
            yourIDLabel.isHidden = false
            orderLabel.isHidden = false
            finishButtonOutlet.backgroundColor = #colorLiteral(red: 0.2705882353, green: 0.6901960784, blue: 0.368627451, alpha: 1)
            
            
        } else {
            imageview.image = #imageLiteral(resourceName: "transactionFailed")
            backgroundView.backgroundColor = #colorLiteral(red: 0.8862745098, green: 0.1725490196, blue: 0.168627451, alpha: 1)
            transactionFailedLabel.isHidden = false
            descriptionLabel.isHidden = false
            descriptionLabel.text = "Your transaction has been failed due to some reason."
            yourIDLabel.isHidden = true
            orderLabel.isHidden = true
            finishButtonOutlet.backgroundColor =  #colorLiteral(red: 0.8862745098, green: 0.1725490196, blue: 0.168627451, alpha: 1)
        }
    }
    
    
    
    
    @IBAction func finishButtonTapped(_ sender: RoundedButton) {
        performSegue(withIdentifier: "toFinalToDashboard", sender: self)
    }
}


