                  //
//  Dashboard.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 25/10/17.
//  Copyright © 2017 Cynoteck. All rights reserved.
//

import UIKit
import SDWebImage
import JGProgressHUD
import GooglePlaces
import CoreLocation
import SwiftyJSON
import UserNotifications


                
                  
class DashboardVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate,UNUserNotificationCenterDelegate {
    

    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var collectionview: UICollectionView!
    @IBOutlet weak var typeSelectionCollectionView: UICollectionView!
    @IBOutlet weak var errorLabelOutlet: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var nearByIconImageviewOutlet: UIImageView!
    @IBOutlet weak var searchButtonOutlet: RoundedButton!
    
    
    let hud = JGProgressHUD(style: .light)
    private let refreshControl = UIRefreshControl()
    var dashboardObj: DashboardModel = DashboardModel()
    var categoryId = String()
    var categoryName =  String()
    var selectedMenuString = String()
    var boolTemp = Bool()
    var cartCheckForMenuSelection = Bool()
    
    var notificationOrderId = String()
    var notificationType =  String()
    
    var menuArray = [["name": "Hire a cook", "selected": "0", "shortName": "Hire"],
                     ["name": "Order Food", "selected": "1", "shortName": "Order"],
                     ["name": "Add Recipe", "selected": "0", "shortName": "Recipe"],
                     ["name": "Map", "selected": "0", "shortName": "Map"],
                     ["name": "Filter", "selected": "0", "shortName": "Filter"]]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
          //self.performSegue(withIdentifier: "notificationDetailSegue", sender: nil)
        UNUserNotificationCenter.current().delegate = self
        
        let network = NetworkManager.sharedInstance
        network.reachability.whenUnreachable = { reachability in
            self.showOfflinePage()
        }
        
        
        self.revealViewController().delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(receiveData(_:)), name: NSNotification.Name(rawValue: "recieveLocation"), object: nil)
        
        //User Role
        //2 - customer
        //1 - cook
        if Helper.getUserDefaultValue(key: USER_ROLE_KEY) == "2" {
            menuArray.remove(at: 2)
        } else if Helper.getUserDefaultValue(key: GUEST_KEY) == "1" {
            menuArray.remove(at: 2)
            menuArray[0]["selected"] = "0"
            menuArray[1]["selected"] = "1"
            print(menuArray)
        }
        
        
        //Revealview Controller.
        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 80
        menuButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        
        
        self.revealViewController().frontViewShadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3131710123)
        self.revealViewController().frontViewShadowRadius = 2
        self.revealViewController().frontViewShadowOffset = CGSize(width: 0.0, height: 1.5)
        self.revealViewController().frontViewShadowOpacity = 0.8
       
        self.collectionview.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        Helper.saveUserDefaultValue(key: "orderType", value: "0")
        
        //hud.show(in: self.view)
        //hud.textLabel.text = "Loading"
        
        self.collectionview.dataSource = self
        self.collectionview.delegate = self
        
        dashboardObj.getDashboardData { (success) in
            if success {
                //self.hud.dismiss()
                self.collectionview.reloadData()
                
                //Subscribe for notification
                self.dashboardObj.subscribeNotification(completion: { (success) in
                    //We are not handling the response because we are calling it in background the api is updating device token.
                })
               
            } else{
                self.hud.dismiss()
                self.showAlertWithMessage(alertMessage: self.dashboardObj.alertMessage, errorCode: self.dashboardObj.errorCode)
            }
        }
        
        
        //For Menu Selection.
        if Helper.getUserDefaultValue(key: "orderType") == "1"{
            //Hire
            selectedMenuString = menuArray[0]["shortName"]!
            menuArray[0]["selected"] = "1"
            menuArray[1]["selected"] = "0"
            typeSelectionCollectionView.reloadData()
        } else if  Helper.getUserDefaultValue(key: "orderType") == "0" {
            //Order
            selectedMenuString = menuArray[1]["shortName"]!
            menuArray[0]["selected"] = "0"
            menuArray[1]["selected"] = "1"
            typeSelectionCollectionView.reloadData()
        }
        
    }
    
    

    private func showOfflinePage() -> Void {
        DispatchQueue.main.async {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "noNetworkIdentifierView") as! OfflineViewController
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    
    @objc func receiveData(_ notification:Notification) {
        // Do something now
        
        self.nearByIconImageviewOutlet.isHidden = false
        if Singleton.instance.subLocalityName != "" && Singleton.instance.cityName != "" {
            addressLabel.text = Singleton.instance.subLocalityName + "," + " " + Singleton.instance.cityName
        } else {
            addressLabel.text = "Select your location."
        }
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        typeSelectionCollectionView.delegate = self
        typeSelectionCollectionView.dataSource = self
        
       
        
    }
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        //let vc = SearchVC()
        //self.present(vc, animated: false, completion: nil)
        
        //let addRecipeViewController = self.storyboard?.instantiateViewController(withIdentifier: "searchID") as! SearchVC
       // self.present(addRecipeViewController, animated: false)
        self.performSegue(withIdentifier: "searchVCID", sender: nil)
        
    }
    
    
    @IBAction func unwindToOrderVC(segue:UIStoryboardSegue) { }
    
    
    @IBAction func locationChangeButtonTapped(_ sender: Any) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        // Set a filter to return only addresses.
        let addressFilter = GMSAutocompleteFilter()
        addressFilter.country = Locale.current.regionCode
        autocompleteController.autocompleteFilter = addressFilter
        
        present(autocompleteController, animated: true, completion: nil)
    }
    
    @objc private func refreshData(_ sender: Any) {
        
        dashboardObj.getDashboardData { (success) in
            if success {
                self.refreshControl.endRefreshing()
               // self.collectionview.dataSource = self
               // self.collectionview.delegate = self
                self.collectionview.reloadData()
               
            } else{
                self.refreshControl.endRefreshing()
                self.showAlertWithMessage(alertMessage: self.dashboardObj.alertMessage, errorCode: self.dashboardObj.errorCode)
            }
        }
    }
    
    

    
    // MARK: Collectionview delegate tha datasource method.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1 {
            return menuArray.count
        } else {
            
            if dashboardObj.dashboardArray.count != 0 {
                return dashboardObj.dashboardArray.count
            } else {
                return 2
            }
            
           
        }
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? DashboardCollectionViewCell {
            
            cell.layer.cornerRadius = 10
            cell.layer.masksToBounds = true
            cell.showSkeletonView()
            
            if dashboardObj.dashboardArray.count != 0 {
                cell.hideSkeletonViews()
                cell.categoryNameLabel.text = dashboardObj.dashboardArray[indexPath.row]["name"].stringValue
                cell.collectionviewImage.sd_setImage(with: URL(string: dashboardObj.dashboardArray[indexPath.row]["MediaObjects"][0][IMAGE_URL_KEY].stringValue), placeholderImage:UIImage(named: "recipePlaceholder"), options: .refreshCached)
            }
            
            
            
            return cell
        
        } else  if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? MenuCollectionViewCell {
            
            cell.contentView.layer.cornerRadius = 2.0
            cell.contentView.layer.borderWidth = 1.0
            cell.contentView.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            cell.contentView.layer.masksToBounds = true
            
            /*
             menuArray[indexPath.row]["selected"] == "1" && menuArray[indexPath.row]["name"] == "Hire a cook" ||
             menuArray[indexPath.row]["selected"] == "1" && menuArray[indexPath.row]["name"] == "Order Food"
             */
            
            
            if menuArray[indexPath.row]["selected"] == "1" && menuArray[indexPath.row]["name"] == "Hire a cook" {
                
                cell.menuLabelOutlet.text = menuArray[indexPath.row]["name"]
                cell.menuLabelOutlet.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                cell.contentView.backgroundColor = #colorLiteral(red: 0.8862745098, green: 0.1725490196, blue: 0.168627451, alpha: 1)
                
            } else if  menuArray[indexPath.row]["selected"] == "1" && menuArray[indexPath.row]["name"] == "Order Food" {
                
                cell.menuLabelOutlet.text = menuArray[indexPath.row]["name"]
                cell.menuLabelOutlet.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                cell.contentView.backgroundColor = #colorLiteral(red: 0.8862745098, green: 0.1725490196, blue: 0.168627451, alpha: 1)
                
            } else {
                cell.menuLabelOutlet.text = menuArray[indexPath.row]["name"]
                cell.menuLabelOutlet.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                cell.contentView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            }
            
            return cell
        }
        
       return UICollectionViewCell()

    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView.tag == 1 {
            
            return CGSize(width: UIScreen.main.bounds.size.width * 0.222, height: collectionView.frame.size.height )
            
        } else {
            let numOfColomns: CGFloat = 2
            let theSpaceBetweenCells : CGFloat = 5
            let padding : CGFloat = 40
            let cellDimension = ((collectionView.bounds.width - padding) - (numOfColomns - 1) * theSpaceBetweenCells) / numOfColomns
            return CGSize(width: cellDimension, height: cellDimension )
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView.tag == 1 {
            
            var indexName = String()
            indexName  =  menuArray[indexPath.row]["name"]!
            
            if indexName == "Hire a cook" {
                
                if Helper.getUserDefaultValue(key: GUEST_KEY) == "1" {
                    self.showAlertWithMessage(alertMessage: "You have to login to use this feature.", errorCode: "")
                } else {
                    menuArray[0]["selected"] = "1"
                    menuArray[1]["selected"] = "0"
                    selectedMenuString = menuArray[indexPath.row]["shortName"]!
                    Helper.saveUserDefaultValue(key: "orderType", value: "1")
                    typeSelectionCollectionView.reloadData()
                }
            }
            
            if indexName == "Order Food" {
                menuArray[0]["selected"] = "0"
                menuArray[1]["selected"] = "1"
                selectedMenuString = menuArray[indexPath.row]["shortName"]!
                Helper.saveUserDefaultValue(key: "orderType", value: "0")
                typeSelectionCollectionView.reloadData()
            }
            
            //For Add Recipe.
            if indexName == "Add Recipe" {
                if Helper.getUserDefaultValue(key: GUEST_KEY) == "1" {
                    //For Guest User
                    Helper.removeUserDefault(key: TOKEN_KEY)
                } else {
                    DispatchQueue.main.async {
                        Singleton.instance.ingredientCheck = "10" //Assign some default value that is not related to anything(just use to make the condition false.).
                        let addRecipeViewController = self.storyboard?.instantiateViewController(withIdentifier: "addRecipeID") as! AddRecipeVC
                        self.present(addRecipeViewController, animated: true)
                        
                    }
                }
            }
            
            if indexName == "Map" {
                self.performSegue(withIdentifier: "toDashboardVCToMapVCId", sender: nil)
            }
            
            
    }else {
            
            if selectedMenuString != menuArray[0]["shortName"] && selectedMenuString != menuArray[1]["shortName"] {
                showAlertWithMessage(alertMessage: "You have to select one option 'Hire a cook' or 'Order food'.", errorCode: "0")
            } else {
                categoryId = dashboardObj.dashboardArray[indexPath.row][ID_KEY].stringValue
                categoryName = dashboardObj.dashboardArray[indexPath.row]["name"].stringValue
                self.performSegue(withIdentifier: "orderVCIdentifier", sender: nil)
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "orderVCIdentifier" {
            let destinationVC = segue.destination as! OrderVC
            destinationVC.categoryId = categoryId
            
            if selectedMenuString == "Hire" {
                //Singleton.instance.hireCook =  true
                destinationVC.flagValue = 1
                destinationVC.categoryName = selectedMenuString + " " + categoryName + " " + "Cook"
            } else {
                //Singleton.instance.hireCook =  false
                destinationVC.flagValue = 2
                destinationVC.categoryName = selectedMenuString + " " + categoryName + " " + "Food"
            }
        } else if segue.identifier == "notificationDetailSegue" {
            let destinationVC = segue.destination as! OrderDetailsViewController
            
            print(notificationType)
            print(notificationOrderId)
           // Helper.saveUserDefaultValue(key: "notificationOrderId", value: notificationOrderId)
           // Helper.saveUserDefaultValue(key: "notificationType", value: notificationType)
            
            //print(Helper.getUserDefaultValue(key: "notificationType"))
           // print(Helper.getUserDefaultValue(key: "notificationOrderId"))
            
            destinationVC.type = notificationType //Helper.getUserDefaultValue(key: "notificationType") ?? ""
            destinationVC.orderId = notificationOrderId //Helper.getUserDefaultValue(key: "notificationOrderId") ?? ""
            
        }
    }
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 23 2017
    // Input Parameters :   Message String.
    // Purpose          :   Show alert when error occur.
    //>--------------------------------------------------------------------------------------------------
    func showAlertWithMessage(alertMessage:String, errorCode: String)
    {
        
        if errorCode == "403" {
            
//            UserDefaults.standard.removeObject(forKey: "profileImage")
//            UserDefaults.standard.removeObject(forKey: "userType")
//            UserDefaults.standard.removeObject(forKey: "userRole")
//            UserDefaults.standard.removeObject(forKey: "userName")
//            UserDefaults.standard.removeObject(forKey: "userRegisterEmail")
//            Helper.removeUserDefault(key: TOKEN_KEY)
            
        }else {
            
            let alertController = UIAlertController(title:ALERT_TITLE.APP_NAME, message:alertMessage, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action:UIAlertAction!) in
            }))
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

extension DashboardVC: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        
        print("Place name: \(place.name)")
        print("Place address: \(String(describing: place.formattedAddress))")
        print("Place attributions: \(String(describing: place.attributions))")
        
        //let appDelegate = UIApplication.shared.delegate as! AppDelegate
        currentLocationLatitude = place.coordinate.latitude
        currentLocationLongitute = place.coordinate.longitude
        
        print("latitude is ",place.coordinate.latitude)
        print("longitude is ",place.coordinate.longitude)
        
        let location = CLLocation(latitude: currentLocationLatitude, longitude: currentLocationLongitute)
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
            
            guard let addressDict = placemarks?[0].addressDictionary else {
                return
            }
            
            let jsonAddressData = JSON(addressDict)
            
            print(jsonAddressData)
            Singleton.instance.subLocalityName = place.name
            Singleton.instance.cityName = jsonAddressData["City"].stringValue
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "recieveLocation"), object: nil)
            
        })
        
        
        // Close the autocomplete widget.
        self.dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Show the network activity indicator.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    // Hide the network activity indicator.
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
   
}
                  
extension DashboardVC: SWRevealViewControllerDelegate {
    
    func revealController(_ revealController: SWRevealViewController!, willMoveTo position: FrontViewPosition) {
        if(position == FrontViewPosition.left) {
            self.searchButtonOutlet.isUserInteractionEnabled = true
            self.collectionview.isUserInteractionEnabled = true
            self.typeSelectionCollectionView.isUserInteractionEnabled = true
        } else {
             self.searchButtonOutlet.isUserInteractionEnabled = false
            self.collectionview.isUserInteractionEnabled = false
            self.typeSelectionCollectionView.isUserInteractionEnabled = false
        }
    }
    
    
    func revealController(_ revealController: SWRevealViewController!, didMoveTo position: FrontViewPosition) {
        if(position == FrontViewPosition.left) {
            self.searchButtonOutlet.isUserInteractionEnabled = true
            self.collectionview.isUserInteractionEnabled = true
            self.typeSelectionCollectionView.isUserInteractionEnabled = true
        } else {
            self.searchButtonOutlet.isUserInteractionEnabled = false
            self.collectionview.isUserInteractionEnabled = false
            self.typeSelectionCollectionView.isUserInteractionEnabled = false
            
        }
    }
    
    
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
//        // If you are receiving a notification message while your app is in the background,
//        // this callback will not be fired till the user taps on the notification launching the application.
//        // TODO: Handle data of notification
//
//        // With swizzling disabled you must let Messaging know about the message, for Analytics
//        // Messaging.messaging().appDidReceiveMessage(userInfo)
//
//        // Print full message.
//        print(userInfo)
//    }
//
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
//                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//        // If you are receiving a notification message while your app is in the background,
//        // this callback will not be fired till the user taps on the notification launching the application.
//        // TODO: Handle data of notification
//
//        // With swizzling disabled you must let Messaging know about the message, for Analytics
//        // Messaging.messaging().appDidReceiveMessage(userInfo)
//        // Print full message.
//        print("User Info",userInfo)
//
//        completionHandler(UIBackgroundFetchResult.newData)
//    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let notificationDetails = JSON(response.notification.request.content.userInfo)
        
        print("Notification data",notificationDetails)
        
        notificationOrderId = notificationDetails["gcm.notification.orderId"].stringValue
        notificationType = notificationDetails["gcm.notification.type"].stringValue
        
        print("NID T",notificationOrderId,notificationType)
        
        //Helper.saveUserDefaultValue(key: "notificationOrderId", value: notificationOrderId)
        //Helper.saveUserDefaultValue(key: "notificationType", value: notificationType)
        
        self.performSegue(withIdentifier: "notificationDetailSegue", sender: notificationDetails)
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    
    
    
    
}




