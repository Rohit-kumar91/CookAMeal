//
//  AddressTableviewcell.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 26/03/18.
//  Copyright © 2018 Cynoteck. All rights reserved.
//

import UIKit
import BEMCheckBox

class AddressTableviewcell: UITableViewCell {

    @IBOutlet weak var nameLabelOutlet: UILabel!
    @IBOutlet weak var streetAddressLabelOutlet: UILabel!
    @IBOutlet weak var cityLabelOutlet: UILabel!
    @IBOutlet weak var zipCodeOutlet: UILabel!
    @IBOutlet weak var countryLabelOutlet: UILabel!
    @IBOutlet weak var checkButtonOutlet: BEMCheckBox!
    @IBOutlet weak var deliveryButtonOutlet: RoundedButton!
    @IBOutlet weak var deleteButtonOutlet: RoundedButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
