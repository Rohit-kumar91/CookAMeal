//
//  HireCookSummaryModel.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 15/01/18.
//  Copyright © 2018 Cynoteck. All rights reserved.
//

import UIKit

class HireCookSummaryModel: NSObject {
    
    var spiceLevel: String!
    var orderServing: String!
    var specialInstruction: String!
    var addedFeatures: String!
    var dateTime: String!
    var frequency: String!
    var weekDays: String!
    var cleaningTime: String!
    var cookingtime: String!
    var totalTime: String!
    var totalAmount: String!
    var alertMessage: String!

    
    
    override init() {
        spiceLevel = ""
        orderServing = ""
        specialInstruction = ""
        addedFeatures = ""
        dateTime = ""
        frequency = ""
        weekDays = ""
        cleaningTime = ""
        cookingtime = ""
        totalTime = ""
        totalAmount = ""
        alertMessage = ""

        
    }
    
    
    func validateSpiceLevel () -> Bool
    {
        var valid: Bool = true
        
        if self.spiceLevel.isEmpty
        {
            valid = false
            self.alertMessage = "Spice Level is empty."
        }
        
        return valid
    }
    
    
    func validateSpecialInstruction () -> Bool
    {
        var valid: Bool = true
        
        if self.specialInstruction.isEmpty
        {
            valid = false
            self.alertMessage = "Special Instruction is empty."
        }
        
        return valid
    }
    
    
    
    func validateOrderServing () -> Bool
    {
        var valid: Bool = true
        
        if self.orderServing.isEmpty
        {
            valid = false
            self.alertMessage = "Order Serving is empty."
        }
        
        return valid
    }
    
    
    
    func validateAddedFeatures () -> Bool
    {
        var valid: Bool = true
        
        if self.addedFeatures.isEmpty
        {
            valid = false
            self.alertMessage = "Added Feature is empty."
        }
        
        return valid
    }
    
    
    
    func validateDateTime () -> Bool
    {
        var valid: Bool = true
        
        if self.dateTime.isEmpty
        {
            valid = false
            self.alertMessage = "Date time is empty."
        }
        
        return valid
    }
    
    
    func validateWorkingTimePeriod () -> Bool
    {
        var valid: Bool = true
        
        if self.dateTime.isEmpty
        {
            valid = false
            self.alertMessage = "Working frequency is empty."
        }
        
        return valid
    }
    
    
    func validateWeekDays () -> Bool
    {
        var valid: Bool = true
        
        if self.dateTime.isEmpty
        {
            valid = false
            self.alertMessage = "WeekDays is empty."
        }
        
        return valid
    }
    

}
