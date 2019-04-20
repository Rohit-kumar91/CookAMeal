//
//  ApproveRejectVC.swift
//  CookAMeal
//
//  Created by Cynoteck on 17/05/18.
//  Copyright © 2018 Cynoteck. All rights reserved.
//

import UIKit

class ApproveRejectVC: UIViewController {
    
    
   
    @IBOutlet weak var orderIdLabel: UILabel!
    var orderId = String()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        orderIdLabel.text = orderId
    }

    @IBAction func doneButtonTapped(_ sender: RoundedButton) {
        
        
    }
}
