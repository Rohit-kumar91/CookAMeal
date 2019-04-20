//
//  UploadYourIdVC.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 22/11/17.
//  Copyright © 2017 Cynoteck. All rights reserved.
//

import UIKit
import CountryPicker
import AAPickerView
import CRNotifications
import JGProgressHUD


class UploadYourIdVC: UIViewController,UIImagePickerControllerDelegate,UIPopoverControllerDelegate,UINavigationControllerDelegate, CountryPickerDelegate {
    
    
    @IBOutlet weak var idTypeStack: UIStackView!
    
    @IBOutlet weak var issuingCountryTextfield: UITextField!
    @IBOutlet weak var typeOfIdentificationTextfield: UITextField!
    @IBOutlet weak var reflectIdTextfield: UITextField!
    @IBOutlet weak var idImageview: UIImageView!
    @IBOutlet weak var textReflectLabelOutlet: UILabel!
    @IBOutlet weak var idTypePicker: AAPickerView!
    
    @IBOutlet weak var doneButtonOutlet: RoundedButton!
    @IBOutlet weak var textReflectConstraint: NSLayoutConstraint!
    @IBOutlet weak var seperatorView: UIView!
    var flagCheck = Bool()
   

    
    var imagePicker:UIImagePickerController?=UIImagePickerController()
    var registrationObj: CustomerRegistrationModel = CustomerRegistrationModel()
    let countryPicker = CountryPicker()
    let uploadYourIdModelObj : UploadyourIdModel = UploadyourIdModel()
    var countryName: String = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // If the singleton class has value.
        Singleton.instance.identificationPhoto = UIImage(named: "liciense_icon")

        // Do any additional setup after loading the view.
         idImageview.clipsToBounds = true
         imagePicker?.delegate=self
         customCountryPicker()
         iDtypePreference()
         textReflectLabelOutlet.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        print(Singleton.instance.issuingCountry)
        
        if Singleton.instance.issuingCountry != ""  {
            self.textReflectLabelOutlet.isHidden = false
            
            if Singleton.instance.identificationType != nil {
                self.textReflectLabelOutlet.text = Singleton.instance.identificationType + " " + "Number"
            }
            
            
            self.idTypeStack.isHidden = false
            self.seperatorView.isHidden = false
            self.textReflectConstraint.constant = 42
            
            issuingCountryTextfield.text =  Singleton.instance.issuingCountry
            idTypePicker.text = Singleton.instance.identificationType
            reflectIdTextfield.text =  Singleton.instance.choosenTypeId
            print(Singleton.instance.identificationImageUrl)
            
            if flagCheck {
                flagCheck = false
                idImageview.contentMode = .scaleAspectFit
                //Nothing to do.
                idImageview.image = Singleton.instance.identificationPhoto
            } else {
                doneButtonOutlet.tag = 1
                idImageview.contentMode = .scaleAspectFill
                idImageview.sd_setImage(with: URL(string: Singleton.instance.identificationImageUrl), placeholderImage:UIImage(named: "recipePlaceholder"), options: .refreshCached)
            }
        }
    }

    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Oct, 31 2017
    // Input Parameters :   N/A
    // Purpose          :   Create string selection picker.
    //>--------------------------------------------------------------------------------------------------
    func iDtypePreference() {
        
            idTypePicker.pickerType = .string(data: ID_TYPE_ARRAY)
            idTypePicker.toolbar.tintColor = #colorLiteral(red: 0.9568627451, green: 0.262745098, blue: 0.2117647059, alpha: 1)
            idTypePicker.valueDidSelected = { index in

                print("selectedString ", ID_TYPE_ARRAY[index as! Int])
                Singleton.instance.identificationType = ID_TYPE_ARRAY[index as! Int]
                self.reflectIdTextfield.text = ""
                self.textReflectLabelOutlet.isHidden = false
                self.textReflectLabelOutlet.text = ID_TYPE_ARRAY[index as! Int] + " " + "No."
                self.idTypeStack.isHidden = false
                self.seperatorView.isHidden = false
                self.textReflectConstraint.constant = 42
        }
        
//        idTypePicker.stringPickerData = ID_TYPE_ARRAY
//        idTypePicker.pickerType = .StringPicker
//        idTypePicker.toolbar.tintColor = #colorLiteral(red: 0.9568627451, green: 0.262745098, blue: 0.2117647059, alpha: 1)
//        idTypePicker.stringDidChange = { index in
//
//            print("selectedString ", ID_TYPE_ARRAY[index])
//            Singleton.instance.identificationType = ID_TYPE_ARRAY[index]
//            self.reflectIdTextfield.text = ""
//            self.textReflectLabelOutlet.isHidden = false
//            self.textReflectLabelOutlet.text = ID_TYPE_ARRAY[index] + " " + "No."
//            self.idTypeStack.isHidden = false
//            self.seperatorView.isHidden = false
//            self.textReflectConstraint.constant = 42
//        }
        
        
    }
    
    
    
    //>--------------------------------------------------------------------------------------------------
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
        
        issuingCountryTextfield.inputAccessoryView = toolbar
        issuingCountryTextfield.inputView = countryPicker
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
        self.view.endEditing(true)
    }
    
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 01 2017
    // Input Parameters :   N/A.
    // Purpose          :   Picker toobar done action for dismiss picker.
    //>--------------------------------------------------------------------------------------------------
    @objc func pickerDonePressed() {
        
        if countryName == "" {
            Singleton.instance.issuingCountry = "United States"
            issuingCountryTextfield.text = "United States"
        } else {
            issuingCountryTextfield.text = countryName
            Singleton.instance.issuingCountry = countryName
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
    // Date             :   Nov, 01 2017
    // Input Parameters :   N/A.
    // Purpose          :   Close view controller.
    //>--------------------------------------------------------------------------------------------------
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        
        Singleton.instance.issuingCountry = nil
        Singleton.instance.identificationType = nil
        Singleton.instance.choosenTypeId =  nil
        Singleton.instance.identificationPhoto = nil
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 01 2017
    // Input Parameters :   N/A.
    // Purpose          :   Select photo from gallery or use camera .
    //>--------------------------------------------------------------------------------------------------
    @IBAction func choosePhotoButtonTapped(_ sender: UIButton) {
        flagCheck = true
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
        print(chosenImage)
        idImageview.contentMode = .scaleAspectFill
        //idImageview.image = UIImage(named: "profilePlaceholder")
        Singleton.instance.identificationPhoto = chosenImage
        dismiss(animated: true, completion: nil)
    }
    
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 22 2017
    // Input Parameters :   N/A.
    // Purpose          :   Upload Id certificates.
    //>--------------------------------------------------------------------------------------------------
    
    @IBAction func uploadCertificateTapped(_ sender: UIButton) {
        
        if issuingCountryTextfield.text == "" {
            
            showAlertWithMessage(alertMessage: "Country is missing.")
            
        } else  if idTypePicker.text == "" {
            
            showAlertWithMessage(alertMessage: "Identification type is missing.")
            
        } else if reflectIdTextfield.text == "" {
            
            showAlertWithMessage(alertMessage: "Enter ID Number.")
            
        } else if idImageview.image == UIImage(named: "liciense_icon"){
            
            showAlertWithMessage(alertMessage: "ID image is missing.")
            
        }else {
            
            if doneButtonOutlet.tag == 1 {
                Singleton.instance.issuingCountry = issuingCountryTextfield.text
                Singleton.instance.identificationType = idTypePicker.text
                Singleton.instance.choosenTypeId =  reflectIdTextfield.text
                Singleton.instance.identificationPhoto = idImageview.image
                
                let hud = JGProgressHUD(style: .light)
                hud.show(in: self.view)
                hud.textLabel.text = "Loading"
                
                
                uploadYourIdModelObj.uploadUserIdentificationCard(completion: { (success) in
                    hud.dismiss()
                    if success {
                        CRNotifications.showNotification(type: CRNotifications.success, title: "Success!", message: self.uploadYourIdModelObj.alertMessage, dismissDelay: 3)
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        //self.showAlertWithMessage(alertMessage: self.uploadYourIdModelObj.alertMessage)
                        self.present(Helper.globalAlertView(with: LOGIN_CONSTANT.ALERT_HEADER_MESSAGE_KEY, message: self.uploadYourIdModelObj.alertMessage), animated: true, completion: nil)
                    }
                })
                
                
            } else {
                Singleton.instance.issuingCountry = issuingCountryTextfield.text
                Singleton.instance.identificationType = idTypePicker.text
                Singleton.instance.choosenTypeId =  reflectIdTextfield.text
                Singleton.instance.identificationPhoto = idImageview.image
                dismiss(animated: true, completion: nil)
            }
            
           
            
        }
    }
    
    
    @IBAction func issuingCountryButtonTapped(_ sender: UIButton) {
        
        issuingCountryTextfield.becomeFirstResponder()
    }
    
    
    @IBAction func typeOfIdentificationTapped(_ sender: Any) {
        idTypePicker.becomeFirstResponder()
    }
    
    
    
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 22 2017
    // Input Parameters :   N/A.
    // Purpose          :   Alert Message.
    //>--------------------------------------------------------------------------------------------------
    func showAlertWithMessage(alertMessage:String )
    {
        let alertController = UIAlertController(title:ALERT_TITLE.APP_NAME, message:alertMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action:UIAlertAction!) in
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
}

extension UploadYourIdVC: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
       Singleton.instance.choosenTypeId = reflectIdTextfield.text
    }
    
    
}
