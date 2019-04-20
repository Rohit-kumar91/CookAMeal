//
//  OrderCollectionViewCell.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 28/11/17.
//  Copyright © 2017 Cynoteck. All rights reserved.
//

import UIKit
import FloatRatingView


class OrderCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var recipeImageview: UIImageView!
    @IBOutlet weak var dishNameLable: UILabel!
    @IBOutlet weak var ratingStarView: FloatRatingView!
    @IBOutlet weak var favouriteButtonOutlet: UIButton!
    @IBOutlet weak var orderDateHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var verticalLabelConstarint: NSLayoutConstraint!
    @IBOutlet weak var costPerServingLabel: UILabel!
    @IBOutlet weak var orderByDateLabel: UILabel!
    @IBOutlet weak var costPerServingHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageviewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var verticalHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var foodTypeImages: UIImageView!
    @IBOutlet weak var reviewButtonOutlet: UIButton!
    
    
    func showSkeletonViews() {
        recipeImageview.showAnimatedSkeleton()
        dishNameLable.showAnimatedSkeleton()
        ratingStarView.showAnimatedSkeleton()
        favouriteButtonOutlet.showAnimatedSkeleton()
        costPerServingLabel.showAnimatedSkeleton()
        orderByDateLabel.showAnimatedSkeleton()
        foodTypeImages.showAnimatedSkeleton()
    }
    
    func hideSkeletonViews() {
        recipeImageview.hideSkeleton()
        dishNameLable.hideSkeleton()
        ratingStarView.hideSkeleton()
        favouriteButtonOutlet.hideSkeleton()
        costPerServingLabel.hideSkeleton()
        orderByDateLabel.hideSkeleton()
        foodTypeImages.hideSkeleton()
    }
    
    
   
    
    
}
