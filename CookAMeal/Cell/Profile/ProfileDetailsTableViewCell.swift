//
//  ProfileDetailsTableViewCell.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 21/12/17.
//  Copyright © 2017 Cynoteck. All rights reserved.
//

import UIKit
import FloatRatingView

class ProfileDetailsTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var profileNameLabelOutlet: UILabel!
    @IBOutlet weak var profileImageView: UIImageViewX!
    @IBOutlet weak var ratingView: FloatRatingView!
    @IBOutlet weak var aboutTextLabelOutlet: UILabel!
    @IBOutlet weak var favouriteButtonOutlet: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
