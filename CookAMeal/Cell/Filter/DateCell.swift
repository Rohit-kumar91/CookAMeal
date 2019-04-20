//
//  DateCell.swift
//  FilterDesign
//
//  Created by Cynoteck on 22/06/18.
//  Copyright © 2018 Cynoteck. All rights reserved.
//

import UIKit

class DateCell: UITableViewCell {
    
    
    
    @IBOutlet weak var fromDateTextfield: UITextField!
    @IBOutlet weak var toDateTextfield: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
