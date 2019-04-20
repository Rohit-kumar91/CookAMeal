//
//  PreparationMethodTableViewCell.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 11/12/17.
//  Copyright © 2017 Cynoteck. All rights reserved.
//

import UIKit

class PreparationMethodTableViewCell: UITableViewCell {
    
    @IBOutlet weak var preperationStackView: UIStackView!
    @IBOutlet weak var seeMoreButtonOutlet: UIButton!
    @IBOutlet weak var arrowKeyLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
