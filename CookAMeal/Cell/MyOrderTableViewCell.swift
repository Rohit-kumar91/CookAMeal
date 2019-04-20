//
//  MyOrderTableViewCell.swift
//  CookAMeal
//
//  Created by Cynoteck on 17/04/18.
//  Copyright © 2018 Cynoteck. All rights reserved.
//

import UIKit

class MyOrderTableViewCell: UITableViewCell {

    @IBOutlet weak var cookImageView: UIImageView!
    @IBOutlet weak var cookNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var orderByLabelOutlet: UILabel!
    @IBOutlet weak var orderTypeLabelOutlet: UILabel!
    @IBOutlet weak var orderByMeLabelOutlet: UILabel!
    @IBOutlet weak var statusLabelOutlet: UILabel!
    @IBOutlet weak var statusStackView: UIStackView!
    @IBOutlet weak var orderTypeLabel: UILabel!
    @IBOutlet weak var viewOrderButtonOutlet: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        orderByLabelOutlet.layer.masksToBounds = true
        orderByLabelOutlet.layer.cornerRadius =  2
        
        
        cookImageView.showAnimatedSkeleton()
        cookNameLabel.showAnimatedSkeleton()
        dateLabel.showAnimatedSkeleton()
        timeLabel.showAnimatedSkeleton()
        orderByLabelOutlet.showAnimatedSkeleton()
        orderTypeLabelOutlet.showAnimatedSkeleton()
        orderByMeLabelOutlet.showAnimatedSkeleton()
        statusLabelOutlet.showAnimatedSkeleton()
        orderTypeLabel.showAnimatedSkeleton()
        viewOrderButtonOutlet.showAnimatedSkeleton()
        
    }
    
    
    func hideSkeletonsViews() {
        cookImageView.hideSkeleton()
        cookNameLabel.hideSkeleton()
        dateLabel.hideSkeleton()
        timeLabel.hideSkeleton()
        orderByLabelOutlet.hideSkeleton()
        orderTypeLabelOutlet.hideSkeleton()
        orderByMeLabelOutlet.hideSkeleton()
        statusLabelOutlet.hideSkeleton()
        orderTypeLabel.hideSkeleton()
        viewOrderButtonOutlet.hideSkeleton()
    }

   
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
