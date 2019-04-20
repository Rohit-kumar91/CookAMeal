//
//  ShowReviewScreenVC.swift
//  CookAMeal
//
//  Created by cyno on 10/25/18.
//  Copyright © 2018 Cynoteck. All rights reserved.
//

import UIKit
import FloatRatingView


class ShowRecipeReviewCell: UITableViewCell {
    @IBOutlet weak var reviewGivenbyLabelOutlet: UILabel!
    @IBOutlet weak var dateLabelOutlet: UILabel!
    @IBOutlet weak var reviewOutlet: FloatRatingView!
    @IBOutlet weak var comment: UILabel!
    
    
}

class ShowReviewScreenVC: UIViewController {

    let showReviewRecipeModelobj = ShowReviewRecipeModel()
    var recipeId = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        showReviewRecipeModelobj.getReviewData(id: recipeId) { (success) in
            if success {
                
            } else {
                 self.present(Helper.globalAlertView(with: LOGIN_CONSTANT.ALERT_HEADER_MESSAGE_KEY, message: self.showReviewRecipeModelobj.alertMessage), animated: true, completion: nil)
            }
        }
    }
    
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension ShowReviewScreenVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ShowRecipeReviewCell
        
        return cell
    }
    
    
}
