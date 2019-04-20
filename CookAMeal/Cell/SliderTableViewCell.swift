//  SliderTableViewCell.swift
//  CookAMeal
//  Created by cynoteck Mac Mini on 23/11/17.
//  Copyright © 2017 Cynoteck. All rights reserved.
//

import UIKit

class SliderTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var tableImageview: UIImageView!
    @IBOutlet weak var tableLabel: UILabel!
    @IBOutlet weak var seperatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
