//
//  AddNewDeliveryAddressVC.swift
//  CookAMeal
//
//  Created by Rohit Prajapati on 08/04/18.
//  Copyright © 2018 Cynoteck. All rights reserved.
//

import UIKit
import CountryPicker
import GooglePlaces
import JGProgressHUD


class AddNewDeliveryAddressVC: UIViewController, CountryPickerDelegate {

    @IBOutlet weak var firstNameTxtfield: UITextField!
    @IBOutlet weak var countryCodeTxtField: UITextField!
    @IBOutlet weak var pincodeTxtfield: UITextField!
    @IBOutlet weak var streetTxtfield: UITextField!
    @IBOutlet weak var cityTxtfield: UITextField!
    @IBOutlet weak var stateTxtfield: UITextField!
    @IBOutlet weak var countryTxtfield: UITextField!
    @IBOutlet weak var mobileNumberTextfield: UITextField!
    
    var orderSummaryData = [String: Any]()
    
    let addNewAddressObj: AddNewDeliveryAddressModel = AddNewDeliveryAddressModel()
    

    var cookId: String = "" 
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
    var countryPhoneCode = ""
    let hud = JGProgressHUD(style: .light)
    var singleOrder = Bool()


    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        pincodeTxtfield.text = postal_code
        streetTxtfield.text = placeName + " " + street_number + " " + route
        stateTxtfield.text = administrative_area_level_1
        countryTxtfield.text = country
        cityTxtfield.text = locality
        
        //let locale = Locale.current
        //let phoneCode = Singleton.instance.getCountryPhonceCode(locale.regionCode!)
        //countryCodeTxtField.text = "+" + phoneCode
        countryCodeTxtField.text = "+" + Singleton.instance.getCountryPhonceCode(localeCode(for: countryTxtfield.text!))
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.customCountryPicker()
        
    }
   
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    
    }

    
    
    func countryPhoneCodePicker(_ picker: CountryPicker, didSelectCountryWithName name: String, countryCode: String, phoneCode: String, flag: UIImage) {
        countryPhoneCode = phoneCode
    }

    
    func customCountryPicker() {
        let countryPicker = CountryPicker()
        let toolbar = UIToolbar()
        let cancelButton = UIBarButtonItem (barButtonSystemItem: .cancel, target: nil, action: #selector(pickerCancelPressed))
        let doneButton = UIBarButtonItem (barButtonSystemItem: .done, target: nil, action: #selector(pickerDonePressed))
        let flexButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([cancelButton,flexButton, doneButton], animated: true)
        
        doneButton.tintColor = #colorLiteral(red: 0.8862745098, green: 0.1725490196, blue: 0.168627451, alpha: 1)
        cancelButton.tintColor = #colorLiteral(red: 0.8862745098, green: 0.1725490196, blue: 0.168627451, alpha: 1)
        toolbar.sizeToFit()
        
        countryCodeTxtField.inputAccessoryView = toolbar
        countryCodeTxtField.inputView = countryPicker
        countryPicker.countryPickerDelegate = self
        countryPicker.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        countryPicker.showPhoneNumbers = true
        
    }
    
    
    @objc func pickerDonePressed() {
        
        if countryPhoneCode == "" {
            countryCodeTxtField.text = "+1"
        } else {
            countryCodeTxtField.text = countryPhoneCode
        }
        self.view.endEditing(true)
    }
    
    
    @objc func pickerCancelPressed() {
        self.view.endEditing(true)
    }
    

    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    @IBAction func AddNewAddressTapped(_ sender: Any) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        // Set a filter to return only addresses.
        let addressFilter = GMSAutocompleteFilter()
        autocompleteController.autocompleteFilter = addressFilter
        present(autocompleteController, animated: true, completion: nil)
        
    }
    
    
    
     func localeCode(for fullCountryName : String) -> String {
        let locales : String = ""
        for localeCode in NSLocale.isoCountryCodes {
            let identifier = NSLocale(localeIdentifier: localeCode)
            let countryName = identifier.displayName(forKey: NSLocale.Key.countryCode, value: localeCode)
            if fullCountryName.lowercased() == countryName?.lowercased() {
                return localeCode
            }
        }
        return locales
    }
    
    
    @IBAction func deliveredThisAddressTapped(_ sender: RoundedButton) {
       
        addNewAddressObj.fullName  = firstNameTxtfield.text
        addNewAddressObj.pinCode = pincodeTxtfield.text
        addNewAddressObj.streetAddress = streetTxtfield.text
        addNewAddressObj.city = cityTxtfield.text
        addNewAddressObj.state = stateTxtfield.text
        addNewAddressObj.country = countryTxtfield.text
        addNewAddressObj.mobileNumber = mobileNumberTextfield.text
        
        addNewAddressObj.name =  countryTxtfield.text
        addNewAddressObj.dialCode = Singleton.instance.getCountryPhonceCode(localeCode(for: countryTxtfield.text!))
        addNewAddressObj.countryCode = localeCode(for: countryTxtfield.text!)
        addNewAddressObj.cookId = cookId
        
        
        if !addNewAddressObj.validateFullname() {
            showAlertWithMessage(alertMessage: addNewAddressObj.alertMessage)
        } else if !addNewAddressObj.validatePhone() {
             showAlertWithMessage(alertMessage: addNewAddressObj.alertMessage)
        } else if !addNewAddressObj.validatePincode() {
             showAlertWithMessage(alertMessage: addNewAddressObj.alertMessage)
        } else if !addNewAddressObj.validateStreet() {
             showAlertWithMessage(alertMessage: addNewAddressObj.alertMessage)
        } else if !addNewAddressObj.validateCity() {
             showAlertWithMessage(alertMessage: addNewAddressObj.alertMessage)
        } else if !addNewAddressObj.validateState() {
             showAlertWithMessage(alertMessage: addNewAddressObj.alertMessage)
        } else if !addNewAddressObj.validateCountry() {
             showAlertWithMessage(alertMessage: addNewAddressObj.alertMessage)
        } else {
            
            hud.textLabel.text = PROGRESS_HUD.HUD_LABEL_KEY
            hud.show(in: self.view)
            addNewAddressObj.addNewAddress(completion: { (success) in
                self.hud.dismiss()
                if success {
                   print(self.orderSummaryData)
                   self.orderSummaryData[ID_KEY] = self.addNewAddressObj.addressJson[ID_KEY].stringValue
                   self.orderSummaryData["country"] =  self.addNewAddressObj.addressJson["country"].stringValue
                    self.orderSummaryData["city"] = self.addNewAddressObj.addressJson["city"].stringValue
                    self.orderSummaryData["street"] = self.addNewAddressObj.addressJson["street"].stringValue
                    self.orderSummaryData["zipCode"] = self.addNewAddressObj.addressJson["zipCode"].stringValue
                    self.orderSummaryData["cookId"]  = self.cookId
                    
                    print(self.orderSummaryData)
                    //toAddnewToOrderFinal
                    self.performSegue(withIdentifier: "toAddnewToOrderFinal", sender: nil)
                    
                } else {
                    //self.showAlertWithMessage(alertMessage: self.addNewAddressObj.alertMessage)
                    self.present(Helper.globalAlertView(with: LOGIN_CONSTANT.ALERT_HEADER_MESSAGE_KEY, message: self.addNewAddressObj.alertMessage), animated: true, completion: nil)
                }
            })
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toAddnewToOrderFinal" {
            let destinationVC = segue.destination as! OrderFinalScreenVC
            destinationVC.finalCartdict = self.orderSummaryData
            destinationVC.singleOrder = singleOrder
        }
        
    }
    
    
    
    func showAlertWithMessage(alertMessage:String)
    {
        let alertController = UIAlertController(title:ALERT_TITLE.APP_NAME, message:alertMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
}



extension AddNewDeliveryAddressVC: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        addNewAddressObj.latitude = String(place.coordinate.latitude)
        addNewAddressObj.longitute = String(place.coordinate.longitude)
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
        
       
        
        self.streetTxtfield.text = placeName + " " + street_number + " " + route
        self.cityTxtfield.text = locality
        self.stateTxtfield.text = administrative_area_level_1
        if postal_code_suffix != "" {
            self.pincodeTxtfield.text = postal_code + "-" + postal_code_suffix
        } else {
            self.pincodeTxtfield.text = postal_code
        }
        self.countryTxtfield.text = country
        
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



extension AddNewDeliveryAddressVC : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var maxLength = Int()
        var currentString = NSString()
        var newString = NSString()
        maxLength = 10
        currentString = textField.text! as NSString
        newString = currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
   }
}
