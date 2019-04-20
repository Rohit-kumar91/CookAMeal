//
//  PriceCell.swift
//  FilterDesign
//
//  Created by Cynoteck on 22/06/18.
//  Copyright © 2018 Cynoteck. All rights reserved.
//

import UIKit
import TTRangeSlider


class PriceCell: UITableViewCell {

    @IBOutlet weak var minPriceLabel: UILabel!
    @IBOutlet weak var maxPriceLabel: UILabel!
    @IBOutlet weak var sliderOutlet: TTRangeSlider!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
