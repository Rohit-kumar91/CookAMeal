//
//  String+Extension.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 30/10/17.
//  Copyright © 2017 Cynoteck. All rights reserved.
//

import Foundation

extension String {
    
    
    
    func isValidEmail() -> Bool {
        
        let emailRegEx = "(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"+"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"+"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"+"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"+"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"+"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"+"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
        

    }
    
    
    

    var isPasswordStrong: Bool {
        print(self)
        //"^(?=.*[A-Z].*[A-Z])(?=.*[!@#$&*])(?=.*[0-9].*[0-9])(?=.*[a-z].*[a-z].*[a-z]).{8,16}$"
        
        //Old One ^(?=.*[A-Z])(?=.*[!@#$&*])(?=.*[0-9].*[0-9])(?=.*[a-z].*[a-z].*[a-z]).{9,16}$
        //New one ^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{9,}$
        let passwordRegEx = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{9,}$"
        print(NSPredicate(format: "SELF MATCHES %@", passwordRegEx).evaluate(with: self))
        return NSPredicate(format: "SELF MATCHES %@", passwordRegEx).evaluate(with: self)
    
    }
    
    var isTimeValid: Bool {
        //  /^([0-1][0-9]|[2][0-3]):([0-5][0-9])$/;
        let timeRegEx = "^([0-1][0-9]|[2][0-3]):([0-5][0-9])$"
        let timeTest  = NSPredicate(format:"SELF MATCHES %@", timeRegEx)
        return timeTest.evaluate(with:self)
    }
    
    
    var validateTextfieldText: Bool {
        let timeRegEx = ".*[^A-Za-z ].*"
        let timeTest  = NSPredicate(format:"SELF MATCHES %@", timeRegEx)
        return timeTest.evaluate(with:self)
    }
    
    
    var numberOnlyText: Bool {
        let numberRegEx = "^[0-9]*$"
        let numberTest  = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        return numberTest.evaluate(with:self)
    }
    
  
    
}
