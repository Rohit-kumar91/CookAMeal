//
//  OrderVC.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 28/11/17.
//  Copyright © 2017 Cynoteck. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage
import JGProgressHUD
import QuartzCore


class OrderVC: UIViewController {

    @IBOutlet weak var recipeTableview: UITableView!
    @IBOutlet weak var identificationLabelOutlet: UILabelX!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var pickerTextField: UITextField!
    
    var collectionViewTagValue = Int()
    var indexValue = Int()
    
    var categoryId = String()
    var categoryName = String()
   
    
    var tempCategories = [String: String]()
    var recipeId = String()
    var tempRecipeArray = [JSON]()
    private let refreshControl = UIRefreshControl()
    var orderModelObj: OrderModel = OrderModel()
    var favouriteModelObj: FavourateModel = FavourateModel()
    
    //For tableviewcCell Index and CollectionViewCell Index
    var tableviewCellIndex = Int()
    var collectionViewCellIndex = Int()
    var reloadTableCheck = Bool()
    var flagValue = Int()    //Use in url for hire and order food.
    

    
    var sortingArray = [["key":"Price","value":"price"],["key":"Order By Date","value":"date"], ["key":"Rating","value":"rating"],  ["key":"Distance","value":"distance"]]
    var selectedPickerValue = String()
    let PickerView = UIPickerView()
    let toolbar = UIToolbar()
    var cancelButton = UIBarButtonItem()
    var doneButton = UIBarButtonItem()
    var flexButton = UIBarButtonItem()
    var pickerSelectedValue = String()
    let sortingObj: SortingModel = SortingModel()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        pickerSelectedValue = "price"
        self.PickerView.delegate = self
        cancelButton = UIBarButtonItem (barButtonSystemItem: .cancel, target: nil, action: #selector(pickerCancelPressed))
        doneButton = UIBarButtonItem (barButtonSystemItem: .done, target: nil, action: #selector(pickerDonePressed))
        flexButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([cancelButton,flexButton, doneButton], animated: true)
        doneButton.tintColor =  #colorLiteral(red: 0.8862745098, green: 0.1725490196, blue: 0.168627451, alpha: 1)
        cancelButton.tintColor = #colorLiteral(red: 0.8862745098, green: 0.1725490196, blue: 0.168627451, alpha: 1)
        toolbar.sizeToFit()
        pickerTextField.inputAccessoryView = toolbar
        pickerTextField.inputView = PickerView

        identificationLabelOutlet.layer.cornerRadius = identificationLabelOutlet.frame.size.height / 2
        orderModelObj.categoryId = categoryId
        
        self.recipeTableview.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        
        self.recipeTableview.dataSource = self
        self.recipeTableview.delegate = self
        
        self.recipeTableview.estimatedRowHeight =  self.recipeTableview.rowHeight
        self.recipeTableview.rowHeight = UITableViewAutomaticDimension
        
        reloadTableCheck = true
        
        print(currentLocationLatitude)
        print(currentLocationLongitute)
        getCategoryData()
        
       
    }
    
    @IBAction func unwindToCancelOrder(segue:UIStoryboardSegue) { }
    @IBAction func unwindToDeleteRecipe(segue:UIStoryboardSegue) {
        
        print("Delete cell after delete")
        
//        let indexPath = IndexPath(row: self.tableviewCellIndex, section: 0)
//        let cell: OrderTableviewCell = self.recipeTableview.cellForRow(at: indexPath) as! OrderTableviewCell
//        let collectionViewindexPath = IndexPath(row: self.collectionViewCellIndex, section: 0)
//        cell.recipeCollectionview.deleteItems(at: [collectionViewindexPath])
         Singleton.instance.isSimpleGetRequest = true
        
        print(flagValue)
        reloadTableCheck = true
        getCategoryData()

        
    }
    
    @IBAction func filterButtonAction(_ sender: UIButton) {
        let filterViewController = self.storyboard?.instantiateViewController(withIdentifier: "filterVCID") as! FilterVC
        self.present(filterViewController, animated: false)
    }
    
    
    @IBAction func sortButtonTapped(_ sender: UIButton) {
        pickerTextField.becomeFirstResponder()
    }
    
    @objc func pickerCancelPressed(){
        self.view.endEditing(true)
    }
    
    @objc func pickerDonePressed(){
        self.view.endEditing(true)
        
        let hud = JGProgressHUD(style: .light)
        hud.show(in: self.view)
        hud.textLabel.text = "Loading"
        sortingObj.sortingData(categoryId: categoryId, sortingType: pickerSelectedValue) { (success) in
            hud.dismiss()
            if success {
                self.performSegue(withIdentifier: "sortingAndFilterDataID", sender: nil)
            } else {
                self.showAlertWithMessage(alertMessage: self.sortingObj.alertMessage)
            }
        }
    }
    
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        let addRecipeViewController = self.storyboard?.instantiateViewController(withIdentifier: "searchID") as! SearchVC
        self.present(addRecipeViewController, animated: false)
    }
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 23 2017
    // Input Parameters :   N/A.
    // Purpose          :   Refresh the data.
    //>--------------------------------------------------------------------------------------------------
    
    @objc private func refreshData(_ sender: Any) {
        
        orderModelObj.getOrderData(orderType: String(flagValue)) { (success) in
            self.refreshControl.endRefreshing()
            if success {
                self.recipeTableview.reloadData()
                
            }else {
                self.present(Helper.globalAlertView(with: LOGIN_CONSTANT.ALERT_HEADER_MESSAGE_KEY, message: self.orderModelObj.alertMessage), animated: true, completion: nil)
            }
        }
    }
    
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 23 2017
    // Input Parameters :   N/A.
    // Purpose          :   Handle favourite Button Api and button state.
    //>--------------------------------------------------------------------------------------------------
    @IBAction func favouriteButtonTapped(_ sender: UIButton) {
        
        if Helper.getUserDefaultValue(key: GUEST_KEY) == "1" {
            //For Guest User
            Helper.removeUserDefault(key: TOKEN_KEY)
        } else {
            //For Cook and Customer
            
            let outerArrayIndex = sender.tag / 10
            let nestedInnerArrayIndex = sender.tag % 10
            
            //Button Animation.
            let pulse = CASpringAnimation(keyPath: "transform.scale")
            pulse.duration = 0.6
            pulse.fromValue = 0.95
            pulse.toValue = 1.2
            pulse.autoreverses = true
            pulse.repeatCount = 1
            pulse.initialVelocity = 0.5
            pulse.damping = 1.0
            sender.layer.add(pulse, forKey: "pulse")
            
            
            
            //Calling Favourite API.
            favouriteModelObj.favourateRecipeData(recipeId: orderModelObj.recipeCategoryData[outerArrayIndex - 1][nestedInnerArrayIndex][ID_KEY].stringValue) { (success) in
                if success {
                    
                    if self.favouriteModelObj.favorite {
                        self.orderModelObj.recipeCategoryData[outerArrayIndex - 1][nestedInnerArrayIndex]["Favorite"] = true
                        
                        let indexPath = IndexPath(row: outerArrayIndex - 1, section: 0)
                        let cell: OrderTableviewCell = self.recipeTableview.cellForRow(at: indexPath) as! OrderTableviewCell
                        let collectionViewindexPath = IndexPath(row: nestedInnerArrayIndex, section: 0)
                        cell.recipeCollectionview.reloadItems(at: [collectionViewindexPath])
                        
                        
                    } else {
                        self.orderModelObj.recipeCategoryData[outerArrayIndex - 1][nestedInnerArrayIndex]["Favorite"] = false
                        
                        let indexPath = IndexPath(row: outerArrayIndex - 1, section: 0)
                        let cell: OrderTableviewCell = self.recipeTableview.cellForRow(at: indexPath) as! OrderTableviewCell
                        let collectionViewindexPath = IndexPath(row: nestedInnerArrayIndex, section: 0)
                        cell.recipeCollectionview.reloadItems(at: [collectionViewindexPath])
                        
                    }
                    
                } else {
                    
                    self.orderModelObj.recipeCategoryData[outerArrayIndex - 1][nestedInnerArrayIndex]["Favorite"] = false
                    
                    let indexPath = IndexPath(row: outerArrayIndex - 1, section: 0)
                    let cell: OrderTableviewCell = self.recipeTableview.cellForRow(at: indexPath) as! OrderTableviewCell
                    let collectionViewindexPath = IndexPath(row: nestedInnerArrayIndex, section: 0)
                    cell.recipeCollectionview.reloadItems(at: [collectionViewindexPath])
                    
                }
            }
        }
    }
    
    
    
    
    override func viewWillLayoutSubviews() {
         identificationLabelOutlet.layer.masksToBounds = true
         identificationLabelOutlet.layer.cornerRadius = identificationLabelOutlet.frame.size.height / 2
         identificationLabelOutlet.text = categoryName
    }
    
    
    
    
    func getCategoryData() {
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
       
        //delegate method calling
        self.recipeTableview.estimatedRowHeight =  self.recipeTableview.rowHeight
        self.recipeTableview.rowHeight = UITableViewAutomaticDimension

        
        let hud = JGProgressHUD(style: .light)
        //hud.show(in: self.view)
        hud.textLabel.text = "Loading"
        
        
        print(String(flagValue))
        
        orderModelObj.getOrderData(orderType: String(flagValue)) { (success) in
            if success {
                //hud.dismiss()
                
                if self.orderModelObj.recipeCategoryData.count == 0 {
                    self.messageLabel.isHidden = false
                    self.recipeTableview.isHidden = true
                } else {
                    
                    //Print category Data.
                    self.messageLabel.isHidden = true
                    self.recipeTableview.isHidden = false
                    
                    if self.reloadTableCheck {
                        self.reloadTableCheck = false
                        self.recipeTableview.reloadData()
                    } else {
                        let indexPath = IndexPath(row: self.tableviewCellIndex, section: 0)
                        let cell: OrderTableviewCell = self.recipeTableview.cellForRow(at: indexPath) as! OrderTableviewCell
                        let collectionViewindexPath = IndexPath(row: self.collectionViewCellIndex, section: 0)
                        cell.recipeCollectionview.reloadItems(at: [collectionViewindexPath])
                    }
                }
                
            }else {
                hud.dismiss()
                //self.showAlertWithMessage(alertMessage: self.orderModelObj.alertMessage)
                self.present(Helper.globalAlertView(with: LOGIN_CONSTANT.ALERT_HEADER_MESSAGE_KEY, message: self.orderModelObj.alertMessage), animated: true, completion: nil)
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
    
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 23 2017
    // Input Parameters :   N/A.
    // Purpose          :   Pop ViewController.
    //>--------------------------------------------------------------------------------------------------
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    @IBAction func reviewButtontapped(_ sender: UIButton) {
//        let outerArrayIndex = sender.tag / 10
//        let nestedInnerArrayIndex = sender.tag % 10
//        
//        print(orderModelObj.recipeCategoryData)
//        
//        var Id = orderModelObj.recipeCategoryData[outerArrayIndex - 1][nestedInnerArrayIndex][ID_KEY].stringValue
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "showRecipeReviewId") as! ShowReviewScreenVC
//        vc.recipeId = Id
//        self.present(vc, animated: true, completion: nil)
        
    }
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 23 2017
    // Input Parameters :   N/A.
    // Purpose          :   Select category and subCategory Id, also navigate to sellAllRecipeCategoryList ViewController.
    //>--------------------------------------------------------------------------------------------------
    @IBAction func seeAllButtonTapped(_ sender: UIButton) {
        
        tempCategories = ["categoryId": categoryId, "subCategoryId": (orderModelObj.recipeCategoryName[sender.tag][ID_KEY]?.stringValue)!, "subCategoryName" : orderModelObj.recipeArray[sender.tag]["name"].stringValue, "categoryName": categoryName]
        
        self.performSegue(withIdentifier: "seeAllRecipeCategoryListIdentifier", sender: nil)
    }
    
    
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 23 2017
    // Input Parameters :   N/A.
    // Purpose          :   Helps in pass data to other viewController by identify the identifierID.
    //>--------------------------------------------------------------------------------------------------
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seeAllRecipeCategoryListIdentifier" {
            
            let destinationVC = segue.destination as! SeeAllRecipeCategoryList
            destinationVC.categoriesValue = tempCategories
            
        } else if segue.identifier == "orderDetailIdentifier" {
            
            let destinationVC = segue.destination as! FoodDetailVC
            destinationVC.recipeId = recipeId
            destinationVC.tableViewIndex = tableviewCellIndex
            destinationVC.collectionViewIndex = collectionViewCellIndex
            
        } else if segue.identifier == "sortingAndFilterDataID" {
            
            let destinationVC = segue.destination as! FilterAndSortingDataVC
            destinationVC.collectionViewData = sortingObj.sortingData
            destinationVC.categoryId = categoryId
            
        }
    }
}





extension OrderVC:  UITableViewDataSource, UITableViewDelegate  {
    // MARK: Tableview delegate tha datasource method.
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if orderModelObj.recipeCategoryName.count != 0 {
            return orderModelObj.recipeCategoryName.count
        } else {
            return 2
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! OrderTableviewCell
        
        cell.contentView.layoutIfNeeded()
        cell.collectionviewHeightConstraintConstant.constant = UIScreen.main.bounds.size.height * 0.4048 //percentage calculation - 0.4048
        cell.seeAllButtonOutlet.tag = indexPath.row
        cell.recipeCollectionview.tag = indexPath.row
        cell.seeAllButtonOutlet.isHidden = true
        
        if orderModelObj.recipeCategoryName.count != 0 {
            
            cell.hideSkeletonViews()
            cell.seeAllButtonOutlet.isHidden = false
            
            cell.categoryTitleLabel.text = orderModelObj.recipeCategoryName[indexPath.row]["name"]?.stringValue
            
            //SeeAll button
            if orderModelObj.recipeCategoryData[indexPath.row].count > 3 {
                cell.seeAllButtonOutlet.isHidden = false
            }
            
            if Helper.getUserDefaultValue(key: "orderType")! == "0" {
                //unhide
                cell.collectionviewHeightConstraintConstant.constant = UIScreen.main.bounds.size.height * 0.4248
                
            } else if Helper.getUserDefaultValue(key: "orderType")! == "1" {
                //hide
                cell.collectionviewHeightConstraintConstant.constant = UIScreen.main.bounds.size.height * 0.3359
            }
        }

        
        cell.recipeCollectionview.dataSource = self
        cell.recipeCollectionview.reloadData()
        return cell
    }
}




extension OrderVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    // MARK: Collectionview delegate tha datasource method.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if orderModelObj.recipeCategoryData.count != 0 {
            return orderModelObj.recipeCategoryData[collectionView.tag].count
        } else {
            return 3
        }
        
        

    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? OrderCollectionViewCell
        
        cell?.showSkeletonViews()
        
        if orderModelObj.recipeCategoryData.count != 0 {
            
            cell?.hideSkeletonViews()
            
            cell?.recipeImageview.contentMode = .scaleAspectFill
            cell?.recipeImageview.sd_setImage(with: URL(string: orderModelObj.recipeCategoryData[collectionView.tag][indexPath.row]["MediaObjects"][0][IMAGE_URL_KEY].stringValue), placeholderImage:UIImage(named: "recipePlaceholder"), options: .refreshCached)
            cell?.favouriteButtonOutlet.tag = (((collectionView.tag + 1) * 10) + indexPath.row)
            cell?.reviewButtonOutlet.tag = (((collectionView.tag + 1) * 10) + indexPath.row)
            
            //Rating
            cell?.ratingStarView.halfRatings = true
            cell?.ratingStarView.rating = orderModelObj.recipeCategoryData[collectionView.tag][indexPath.row]["Rating"].floatValue
            
            
            //CostPerServing
            cell?.costPerServingLabel.text =
                orderModelObj.recipeCategoryData[collectionView.tag][indexPath.row]["currencySymbol"].stringValue +
                orderModelObj.recipeCategoryData[collectionView.tag][indexPath.row]["costPerServing"].stringValue + " " + "per serving"
            
            
            //Favourite
            if orderModelObj.recipeCategoryData[collectionView.tag][indexPath.row]["Favorite"].boolValue {
                cell?.favouriteButtonOutlet.tintColor = #colorLiteral(red: 0.8859999776, green: 0.172999993, blue: 0.1689999998, alpha: 1)
            } else {
                cell?.favouriteButtonOutlet.tintColor = #colorLiteral(red: 0.8196078431, green: 0.8196078431, blue: 0.8196078431, alpha: 1)
            }
            
            
            //Food Type
            if orderModelObj.recipeCategoryData[collectionView.tag][indexPath.row]["foodType"].stringValue == "Veg" {
                cell?.foodTypeImages.image = #imageLiteral(resourceName: "veg")
            } else {
                cell?.foodTypeImages.image = #imageLiteral(resourceName: "non-veg")
            }
            
            //Constraint hide/unhide.
            if Helper.getUserDefaultValue(key: "orderType")! == "0" {
                
                //unhide
                cell?.orderDateHeightConstraint.constant = 17
                cell?.verticalLabelConstarint.constant = 8
                cell?.costPerServingHeightConstraint.constant = 19
                cell?.imageviewHeightConstraint.constant = collectionView.frame.size.height * 0.50
                
                cell?.orderByDateLabel.text =  "Order By: " + Helper.getDate(date: orderModelObj.recipeCategoryData[collectionView.tag][indexPath.row]["orderByDateTime"].stringValue)
                
            } else if Helper.getUserDefaultValue(key: "orderType")! == "1" {
                
                //hide
                cell?.orderDateHeightConstraint.constant = 0
                cell?.verticalLabelConstarint.constant = 0
                cell?.costPerServingHeightConstraint.constant = 0
                cell?.imageviewHeightConstraint.constant = collectionView.frame.size.height * 0.62
                
            }
            
            
            cell?.clipsToBounds = true
            cell?.dishNameLable.text = orderModelObj.recipeCategoryData[collectionView.tag][indexPath.row]["dishName"].stringValue
        } else {
            cell?.orderDateHeightConstraint.constant = 17
            cell?.verticalLabelConstarint.constant = 8
            cell?.costPerServingHeightConstraint.constant = 19
            cell?.imageviewHeightConstraint.constant = collectionView.frame.size.height * 0.50
        }
        
        
       
        
      
        return cell!
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        recipeId = orderModelObj.recipeCategoryData[collectionView.tag][indexPath.row][ID_KEY].stringValue
        tableviewCellIndex = collectionView.tag
        collectionViewCellIndex = indexPath.row
        self.performSegue(withIdentifier: "orderDetailIdentifier", sender: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width * 0.375 , height: collectionView.bounds.size.height);
    }

}



extension OrderVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
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





