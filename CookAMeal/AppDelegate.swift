//
//  AppDelegate.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 12/10/17.
//  Copyright © 2017 Cynoteck. All rights reserved.
//  Rohit Latest

import UIKit
import FBSDKCoreKit
import Braintree
import LinkedinSwift
import CoreLocation
import GoogleMaps
import GooglePlaces
import SwiftyJSON
import FirebaseCore
import FirebaseMessaging
import FirebaseInstanceID
import UserNotifications

var currentLocationLatitude = Double()
var currentLocationLongitute = Double()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,CLLocationManagerDelegate,  MessagingDelegate {
    

    var window: UIWindow?
    let linkedinHelper = LinkedinSwiftHelper()
    var locationManager: CLLocationManager?
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if  Helper.getUserDefault(key: TOKEN_KEY) != nil {
            //Login Suucess Skip for the login screen.
            //and go to main screen.
            let dashboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "dashboardID")
            window?.rootViewController = dashboard
        }
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        //For Braintree
        BTAppSwitch.setReturnURLScheme("com.domesticeat.domesticeat.payments")
        
        
        //For Location Manager.
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.startUpdatingLocation()
        
        //GoogleAPI Keys
        GMSServices.provideAPIKey("AIzaSyCJ3qmd_PmNIMsoLgdsB92QAji_tvyThvc")
        GMSPlacesClient.provideAPIKey("AIzaSyCJ3qmd_PmNIMsoLgdsB92QAji_tvyThvc")
        
        
        //Notification
//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (isGranted, err) in
//            if err != nil {
//                //Something bad happened
//
//            } else {
//
//                Messaging.messaging().delegate = self
//                DispatchQueue.main.async {
//                    UIApplication.shared.registerForRemoteNotifications()
//                }
//            }
//        }
        
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            
            
            if settings.authorizationStatus == .authorized {
                // Already authorized
            }
            else {
                // Either denied or notDetermined
                self.notificationRegisteration()
            }
        }
        
        
        FirebaseApp.configure()
        
        return true
    }
    
    
    func notificationRegisteration() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            // add your own
            let alertController = UIAlertController(title: "DomesticEat", message: "Please enable notifications", preferredStyle: .alert)
            let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                    return
                }
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    })
                }
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            alertController.addAction(cancelAction)
            alertController.addAction(settingsAction)
            DispatchQueue.main.async {
                self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
                
            }
        }
    }
    
    
    func ConnectToFCM() {
        Messaging.messaging().shouldEstablishDirectChannel = true
        
        if let token = InstanceID.instanceID().token() {
            //Singleton.instance.deviceToken = token
           Helper.saveUserDefault(key: "deviceToken", value: token)
            print("DCS", token)
        }
    }
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        //Braintree
        if url.scheme?.localizedCaseInsensitiveCompare("com.domesticeat.domesticeat.payments.payments") == .orderedSame {
            return BTAppSwitch.handleOpen(url, options: options)
        }
        
        //Linkedin
//        else if LISDKCallbackHandler.shouldHandle(url) {
//            return LISDKCallbackHandler.application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String!, annotation: nil)
//        }
            
        else if LinkedinSwiftHelper.shouldHandle(url) {
            return LinkedinSwiftHelper.application(app,
                                                   open: url,
                                                   sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String?,
                                                   annotation: nil
            )
            
        }
        
        //Facebook
        else{
            let handled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String?, annotation: options[UIApplicationOpenURLOptionsKey.annotation] )
            return handled
        }
    
    }
    
    

    func applicationWillResignActive(_ application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        //Braintree
        if url.scheme?.localizedCaseInsensitiveCompare("com.developmentRetroApp.payments") == .orderedSame {
            return BTAppSwitch.handleOpen(url, sourceApplication: sourceApplication)
        }
            
        //Facebook
        else{
            return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        }
        
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        Messaging.messaging().shouldEstablishDirectChannel = false
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        ConnectToFCM()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation = locations.last!
        print("Current location: \(currentLocation.coordinate.latitude)")
        currentLocationLatitude = currentLocation.coordinate.latitude
        currentLocationLongitute = currentLocation.coordinate.longitude
        locationAuthStatus()
        locationManager?.stopUpdatingLocation()
        
    }
    
    // 2
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
    
    
    
    func locationAuthStatus() {
       
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways {
            
            let location = CLLocation(latitude: currentLocationLatitude, longitude: currentLocationLongitute)
            
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
                
                guard let addressDict = placemarks?[0].addressDictionary else {
                    return
                }
                
                let jsonAddressData = JSON(addressDict)
                let countryName = jsonAddressData["Country"].stringValue
                Helper.saveUserDefaultValue(key: "CountryName", value: countryName.lowercased())
                
                Singleton.instance.subLocalityName = jsonAddressData["SubLocality"].stringValue
                Singleton.instance.cityName = jsonAddressData["City"].stringValue
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "recieveLocation"), object: nil)

            })
            
        }
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        //completionHandler(.alert)
        
        UIApplication.shared.applicationIconBadgeNumber += 1
        
        //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "badgeWasUpdated"), object: nil)
        completionHandler([.alert,.sound])
    }
    
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        ConnectToFCM()
    }
    
}

