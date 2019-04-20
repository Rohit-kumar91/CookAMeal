//
//  NutritionInfoTableViewCell.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 11/12/17.
//  Copyright © 2017 Cynoteck. All rights reserved.
//

import UIKit

class NutritionInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var caloriesLabelOutlet: UILabel!
    @IBOutlet weak var carbohydratesLabelOutlet: UILabel!
    @IBOutlet weak var proteinLabelOutlet: UILabel!
    @IBOutlet weak var fatLabelOutlet: UILabel!
    @IBOutlet weak var otherLabelOutlet: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
