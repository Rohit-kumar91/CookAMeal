//
//  OrderTableviewCell.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 08/12/17.
//  Copyright © 2017 Cynoteck. All rights reserved.
//

import UIKit

class OrderTableviewCell: UITableViewCell {
    

    @IBOutlet weak var collectionviewHeightConstraintConstant: NSLayoutConstraint!
    @IBOutlet weak var seeAllButtonOutlet: UIButton!
    @IBOutlet weak var categoryTitleLabel: UILabel!
    @IBOutlet weak var recipeCollectionview: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        seeAllButtonOutlet.showAnimatedSkeleton()
        categoryTitleLabel.showAnimatedSkeleton()
        
    }
    
    
    func hideSkeletonViews() {
        seeAllButtonOutlet.hideSkeleton()
        categoryTitleLabel.hideSkeleton()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
