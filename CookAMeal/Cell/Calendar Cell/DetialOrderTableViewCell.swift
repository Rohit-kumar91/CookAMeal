//
//  DetialOrderTableViewCell.swift
//  CookAMeal
//
//  Created by Cynoteck on 14/07/18.
//  Copyright © 2018 Cynoteck. All rights reserved.
//

import UIKit

class DetialOrderTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var cookNameLabelOutlet: UILabel!
    @IBOutlet weak var dateLabelOutlet: UILabel!
    @IBOutlet weak var recipeStackview: UIStackView!
    @IBOutlet weak var calendarImageView: UIImageView!
    @IBOutlet weak var orderStateLabelOutlet: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
