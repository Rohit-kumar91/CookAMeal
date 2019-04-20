//
//  ProfileRecipeCollectionViewCell.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 21/12/17.
//  Copyright © 2017 Cynoteck. All rights reserved.
//

import UIKit
import FloatRatingView

class ProfileRecipeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var recipeNameLabelOutlet: UILabel!
    @IBOutlet weak var perServingPriceLabelOutlet: UILabel!
    @IBOutlet weak var orderByLabelOutlet: UILabel!
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var favouriteButtonOutlet: UIButton!
    @IBOutlet weak var recipeImageView: UIImageViewX!
    
    @IBOutlet weak var priceLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var orderByDateHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageviewHeightConstraint: NSLayoutConstraint!
    
}
