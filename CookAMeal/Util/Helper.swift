//
//  Helper.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 16/11/17.
//  Copyright © 2017 Cynoteck. All rights reserved.
//

import Foundation

class Helper: NSObject {
    
    class func getUserDefault(key: String) -> String?{
        let def = UserDefaults.standard
        return def.object(forKey: key) as? String
    }
    
    
    //This function handle the Logout and login screen flow
    class func saveUserDefault(key: String, value: String ) {
        let def = UserDefaults.standard
        def.set(value, forKey: key)
        def.synchronize()
        restartApp()
    }
    
    
    class func restartApp() {
        guard  let window = UIApplication.shared.keyWindow else {
            return
        }
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        var vc: UIViewController
        
        if getUserDefault(key: TOKEN_KEY) == nil {
            vc = sb.instantiateInitialViewController()!
        } else{
            vc = sb.instantiateViewController(withIdentifier: "dashboardID")
        }
        
        window.rootViewController = vc
        UIView.transition(with: window, duration: 0.5, options: .curveEaseIn, animations: nil, completion: nil)
        
        //.transitionFlipFromTop
    }
    
    
    //Remove the userdefault 
    class func removeUserDefault(key: String) {
        let def = UserDefaults.standard
        def.removeObject(forKey: key)
        def.synchronize()
        
        guard  let window = UIApplication.shared.keyWindow else {
            return
        }
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        var vc: UIViewController
        vc = sb.instantiateViewController(withIdentifier: "loginID")
        
        window.rootViewController = vc
        UIView.transition(with: window, duration: 0.5, options: .curveEaseIn, animations: nil, completion: nil)
        
    }
    
    
    //This function use for the normal
    class func saveUserDefaultValue(key: String, value: Any ) {
        let def = UserDefaults.standard
        def.set(value, forKey: key)
        def.synchronize()
    }
    
    class func getUserDefaultValue(key: String) -> String?{
        let def = UserDefaults.standard
        return def.object(forKey: key) as? String
    }
    
    
    
    //Global Alert function
    class func globalAlertView(with title: String, message: String) -> UIAlertController {
        
        
        var recreateMessage = String()
        if message == "The request timed out." {
            recreateMessage = "Unable to process your request. Please try again later."
        } else {
            recreateMessage = message
        }
        
        let alert  = UIAlertController(title: title, message: recreateMessage, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(alertAction)
        alert.view.tintColor = UIColor(named: "Button_Red")
        return alert
    }
    
    
    // Function that returns the server date in to String Date.
    class func getDate(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"//this your string date format
        var localTimeZoneAbbreviation: String { return TimeZone.current.abbreviation() ?? "" }
        
        dateFormatter.timeZone = NSTimeZone(name: localTimeZoneAbbreviation) as TimeZone?
        let date = dateFormatter.date(from: date)
        
        dateFormatter.dateFormat = "dd/MM/yyyy"///this is what you want to convert format
        dateFormatter.timeZone = NSTimeZone(name: localTimeZoneAbbreviation) as TimeZone?
        
        if let date = date {
            return dateFormatter.string(from: date)
        } else {
            return "Invalid date"
        }
    }
    

    //Function that return the date and time with server time zone.
    class func dateTime(dateTime: String, completion: @escaping (_ success: Bool, _ serverDate: String)->Void){
        let dateFormatter = DateFormatter()
        var localTimeZoneAbbreviation: String { return TimeZone.current.abbreviation() ?? "" }
        dateFormatter.dateFormat = "MMM d,yyyy hh:mm a"
        dateFormatter.timeZone = NSTimeZone(name: localTimeZoneAbbreviation) as TimeZone?
        let finaldatetime = dateFormatter.date(from: dateTime)
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.timeZone = NSTimeZone.local
        
        if let date = finaldatetime {
            //return dateFormatter.string(from: date)
            completion(true, dateFormatter.string(from: date))
        } else {
           // return "Invalid date"
            completion(false, "")
        }
    }
    
    //Header with token.
    class func headerWithToken(token: String) -> [String: String] {
        let header: [String: String] = [
            AUTHORIZATION_KEY : token,
            "Content-Type": "application/json"
        ]
        return header
    }
}


