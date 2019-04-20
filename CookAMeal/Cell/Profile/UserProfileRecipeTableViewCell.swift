//
//  UserProfileRecipeTableViewCell.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 21/12/17.
//  Copyright © 2017 Cynoteck. All rights reserved.
//

import UIKit

class UserProfileRecipeTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var recipeTitleLabelText: UILabel!
    @IBOutlet weak var recipeCollectionViewOutlet: UICollectionView!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
