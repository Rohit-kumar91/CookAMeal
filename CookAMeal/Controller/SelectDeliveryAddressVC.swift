//
//  SelectDeliveryAddressVC.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 26/03/18.
//  Copyright © 2018 Cynoteck. All rights reserved.
//

import UIKit
import GooglePlaces
import JGProgressHUD
import SwiftyJSON

class SelectDeliveryAddressVC: UIViewController {
    
    
    @IBOutlet weak var addNewAddressButtonOutlet: RoundedButton!
    @IBOutlet weak var selectDeliveryAddressTableview: UITableView!
    
    var placeName: String = ""
    var street_number: String = ""
    var route: String = ""
    var neighborhood: String = ""
    var locality: String = ""
    var administrative_area_level_1: String = ""
    var country: String = ""
    var searchCountry : String = ""
    var postal_code: String = ""
    var postal_code_suffix: String = ""
    var City: String = ""
    
    @IBOutlet weak var navBar: UINavigationBar!
    
    let selectDeliveryAddressObj : SelectDeliveryAddressModel = SelectDeliveryAddressModel()
    let hud = JGProgressHUD(style: .light)
    var cartDict = [String: Any]()
    var forHireCook = Bool()
    var addressId = String()
    var streetAddress = String()
    var pincode = String()
    var city = String()
    var state = String()
    var singleOrder = Bool()
    var cookId: String = ""
    var recipeArray = [JSON]()
    var hireRecipeArray = [JSON]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print(recipeArray)
        
        hud.textLabel.text = PROGRESS_HUD.HUD_LABEL_KEY
        hud.show(in: self.view)
        selectDeliveryAddressObj.getAllAddress { (success) in
            self.hud.dismiss()
            if success {
                
                self.selectDeliveryAddressTableview.delegate = self
                self.selectDeliveryAddressTableview.dataSource = self
                self.selectDeliveryAddressTableview.reloadData()
                
                print(self.selectDeliveryAddressObj.sectionTitleArray.count)
                print(self.selectDeliveryAddressObj.finalAddressArray.count)
                
            } else {
                 self.present(Helper.globalAlertView(with: "DomesticEat", message: self.selectDeliveryAddressObj.alertMessage), animated: true, completion: nil)
            }
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
    }
    
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    @IBAction func checkButtonTapped(_ sender: Any) {
        
        let section = (sender as AnyObject).tag % 1000
        let row = (sender as AnyObject).tag / 1000
        
        if section == 0 {
            
           //For Section 0
           let array = selectDeliveryAddressObj.finalAddressArray[section]
           for (index, value) in array.enumerated() {
                
                if index == row {
                    print(value)
                    let temp = [
                        ID_KEY : value[ID_KEY],
                        "street" : value["street"],
                        "city" : value["city"],
                        "state" : value["state"],
                        "zipCode" : value["zipCode"],
                        "country" : value["country"],
                        "fullName" : value["fullName"],
                        "selected" : "1"
                    ]
                    
                    selectDeliveryAddressObj.finalAddressArray[section][index] = temp as! [String : String]
                }
            }
            
            if selectDeliveryAddressObj.sectionTitleArray.count == 2 {
                let section1array = selectDeliveryAddressObj.finalAddressArray[1]
                for (index, value) in section1array.enumerated() {
                    
                    let temp = [
                        ID_KEY : value[ID_KEY],
                        "street" : value["street"],
                        "city" : value["city"],
                        "state" : value["state"],
                        "zipCode" : value["zipCode"],
                        "country" : value["country"],
                        "fullName" : value["fullName"],
                        "selected" : "0"
                    ]
                    selectDeliveryAddressObj.finalAddressArray[1][index] = temp as! [String : String]
                }
            }
           
            
        } else {
            let array = selectDeliveryAddressObj.finalAddressArray[section]
            for (index, value) in array.enumerated() {
                
                if index == row {
                    print(value)
                    let temp = [
                        ID_KEY : value[ID_KEY],
                        "street" : value["street"],
                        "city" : value["city"],
                        "state" : value["state"],
                        "zipCode" : value["zipCode"],
                        "country" : value["country"],
                        "fullName" : value["fullName"],
                        "selected" : "1"
                    ]
                    
                    selectDeliveryAddressObj.finalAddressArray[section][index] = temp as! [String : String]
                    
                } else {
                    
                    let temp = [
                        ID_KEY : value[ID_KEY],
                        "street" : value["street"],
                        "city" : value["city"],
                        "state" : value["state"],
                        "zipCode" : value["zipCode"],
                        "country" : value["country"],
                        "fullName" : value["fullName"],
                        "selected" : "0"
                        
                    ]
                    selectDeliveryAddressObj.finalAddressArray[section][index] = temp as! [String : String]
                }
            }
            
            
            //For Section 0
            let section0array = selectDeliveryAddressObj.finalAddressArray[0]
            for (index, value) in section0array.enumerated() {
                
                let temp = [
                    ID_KEY : value[ID_KEY],
                    "street" : value["street"],
                    "city" : value["city"],
                    "state" : value["state"],
                    "zipCode" : value["zipCode"],
                    "country" : value["country"],
                    "fullName" : value["fullName"],
                    "selected" : "0"
                ]
                selectDeliveryAddressObj.finalAddressArray[0][index] = temp as! [String : String]
            }
        }
        
        selectDeliveryAddressTableview.reloadData()
        
    }
    
    
    @IBAction func deleteButtonTapped(_ sender: RoundedButton) {
        
        let section = (sender as AnyObject).tag % 1000
        let row = (sender as AnyObject).tag / 1000
        
        selectDeliveryAddressObj.deleteAddress(addressId: selectDeliveryAddressObj.finalAddressArray[section][row][ID_KEY]!) { (success) in
            if success {
                
                self.selectDeliveryAddressObj.finalAddressArray[section].remove(at: row)
                if self.selectDeliveryAddressObj.finalAddressArray[section].count == 0 {
                    self.selectDeliveryAddressObj.sectionTitleArray.remove(at: 1)
                    self.selectDeliveryAddressTableview.reloadData()
                } else {
                  self.selectDeliveryAddressTableview.deleteRows(at: [IndexPath(row: row, section: section)], with: .automatic)
                }
            } else{
               //self.showAlertWithMessage(alertMessage: self.selectDeliveryAddressObj.alertMessage)
                self.present(Helper.globalAlertView(with: LOGIN_CONSTANT.ALERT_HEADER_MESSAGE_KEY, message: self.selectDeliveryAddressObj.alertMessage), animated: true, completion: nil)
            }
        }
    }
    
    
    func showAlertWithMessage(alertMessage:String)
    {
        let alertController = UIAlertController(title:ALERT_TITLE.APP_NAME, message:alertMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    @IBAction func addNewAddressTapped(_ sender: RoundedButton) {
        
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self

        // Set a filter to return only addresses.
        let addressFilter = GMSAutocompleteFilter()
        autocompleteController.autocompleteFilter = addressFilter
        present(autocompleteController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func deliveredToThisAddressButtonTapped(_ sender: RoundedButton) {
        
        let section = (sender as AnyObject).tag % 1000
        let row = (sender as AnyObject).tag / 1000
        var idCook = String()
        
        if singleOrder {
            print(cookId)
            idCook = cookId
        } else {
            idCook = cartDict["cookId"]! as! String
        }
        
        hud.textLabel.text = PROGRESS_HUD.HUD_LABEL_KEY
        hud.show(in: self.view)
        selectDeliveryAddressObj.validateDeliveryAddress(sectionValue: section, cookId: idCook, addressId: selectDeliveryAddressObj.finalAddressArray[section][row]["id"]!) { (success) in
            self.hud.dismiss()
            if success {
                
                //serviceCallCheck
                self.performSegue(withIdentifier: "deliveryAddressToOrderFinal", sender: nil)
            } else  {
               //self.showAlertWithMessage(alertMessage: self.selectDeliveryAddressObj.alertMessage)
                self.present(Helper.globalAlertView(with: LOGIN_CONSTANT.ALERT_HEADER_MESSAGE_KEY, message: self.selectDeliveryAddressObj.alertMessage), animated: true, completion: nil)
            }
        }
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        for element in selectDeliveryAddressObj.finalAddressArray {
            for innerElement in element {
                if innerElement["selected"] == "1" {
                    addressId = innerElement[ID_KEY]!
                    streetAddress = innerElement["street"]!
                    city = innerElement["city"]!
                    pincode = innerElement["zipCode"]!
                    country = innerElement["country"]!
                }
            }
        }
        
        
        //Checking for orderType ForHiring or For Ordering
        
        if forHireCook {
            cartDict[ID_KEY] = addressId
            cartDict["street"] = streetAddress
            cartDict["city"] = city
            cartDict["zipCode"] = pincode
            cartDict["country"] = country
        } else {
            cartDict[ID_KEY] = addressId
            cartDict["street"] = streetAddress
            cartDict["city"] = city
            cartDict["zipCode"] = pincode
            cartDict["country"] = country
        }
        
       
        if segue.identifier == "addNewAddressSegue" {
            
            if let dest = segue.destination as? AddNewDeliveryAddressVC {
                dest.placeName = placeName
                dest.street_number = street_number
                dest.route =  route
                dest.locality = locality
                dest.administrative_area_level_1 = administrative_area_level_1
                dest.postal_code = postal_code
                dest.country = searchCountry
                dest.orderSummaryData = cartDict
                dest.cookId = cookId
                dest.singleOrder = singleOrder
                
                
            }
        } else if segue.identifier == "deliveryAddressToOrderFinal" {
             let destinationVC = segue.destination as! OrderFinalScreenVC
            
            if forHireCook {
                destinationVC.hireCookForSingleRecipe = true
                destinationVC.forHire = true
                destinationVC.singleOrder = true
                destinationVC.finalCartdict = cartDict
                destinationVC.finalRecipeArray = recipeArray
                destinationVC.hireRecipeArray = hireRecipeArray
                
            } else{
                destinationVC.finalCartdict = cartDict
                destinationVC.singleOrder = singleOrder
                print("Rohitrtert",recipeArray)
                destinationVC.finalRecipeArray = recipeArray
            }
            
        } 
    }
}





extension SelectDeliveryAddressVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return selectDeliveryAddressObj.sectionTitleArray.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return selectDeliveryAddressObj.sectionTitleArray[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectDeliveryAddressObj.finalAddressArray[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AddressTableviewcell
        cell.checkButtonOutlet.tag =  indexPath.row * 1000 + indexPath.section
        cell.deleteButtonOutlet.tag = indexPath.row * 1000 + indexPath.section
        cell.deliveryButtonOutlet.tag = indexPath.row * 1000 + indexPath.section
        
        if let firstName = selectDeliveryAddressObj.finalAddressArray[indexPath.section][indexPath.row]["fullName"] {
            cell.nameLabelOutlet.text = firstName
        }
        
        if let streetAddress = selectDeliveryAddressObj.finalAddressArray[indexPath.section][indexPath.row]["street"] {
             cell.streetAddressLabelOutlet.text = streetAddress
        }
        
        if let city = selectDeliveryAddressObj.finalAddressArray[indexPath.section][indexPath.row]["city"],
            let state = selectDeliveryAddressObj.finalAddressArray[indexPath.section][indexPath.row]["state"] {
            cell.cityLabelOutlet.text = city + ", " + state
        }
        
        if let zipCode = selectDeliveryAddressObj.finalAddressArray[indexPath.section][indexPath.row]["zipCode"] {
           cell.zipCodeOutlet.text = zipCode
        }
       
        if let country = selectDeliveryAddressObj.finalAddressArray[indexPath.section][indexPath.row]["country"] {
             cell.countryLabelOutlet.text = country
        }
        
        let selectedValue = selectDeliveryAddressObj.finalAddressArray[indexPath.section][indexPath.row]["selected"]
        
        if Helper.getUserDefaultValue(key: "orderType") == "1" {
            cell.deliveryButtonOutlet.setTitle("Select", for: .normal)
            navBar.topItem?.title = "Select Address"

        }
        
    
        if selectedValue! == "1" {
            cell.deliveryButtonOutlet.isHidden = false
            if indexPath.section == 0 {
                if indexPath.row == 0 {
                     cell.deleteButtonOutlet.isHidden = true
                }
            } else {
                cell.deleteButtonOutlet.isHidden = false
            }
            cell.checkButtonOutlet.on = true
            
        } else {
            cell.deliveryButtonOutlet.isHidden = true
            cell.deleteButtonOutlet.isHidden = true
            cell.checkButtonOutlet.on = false
        }
       
        return cell
    }
}




extension SelectDeliveryAddressVC: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        // Print place info to the console.
        self.placeName = place.name
        
        // Get the address components.
        if let addressLines = place.addressComponents {
            // Populate all of the address fields we can find.
            for field in addressLines {
                switch field.type {
                case kGMSPlaceTypeStreetNumber:
                    street_number = field.name
                case kGMSPlaceTypeRoute:
                    route = field.name
                case kGMSPlaceTypeNeighborhood:
                    neighborhood = field.name
                case kGMSPlaceTypeLocality:
                    locality = field.name
                case kGMSPlaceTypeAdministrativeAreaLevel1:
                    administrative_area_level_1 = field.name
                case kGMSPlaceTypeCountry:
                    searchCountry = field.name
                case kGMSPlaceTypePostalCode:
                    postal_code = field.name
                case kGMSPlaceTypePostalCodeSuffix:
                    postal_code_suffix = field.name
                // Print the items we aren't using.
                default:
                    print("Type: \(field.type), Name: \(field.name)")
                }
            }
        }
        
        // Call custom function to populate the address form.
        // Close the autocomplete widget.
        //self.dismiss(animated: true, completion: nil)
        self.dismiss(animated: true) {
            self.performSegue(withIdentifier: "addNewAddressSegue", sender: nil)
        }
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


