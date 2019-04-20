//
//  RecipeDetailTableViewCell.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 11/12/17.
//  Copyright © 2017 Cynoteck. All rights reserved.
//

import UIKit
import FloatRatingView

class RecipeDetailTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var starRatingView: FloatRatingView!
    @IBOutlet weak var profielImageview: UIImageView!
    @IBOutlet weak var cookNameLabel: UILabel!
    @IBOutlet weak var collectionViewType: UICollectionView!
    @IBOutlet weak var spiceLevelTextfield: ImageTextfield!
    @IBOutlet weak var orderServingTextfield: ImageTextfield!
    @IBOutlet weak var collectionviewHeight: NSLayoutConstraint!
    @IBOutlet weak var favouriteButtonOutlet: UIButton!
    @IBOutlet weak var backgroundViewOutlet: UIViewX!
    
    //Constaint outlet
    @IBOutlet weak var stackviewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackVerticalHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackview: UIStackView!
    @IBOutlet weak var downArrowImageview: UIImageView!
    @IBOutlet weak var orderDownArrow: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
