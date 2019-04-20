//
//  CookRecipeTableViewCell.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 11/12/17.
//  Copyright © 2017 Cynoteck. All rights reserved.
//

import UIKit

class CookRecipeTableViewCell: UITableViewCell {

    @IBOutlet weak var titleNameTextLabel: UILabel!
    @IBOutlet weak var cookRecipeCollectionview: UICollectionView!
    @IBOutlet weak var collectionviewHeightConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
