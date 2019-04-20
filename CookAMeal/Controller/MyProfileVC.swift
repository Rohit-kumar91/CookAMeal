
//
//  MyProfileVC.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 30/01/18.
//  Copyright © 2018 Cynoteck. All rights reserved.
//

import UIKit
import JGProgressHUD
import SwiftyJSON
import AVFoundation
import GooglePlaces
import CRNotifications
import FacebookLogin
import FBSDKLoginKit
import CountryPicker


class MyProfileVC: UIViewController,UIImagePickerControllerDelegate,UIPopoverControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate, CountryPickerDelegate {
    
    
    @IBOutlet weak var starRatingHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var addNewAllergiesButtonOutlet: UIButton!
    @IBOutlet weak var coverPhotoImageview: UIImageView!
    @IBOutlet weak var profilePhotoview: UIView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var editButtonOutlet: RoundedButton!
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var genderTextfield: UITextField!
    @IBOutlet weak var phoneNumberTextfield: UITextField!
    @IBOutlet weak var streetTextfield: UITextField!
    @IBOutlet weak var cityTextfield: UITextField!
    @IBOutlet weak var statetextfield: UITextField!
    @IBOutlet weak var zipcodeTextfield: UITextField!
    @IBOutlet weak var introductionTextview: UITextView!
    @IBOutlet weak var foodLicenseImageView: UIImageView!
    @IBOutlet weak var profileImageview: UIImageView!
    @IBOutlet weak var countryTextfield: UITextField!
    @IBOutlet weak var menuButtonOutlet: UIButton!
    
    @IBOutlet weak var varificationForSaftelyLabelOutlet: UILabel!
    @IBOutlet weak var underLineLabelOfVerificationForSafetlyLabelOutlet: UIView!
    @IBOutlet weak var cottageLicenseLabelOutlet: UILabel!
    @IBOutlet weak var belowSectionLabel: UILabel!
    @IBOutlet weak var uploadYourIDLabelOutlet: UILabel!
    @IBOutlet weak var uploadButtonOutlet: RoundedButton!
    @IBOutlet weak var signInLabelOutlet: UILabel!
    @IBOutlet weak var createaLinkLabelOutlet: UILabel!
    @IBOutlet weak var linkedinButtonOutlet: UIButton!
    
    
    //Introduction Constriant Outlet
    @IBOutlet weak var introductionLabelVerticalConstraint: NSLayoutConstraint!
    @IBOutlet weak var introductionLabelUnderLineHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var introductionTextviewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var introductionTextviewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var introductionTextviewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var introductionLabelOutlet: UILabel!
    
    //Allergies constraint Outlet
    
    @IBOutlet weak var alergiesUnderLineHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var allergiesLabelOutlet: UILabel!
    
    @IBOutlet weak var firstnameStackViewOutlet: UIStackView!
    @IBOutlet weak var lastnameStackViewOutlet: UIStackView!
    @IBOutlet weak var firstNameLabelOutlet: UITextField!
    @IBOutlet weak var lastNameLabelOutlet: UITextField!
    @IBOutlet weak var nameStackViewOutlet: UIStackView!
    @IBOutlet weak var changeAddressOutlet: UIButton!
    @IBOutlet weak var emailStackView: UIStackView!
    @IBOutlet weak var allergiesLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var allergiesLabelDetailOutlet: UILabel!
    @IBOutlet weak var allergyTableview: UITableView!
    
    
    //Diet Preference.
    @IBOutlet weak var dietPreferenceTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var dietPreferenceLabelOutlet: UILabel!
    @IBOutlet weak var underLineLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var underLineLabelHeightConstarint: NSLayoutConstraint!
    @IBOutlet weak var dietPreferencetextfieldTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var dietPreferenceTextfieldHeightConstriant: NSLayoutConstraint!
    @IBOutlet weak var drivingDistanceTextfield: UITextField!
    @IBOutlet weak var drivingDistancebuttonOutlet: UIButton!
   
    
    @IBOutlet weak var drivingDistanceLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var drivingDistanceLabelOutlet: UILabel!
    @IBOutlet weak var drivingDistanceUnderLineTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var drivingDistanceUnderlineHeigthConstraint: NSLayoutConstraint!
    @IBOutlet weak var drivingDistanceTextfieldHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var varificationLabelUnderlineTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var underLineVarifcationHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var foodLicenseTopLabelConstraint: NSLayoutConstraint!
    @IBOutlet weak var licenseOperateLabelOutlet: UILabel!
    @IBOutlet weak var licenseImageTopConstarint: NSLayoutConstraint!
    @IBOutlet weak var licenseImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var changeLicenseButtonOutlet: UIButton!
    @IBOutlet weak var dietPreferenceTextfieldOutlet: UITextField!
    @IBOutlet weak var dietPreferenceButtonOutlet: UIButton!
    
    
    @IBOutlet weak var fbConnectButtonOutlet: RoundedButton!
    @IBOutlet weak var facebookIconImage: UIImageViewX!
    @IBOutlet weak var linkedinIconImage: UIImageViewX!
    @IBOutlet weak var licenseImageBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var drivingTextfieldTextfieldTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var addnewHeightConstraint: NSLayoutConstraint!
    
    
    //Modelclass object.
    let myProfileObj: MyProfileModel = MyProfileModel()
    var editTypeForImage = String()
    var imagePicker:UIImagePickerController?=UIImagePickerController()
    let hud = JGProgressHUD(style: .light)
    let PickerView = UIPickerView()
    var pickerType = String()
    let toolbar = UIToolbar()
   
    var countryName:String = ""
    
    
    //GMSAutocompleteViewController
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
    var dict : [String : AnyObject]!
    
    
    
    func addToolbarInPicker() {
        //Toolbar for pickerview
        
        let cancelButton = UIBarButtonItem (barButtonSystemItem: .cancel, target: nil, action: #selector(pickerCancelPressed))
        let doneButton = UIBarButtonItem (barButtonSystemItem: .done, target: nil, action: #selector(pickerDonePressed))
        let flexButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([cancelButton,flexButton, doneButton], animated: true)
        
        doneButton.tintColor = #colorLiteral(red: 0.8862745098, green: 0.1725490196, blue: 0.168627451, alpha: 1)
        cancelButton.tintColor = #colorLiteral(red: 0.8862745098, green: 0.1725490196, blue: 0.168627451, alpha: 1)
        toolbar.sizeToFit()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        customCountryPicker()

    }
    
    func customCountryPicker() {
        
        let countryPicker = CountryPicker()
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //done button for toolbar
        let cancelButton = UIBarButtonItem (barButtonSystemItem: .cancel, target: nil, action: #selector(pickerCancelPressed))
        let doneButton = UIBarButtonItem (barButtonSystemItem: .done, target: nil, action: #selector(pickerCountryDonePressed))
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let locale = Locale.current
        if locale.currencyCode == "USD" {
            drivingDistanceLabelOutlet.text = "Driving Distance in " + "Miles :"
        } else {
            drivingDistanceLabelOutlet.text = "Driving Distance in " + "Kilometers :"
        }
        
        //CreatingPicker for selction of gender.
        addToolbarInPicker()
        genderTextfield.inputAccessoryView = toolbar
        genderTextfield.inputView = PickerView
        pickerType = "genderfield"
        PickerView.delegate = self
        
        //Cook == 1
        //Customer == 2
        if Helper.getUserDefaultValue(key: USER_ROLE_KEY)! ==  "1" {
            //Cook
            self.starRatingHeightConstraint.constant = 20
            self.ratingView.isHidden = false

            hideAllergies(flagConstant: 0)
            hideDietPreference(flagConstant: 0)
            addnewHeightConstraint.constant = 0
            
        } else if Helper.getUserDefaultValue(key: USER_ROLE_KEY)! ==  "2" {
            //Customer
            self.ratingView.isHidden = true
            self.starRatingHeightConstraint.constant = 0
            hideOnlyAllergiesTableview(flagConstant: 0)
            hideIntroductionSection(flagConstant: 0)
            hideDrivingDistance(flagConstant: 0)
            hideVarificationSaftely(flagConstant: 0)
            addNewAllergiesButtonOutlet.isHidden = true
            allergyTableview.delegate = self
            allergyTableview.dataSource = self
            
            
        }
        
        
        imagePicker?.delegate=self
        
        //Revealview Controller.
        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 80
        menuButtonOutlet.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        self.revealViewController().frontViewShadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3131710123)
        self.revealViewController().frontViewShadowRadius = 2
        self.revealViewController().frontViewShadowOffset = CGSize(width: 0.0, height: 1.5)
        self.revealViewController().frontViewShadowOpacity = 0.8
    }
    

    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hud.show(in: self.view)
        hud.textLabel.text = "Loading"
        dietPreferenceButtonOutlet.isUserInteractionEnabled = false
        dietPreferenceTextfieldOutlet.isUserInteractionEnabled = false
        self.revealViewController().delegate = self
       
        myProfileObj.getProfileData { (success) in
            if success {
                self.hud.dismiss()
                self.backgroundView.isHidden = false
                self.setValueInUIElements()
                self.allergyTableview.reloadData()
                
            } else {
                 self.hud.dismiss()
            }
        }
    }
    
    
    func countryPhoneCodePicker(_ picker: CountryPicker, didSelectCountryWithName name: String, countryCode: String, phoneCode: String, flag: UIImage) {
        
        countryName = name
    }
    
    
    
    @objc func pickerCountryDonePressed() {
        if countryName == "" {
            countryTextfield.text = "United States"
            
        } else {
            countryTextfield.text = countryName
        }
        self.view.endEditing(true)
    }
    
    
    @IBAction func dirivingDistanceButtonOutlet(_ sender: Any) {
        
        pickerType = "drivingDistance"
        addToolbarInPicker()
        drivingDistanceTextfield.inputAccessoryView = toolbar
        drivingDistanceTextfield.inputView = PickerView
        drivingDistanceTextfield.becomeFirstResponder()
        PickerView.delegate = self
        
    }
    
    
    @objc func pickerDonePressed() {
        
        
        if pickerType == "drivingDistance" {
             pickerType = ""
             drivingDistanceTextfield.text  = myProfileObj.drivingDistance
            self.view.endEditing(true)
        } else if pickerType ==  "dietPreference" {
             pickerType = ""
             dietPreferenceTextfieldOutlet.text  = myProfileObj.dietPreference
            self.view.endEditing(true)
        } else if pickerType ==  "genderfield" {
            if myProfileObj.flagGender == "M" {
                self.genderTextfield.text = "Male"
            } else if myProfileObj.flagGender == "F" {
                self.genderTextfield.text = "Female"
            }
            self.view.endEditing(true)
        }
        
        
        
    }
    
    
    @objc func pickerCancelPressed() {
        if pickerType == "drivingDistance" {
           pickerType = ""
        } else if pickerType ==  "dietPreference" {
            pickerType = ""
        } else if pickerType == "genderfield" {
            pickerType = ""
        }
        self.view.endEditing(true)
    }
    
    
    
   
    func setValueInUIElements() {
        
        self.coverPhotoImageview.contentMode = .scaleAspectFill
        self.coverPhotoImageview.sd_setImage(with: URL(string: self.myProfileObj.coverImageUrl), placeholderImage:UIImage(named: "recipePlaceholder"), options: .refreshCached)
        
        self.profileImageview.contentMode = .scaleAspectFill
        self.profileImageview.sd_setImage(with: URL(string: self.myProfileObj.profileImageUrl), placeholderImage:UIImage(named: "profilePlaceholder"), options: .refreshCached)
        
        print("License\(self.myProfileObj.certificate)")
        self.foodLicenseImageView.contentMode = .scaleAspectFit
        self.foodLicenseImageView.sd_setImage(with: URL(string: self.myProfileObj.certificate), placeholderImage:UIImage(named: "recipePlaceholder"), options: .refreshCached)
        
        self.profileNameLabel.text = self.myProfileObj.profileName
        
        self.nameTextfield.text =  self.myProfileObj.profileName
        
        self.emailTextfield.text = self.myProfileObj.email
        
        if self.myProfileObj.gender == "Male" {
            self.myProfileObj.flagGender = "M"
        } else if self.myProfileObj.gender == "Female" {
              self.myProfileObj.flagGender = "F"
        }
        
        self.genderTextfield.text = self.myProfileObj.gender
        
        self.phoneNumberTextfield.text = self.myProfileObj.contactNumber
        
        self.streetTextfield.text = self.myProfileObj.street
        
        self.cityTextfield.text = self.myProfileObj.city
        
        self.statetextfield.text = self.myProfileObj.state
        
        self.countryTextfield.text = self.myProfileObj.country
        
        self.zipcodeTextfield.text = self.myProfileObj.zipCode
        
        self.introductionTextview.text = self.myProfileObj.introduction
        
        self.firstNameLabelOutlet.text = self.myProfileObj.firstname
        
        self.lastNameLabelOutlet.text = self.myProfileObj.lastname
        
        self.drivingDistanceTextfield.text =  self.myProfileObj.drivingDistance
        
        self.allergiesLabelDetailOutlet.text =  self.myProfileObj.allergies
        
        self.dietPreferenceTextfieldOutlet.text = self.myProfileObj.dietPreference
        
        self.profilePhotoview.layer.cornerRadius =  self.profilePhotoview.frame.size.width / 2
        self.profileImageview.layer.cornerRadius =  self.profileImageview.frame.size.width / 2
        
        
        if  self.myProfileObj.facebookConnected {
            self.fbConnectButtonOutlet.setTitle("Connected",for: .normal)
        } else {
            self.fbConnectButtonOutlet.setTitle("Not Connected",for: .normal)
        }
        
        
        if self.myProfileObj.identificationCard[ID_KEY].stringValue != ""  {
            self.uploadButtonOutlet.setTitle("Uploaded",for: .normal)
        }
        
        
    }
    
    
    
    @IBAction func changeLicenseButtonTapped(_ sender: UIButton) {
        
        self.editTypeForImage = "License"
        self.editOptionInActionSheet(sender: sender)
        
    }
    
    
    
    
    
    @IBAction func fbButtonTapped(_ sender: RoundedButton) {
        
        if fbConnectButtonOutlet.titleLabel?.text == "Connected" {
            
        }else {
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
                    self.dict = result as! [String : AnyObject]
                    print(result!)
                    print(self.dict)
                    
                    if let fbID = self.dict[ID_KEY] {
                        //Singleton.instance.fbId = fbID as! String
                    }
                    
                    if let email = self.dict["email"] {
                       // Singleton.instance.fbEmail = email as! String
                    }
                    
                  
                }
            })
        }else{
            //Do Something here.
        }
    }
    
    
    
    
    
    @IBAction func uploadIDBUttonTapped(_ sender: RoundedButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "uploadCertificateID") as! UploadYourIdVC
        self.present(vc, animated: true, completion: nil)
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
    
    
    @IBAction func dietPreferenceTapped(_ sender: UIButton) {
        
        pickerType = "dietPreference"
        addToolbarInPicker()
        
        dietPreferenceTextfieldOutlet.inputAccessoryView = toolbar
        dietPreferenceTextfieldOutlet.inputView = PickerView
        dietPreferenceTextfieldOutlet.becomeFirstResponder()
        PickerView.delegate = self
    }
    
    
    @IBAction func editProfileButtonTapped(_ sender: RoundedButton) {
        
        if sender.titleLabel?.text == "Edit Profile" {
            
            let alertController = UIAlertController(title: nil, message: "Setting", preferredStyle: .actionSheet)
            
            let profileCover = UIAlertAction(title: "Edit Profile Cover", style: .default, handler: { (alert: UIAlertAction!) -> Void in
                //  Do some action here.
                self.editTypeForImage = "ProfileCover"
                self.editOptionInActionSheet(sender: sender)
                
            })
            
            let profileImage = UIAlertAction(title: "Edit Profile Image", style: .default, handler: { (alert: UIAlertAction!) -> Void in
                //  Do some destructive action here.
                self.editTypeForImage = "ProfileImage"
                self.editOptionInActionSheet(sender: sender)
                //self.addBorderUItextfield()

            })
            
            let editProfile = UIAlertAction(title: "Edit Profile", style: .default, handler: { (alert: UIAlertAction!) -> Void in
                
                //  Do some destructive action here.
                
                if Helper.getUserDefaultValue(key: USER_ROLE_KEY)! ==  "1" {
                    //Cook
                    self.emailStackView.isHidden = true
                    self.changeAddressOutlet.isHidden = false
                    self.firstNameLabelOutlet.becomeFirstResponder()
                    self.editButtonOutlet.setTitle("Update Profile", for: .normal)
                    //self.changeLabelColor(color: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1))
                    //self.changeButtonColor(color: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1))
                    self.nameStackViewOutlet.isHidden = true
                    self.firstnameStackViewOutlet.isHidden = false
                    self.lastnameStackViewOutlet.isHidden = false
                    self.userInteraction(value: true)
                    self.addBorderUItextfield()
                    
                } else if Helper.getUserDefaultValue(key: USER_ROLE_KEY)! ==  "2" {
                    //Customer
                    self.emailStackView.isHidden = true
                    self.changeAddressOutlet.isHidden = false
                    self.firstNameLabelOutlet.becomeFirstResponder()
                    self.editButtonOutlet.setTitle("Update Profile", for: .normal)
                    //self.changeLabelColor(color: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1))
                    //self.changeButtonColor(color: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1))
                    self.nameStackViewOutlet.isHidden = true
                    self.firstnameStackViewOutlet.isHidden = false
                    self.lastnameStackViewOutlet.isHidden = false
                    self.userInteraction(value: true)
                    self.addBorderUItextfield()
                    self.allergiesLabelDetailOutlet.text = ""
                    self.tableHeightConstraint.constant = 300
                    self.dietPreferenceTopConstraint.constant = 30
                    self.addNewAllergiesButtonOutlet.isHidden = false

                   
                    
                }
                
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (alert: UIAlertAction!) -> Void in
                //  Do something here upon cancellation.
            })
            
            if let popoverController = alertController.popoverPresentationController {
                popoverController.sourceView = sender
                popoverController.sourceRect = sender.bounds
            }
            
            alertController.addAction(profileCover)
            alertController.addAction(profileImage)
            alertController.addAction(editProfile)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)
            
            
        } else if sender.titleLabel?.text == "Update Profile"{
            
            setEditableValue ()
            
            if  Helper.getUserDefaultValue(key: USER_ROLE_KEY)! ==  "2" {
                //Customer
                if !myProfileObj.validatePhone()
                {
                    //showAlertWithMessage(alertMessage: myProfileObj.alertMessage)
                    self.present(Helper.globalAlertView(with: LOGIN_CONSTANT.ALERT_HEADER_MESSAGE_KEY, message: myProfileObj.alertMessage), animated: true, completion: nil)
                } else {
                     sendDataToServer()
                }
                
            } else {
                if !myProfileObj.validatePhone()
                {
                    //showAlertWithMessage(alertMessage: myProfileObj.alertMessage)
                    self.present(Helper.globalAlertView(with: LOGIN_CONSTANT.ALERT_HEADER_MESSAGE_KEY, message: myProfileObj.alertMessage), animated: true, completion: nil)
                    
                } else if !myProfileObj.validateIntroduction() {
                    
                    //showAlertWithMessage(alertMessage: myProfileObj.alertMessage)
                    self.present(Helper.globalAlertView(with: LOGIN_CONSTANT.ALERT_HEADER_MESSAGE_KEY, message: myProfileObj.alertMessage), animated: true, completion: nil)
                    
                } else {
                    
                    sendDataToServer()
                }
                
            }
        }
    }
    
    
    func sendDataToServer() {
        
        hud.show(in: self.view)
        hud.textLabel.text = "Loading"
        self.view.endEditing(true)
        
        
        myProfileObj.updateProfileData(userType: Helper.getUserDefaultValue(key: USER_ROLE_KEY)!) { (success) in
            if success {
                
                self.editButtonOutlet.setTitle("Edit Profile", for: .normal)
                self.setValueInUIElements()
                self.emailStackView.isHidden = false
                self.changeAddressOutlet.isHidden = true
                self.nameStackViewOutlet.isHidden = false
                self.firstnameStackViewOutlet.isHidden = true
                self.lastnameStackViewOutlet.isHidden = true
                self.removeBorderUITextfield()
                self.userInteraction(value: false)
                self.addNewAllergiesButtonOutlet.isHidden = true
                self.tableHeightConstraint.constant = 0
                
                self.myProfileObj.getProfileData { (success) in
                    self.hud.dismiss()
                    if success {
                        self.setValueInUIElements()
                        self.allergyTableview.reloadData()
                    } else {
                       print("Something happening wrong")
                    }
                }
                
            } else {
                //self.showAlertWithMessage(alertMessage: self.myProfileObj.alertMessage)
                self.present(Helper.globalAlertView(with: LOGIN_CONSTANT.ALERT_HEADER_MESSAGE_KEY, message: self.myProfileObj.alertMessage), animated: true, completion: nil)
                self.hud.dismiss()
            }
        }
    }
    
    
    
    func editOptionInActionSheet(sender: UIButton) {
        
        let alertController = UIAlertController(title: nil, message: "Setting", preferredStyle: .actionSheet)
        
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
    

    //MARK: Add new allergies
    @IBAction func addNewAllergiesTapped(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: "Add  Allergy", message: "", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: {
            alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            
            if (firstTextField.text?.isEmpty)! {
               print("Textfield is blank")
            } else{
                let tempDict = ["name":firstTextField.text!, "selectionType" : "check"]
                self.myProfileObj.finalAllergies.insert(tempDict, at: 0)
                self.allergyTableview.reloadData()
            }
        })
        
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Allergy Name"
        }
        
        
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        alertController.view.tintColor = UIColor(named: "Button_Red")
        
        
    }
    
    
    // MARK: Imagepicker Delegate method.
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        if editTypeForImage == "ProfileCover" {
            coverPhotoImageview.contentMode = .scaleAspectFill
            coverPhotoImageview.image = chosenImage
            self.changeCoverImage(image: chosenImage, url: PROFILE_COVER_URL_KEY, profileImageType: "profileCover")
        } else if editTypeForImage == "ProfileImage" {
            profileImageview.contentMode = .scaleAspectFill
            profileImageview.image = chosenImage
            self.changeCoverImage(image: chosenImage, url: PROFILE_IMAGE_URL_KEY, profileImageType: "profile")
        } else if editTypeForImage == "License"{
            
            foodLicenseImageView.contentMode = .scaleAspectFit
            foodLicenseImageView.image = chosenImage
            self.changeCoverImage(image: chosenImage, url: "cook/certificate", profileImageType: "certificate")
        }
        
        
        dismiss(animated: true, completion: nil)
    }
    
    
    
    func changeCoverImage(image: UIImage, url: String, profileImageType: String) {
        
        hud.show(in: self.view)
        hud.textLabel.text = "Loading"
        myProfileObj.editCoverProfilePicture(editCoverImage: image, url: url, profileImageType: profileImageType) { (success) in
            if success {
                self.hud.dismiss()
                
                CRNotifications.showNotification(type: CRNotifications.success, title: "Success" , message: self.myProfileObj.alertMessage, dismissDelay: 3)
            } else{
                self.hud.dismiss()
                //self.showAlertWithMessage(alertMessage: self.myProfileObj.alertMessage)
                self.present(Helper.globalAlertView(with: LOGIN_CONSTANT.ALERT_HEADER_MESSAGE_KEY, message: self.myProfileObj.alertMessage), animated: true, completion: nil)
            }
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
    
    
    
    @IBAction func allergiesCheckBoxButtonTapped(_ sender: RoundedButton) {
        
        if myProfileObj.finalAllergies[sender.tag]["selectionType"] == "uncheck" {
            //creating local dictionary
            let tempDict = ["name":myProfileObj.finalAllergies[sender.tag]["name"], "selectionType" : "check"]
            myProfileObj.finalAllergies[sender.tag] = tempDict as! [String : String]
        }
        else if myProfileObj.finalAllergies[sender.tag]["selectionType"] == "check" {
            let tempDict = ["name":myProfileObj.finalAllergies[sender.tag]["name"], "selectionType" : "uncheck"]
           myProfileObj.finalAllergies[sender.tag] = tempDict as! [String : String]
        }
        
        print(myProfileObj.tempAllergiesArray)
        allergyTableview.reloadData()
        
    }
   
}




extension MyProfileVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if  pickerType == "drivingDistance" {
            return myProfileObj.drivingDistanceArray.count
        } else if pickerType ==  "dietPreference" {
            return  customerRegistrationConstant.dietPreferenceArray.dietType.count
        } else if pickerType == "genderfield" {
            return myProfileObj.genderArray.count
        }
        
        
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
      
        if  pickerType ==  "drivingDistance" {
           return  String(self.myProfileObj.drivingDistanceArray[row])
        }else if pickerType ==  "dietPreference" {
            return  customerRegistrationConstant.dietPreferenceArray.dietType[row]
        }else if pickerType == "genderfield" {
            return myProfileObj.genderArray[row]
        }
        
        return ""
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if  pickerType ==  "drivingDistance" {
        
            self.myProfileObj.drivingDistance = String(self.myProfileObj.drivingDistanceArray[row])
            
        }else if pickerType ==  "dietPreference" {
            self.myProfileObj.dietPreference = customerRegistrationConstant.dietPreferenceArray.dietType[row]
        }
        
        else if pickerType == "genderfield" {
            if myProfileObj.genderArray[row] == "Male" {
                myProfileObj.flagGender = "M"
            }else  if myProfileObj.genderArray[row] == "Female"{
                myProfileObj.flagGender = "F"
            }
        }
    }
}




extension MyProfileVC: GMSAutocompleteViewControllerDelegate {
    
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
        
        self.streetTextfield.text = placeName + street_number + " " + route
        self.cityTextfield.text = locality
        self.statetextfield.text = administrative_area_level_1
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




extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}





extension MyProfileVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myProfileObj.finalAllergies.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AllergiesTableviewCellTableViewCell
        
        if myProfileObj.finalAllergies[indexPath.row]["selectionType"] == "uncheck" {
            cell.myProfileAllergiesCellLabelOutlet.text = myProfileObj.finalAllergies[indexPath.row]["name"]
            
            cell.myProfilecheckButtonOutlet.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cell.myProfilecheckButtonOutlet.tag = indexPath.row;
        }
        else if myProfileObj.finalAllergies[indexPath.row]["selectionType"]  == "check" {
            cell.myProfileAllergiesCellLabelOutlet.text = myProfileObj.finalAllergies[indexPath.row]["name"]
           
            cell.myProfilecheckButtonOutlet.tintColor = #colorLiteral(red: 0.9568627451, green: 0.262745098, blue: 0.2117647059, alpha: 1)
            cell.myProfilecheckButtonOutlet.tag = indexPath.row;
        }
        
        
        
        return cell
    }
    
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Oct, 16 2017
    // Input Parameters :   Textfield Delegate methods.
    // Purpose          :   Helps in to set the character length of textfield.
    //>--------------------------------------------------------------------------------------------------
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 10
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    
    
}


extension MyProfileVC {
    func hideDrivingDistance (flagConstant: CGFloat) {
        drivingDistanceLabelTopConstraint.constant = flagConstant
        drivingDistanceLabelOutlet.text = ""
        drivingDistanceUnderLineTopConstraint.constant = flagConstant
        drivingDistanceUnderlineHeigthConstraint.constant = flagConstant
        drivingDistanceTextfieldHeightConstraint.constant = flagConstant
        drivingTextfieldTextfieldTopConstraint.constant = flagConstant
        dietPreferenceTopConstraint.constant = flagConstant
    }
    
    
    func hideIntroductionSection(flagConstant: CGFloat) {
        introductionLabelOutlet.text = ""
        introductionLabelVerticalConstraint.constant = flagConstant
        introductionLabelUnderLineHeightConstraint.constant = flagConstant
        introductionTextviewTopConstraint.constant = flagConstant
        introductionTextviewBottomConstraint.constant = flagConstant
        introductionTextview.isHidden = true
    }
    
    
    func hideDietPreference (flagConstant: CGFloat) {
        dietPreferenceTopConstraint.constant = flagConstant
        dietPreferenceLabelOutlet.text = ""
        underLineLabelTopConstraint.constant = flagConstant
        underLineLabelHeightConstarint.constant = flagConstant
        
        dietPreferencetextfieldTopConstraint.constant = flagConstant
        dietPreferenceTextfieldHeightConstriant.constant = flagConstant
    }
    
    
    
    func hideAllergies(flagConstant: CGFloat){
        allergiesLabelOutlet.text = ""
        allergiesLabelDetailOutlet.text = ""
        allergiesLabelTopConstraint.constant = flagConstant
        alergiesUnderLineHeightConstraint.constant = flagConstant
        tableHeightConstraint.constant = flagConstant
        introductionTextviewBottomConstraint.constant = flagConstant
        
    }
    
    func hideOnlyAllergiesTableview(flagConstant: CGFloat){
        tableHeightConstraint.constant = flagConstant
    }
    
    
    func hideVarificationSaftely(flagConstant: CGFloat) {
        varificationForSaftelyLabelOutlet.text = ""
        varificationLabelUnderlineTopConstraint.constant = flagConstant
        underLineVarifcationHeightConstraint.constant = flagConstant
        foodLicenseTopLabelConstraint.constant = flagConstant
        licenseOperateLabelOutlet.text = ""
        licenseImageTopConstarint.constant = flagConstant
        licenseImageHeightConstraint.constant = flagConstant
        changeLicenseButtonOutlet.isHidden = true
        licenseImageBottomConstraint.constant = flagConstant
        
    }
    
    
    func changeLabelColor(color: UIColor) {
        varificationForSaftelyLabelOutlet.textColor = color
        underLineLabelOfVerificationForSafetlyLabelOutlet.backgroundColor = color
        cottageLicenseLabelOutlet.textColor = color
        belowSectionLabel.textColor = color
        uploadYourIDLabelOutlet.textColor = color
        signInLabelOutlet.textColor = color
        createaLinkLabelOutlet.textColor = color
        
    }
    
    func changeButtonColor(color: UIColor) {
       // uploadButtonOutlet.titleLabel?.textColor = color
        //facebookConnectButtonOutlet.titleLabel?.textColor = color
        //linkedinButtonOutlet.titleLabel?.textColor = color
    }
    
    func setEditableValue () {
        
        self.myProfileObj.firstname = firstNameLabelOutlet.text!
        
        self.myProfileObj.lastname = lastNameLabelOutlet.text!
        
        self.myProfileObj.contactNumber =  self.phoneNumberTextfield.text!
        
        self.myProfileObj.street =  self.streetTextfield.text!
        
        self.myProfileObj.city =  self.cityTextfield.text!
        
        self.myProfileObj.state = self.statetextfield.text!
        
        self.myProfileObj.country = self.countryTextfield.text!
        
        self.myProfileObj.introduction = self.introductionTextview.text!
        
        self.myProfileObj.zipCode =  self.zipcodeTextfield.text!
        
    }
    
    
    func userInteraction (value: Bool) {
        genderTextfield.isUserInteractionEnabled = value
        firstNameLabelOutlet.isUserInteractionEnabled = value
        lastNameLabelOutlet.isUserInteractionEnabled = value
        phoneNumberTextfield.isUserInteractionEnabled = value
        streetTextfield.isUserInteractionEnabled = value
        cityTextfield.isUserInteractionEnabled = value
        statetextfield.isUserInteractionEnabled = value
        zipcodeTextfield.isUserInteractionEnabled = value
        countryTextfield.isUserInteractionEnabled = value
        drivingDistanceTextfield.isUserInteractionEnabled = value
        drivingDistancebuttonOutlet.isUserInteractionEnabled = value
        introductionTextview.isUserInteractionEnabled = value
        dietPreferenceButtonOutlet.isUserInteractionEnabled = value
        dietPreferenceTextfieldOutlet.isUserInteractionEnabled = value
    }
    
    
    func removeBorderUITextfield() {
        
        firstNameLabelOutlet.layer.borderWidth = 0
        lastNameLabelOutlet.layer.borderWidth = 0
        genderTextfield.layer.borderWidth = 0
        phoneNumberTextfield.layer.borderWidth = 0
        streetTextfield.layer.borderWidth = 0
        cityTextfield.layer.borderWidth = 0
        statetextfield.layer.borderWidth = 0
        zipcodeTextfield.layer.borderWidth = 0
        countryTextfield.layer.borderWidth = 0
        introductionTextview.layer.borderWidth = 0
        drivingDistanceTextfield.layer.borderWidth = 0
        dietPreferenceTextfieldOutlet.layer.borderWidth = 0
    }
    
    
    func addBorderUItextfield() {
        
        firstNameLabelOutlet.layer.borderWidth = 1
        firstNameLabelOutlet.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        firstNameLabelOutlet.setLeftPaddingPoints(10)
        
        lastNameLabelOutlet.layer.borderWidth = 1
        lastNameLabelOutlet.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        lastNameLabelOutlet.setLeftPaddingPoints(10)
        
        genderTextfield.layer.borderWidth = 1
        genderTextfield.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        genderTextfield.setLeftPaddingPoints(10)
        
        phoneNumberTextfield.layer.borderWidth = 1
        phoneNumberTextfield.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        phoneNumberTextfield.setLeftPaddingPoints(10)
        
        streetTextfield.layer.borderWidth = 1
        streetTextfield.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        streetTextfield.setLeftPaddingPoints(10)
        
        cityTextfield.layer.borderWidth = 1
        cityTextfield.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        cityTextfield.setLeftPaddingPoints(10)
        
        statetextfield.layer.borderWidth = 1
        statetextfield.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        statetextfield.setLeftPaddingPoints(10)
        
        zipcodeTextfield.layer.borderWidth = 1
        zipcodeTextfield.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        zipcodeTextfield.setLeftPaddingPoints(10)
        
        countryTextfield.layer.borderWidth = 1
        countryTextfield.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        countryTextfield.setLeftPaddingPoints(10)
        
        introductionTextview.layer.borderWidth = 1
        introductionTextview.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        drivingDistanceTextfield.layer.borderWidth = 1
        drivingDistanceTextfield.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        drivingDistanceTextfield.setLeftPaddingPoints(10)
        
        dietPreferenceTextfieldOutlet.layer.borderWidth = 1
        dietPreferenceTextfieldOutlet.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        dietPreferenceTextfieldOutlet.setLeftPaddingPoints(10)
        
        nameTextfield.setLeftPaddingPoints(10)
        emailTextfield.setLeftPaddingPoints(10)
    }
}

extension MyProfileVC: SWRevealViewControllerDelegate {
    
    func revealController(_ revealController: SWRevealViewController!, willMoveTo position: FrontViewPosition) {
        if(position == FrontViewPosition.left) {
            self.backgroundView.isUserInteractionEnabled = true;
        } else {
            self.backgroundView.isUserInteractionEnabled = false;
            
        }
    }
    
    
    func revealController(_ revealController: SWRevealViewController!, didMoveTo position: FrontViewPosition) {
        if(position == FrontViewPosition.left) {
            self.backgroundView.isUserInteractionEnabled = true;
        } else {
            self.backgroundView.isUserInteractionEnabled = false;
            
        }
    }
}

