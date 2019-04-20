//
//  WishlistTableViewCell.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 19/03/18.
//  Copyright © 2018 Cynoteck. All rights reserved.
//

import UIKit
import FloatRatingView

class WishlistTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var recipeNameLabelOutlet: UILabel!
    @IBOutlet weak var priceLabelOutlet: UILabel!
    @IBOutlet weak var recipeImageviewOutlet: UIImageView!
    @IBOutlet weak var ratingViewOutlet: FloatRatingView!
    @IBOutlet weak var deletedButtonOutlet: RoundedButton!
    @IBOutlet weak var foodTypeImageView: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        recipeNameLabelOutlet.showAnimatedSkeleton()
        priceLabelOutlet.showAnimatedSkeleton()
        recipeNameLabelOutlet.showAnimatedSkeleton()
        ratingViewOutlet.showAnimatedSkeleton()
        deletedButtonOutlet.showAnimatedSkeleton()
        foodTypeImageView.showAnimatedSkeleton()
        
    }
    
    
    func hideSkeletonViews() {
        recipeNameLabelOutlet.hideSkeleton()
        priceLabelOutlet.hideSkeleton()
        recipeNameLabelOutlet.hideSkeleton()
        ratingViewOutlet.hideSkeleton()
        deletedButtonOutlet.hideSkeleton()
        foodTypeImageView.hideSkeleton()
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
