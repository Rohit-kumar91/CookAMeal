//
//  ReviewsCell.swift
//  FilterDesign
//
//  Created by Cynoteck on 22/06/18.
//  Copyright © 2018 Cynoteck. All rights reserved.
//

import UIKit
import FloatRatingView

class ReviewsCell: UITableViewCell {

    
    @IBOutlet weak var ratingView: FloatRatingView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
