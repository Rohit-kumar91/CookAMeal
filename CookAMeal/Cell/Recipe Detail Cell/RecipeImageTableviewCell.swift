//
//  RecipeImageTableviewCell.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 11/12/17.
//  Copyright © 2017 Cynoteck. All rights reserved.
//

import UIKit

class RecipeImageTableviewCell: UITableViewCell {
    
    
    
    @IBOutlet weak var RecipeImageScrollview: UIScrollView!
    @IBOutlet weak var scrollviewHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layoutIfNeeded()
    }

    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
