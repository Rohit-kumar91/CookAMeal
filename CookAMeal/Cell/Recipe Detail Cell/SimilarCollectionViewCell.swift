//
//  SimilarCollectionViewCell.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 12/12/17.
//  Copyright © 2017 Cynoteck. All rights reserved.
//

import UIKit
import FloatRatingView

class SimilarCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var recipeImageView: UIImageViewX!
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var costPerServingLabel: UILabel!
    @IBOutlet weak var orderDateLabel: UILabel!
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var similarFavouratebuttonTapped: UIButton!
    @IBOutlet weak var priceLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var orderDateHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageviewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var verticalHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var foodTypeImage: UIImageView!
    
}
