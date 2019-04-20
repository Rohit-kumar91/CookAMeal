//
//  CustomerRegistrationFirstVC.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 09/11/17.
//  Copyright © 2017 Cynoteck. All rights reserved.
//

import UIKit
import AAPickerView
import CountryPicker
import AVFoundation
import CoreLocation
import GooglePlaces
import JGProgressHUD
import SwiftyJSON

class CustomerRegistrationFirstVC: UIViewController,UIImagePickerControllerDelegate,UIPopoverControllerDelegate,UINavigationControllerDelegate, UITextFieldDelegate, CountryPickerDelegate, CLLocationManagerDelegate {

    
    //Oulets
    @IBOutlet weak var dietPreferencePicker: AAPickerView!
    @IBOutlet weak var emailTextfield: ImageTextfield!
    @IBOutlet weak var firstnameTextfield: ImageTextfield!
    @IBOutlet weak var lastnameTextfield: ImageTextfield!
    @IBOutlet weak var createPasswordTextfield: ImageTextfield!
    @IBOutlet weak var phoneNumberTextfield: ImageTextfield!
    @IBOutlet weak var streetAddressTextfield: ImageTextfield!
    @IBOutlet weak var cityTextfield: UITextField!
    @IBOutlet weak var stateTextfield: UITextField!
    @IBOutlet weak var zipcodeTextfield: UITextField!
    @IBOutlet weak var countryTextfield: UITextField!
    @IBOutlet weak var profilePictureImageview: UIImageViewX!
    @IBOutlet weak var maleButtonOutlet: RoundedButton!
    @IBOutlet weak var femaleButtonOutlet: RoundedButton!
    @IBOutlet weak var passwordHintViewOutlet: UIViewX!
    @IBOutlet weak var countryCodeTextfield: ImageTextfield!
    @IBOutlet weak var mainScrollView: TPKeyboardAvoidingScrollView!
    
    
    var gender: String! = ""
    var countryName: String!
    var imagePicker:UIImagePickerController?=UIImagePickerController()
    let countryPicker = CountryPicker()
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    var registrationObj: CustomerRegistrationModel = CustomerRegistrationModel()

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
    let hud = JGProgressHUD(style: .light)
    var phonePicker = ""
    var countryPhoneCode: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countryPhoneCode = "+1"
        
        //Set the allergies value to the default value.
        customerRegistrationConstant.AllergiesArray.allergiesName =  [["name" : "Milk", "selectionType" : "uncheck"],
                                                                      ["name" : "Eggs", "selectionType" : "uncheck"],
                                                                      ["name" : "Fish(e.g, bass, flounder, cod)", "selectionType" : "uncheck"],
                                                                      ["name" : "Crustacean Shellfish", "selectionType" : "uncheck"],
                                                                      ["name" : "Tree nuts(e.g, almonds, walnuts, pecans)", "selectionType" : "uncheck"],
                                                                      ["name" : "Peanuts", "selectionType" : "uncheck"],
                                                                      ["name" : "Wheat", "selectionType" : "uncheck"],
                                                                      ["name" : "Soyabeans", "selectionType" : "uncheck"]]
        
        
        //Set default gender
        maleButtonOutlet.setImage(UIImage(named:"check_icon.png"), for: .normal)
        maleButtonOutlet.tintColor = #colorLiteral(red: 0.9568627451, green: 0.262745098, blue: 0.2117647059, alpha: 1)
        
        femaleButtonOutlet.setImage(UIImage(named:"uncheck_icon.png"), for: .normal)
        femaleButtonOutlet.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        gender = "M"

        //Lcation Manager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.stopMonitoringSignificantLocationChanges()
        
        
        hud.show(in: self.view)
        hud.textLabel.text = ""
        locationAuthStatus()
        passwordHintViewOutlet.alpha = 0
        mainScrollView.delegate = self
        let locale = Locale.current
        let phoneCode = Singleton.instance.getCountryPhonceCode(locale.regionCode!)
        countryCodeTextfield.text = "+" + phoneCode
        countryTextfield.tag = 1
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.passwordHint(notification:)), name: Notification.Name("passwordValidationCustomer"), object: nil)
        
    }
    
    @objc func passwordHint(notification: Notification){
        self.passwordHintViewOutlet.alpha = 1
    }
    
    deinit {
        // perform the deinitialization
        NotificationCenter.default.removeObserver("passwordValidationCustomer")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        dietPreference()
        profilePictureImageview.clipsToBounds = true
        imagePicker?.delegate=self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        customCountryPicker()

    }
    
   
    @IBAction func countryPickerButtonTapped(_ sender: UIButton) {
        phonePicker = "PhoneCodePicker"
        countryCodeTextfield.becomeFirstResponder()
    }
    
    @IBAction func showPasswordHintTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5) {
            self.passwordHintViewOutlet.alpha = 1
        }
    }
    
    @IBAction func hintViewCloseButtonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5) {
            self.passwordHintViewOutlet.alpha = 0
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        Singleton.instance.enterEmailAddress = emailTextfield.text
    }
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 01 2017
    // Input Parameters :   N/A.
    // Purpose          :   Getting current address.
    //>--------------------------------------------------------------------------------------------------
    func locationAuthStatus() {
        
        hud.dismiss()
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways {
            
            currentLocation = locationManager.location
            print(currentLocation.coordinate.latitude)
            print(currentLocation.coordinate.longitude)
            
            registrationObj.latitude = String(currentLocation.coordinate.latitude)
            registrationObj.longitude = String(currentLocation.coordinate.longitude)
            
            let longitude: CLLocationDegrees = currentLocation.coordinate.longitude
            let latitude: CLLocationDegrees = currentLocation.coordinate.latitude
            let location = CLLocation(latitude: latitude, longitude: longitude)
            
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
                
                guard let addressDict = placemarks?[0].addressDictionary else {
                    return
                }
                
                let jsonAddressData = JSON(addressDict)
                print(jsonAddressData)
              
                self.streetAddressTextfield.text = jsonAddressData["SubLocality"].stringValue
                self.cityTextfield.text = jsonAddressData["City"].stringValue
                self.zipcodeTextfield.text = jsonAddressData["ZIP"].stringValue
                self.countryTextfield.text = jsonAddressData["Country"].stringValue
                self.stateTextfield.text = jsonAddressData["State"].stringValue
                
                /*
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
                } */
            })
            
        } else {
            
            self.showAlertWithMessage(alertMessage: "Location Not Allowed.")
            
            //locationManager.requestWhenInUseAuthorization()
        }
    }
    
    
    
    
    
    @IBAction func changeAddressButtonTapped(_ sender: UIButton) {
        
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        // Set a filter to return only addresses.
        let addressFilter = GMSAutocompleteFilter()
        addressFilter.country = Locale.current.regionCode
        autocompleteController.autocompleteFilter = addressFilter
        
        present(autocompleteController, animated: true, completion: nil)
        
    }
    
    
    func showAlertWithMessage(alertMessage:String)
    {
        let alertController = UIAlertController(title:ALERT_TITLE.APP_NAME, message:alertMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Oct, 31 2017
    // Input Parameters :   N/A
    // Purpose          :   For Keyboard Hiding.
    //>--------------------------------------------------------------------------------------------------
    @IBAction func hidingKeyboardTapGesture(_ sender: Any) {
        self.view.endEditing(true)
        UIView.animate(withDuration: 0.5) {
            self.passwordHintViewOutlet.alpha = 0
        }
    }
    
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Oct, 31 2017
    // Input Parameters :   N/A
    // Purpose          :   Create string selection picker.
    //>--------------------------------------------------------------------------------------------------
    func dietPreference() {
        
//        dietPreferencePicker.stringPickerData = customerRegistrationConstant.dietPreferenceArray.dietType
//        dietPreferencePicker.pickerType = .StringPicker
//        dietPreferencePicker.toolbar.tintColor = #colorLiteral(red: 0.9568627451, green: 0.262745098, blue: 0.2117647059, alpha: 1)
//        dietPreferencePicker.stringDidChange = { index in
//            print("selectedString ", customerRegistrationConstant.dietPreferenceArray.dietType[index])
//        }
        
        dietPreferencePicker.pickerType = .string(data: customerRegistrationConstant.dietPreferenceArray.dietType)
        dietPreferencePicker.toolbar.tintColor = #colorLiteral(red: 0.9568627451, green: 0.262745098, blue: 0.2117647059, alpha: 1)
        dietPreferencePicker.valueDidSelected = { index in
        }
        
        
        
    }

    
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 13 2017
    // Input Parameters :   N/A
    // Purpose          :   Helps in to select gallery or camera.
    //>--------------------------------------------------------------------------------------------------
    @IBAction func chooseProfileButtonTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        
        let alertController = UIAlertController(title: nil, message: "Action", preferredStyle: .actionSheet)
        
        let gallery = UIAlertAction(title: "Gallery", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            //  Do some action here.
            self.openGallary()
        })
        
        let camera = UIAlertAction(title: "Camera", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            //  Do some destructive action here.
            self.openCamera()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (alert: UIAlertAction!) -> Void in
            //  Do something here upon cancellation.
        })
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
        }
        
        alertController.addAction(gallery)
        alertController.addAction(camera)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 13 2017
    // Input Parameters :   N/A.
    // Purpose          :   open imagepicker.
    //>--------------------------------------------------------------------------------------------------
    func openGallary()
    {
        imagePicker!.allowsEditing = false
        imagePicker!.sourceType = .photoLibrary
        present(imagePicker!, animated: true, completion: nil)
    }
    
    
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 13 2017
    // Input Parameters :   N/A.
    // Purpose          :   open camera.
    //>--------------------------------------------------------------------------------------------------
    func openCamera()
    {
                
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.sourceType = UIImagePickerControllerSourceType.camera
        
        self.present(myPickerController, animated: true, completion: nil)
        print("Camera");
        
    }
    
    
    
    func checkCamera() {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch authStatus {
        case .authorized: openCamera() // Do your stuff here i.e. callCameraMethod()
        case .denied: alertToEncourageCameraAccessInitially()
        case .notDetermined: alertPromptToAllowCameraAccessViaSetting()
        default: alertToEncourageCameraAccessInitially()
        }
    }
    
    
    
    func alertToEncourageCameraAccessInitially() {
        let alert = UIAlertController(
            title: "IMPORTANT",
            message: "Camera access required for capturing photos!",
            preferredStyle: UIAlertControllerStyle.alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Allow Camera", style: .cancel, handler: { (alert) -> Void in
            // UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
            UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
            
            
        }))
        present(alert, animated: true, completion: nil)
    }
    
    
    
    func alertPromptToAllowCameraAccessViaSetting() {
        
        let alert = UIAlertController(
            title: "IMPORTANT",
            message: "Camera access required for capturing photos!",
            preferredStyle: UIAlertControllerStyle.alert
        )
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel) { alert in
            
            if (AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.front).devices.first?.localizedName) != nil{
                //cameraID = "Front Camera"
                AVCaptureDevice.requestAccess(for: AVMediaType.video) { granted in
                    DispatchQueue.main.async() {
                        self.checkCamera() } }
            }
            
            }
        )
        present(alert, animated: true, completion: nil)
    }
    
    
    
    
    // MARK: Imagepicker Delegate method.
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        profilePictureImageview.contentMode = .scaleAspectFill
        profilePictureImageview.image = chosenImage
        dismiss(animated: true, completion: nil)
    }
    
    
    
    // MARK: Textfield Delegate method.
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Oct, 16 2017
    // Input Parameters :   Textfield Delegate methods.
    // Purpose          :   Helps in to set the character length of textfield.
    //>--------------------------------------------------------------------------------------------------
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var maxLength = Int()
        var currentString = NSString()
        var newString = NSString()
        
        if textField.tag == 1 {
            
            maxLength = 10
            currentString = textField.text! as NSString
            newString = currentString.replacingCharacters(in: range, with: string) as NSString
           
        } else if textField.tag == 5 {
            passwordHintViewOutlet.alpha = 1
         
        }
        
        return newString.length <= maxLength
      
    }
    

    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 5 {
            //passwordHintViewOutlet.alpha = 1
        }
    }

   
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 5 {
            passwordHintViewOutlet.alpha = 0
        }
        
    }
    
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 01 2017
    // Input Parameters :   N/A.
    // Purpose          :   For select the country from picker.
    //>--------------------------------------------------------------------------------------------------
    
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
        
      
        countryCodeTextfield.inputAccessoryView = toolbar
        countryCodeTextfield.inputView = countryPicker
        
        countryPicker.countryPickerDelegate = self
        countryPicker.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        countryPicker.showPhoneNumbers = true
        
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
            countryCodeTextfield.text = countryPhoneCode
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
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 10 2017
    // Input Parameters :   Textfield Delegate methods.
    // Purpose          :   Button works as a radio button for gender selection.
    //>--------------------------------------------------------------------------------------------------
    @IBAction func genderButtonTapped(_ sender: UIButton) {
        
        if sender.tag == 1 {
            if (maleButtonOutlet.currentImage?.isEqual(UIImage(named:"uncheck_icon.png")))! {
                
                maleButtonOutlet.setImage(UIImage(named:"check_icon.png"), for: .normal)
                maleButtonOutlet.tintColor = #colorLiteral(red: 0.9568627451, green: 0.262745098, blue: 0.2117647059, alpha: 1)
                
                femaleButtonOutlet.setImage(UIImage(named:"uncheck_icon.png"), for: .normal)
                femaleButtonOutlet.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                gender = "M"
                
            }
            
//            else {
//
//                maleButtonOutlet.setImage(UIImage(named:"uncheck_icon.png"), for: .normal)
//                maleButtonOutlet.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//                gender = ""
//            }
            
        } else if sender.tag == 2{
            if (femaleButtonOutlet.currentImage?.isEqual(UIImage(named:"uncheck_icon.png")))! {
                
                femaleButtonOutlet.setImage(UIImage(named:"check_icon.png"), for: .normal)
                femaleButtonOutlet.tintColor = #colorLiteral(red: 0.9568627451, green: 0.262745098, blue: 0.2117647059, alpha: 1)
                
                maleButtonOutlet.setImage(UIImage(named:"uncheck_icon.png"), for: .normal)
                maleButtonOutlet.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                gender = "F"
                
            }
//            else {
//
//                femaleButtonOutlet.setImage(UIImage(named:"uncheck_icon.png"), for: .normal)
//                femaleButtonOutlet.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//                gender = ""
//
//            }
        }
    }
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 10 2017
    // Input Parameters :   N/A.
    // Purpose          :   Used for to open country picker.
    //>--------------------------------------------------------------------------------------------------
    @IBAction func countryButtonTapped(_ sender: UIButton) {
        countryTextfield.becomeFirstResponder()
    }

}



extension CustomerRegistrationFirstVC: GMSAutocompleteViewControllerDelegate {
    
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

extension CustomerRegistrationFirstVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        passwordHintViewOutlet.alpha = 0
    }
    
}

