//  CookRegistrationSecondVC.swift
//  Created by cynoteck Mac Mini on 09/11/17.
//  Copyright © 2017 Cynoteck. All rights reserved.

import UIKit
import CountryPicker
import AAPickerView
import FacebookLogin
import FBSDKLoginKit
import JGProgressHUD
import CoreLocation
import GooglePlaces
import SwiftyJSON

class CookRegistrationSecondVC: UIViewController,UIImagePickerControllerDelegate,UIPopoverControllerDelegate,UINavigationControllerDelegate,CountryPickerDelegate, UITextFieldDelegate, CLLocationManagerDelegate {
    
    
    //Outlets
    @IBOutlet weak var licenseImageview: UIImageViewX!
    @IBOutlet weak var streetAddressTextfield: UITextField!
    @IBOutlet weak var cityTextfield: UITextField!
    @IBOutlet weak var stateTextfield: UITextField!
    @IBOutlet weak var zipcodeTextfield: UITextField!
    @IBOutlet weak var countryTextfield: UITextField!
    @IBOutlet weak var drivingDistanceTextfield: AAPickerView!
    @IBOutlet weak var facbookConnectOutlet: UIButton!
    @IBOutlet weak var linkdinConnectOutlet: UIButton!
    @IBOutlet weak var uploadOfficialIdOutlet: UIButton!
    @IBOutlet weak var acceptingTermsOutlet: RoundedButton!
    @IBOutlet weak var changeAddressButtonOutlet: UIButton!
    @IBOutlet weak var drivingDistanceLabelOutlet: UILabelX!
    
    
    var dict : [String : AnyObject]!
    var imagePicker:UIImagePickerController?=UIImagePickerController()
    let countryPicker = CountryPicker()
    var registrationObj: CookRegisterationModel = CookRegisterationModel()
    var countryName:String = ""
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    let userVerificationObj: UserVerificationModel = UserVerificationModel()
    let PickerView = UIPickerView()
    
    var street_number: String = ""
    var route: String = ""
    var neighborhood: String = ""
    var locality: String = ""
    var administrative_area_level_1: String = ""
    var country: String = ""
    var postal_code: String = ""
    var postal_code_suffix: String = ""
    var City: String = ""
    var placeName: String = ""
    var pickerType = Bool()
    var drivingDistance: String = "3"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        licenseImageview.clipsToBounds = true
        imagePicker?.delegate=self
        customCountryPicker()
        drivingDistancePicker()
        
        
        //Lcation Manager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.stopMonitoringSignificantLocationChanges()
        locationAuthStatus()
        PickerView.delegate = self
        
        
        
        //set label text.
        let locale = Locale.current
        if locale.currencyCode == "USD" {
            drivingDistanceLabelOutlet.text = "Select Distance in" + " Miles"
        } else {
            drivingDistanceLabelOutlet.text = "Select Distance in" + " Kilometers"
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
    
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 01 2017
    // Input Parameters :   N/A.
    // Purpose          :   Getting current address.
    //>--------------------------------------------------------------------------------------------------
    func locationAuthStatus() {
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways{
            
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
                
                
            })
            
        } else {
            self.showAlertWithMessage(alertMessage: "Location Not Allowed.")
        }
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if Singleton.instance.issuingCountry != "" && Singleton.instance.identificationType != "" && Singleton.instance.choosenTypeId != "" && Singleton.instance.identificationPhoto != nil {
            uploadOfficialIdOutlet.setTitle("Uploaded", for: .normal)
        }
    }
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 01 2017
    // Input Parameters :   N/A.
    // Purpose          :   For Driving distance picker.
    //>--------------------------------------------------------------------------------------------------
    func drivingDistancePicker() {
        
        /*
        
        drivingDistanceTextfield.stringPickerData = cookRegistrationConstant.drivingDistance
        drivingDistanceTextfield.pickerType = .StringPicker
        drivingDistanceTextfield.toolbar.tintColor = #colorLiteral(red: 0.9568627451, green: 0.262745098, blue: 0.2117647059, alpha: 1)
        drivingDistanceTextfield.stringDidChange = { index in
            print("selectedString ", cookRegistrationConstant.drivingDistance[index])
        }
        */
        
        let toolbar = UIToolbar()
        let cancelButton = UIBarButtonItem (barButtonSystemItem: .cancel, target: nil, action: #selector(pickerCancelPressed))
        let doneButton = UIBarButtonItem (barButtonSystemItem: .done, target: nil, action: #selector(pickerDonePressed))
        let flexButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([cancelButton,flexButton, doneButton], animated: true)
        
        doneButton.tintColor = #colorLiteral(red: 0.8862745098, green: 0.1725490196, blue: 0.168627451, alpha: 1)
        cancelButton.tintColor = #colorLiteral(red: 0.8862745098, green: 0.1725490196, blue: 0.168627451, alpha: 1)
        toolbar.sizeToFit()
        
        drivingDistanceTextfield.inputAccessoryView = toolbar
        drivingDistanceTextfield.inputView = PickerView
       
        

        
    }
    
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 01 2017
    // Input Parameters :   N/A.
    // Purpose          :   For select the country from picker.
    //>--------------------------------------------------------------------------------------------------
    
    func customCountryPicker() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        
        //done button for toolbar
        let cancelButton = UIBarButtonItem (barButtonSystemItem: .cancel, target: nil, action: #selector(pickerCancelPressed))
        let doneButton = UIBarButtonItem (barButtonSystemItem: .done, target: nil, action: #selector(pickerDonePressed))
        let flexButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([cancelButton,flexButton, doneButton], animated: true)
        doneButton.tintColor = #colorLiteral(red: 0.8862745098, green: 0.1725490196, blue: 0.168627451, alpha: 1)
        cancelButton.tintColor = #colorLiteral(red: 0.8862745098, green: 0.1725490196, blue: 0.168627451, alpha: 1)
        
        countryTextfield.inputAccessoryView = toolbar
        countryTextfield.inputView = countryPicker
        countryPicker.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        countryPicker.countryPickerDelegate = self
        countryPicker.showPhoneNumbers = true
        
        
    }
    
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 01 2017
    // Input Parameters :   N/A.
    // Purpose          :   Picker toobar done action for dismiss picker.
    //>--------------------------------------------------------------------------------------------------
    @objc func pickerCancelPressed() {
        self.view.endEditing(true)
    }
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 01 2017
    // Input Parameters :   N/A.
    // Purpose          :   Picker toobar done action for dismiss picker.
    //>--------------------------------------------------------------------------------------------------
    @objc func pickerDonePressed() {
        
        if pickerType {
            pickerType = false
            if countryName == "" {
                countryTextfield.text = "United States"
                
            } else {
                countryTextfield.text = countryName
            }
        } else {
            let locale = Locale.current
            if locale.currencyCode == "USD" {
                drivingDistanceTextfield.text = drivingDistance
            } else {
                drivingDistanceTextfield.text = drivingDistance 
            }
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
        
        countryName = name
    }
    
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Oct, 16 2017
    // Input Parameters :   Textfield Delegate methods.
    // Purpose          :   Helps in to set the character length of textfield.
    //>--------------------------------------------------------------------------------------------------
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 6
        let currentString: NSString = textField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 01 2017
    // Input Parameters :   N/A.
    // Purpose          :   Helps in selection of license image from gallery and camera.
    //>--------------------------------------------------------------------------------------------------
    @IBAction func foodLicenseUploadImageButtonTapped(_ sender: UIButton) {
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
    // Date             :   Oct, 31 2017
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
    // Date             :   Nov, 8 2017
    // Input Parameters :   N/A.
    // Purpose          :   open camera.
    //>--------------------------------------------------------------------------------------------------
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            imagePicker!.allowsEditing = false
            imagePicker!.sourceType = .camera
            imagePicker!.cameraCaptureMode = .photo
            present(imagePicker!, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: "Camera Not Found", message: "This device has no Camera", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style:.default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }
    }
    
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 8 2017
    // Input Parameters :   ImagePicker Delegate methods.
    // Purpose          :   Helps in Dismiss and the selection of the image from gallery.
    //>--------------------------------------------------------------------------------------------------
    // MARK: Imagepicker Delegate method.
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        licenseImageview.contentMode = .scaleAspectFill
        licenseImageview.image = chosenImage
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Oct, 16 2017
    // Input Parameters :   N/A.
    // Purpose          :   To connect with Facebook SDk.
    //>--------------------------------------------------------------------------------------------------
    @IBAction func facebookConnectionButton(_ sender: UIButton) {
        
        FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile"], from: self) { (result, err) in
            if (result?.isCancelled)! {
                
                print("cancceleeddddddd")
                
            }else{
                
                if err != nil {
                    
                    print("Custom FB Login Failed", err!)
                    return
                }else {
                    self.getFBUserData()
                }
            }
        }
    }
    
    
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Oct, 16 2017
    // Input Parameters :   Facebook Delegate methods.
    // Purpose          :   Function is fetching the user data through Facebook.
    //>--------------------------------------------------------------------------------------------------
    // MARK: Function to get the facebook user data.
    func getFBUserData(){
        
        NotificationCenter.default.post(name: Notification.Name("NotificationShowHudForCook"), object: nil)

        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, picture.type(large), email, first_name, last_name, gender,verified"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    self.dict = result as? [String : AnyObject]
                    print(result!)
                    print(self.dict)
                    
                    if let fbID = self.dict[ID_KEY] {
                        Singleton.instance.fbId = fbID as? String
                    }
                    
                    if let email = self.dict["email"] {
                        Singleton.instance.fbEmail = email as? String
                    }

                    
                    print("Connected To Facebook")
                    NotificationCenter.default.post(name: Notification.Name("NotificationHideHudForCook"), object: nil)
                    
                    print(Singleton.instance.fbId)
                    print(Singleton.instance.fbEmail)
                    
                    var email = String()
                    
                    if Singleton.instance.fbEmail == nil {
                        email = ""
                    } else {
                        email = Singleton.instance.fbEmail
                    }
                    
                    
                    self.userVerificationObj.verifyFacebookUser(facbookID: Singleton.instance.fbId, facebookEmailId:  email, completion: { (fbUserExist, success) in
                        if success {
                            
                            if fbUserExist{
                                Singleton.instance.fbId = ""
                                self.facbookConnectOutlet.setTitle("Connect", for: .normal)
                                self.showAlertWithMessage(alertMessage: self.userVerificationObj.alertMessage)
                            } else {
                                self.facbookConnectOutlet.setTitle("Connected", for: .normal)
                            }
                        } else {
                            self.showAlertWithMessage(alertMessage: self.userVerificationObj.alertMessage)
                        }
                    })
                }
            })
        }else{
            NotificationCenter.default.post(name: Notification.Name("NotificationHideHudForCook"), object: nil)
        }
    }
    
    
    
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 23 2017
    // Input Parameters :   Message String.
    // Purpose          :   Show alert when error occur.
    //>--------------------------------------------------------------------------------------------------
    func showAlertWithMessage(alertMessage:String )
    {
        let alertController = UIAlertController(title:ALERT_TITLE.APP_NAME, message:alertMessage, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action:UIAlertAction!) in
            
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    @IBAction func linkedinButtonTapped(_ sender: UIButton) {
    }
    
    
    
    @IBAction func countryButtonTapped(_ sender: Any) {
        
        pickerType = true
        countryTextfield.becomeFirstResponder()
    }
    
    
    @IBAction func uploadIdButtonTapped(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "uploadCertificateID") as! UploadYourIdVC
        vc.flagCheck = true
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func drivingDistanceButtonTapped(_ sender: UIButton) {
        drivingDistanceTextfield.becomeFirstResponder()
    }
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 23 2017
    // Input Parameters :   N/A.
    // Purpose          :   Accepting Terms.
    //>--------------------------------------------------------------------------------------------------
    @IBAction func acceptingTermsButtonTapped(_ sender: RoundedButton) {
        if (acceptingTermsOutlet.currentImage?.isEqual(UIImage(named:"uncheck_icon.png")))! {
            acceptingTermsOutlet.setImage(UIImage(named:"check_icon.png"), for: .normal)
            acceptingTermsOutlet.tintColor = #colorLiteral(red: 0.9568627451, green: 0.262745098, blue: 0.2117647059, alpha: 1)
            Singleton.instance.acceptingTermValidate = true
            
        } else if (acceptingTermsOutlet.currentImage?.isEqual(UIImage(named:"check_icon.png")))!{
            
            acceptingTermsOutlet.setImage(UIImage(named:"uncheck_icon.png"), for: .normal)
            acceptingTermsOutlet.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            Singleton.instance.acceptingTermValidate = false
        }
    }
}

    
    
    
extension CookRegistrationSecondVC: UIPickerViewDelegate, UIPickerViewDataSource {
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return cookRegistrationConstant.drivingDistance.count
        }
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return cookRegistrationConstant.drivingDistance[row]
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            drivingDistance =  cookRegistrationConstant.drivingDistance[row]
        }
}
    
    
extension CookRegistrationSecondVC: GMSAutocompleteViewControllerDelegate {
        
        // Handle the user's selection.
        func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
            // Print place info to the console.
            print("Place name: \(place.name)")
            print("Place address: \(String(describing: place.formattedAddress))")
            print("Place attributions: \(String(describing: place.attributions))")
            
            currentLocationLatitude = place.coordinate.latitude
            currentLocationLongitute = place.coordinate.longitude
            
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
    
    

    
    
    
