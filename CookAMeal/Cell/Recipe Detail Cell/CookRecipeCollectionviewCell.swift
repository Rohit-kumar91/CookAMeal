//
//  CookRecipeCollectionviewCell.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 12/12/17.
//  Copyright © 2017 Cynoteck. All rights reserved.
//

import UIKit
import FloatRatingView

class CookRecipeCollectionviewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var recipeImageView: UIImageViewX!
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var costPerServingLabel: UILabel!
    @IBOutlet weak var orderDateLabel: UILabel!
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var cookfavourateButtonOutlet: UIButton!
    @IBOutlet weak var priceLableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var orderDateHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageviewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var verticalHeigthConstraint: NSLayoutConstraint!
    @IBOutlet weak var foodTypeImage: UIImageView!
    
}
