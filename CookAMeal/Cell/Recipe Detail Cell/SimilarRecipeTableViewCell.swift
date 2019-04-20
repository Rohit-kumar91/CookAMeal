//
//  SimilarRecipeTableViewCell.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 11/12/17.
//  Copyright © 2017 Cynoteck. All rights reserved.
//

import UIKit

class SimilarRecipeTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var similarCollectionView: UICollectionView!
    @IBOutlet weak var similarCollectionviewHeightConstraint: NSLayoutConstraint!
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
