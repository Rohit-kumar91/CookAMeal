//
//  RejectRepaymentVC.swift
//  CookAMeal
//
//  Created by Cynoteck on 24/07/18.
//  Copyright © 2018 Cynoteck. All rights reserved.
//

import UIKit

class RejectRepaymentVC: UIViewController {
    
    
    @IBOutlet weak var meaageLabelOutlet: UILabel!
    
    var message = String()
    var orderId = String()
    var rejectRepaymentObj : RejectRepaymentModel = RejectRepaymentModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        meaageLabelOutlet.text = message
        
    }

    
    @IBAction func rejectOrderButtonTapped(_ sender: RoundedButton) {
    }
    
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
   
    @IBAction func rePaymentButtonTapped(_ sender: RoundedButton) {
        rejectRepaymentObj.rePaymentForOrder(orderId: orderId) { (success) in
            if success {
                self.showAlertWithMessage(alertMessage: self.rejectRepaymentObj.alertMessage)
            } else {
                 self.present(Helper.globalAlertView(with: LOGIN_CONSTANT.ALERT_HEADER_MESSAGE_KEY, message: self.rejectRepaymentObj.alertMessage), animated: true, completion: nil)
            }
        }
    }
    
    func showAlertWithMessage(alertMessage:String )
    {
        let alertController = UIAlertController(title:ALERT_TITLE.APP_NAME, message:alertMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action:UIAlertAction!) in
             self.performSegue(withIdentifier: "unwindToMyOrder", sender: self)
        }))
        self.present(alertController, animated: true, completion: nil)
    }
}
