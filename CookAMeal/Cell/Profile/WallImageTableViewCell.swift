//
//  WallImageTableViewCell.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 21/12/17.
//  Copyright © 2017 Cynoteck. All rights reserved.
//

import UIKit

class WallImageTableViewCell: UITableViewCell {
    
    

    @IBOutlet weak var wallImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}