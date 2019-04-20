//
//  SeeAllRecipeCategoryCollectionViewCell.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 09/12/17.
//  Copyright © 2017 Cynoteck. All rights reserved.
//

import UIKit
import FloatRatingView

class SeeAllRecipeCategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var recipeImageview: UIImageViewX!
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var imageviewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var costPerServingHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var orderDateHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var verticalLabelConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var orderByDateLabel: UILabel!
    @IBOutlet weak var likeButtonOutlet: UIButton!
    
    @IBOutlet weak var ratingViewOutlet: FloatRatingView!
    
    @IBOutlet weak var foodDetailImage: UIImageView!
    
    
}
