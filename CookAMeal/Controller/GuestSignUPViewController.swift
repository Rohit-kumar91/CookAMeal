//
//  GuestSignUPViewController.swift
//  CookAMeal
//
//  Created by Cynoteck on 18/04/18.
//  Copyright © 2018 Cynoteck. All rights reserved.
//

import UIKit
import JGProgressHUD
import CoreLocation
import GooglePlaces
import CountryPicker



class GuestSignUPViewController: UIViewController, CountryPickerDelegate, UITextFieldDelegate {
    
    let hud = JGProgressHUD(style: .light)
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    var guestModelObj : GuestSignUPModel = GuestSignUPModel()
    var placeName: String = ""
    var street_number: String = ""
    var route: String = ""
    var neighborhood: String = ""
    var locality: String = ""
    var administrative_area_level_1: String = ""
    var country: String = ""
    var postal_code: String = ""
    var postal_code_suffix: String = ""
    var City: String = ""
    var recipeData = [String: String]()
    var cookId = String()
    let countryPicker = CountryPicker()
    var phonePicker = ""
    var countryPhoneCode: String!
    var countryName: String!


    @IBOutlet weak var countryCodeTextField: ImageTextfield!
    @IBOutlet weak var firstnameTextfield: ImageTextfield!
    @IBOutlet weak var lastnameTextfield: ImageTextfield!
    @IBOutlet weak var emailTextfield: ImageTextfield!
    @IBOutlet weak var mobileNumberTextfield: ImageTextfield!
    @IBOutlet weak var streetAddressTextfield: UITextField!
    @IBOutlet weak var cityTextfield: UITextField!
    @IBOutlet weak var stateTextfield: UITextField!
    @IBOutlet weak var zipcodeTextfield: UITextField!
    @IBOutlet weak var countryTextfield: UITextField!
    @IBOutlet weak var signUpButtonOutlet: RoundedButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let locale = Locale.current
        let phoneCode = Singleton.instance.getCountryPhonceCode(locale.regionCode!)
        countryCodeTextField.text = "+" + phoneCode
        
        countryPhoneCode = "+1"
        hud.show(in: self.view)
        hud.textLabel.text = ""
        locationAuthStatus()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        customCountryPicker()
        
    }
    
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

    func locationAuthStatus() {
        
        hud.dismiss()
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways {
            
            currentLocation = locationManager.location
            
            let longitude: CLLocationDegrees = currentLocation.coordinate.longitude
            let latitude: CLLocationDegrees = currentLocation.coordinate.latitude
            let location = CLLocation(latitude: latitude, longitude: longitude)
            
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
                guard let addressDict = placemarks?[0].addressDictionary else {
                    return
                }
                
                // Print each key-value pair in a new row
                addressDict.forEach { print($0) }
                
                // Print fully formatted address
                if let formattedAddress = addressDict["FormattedAddressLines"] as? [String] {
                    print(formattedAddress.joined(separator: ", "))
                }
                
                // Access each element manually
                if let locationName = addressDict["Name"] as? String {
                    print(locationName)
                    self.streetAddressTextfield.text = locationName
                }
                if let street = addressDict["Thoroughfare"] as? String {
                    print(street)
                    //self.streetAddressTextfield.text = street
                }
                if let city = addressDict["City"] as? String {
                    print(city)
                    self.cityTextfield.text = city
                }
                if let zip = addressDict["ZIP"] as? String {
                    print(zip)
                    self.zipcodeTextfield.text = zip
                }
                if let country = addressDict["Country"] as? String {
                    print(country)
                    self.countryTextfield.text = country
                }
                if let state = addressDict["State"] as? String {
                    print(state)
                    self.stateTextfield.text = state
                }
            })
            
        } else {
            self.showAlertWithMessage(alertMessage: "Location Not Allowed.")
        }
    }

    
    
    
    
    
    func customCountryPicker() {
        
        let toolbar = UIToolbar()
        let cancelButton = UIBarButtonItem (barButtonSystemItem: .cancel, target: nil, action: #selector(pickerCancelPressed))
        let doneButton = UIBarButtonItem (barButtonSystemItem: .done, target: nil, action: #selector(pickerDonePressed))
        let flexButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([cancelButton,flexButton, doneButton], animated: true)
        
        doneButton.tintColor = #colorLiteral(red: 0.8862745098, green: 0.1725490196, blue: 0.168627451, alpha: 1)
        cancelButton.tintColor = #colorLiteral(red: 0.8862745098, green: 0.1725490196, blue: 0.168627451, alpha: 1)
        toolbar.sizeToFit()
        
        countryTextfield.inputAccessoryView = toolbar
        countryTextfield.inputView = countryPicker
        countryCodeTextField.inputAccessoryView = toolbar
        countryCodeTextField.inputView = countryPicker
        
        countryPicker.countryPickerDelegate = self
        countryPicker.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        countryPicker.showPhoneNumbers = true
        
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var maxLength = Int()
        var currentString = NSString()
        var newString = NSString()
        
        if textField.tag == 2 {
            
            maxLength = 10
            currentString = textField.text! as NSString
            newString = currentString.replacingCharacters(in: range, with: string) as NSString
            
        }
        
        return newString.length <= maxLength
        
    }
    
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 1 {
            phonePicker = "PhoneCodePicker"
            //countryCodeTextField.becomeFirstResponder()
        }
        
        return true
    }
    
    
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 01 2017
    // Input Parameters :   N/A.
    // Purpose          :   Picker toobar done action for dismiss picker.
    //>--------------------------------------------------------------------------------------------------
    @objc func pickerCancelPressed() {
        
        if phonePicker == "PhoneCodePicker" {
            phonePicker = ""
        }
        
        self.view.endEditing(true)
    }
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 01 2017
    // Input Parameters :   N/A.
    // Purpose          :   Picker toobar done action for dismiss picker.
    //>--------------------------------------------------------------------------------------------------
    @objc func pickerDonePressed() {
        
        if phonePicker == "PhoneCodePicker" {
            phonePicker = ""
            countryCodeTextField.text = countryPhoneCode
        }else if countryName == "" {
            countryTextfield.text = "+1"
        } else {
            countryTextfield.text = countryName
        }
        self.view.endEditing(true)
    }
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 01 2017
    // Input Parameters :   N/A.
    // Purpose          :   Helps in to set country name in  country textfield .
    //>--------------------------------------------------------------------------------------------------
    
    func countryPhoneCodePicker(_ picker: CountryPicker, didSelectCountryWithName name: String, countryCode: String, phoneCode: String, flag: UIImage) {
        
        if phonePicker == "PhoneCodePicker" {
            countryPhoneCode = phoneCode
        } else {
            countryName = name
        }
    }
    
    
    
    

    func showAlertWithMessage(alertMessage:String)
    {
        let alertController = UIAlertController(title:ALERT_TITLE.APP_NAME, message:alertMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    @IBAction func signUpButtonTapped(_ sender: RoundedButton) {
        
        guestModelObj.firstname = firstnameTextfield.text!
        guestModelObj.lastname = lastnameTextfield.text!
        guestModelObj.userEmail = emailTextfield.text!
        guestModelObj.mobileNumber = mobileNumberTextfield.text!
        guestModelObj.street = streetAddressTextfield.text!
        guestModelObj.city = cityTextfield.text!
        guestModelObj.state = stateTextfield.text!
        guestModelObj.pinCode = zipcodeTextfield.text!
        guestModelObj.country = countryTextfield.text!
        
        
        if !guestModelObj.validateFirstname() {
            showAlertWithMessage(alertMessage: guestModelObj.alertMessage)
        } else if !guestModelObj.validateEmail() {
            showAlertWithMessage(alertMessage: guestModelObj.alertMessage)
        } else if !guestModelObj.validateLastname() {
            showAlertWithMessage(alertMessage: guestModelObj.alertMessage)
        }
        /*
        else if !guestModelObj.validatePhone() {
            showAlertWithMessage(alertMessage: guestModelObj.alertMessage)
        }*/
        else if !guestModelObj.validateStreetAddress() {
            showAlertWithMessage(alertMessage: guestModelObj.alertMessage)
        } else if !guestModelObj.validateCity() {
            showAlertWithMessage(alertMessage: guestModelObj.alertMessage)
        } else if !guestModelObj.validateState() {
            showAlertWithMessage(alertMessage: guestModelObj.alertMessage)
        } else if !guestModelObj.validateZipcode() {
            showAlertWithMessage(alertMessage: guestModelObj.alertMessage)
        } else if !guestModelObj.validateCountry() {
            showAlertWithMessage(alertMessage: guestModelObj.alertMessage)
        } else {
            
            print(recipeData)
            print(recipeData["cookId"]!)
            
            guestModelObj.validateAddress(cookId: recipeData["cookId"]!) { (success) in
                
                if success {
                    self.performSegue(withIdentifier: "fromGuestSignUPToOrderFinal", sender: nil)
                } else {
                    //self.showAlertWithMessage(alertMessage: self.guestModelObj.alertMessage)
                    self.present(Helper.globalAlertView(with: LOGIN_CONSTANT.ALERT_HEADER_MESSAGE_KEY, message: self.guestModelObj.alertMessage), animated: true, completion: nil)
                }
            }
        }
    }
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "fromGuestSignUPToOrderFinal" {
            
            //Create Finaldict
            let guestData : [String: String] = [
                "firstName" : guestModelObj.firstname,
                "lastName" : guestModelObj.lastname,
                "email" : guestModelObj.userEmail,
                "phone" : guestModelObj.mobileNumber,
                "street" : guestModelObj.street,
                "city" : guestModelObj.city,
                "state" : guestModelObj.state,
                "zipcode": guestModelObj.pinCode,
                "country" : guestModelObj.country
            ]
            
            let destinationVC = segue.destination as! OrderFinalScreenVC
            destinationVC.guestOrder = true
            destinationVC.finalGuestOrderDict = guestData
            destinationVC.finalCartdict = recipeData
        }
    }
    
    
    
    
    @IBAction func changeAddress(_ sender: UIButton) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        // Set a filter to return only addresses.
        let addressFilter = GMSAutocompleteFilter()
        addressFilter.country = Locale.current.regionCode
        autocompleteController.autocompleteFilter = addressFilter
        present(autocompleteController, animated: true, completion: nil)
    }
    
}


extension GuestSignUPViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        // Print place info to the console.
        print("Place name: \(place.name)")
        print("Place address: \(String(describing: place.formattedAddress))")
        print("Place attributions: \(String(describing: place.attributions))")
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
                    country = field.name
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
        fillAddressForm()
        
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
    
        
    // Populate the address form fields.
    func fillAddressForm() {
        
        self.streetAddressTextfield.text = placeName + " " + street_number + " " + route
        self.cityTextfield.text = locality
        self.stateTextfield.text = administrative_area_level_1
        if postal_code_suffix != "" {
            self.zipcodeTextfield.text = postal_code + "-" + postal_code_suffix
        } else {
            self.zipcodeTextfield.text = postal_code
        }
        self.countryTextfield.text = country
        
        // Clear values for next time.
        street_number = ""
        route = ""
        neighborhood = ""
        locality = ""
        administrative_area_level_1  = ""
        country = ""
        postal_code = ""
        postal_code_suffix = ""
    }
}

