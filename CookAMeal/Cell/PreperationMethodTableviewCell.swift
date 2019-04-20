//
//  PreperationMethodTableviewCell.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 16/02/18.
//  Copyright © 2018 Cynoteck. All rights reserved.
//

import UIKit

class PreperationMethodTableviewCell: UITableViewCell {
    
    
    
    @IBOutlet weak var stepLabelOutlet: UILabel!
    @IBOutlet weak var textLabelOutlet: UILabel!
    @IBOutlet weak var preparationButtonOutlet: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
