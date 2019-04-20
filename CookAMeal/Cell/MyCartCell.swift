//
//  MyCartCell.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 14/02/18.
//  Copyright © 2018 Cynoteck. All rights reserved.
//

import UIKit

class MyCartCell: UITableViewCell {
    
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var availableLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var costPerServingLabel: UILabel!
    @IBOutlet weak var deliveryFeeLabel: UILabel!
    @IBOutlet weak var spiceLabel: UILabel!
    @IBOutlet weak var sevringLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var decreaseSpiceLevel: RoundedButton!
    @IBOutlet weak var increaseSpiceLevel: RoundedButton!
    @IBOutlet weak var increaseServingLevel: RoundedButton!
    @IBOutlet weak var decreaseServingLevel: RoundedButton!
    
    @IBOutlet weak var viewDetailButton: RoundedButton!
    @IBOutlet weak var deleteButton: RoundedButton!
    
    @IBOutlet weak var readmoreButtonOutlet: UIButton!
    @IBOutlet weak var readlessButtonOutlet: UIButton!
    
    @IBOutlet weak var recipeDeleted: UIButton!
    @IBOutlet weak var recipeNotExist: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
