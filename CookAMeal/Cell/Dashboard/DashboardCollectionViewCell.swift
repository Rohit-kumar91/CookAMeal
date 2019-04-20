//
//  DashboardCollectionViewCell.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 17/11/17.
//  Copyright © 2017 Cynoteck. All rights reserved.
//

import UIKit

class DashboardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var collectionviewImage: UIImageViewX!
    @IBOutlet weak var categoryNameLabel: UILabel!
    
    func showSkeletonView() {
        collectionviewImage.showAnimatedSkeleton()
        categoryNameLabel.showAnimatedSkeleton()
    }
    
    func hideSkeletonViews() {
        collectionviewImage.hideSkeleton()
        categoryNameLabel.hideSkeleton()
    }
    
    
}
