//
//  CookRecipeTableViewCell.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 02/02/18.
//  Copyright © 2018 Cynoteck. All rights reserved.
//

import UIKit
import FloatRatingView

class CookAddedRecipeTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var createdDateLabel: UILabel!
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var recipeImageview: UIImageViewX!
    @IBOutlet weak var priceLabelOutlet: UILabel!
    @IBOutlet weak var ratingViewOutlet: FloatRatingView!
    @IBOutlet weak var foodTypeImageView: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        categoryNameLabel.showAnimatedSkeleton()
        createdDateLabel.showAnimatedSkeleton()
        recipeNameLabel.showAnimatedSkeleton()
        recipeImageview.showAnimatedSkeleton()
        priceLabelOutlet.showAnimatedSkeleton()
        ratingViewOutlet.showAnimatedSkeleton()
        foodTypeImageView.showAnimatedSkeleton()
        
    }
    
    func hideSkeletonViews() {
        categoryNameLabel.hideSkeleton()
        createdDateLabel.hideSkeleton()
        recipeNameLabel.hideSkeleton()
        recipeImageview.hideSkeleton()
        priceLabelOutlet.hideSkeleton()
        ratingViewOutlet.hideSkeleton()
        foodTypeImageView.hideSkeleton()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
