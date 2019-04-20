//
//  FilterVC.swift
//  FilterDesign
//
//  Created by Cynoteck on 22/06/18.
//  Copyright © 2018 Cynoteck. All rights reserved.
//

import UIKit
import TTRangeSlider
import FloatRatingView
import JGProgressHUD


class FilterVC: UIViewController {
    
    let filterDict = [String: String]()
    var minValue = 0.0
    var maxValue = 100.0
    let datePickerFromDate = UIDatePicker()
    let toolbar = UIToolbar()
    let PickerView = UIPickerView()
    var cancelButton = UIBarButtonItem()
    var doneButton = UIBarButtonItem()
    var flexButton = UIBarButtonItem()
    var fromDate = Date()
    var toDate = Date()
    var ratingValue = String()
    
    let hud = JGProgressHUD(style: .light)
    let filterObj: FilterModel = FilterModel()
    
    @IBOutlet weak var filterTableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        cancelButton = UIBarButtonItem (barButtonSystemItem: .cancel, target: nil, action: #selector(pickerCancelPressed))
        doneButton = UIBarButtonItem (barButtonSystemItem: .done, target: nil, action: #selector(pickerDonePressed))
        flexButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([cancelButton,flexButton, doneButton], animated: true)
        doneButton.tintColor =  #colorLiteral(red: 0.8862745098, green: 0.1725490196, blue: 0.168627451, alpha: 1)
        cancelButton.tintColor = #colorLiteral(red: 0.8862745098, green: 0.1725490196, blue: 0.168627451, alpha: 1)
        toolbar.sizeToFit()
        ratingValue = "0.0"
        
    }
    
    
    @IBAction func applyButtonTapped(_ sender: UIBarButtonItem) {
        
        print("Subcategory Array\(Singleton.instance.subCategoryFilterArray)")
        
        let indexPath = IndexPath(row: 1, section: 0)
        let cell: DateCell = self.filterTableview.cellForRow(at: indexPath) as! DateCell
        //For orderDate.
        var tempDates = [String: Any]()
        if cell.fromDateTextfield.text == "" {
        } else {
            tempDates = [
                "start" : cell.fromDateTextfield.text!,
                "end":  cell.toDateTextfield.text!
            ]
        }
        
       
        
        //Price range
        let tempPrice = [
            "start" : String(minValue),
            "end":  String(maxValue)
        ]
      
       
        //Location
        let latitude = String(currentLocationLatitude)
        let longitude = String(currentLocationLongitute)
        let location = [
            "lat": latitude,
            "long" : longitude
        ]
        
        
        
        var filterDict = [String: Any]()
        filterDict["categoryId"] = "e279ccd6-94a9-4596-851e-1f105c4f53e9"
        filterDict["subCategoryId"] = Singleton.instance.subCategoryFilterArray
        filterDict["rating"] = ratingValue
        filterDict["orderByDateTime"] = tempDates
        filterDict["priceRange"] = tempPrice
        filterDict["distance"] = "10"
        filterDict["location"] = location
        filterDict["unit"] = "India"
        
        
        print(filterDict)
        
        hud.textLabel.text = PROGRESS_HUD.HUD_LABEL_KEY
        hud.show(in: self.view)
        filterObj.filterData(filterParameter: filterDict) { (success) in
            self.hud.dismiss()
            if success {
                self.performSegue(withIdentifier: "filterVcToFiterSortingVcId", sender: nil)
            } else {
                //self.showAlertWithMessage(alertMessage: self.filterObj.alertMessage)
                 self.present(Helper.globalAlertView(with: LOGIN_CONSTANT.ALERT_HEADER_MESSAGE_KEY, message: self.filterObj.alertMessage), animated: true, completion: nil)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "filterVcToFiterSortingVcId" {
            let destinationVC = segue.destination as! FilterAndSortingDataVC
            destinationVC.collectionViewData = filterObj.filterData
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        createFromDatePicker()
        createToDatePicker()
        
        let indexPath = IndexPath(row: 2, section: 0)
        let cell: ReviewsCell = self.filterTableview.cellForRow(at: indexPath) as! ReviewsCell
        cell.ratingView.delegate = self
    }
    
    
    @objc func pickerCancelPressed(){
        self.view.endEditing(true)
    }
    
    @objc func pickerDonePressed() {
        let indexPath = IndexPath(row: 1, section: 0)
        let cell: DateCell = self.filterTableview.cellForRow(at: indexPath) as! DateCell
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
       
        
        print("datePickerTags\(datePickerFromDate.tag)")
        
        if datePickerFromDate.tag == 1 {
            cell.fromDateTextfield.text = dateFormatter.string(from: datePickerFromDate.date)
            fromDate = datePickerFromDate.date
        } else {
            cell.toDateTextfield.text = dateFormatter.string(from: datePickerFromDate.date)
            toDate = datePickerFromDate.date
        }
        
        self.view.endEditing(true)
    }

    
    @IBAction func priceSliderAction(_ sender: TTRangeSlider) {
        
        minValue = Double(sender.minValue)
        maxValue = Double(sender.maxValue)
        
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
      //self.dismiss(animated: false, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
}


extension FilterVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 1 {
            datePickerFromDate.tag = 1
        } else if textField.tag == 2 {
            datePickerFromDate.tag = 2
        }
    }
}

extension FilterVC: FloatRatingViewDelegate {
  
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Float) {
        let indexPath = IndexPath(row: 2, section: 0)
        let cell: ReviewsCell = self.filterTableview.cellForRow(at: indexPath) as! ReviewsCell
        ratingValue = String(format: "%.2f", cell.ratingView.rating)
    }
    
    
    // MARK: FloatRatingViewDelegate
    
    private func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating: Double) {
        let indexPath = IndexPath(row: 2, section: 0)
        let cell: ReviewsCell = self.filterTableview.cellForRow(at: indexPath) as! ReviewsCell
        ratingValue = String(format: "%.2f", cell.ratingView.rating)
        
    }
}




extension FilterVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        
        switch indexPath.row {
        case 0:
            print("0")
            cell = tableView.dequeueReusableCell(withIdentifier: "price") as! PriceCell
            
        case 1:
            
            cell = tableView.dequeueReusableCell(withIdentifier: "date") as! DateCell
            
        case 2:
           
            cell = tableView.dequeueReusableCell(withIdentifier: "review") as! ReviewsCell
            
        case 3:
            
            cell = tableView.dequeueReusableCell(withIdentifier: "subCategory") as! SubcategoryCell
            
        case 4:
            
            cell = tableView.dequeueReusableCell(withIdentifier: "cook") as! CookCell
            
        case 5:
            
            cell = tableView.dequeueReusableCell(withIdentifier: "ingredient") as! IngredientCell
            
        default:
           break
        }
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //Constraint hide/unhide.
        if Helper.getUserDefaultValue(key: "orderType")! == "1" {
            
            //hide
            //date
            //return UITableViewAutomaticDimension
            if indexPath.row == 1 {
                 return 0
            } else {
                 return UITableViewAutomaticDimension
            }
            
            
        } else  {
            
            //unhide
            //date nahi ayegi
          return UITableViewAutomaticDimension
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("Indexpath\(indexPath.row)")
        
//        if indexPath.row == 3 {
//          self.performSegue(withIdentifier: "toShowCategory", sender: self)
//        }
        
    }
    
    
    func createFromDatePicker() {
        
        let calendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let currentDate = NSDate()
        let dateComponents = NSDateComponents()
        let minDate = calendar.date(byAdding: dateComponents as DateComponents, to: currentDate as Date, options: NSCalendar.Options(rawValue: 0))
        dateComponents.month = 3 //or you can change month = day(90)
        
        let maxDate = calendar.date(byAdding: dateComponents as DateComponents, to: currentDate as Date, options: NSCalendar.Options(rawValue: 0))
        self.datePickerFromDate.datePickerMode = .date
        self.datePickerFromDate.maximumDate = maxDate
        self.datePickerFromDate.minimumDate = minDate
       
        
        let indexPath = IndexPath(row: 1, section: 0)
        let cell: DateCell = self.filterTableview.cellForRow(at: indexPath) as! DateCell
        cell.fromDateTextfield.inputAccessoryView = toolbar
        cell.fromDateTextfield.inputView = datePickerFromDate
        
    }
    
    func createToDatePicker() {
        
        let calendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let currentDate = NSDate()
        let dateComponents = NSDateComponents()
        let minDate = calendar.date(byAdding: dateComponents as DateComponents, to: fromDate as Date, options: NSCalendar.Options(rawValue: 0))
        dateComponents.month = 3 //or you can change month = day(90)
        
        let maxDate = calendar.date(byAdding: dateComponents as DateComponents, to: currentDate as Date, options: NSCalendar.Options(rawValue: 0))
        self.datePickerFromDate.datePickerMode = .date
        self.datePickerFromDate.maximumDate = maxDate
        self.datePickerFromDate.minimumDate = minDate
        
        
        let indexPath = IndexPath(row: 1, section: 0)
        let cell: DateCell = self.filterTableview.cellForRow(at: indexPath) as! DateCell
        cell.toDateTextfield.inputAccessoryView = toolbar
        cell.toDateTextfield.inputView = datePickerFromDate
        
    }
    
    func showAlertWithMessage(alertMessage:String )
    {
        let alertController = UIAlertController(title:ALERT_TITLE.APP_NAME, message:alertMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action:UIAlertAction!) in
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    
}

