//
//  CookRegistrationFirstVC.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 08/11/17.
//  Copyright © 2017 Cynoteck. All rights reserved.
//

import UIKit
import AVFoundation
import CountryPicker


class CookRegistrationFirstVC: UIViewController,UIImagePickerControllerDelegate,UIPopoverControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate, CountryPickerDelegate {
  

    
    @IBOutlet weak var emailTextfield: ImageTextfield!
    @IBOutlet weak var firstnameTextfield: ImageTextfield!
    @IBOutlet weak var lastnameTextfield: ImageTextfield!
    @IBOutlet weak var createPasswordTextfield: ImageTextfield!
    @IBOutlet weak var phoneNumberTextfield: ImageTextfield!
    @IBOutlet weak var introduceTextview: UITextviewX!
    @IBOutlet weak var profileImageview: UIImageViewX!
    @IBOutlet weak var maleButtonOutlet: RoundedButton!
    @IBOutlet weak var femaleButtonOutlet: RoundedButton!
    @IBOutlet weak var createPasswordUnderLine: UIView!
    @IBOutlet weak var passwordTextfieldStackview: UIStackView!
    @IBOutlet weak var passwordHintViewOutlet: UIViewX!
    @IBOutlet weak var countryCodeTextfield: ImageTextfield!
    @IBOutlet weak var mainScrollview: TPKeyboardAvoidingScrollView!
    
    var gender: String! = ""
    
    var imagePicker:UIImagePickerController?=UIImagePickerController()
    var cookRegisterationType: String!
    
    var countryPhoneCode: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainScrollview.delegate = self
        
        countryPhoneCode = "+1"
        
        //Set default gender
        maleButtonOutlet.setImage(UIImage(named:"check_icon.png"), for: .normal)
        maleButtonOutlet.tintColor = #colorLiteral(red: 0.9568627451, green: 0.262745098, blue: 0.2117647059, alpha: 1)
        
        femaleButtonOutlet.setImage(UIImage(named:"uncheck_icon.png"), for: .normal)
        femaleButtonOutlet.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        gender = "M"
        
        //maleButtonOutlet.layer.cornerRadius = maleButtonOutlet.bounds.size.height * 0.5
        //femaleButtonOutlet.layer.cornerRadius = femaleButtonOutlet.bounds.size.height * 0.5
        NotificationCenter.default.addObserver(self, selector: #selector(self.passwordHint(notification:)), name: Notification.Name("passwordValidation"), object: nil)
       
    }
    
    @objc func passwordHint(notification: Notification){
        self.passwordHintViewOutlet.alpha = 1
    }
    
    deinit {
        // perform the deinitialization
        NotificationCenter.default.removeObserver("passwordValidation")
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
       
       /*
         
         // Do any additional setup after loading the view.
         /*if Singleton.instance.userRegisterationSelectionType == "Facebook" {
         passwordTextfieldStackview.isHidden = true
         
         }*/
         
         if Singleton.instance.userRegisterationSelectionType == "Facebook" {
            emailTextfield.text = Singleton.instance.fbEmail
            firstnameTextfield.text = Singleton.instance.fbfirstName
            lastnameTextfield.text = Singleton.instance.fblastName
            profileImageview.sd_setImage(with: URL(string: Singleton.instance.fbImage), placeholderImage:UIImage(named: "profilePlaceholder"), options: .refreshCached)
        } */
        
        introduceTextview.layer.borderWidth = 1
        introduceTextview.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        profileImageview.clipsToBounds = true
        imagePicker?.delegate=self
        self.passwordHintViewOutlet.alpha = 0
        
        
        let locale = Locale.current
        let phoneCode = Singleton.instance.getCountryPhonceCode(locale.regionCode!)
        countryCodeTextfield.text = "+" + phoneCode
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        customCountryPicker()
    }
    
    
    
    override func viewDidDisappear(_ animated: Bool) {
        Singleton.instance.enterEmailAddress = emailTextfield.text
    }
    
    @IBAction func showPasswordHintTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5) {
            self.passwordHintViewOutlet.alpha = 1
        }
    }
    
    
    @IBAction func closePasswordHintButtonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5) {
            self.passwordHintViewOutlet.alpha = 0
        }
        
    }
    
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Oct, 31 2017
    // Input Parameters :   N/A
    // Purpose          :   Hide keyboard.
    //>--------------------------------------------------------------------------------------------------
    @IBAction func hidingKeyboardTapGesture(_ sender: Any) {
        self.view.endEditing(true)
        self.passwordHintViewOutlet.alpha = 0
    }
    
    
    
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Oct, 31 2017
    // Input Parameters :   N/A
    // Purpose          :   Helps in to select gallery or camera.
    //>--------------------------------------------------------------------------------------------------
    @IBAction func profileImageButton(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: nil, message: "Action", preferredStyle: .actionSheet)
        
        let gallery = UIAlertAction(title: "Gallery", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            //  Do some action here.
            self.openGallary()
        })
        
        let camera = UIAlertAction(title: "Camera", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            //  Do some destructive action here.
            self.checkCamera()
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
        
        
//        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
//            imagePicker!.allowsEditing = false
//            imagePicker!.sourceType = .camera
//            imagePicker!.cameraCaptureMode = .photo
//            present(imagePicker!, animated: true, completion: nil)
//        }else{
//            let alert = UIAlertController(title: "Camera Not Found", message: "This device has no Camera", preferredStyle: .alert)
//            let ok = UIAlertAction(title: "OK", style:.default, handler: nil)
//            alert.addAction(ok)
//            present(alert, animated: true, completion: nil)
//        }
        
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
            
//            if AVCaptureDevice.devices(for: AVMediaType.video).count > 0 {
//                AVCaptureDevice.requestAccess(for: AVMediaType.video) { granted in
//                    DispatchQueue.main.async() {
//                        self.checkCamera() } }
//            }
            }
        )
        present(alert, animated: true, completion: nil)
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
        
        countryCodeTextfield.inputAccessoryView = toolbar
        countryCodeTextfield.inputView = countryPicker
        countryPicker.countryPickerDelegate = self
        countryPicker.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        countryPicker.showPhoneNumbers = true
        
    }
    
    @objc func pickerDonePressed() {
        
        if countryPhoneCode == "" {
            countryCodeTextfield.text = "+1"
        } else {
            countryCodeTextfield.text = countryPhoneCode
        }
        self.view.endEditing(true)
    }
    
    @objc func pickerCancelPressed() {
        self.view.endEditing(true)
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
        profileImageview.contentMode = .scaleAspectFill
        profileImageview.image = chosenImage
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
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
    // Date             :   Nov, 10 2017
    // Input Parameters :   Textfield Delegate methods.
    // Purpose          :   Button works as a radio button for gender selection.
    //>--------------------------------------------------------------------------------------------------
    @IBAction func genderButtonTapped(_ sender: UIButton) {
        
        if sender.tag == 1 {
            
            if (maleButtonOutlet.currentImage?.isEqual(UIImage(named:"uncheck_icon.png")))! {

                maleButtonOutlet.setImage(UIImage(named:"check_icon.png"), for: .normal)
                maleButtonOutlet.tintColor = #colorLiteral(red: 0.9568627451, green: 0.262745098, blue: 0.2117647059, alpha: 1)
                //maleButtonOutlet.backgroundColor =  #colorLiteral(red: 0.9568627451, green: 0.262745098, blue: 0.2117647059, alpha: 1)

                femaleButtonOutlet.setImage(UIImage(named:"uncheck_icon.png"), for: .normal)
                femaleButtonOutlet.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                //femaleButtonOutlet.backgroundColor
                gender = "M"


            }
//            else {
//
//                maleButtonOutlet.setImage(UIImage(named:"uncheck_icon.png"), for: .normal)
//                maleButtonOutlet.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//                gender = ""
//
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
}

extension CookRegistrationFirstVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        passwordHintViewOutlet.alpha = 0
    }
    
}

