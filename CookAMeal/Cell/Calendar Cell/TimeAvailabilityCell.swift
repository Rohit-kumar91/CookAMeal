//
//  TimeAvailabilityCell.swift
//  CookAMeal
//
//  Created by Cynoteck on 14/07/18.
//  Copyright © 2018 Cynoteck. All rights reserved.
//

import UIKit

class TimeAvailabilityCell: UITableViewCell {
    
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var editButtonOutlet: UIButton!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
