//
//  KitchenRecipeCell.swift
//  CookAMeal
//
//  Created by Cynoteck on 06/07/18.
//  Copyright © 2018 Cynoteck. All rights reserved.
//

import UIKit
import FloatRatingView


class KitchenRecipeCell: UICollectionViewCell {
    @IBOutlet weak var recipeImageView: UIImageViewX!
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var likeButtonOutlet: UIButton!
    @IBOutlet weak var addToMenuOutlet: RoundedButton!
    
    
}
