//
//  Section.swift
//  TableViewDropDown
//
//  Created by BriefOS on 5/3/17.
//  Copyright © 2017 BriefOS. All rights reserved.
//

import Foundation
import  SwiftyJSON

struct Section {
    var genre: String!
    var cartItemsData: [JSON]!
    var expanded: Bool!
    var profileImage: String!
    var radiocheck : String!
    
    init(genre: String, profileImage: String,  cartItemsData: [JSON], radiocheck: String, expanded: Bool) {
        self.profileImage = profileImage
        self.genre = genre
        self.cartItemsData = cartItemsData
        self.expanded = expanded
        self.radiocheck = radiocheck
    }
}
