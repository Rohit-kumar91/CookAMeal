//
//  FilterAndSortingDataVC.swift
//  CookAMeal
//
//  Created by Cynoteck on 03/07/18.
//  Copyright © 2018 Cynoteck. All rights reserved.
//

import UIKit
import SwiftyJSON
import JGProgressHUD

class FilterAndSortingDataVC: UIViewController {
    
    
    @IBOutlet weak var filterAndSortingollectionView: UICollectionView!
    @IBOutlet weak var tempTextField: UITextField!
    @IBOutlet weak var errorMessage: UILabel!
    
    var categoryId = String()
    var collectionViewData = [JSON]()
    var Id = String()
    var sortingArray = [["key":"Price","value":"price"], ["key":"Order By Date","value":"date"], ["key":"Rating","value":"rating"], ["key":"Distance","value":"distance"]]
    let PickerView = UIPickerView()
    let toolbar = UIToolbar()
    var cancelButton = UIBarButtonItem()
    var doneButton = UIBarButtonItem()
    var flexButton = UIBarButtonItem()
    var pickerSelectedValue = String()
    let sortingObj: SortingModel = SortingModel()
    let hud = JGProgressHUD(style: .light)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        pickerSelectedValue = "price"
        
        self.PickerView.delegate = self
        cancelButton = UIBarButtonItem (barButtonSystemItem: .cancel, target: nil, action: #selector(pickerCancelPressed))
        doneButton = UIBarButtonItem (barButtonSystemItem: .done, target: nil, action: #selector(pickerDonePressed))
        flexButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([cancelButton,flexButton, doneButton], animated: true)
        doneButton.tintColor =  #colorLiteral(red: 0.8862745098, green: 0.1725490196, blue: 0.168627451, alpha: 1)
        cancelButton.tintColor = #colorLiteral(red: 0.8862745098, green: 0.1725490196, blue: 0.168627451, alpha: 1)
        toolbar.sizeToFit()
        tempTextField.inputAccessoryView = toolbar
        tempTextField.inputView = PickerView
        
        if self.collectionViewData.count == 0 {
            self.errorMessage.isHidden = false
            self.filterAndSortingollectionView.isHidden = true
            
        } else {
            self.errorMessage.isHidden = true
            self.filterAndSortingollectionView.isHidden = false
            self.filterAndSortingollectionView.reloadData()
        }
        
        
    }
    
    
    @objc func pickerCancelPressed() {
        self.view.endEditing(true)
    }
    
    
    
    @objc func pickerDonePressed() {
        self.view.endEditing(true)
        
        hud.textLabel.text = PROGRESS_HUD.HUD_LABEL_KEY
        hud.show(in: self.view)
        sortingObj.sortingData(categoryId: categoryId, sortingType: pickerSelectedValue) { (success) in
            self.hud.dismiss()
            if success {
                self.collectionViewData.removeAll()
                self.collectionViewData = self.sortingObj.sortingData
                
                if self.collectionViewData.count == 0 {
                    self.errorMessage.isHidden = false
                    self.filterAndSortingollectionView.isHidden = true
                    
                } else {
                    self.errorMessage.isHidden = true
                    self.filterAndSortingollectionView.isHidden = false
                    self.filterAndSortingollectionView.reloadData()
                }
                
                
            } else {
                //self.showAlertWithMessage(alertMessage: self.sortingObj.alertMessage)
                 self.present(Helper.globalAlertView(with: LOGIN_CONSTANT.ALERT_HEADER_MESSAGE_KEY, message: self.sortingObj.alertMessage), animated: true, completion: nil)
            }
        }
    }
    
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func filterButtonTapped(_ sender: UIButton) {
    }
    
    
    @IBAction func sortButtontTapped(_ sender: UIButton) {
       tempTextField.becomeFirstResponder()
    }
    
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        let addRecipeViewController = self.storyboard?.instantiateViewController(withIdentifier: "searchID") as! SearchVC
        self.present(addRecipeViewController, animated: false)
    }
    
}


extension FilterAndSortingDataVC : UICollectionViewDelegate, UICollectionViewDataSource {
    // MARK: Collectionview delegate tha datasource method.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewData.count
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? FilterSortingCell
        
        cell?.recipeImageView.contentMode = .scaleAspectFill
        cell?.recipeImageView.sd_setImage(with: URL(string: collectionViewData[indexPath.row]["MediaObjects"][0]["imageUrl"].stringValue), placeholderImage:UIImage(named: "recipePlaceholder"), options: .refreshCached)
        cell?.recipeNameLabel.text = collectionViewData[indexPath.row]["dishName"].stringValue
        
        if collectionViewData[indexPath.row]["foodType"].stringValue == "Veg" {
            cell?.foodTypeImage.image = #imageLiteral(resourceName: "veg")
        } else {
            cell?.foodTypeImage.image = #imageLiteral(resourceName: "non-veg")
        }
        
        return cell!
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //filterSortingToFoodDetailsID
        Id = collectionViewData[indexPath.row]["id"].stringValue
         self.performSegue(withIdentifier: "filterSortingToFoodDetailsID", sender: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width * 0.41062, height: UIScreen.main.bounds.size.height * 0.3360);  // base iphone 5
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "filterSortingToFoodDetailsID" {
            let destinationVC = segue.destination as! FoodDetailVC
            destinationVC.recipeId = Id
        }
    }
}

extension FilterAndSortingDataVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sortingArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sortingArray[row]["key"]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerSelectedValue = sortingArray[row]["value"]!
    }
    
}

extension FilterAndSortingDataVC {
    func showAlertWithMessage(alertMessage:String )
    {
        let alertController = UIAlertController(title:ALERT_TITLE.APP_NAME, message:alertMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action:UIAlertAction!) in
        }))
        self.present(alertController, animated: true, completion: nil)
    }
}
