//
//  MapTableViewCell.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 03/01/18.
//  Copyright © 2018 Cynoteck. All rights reserved.
//

import UIKit

class MapTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var categoryLabelOutlet: UILabel!
    @IBOutlet weak var cookCollectionviewOutlet: UICollectionView!
    @IBOutlet weak var collectionviewheightConstraint: NSLayoutConstraint!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
