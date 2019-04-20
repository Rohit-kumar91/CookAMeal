//
//  AllergiesTableviewCellTableViewCell.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 13/11/17.
//  Copyright © 2017 Cynoteck. All rights reserved.
//

import UIKit

class AllergiesTableviewCellTableViewCell: UITableViewCell {

    
    @IBOutlet weak var checkButtonOutlet: RoundedButton!
    @IBOutlet weak var customCellLabelOutlet: UILabel!
    
    @IBOutlet weak var myProfileAllergiesCellLabelOutlet: UILabel!
    @IBOutlet weak var myProfilecheckButtonOutlet: RoundedButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
