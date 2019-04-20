//
//  FoodDetailVC.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 11/12/17.
//  Copyright © 2017 Cynoteck. All rights reserved.
//

import UIKit
import SwiftyJSON
import JGProgressHUD
import CRNotifications

class FoodDetailVC: UIViewController {
    
    let imageArray = [UIImage]()
    let foodModelObj: FoodDetailModel = FoodDetailModel()
    let favourateModelObj: FavourateModel = FavourateModel()
    var recipeId = String()
    var ingredientCellCheck:Bool!
    var preperationCellCheck:Bool!
    let PickerView = UIPickerView()
    var selectedOrderValue = Int()
    var selectedSpiceValue = Int()
    var pickerBool: Bool!
    var profile_ID = String()
    var spiceLevel = String()
    var orderServing = String()
    var tempOrderServing = String()
    let cookRecipeModelObj: CookRecipeModel = CookRecipeModel()
    var isCommingFromAllRecipe = Bool()
    
    var tableViewIndex = Int()
    var collectionViewIndex = Int()
    var eventId = String()
    var cookId = String()
    var dateString = String()
    var seeMoreCheckPreparation = Int()
    var hud = JGProgressHUD(style: .light)
    
    @IBOutlet weak var addToCartButtonOutlet: RoundedButton!
    @IBOutlet weak var orderButtonOulet: RoundedButton!
    @IBOutlet weak var seperatorViewOutlet: UIView!
    @IBOutlet weak var recipeDetailErrorOutlet: UILabel!
    @IBOutlet weak var foodTableview: UITableView!
    @IBOutlet weak var buttonStackview: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ingredientCellCheck = true
        preperationCellCheck = true
        buttonStackview.isHidden = true
        seeMoreCheckPreparation = 3
        
        self.foodTableview.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
        self.foodTableview.estimatedRowHeight =  self.foodTableview.rowHeight
        self.foodTableview.rowHeight = UITableViewAutomaticDimension
        self.PickerView.delegate = self
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
       
        hud.show(in: self.view)
        hud.textLabel.text = "Loading"
        
        foodModelObj.getFoodDetailData(recipeId: recipeId) { (success) in
            
            if success {
                
                self.hud.dismiss()
                
                if success {
                    
                    if self.foodModelObj.jSONCheck {
                        
                        self.foodTableview.isHidden = true
                        self.recipeDetailErrorOutlet.isHidden = false
                        
                    } else {
                        
                        //Use for to check the recipe is added by login user or not
                        self.buttonStackview.isHidden = false
                        self.recipeDetailErrorOutlet.isHidden = true
                        self.foodTableview.isHidden = false
                        self.addToCartButtonOutlet.isHidden = false
                        self.orderButtonOulet.isHidden = false
                        self.seperatorViewOutlet.isHidden = false
                        
                        let hireCook = Helper.getUserDefaultValue(key: "orderType")
                        if hireCook == "1" {
                            self.addToCartButtonOutlet.isHidden = true
                        }
                        
                        
                        let createdBy = self.foodModelObj.profile["createdBy"]!.stringValue
                        if createdBy ==  Helper.getUserDefaultValue(key: ID_KEY){
                            //If recipe is the cook recipe.
                            self.addToCartButtonOutlet.setTitle("Delete", for: .normal)
                            self.orderButtonOulet.setTitle("Edit", for: .normal)
                            self.addToCartButtonOutlet.tag = 1
                            self.orderButtonOulet.tag = 2
                            
                        } else if hireCook == "1" {
                            //For Hiring a cook.
                            self.addToCartButtonOutlet.setTitle("Cancel", for: .normal)
                            self.orderButtonOulet.setTitle("Check Avialability", for: .normal)
                            self.orderButtonOulet.titleLabel?.adjustsFontSizeToFitWidth = true
                            self.addToCartButtonOutlet.tag = 7
                            self.orderButtonOulet.tag = 8
                            
                        } else {
                            //If not.
                            self.addToCartButtonOutlet.setTitle("Add to cart", for: .normal)
                            self.orderButtonOulet.setTitle("Order", for: .normal)
                            self.addToCartButtonOutlet.tag = 4
                            self.orderButtonOulet.tag = 5
                        }
                        
                        self.foodTableview.dataSource = self
                        self.foodTableview.delegate = self
                        self.foodTableview.reloadData()
                    }
                }
                
                
               /*
                self.foodModelObj.getNutritionData(completion: { (success) in
                    
                    self.hud.dismiss()
                    
                    if success {
                        
                        if self.foodModelObj.jSONCheck {
                            
                            self.foodTableview.isHidden = true
                            self.recipeDetailErrorOutlet.isHidden = false
                            
                        } else {
                            
                            //Use for to check the recipe is added by login user or not
                            self.buttonStackview.isHidden = false
                            self.recipeDetailErrorOutlet.isHidden = true
                            self.foodTableview.isHidden = false
                            self.addToCartButtonOutlet.isHidden = false
                            self.orderButtonOulet.isHidden = false
                            self.seperatorViewOutlet.isHidden = false
                            
                            let hireCook = Helper.getUserDefaultValue(key: "orderType")
                            if hireCook == "1" {
                                self.addToCartButtonOutlet.isHidden = true
                            }
                            
                            
                            let createdBy = self.foodModelObj.profile["createdBy"]!.stringValue
                            if createdBy ==  Helper.getUserDefaultValue(key: ID_KEY){
                                //If recipe is the cook recipe.
                                self.addToCartButtonOutlet.setTitle("Delete", for: .normal)
                                self.orderButtonOulet.setTitle("Edit", for: .normal)
                                self.addToCartButtonOutlet.tag = 1
                                self.orderButtonOulet.tag = 2
                                
                            } else if hireCook == "1" {
                                //For Hiring a cook.
                                self.addToCartButtonOutlet.setTitle("Cancel", for: .normal)
                                self.orderButtonOulet.setTitle("Check Avialability", for: .normal)
                                self.orderButtonOulet.titleLabel?.adjustsFontSizeToFitWidth = true
                                self.addToCartButtonOutlet.tag = 7
                                self.orderButtonOulet.tag = 8
                                
                            } else {
                                //If not.
                                self.addToCartButtonOutlet.setTitle("Add to cart", for: .normal)
                                self.orderButtonOulet.setTitle("Order", for: .normal)
                                self.addToCartButtonOutlet.tag = 4
                                self.orderButtonOulet.tag = 5
                            }
                            
                            self.foodTableview.dataSource = self
                            self.foodTableview.delegate = self
                            self.foodTableview.reloadData()
                        }
                    }
                })  */
                
            } else {
                //self.showAlertWithMessage(alertMessage: self.foodModelObj.alertMessage)
                self.present(Helper.globalAlertView(with: LOGIN_CONSTANT.ALERT_HEADER_MESSAGE_KEY, message: self.foodModelObj.alertMessage), animated: true, completion: nil)
            }
        }
    }
    
    
    
    @IBAction func addToCartButtonTapped(_ sender: RoundedButton) {
        
        
        if sender.titleLabel?.text == "Delete" {
            //showAlertWithMessage(alertMessage: "Delete fuctionality is not implemented.")
            
            let alertController = UIAlertController(title:"Delete Recipe.", message:"Are you sure you want to delete the menu item?", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action:UIAlertAction!) in
                
                self.hud.show(in: self.view)
                self.hud.textLabel.text = "Loading"
                self.cookRecipeModelObj.deleteRecipeFromCookKitchen(id: self.recipeId) { (success) in
                    self.hud.dismiss()
                    //
                    //self.navigationController?.popViewController(animated: true)
                    
                    if self.isCommingFromAllRecipe {
                        self.isCommingFromAllRecipe = false
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        self.performSegue(withIdentifier: "deleteRecipeSegue", sender: self)
                    }
                    
                }
            }))
            
            
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action:UIAlertAction!) in
                
            }))
            
            self.present(alertController, animated: true, completion: nil)
            
            
        } else {
            foodModelObj.addToCart(recipeId: recipeId, numberOfServing: "1") { (success) in
                if success {
                    CRNotifications.showNotification(type: CRNotifications.success, title: "Recipe added successfully!", message: "This Item is placed in your cart.", dismissDelay: 3)
                } else {
                    
                    if self.foodModelObj.statusCode == "403" {
                        //Helper.removeUserDefault(key: TOKEN_KEY)
                        let alertController = UIAlertController(title: "Domestic Eat", message: "Please login to use this feature.", preferredStyle: .alert)
                        
                        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action:UIAlertAction!) in
                            Helper.removeUserDefault(key: TOKEN_KEY)
                        }))
                        
                        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action:UIAlertAction!) in
                            //Helper.removeUserDefault(key: TOKEN_KEY)
                        }))
                        
                        self.present(alertController, animated: true, completion: nil)
                        
                    } else {
                        //self.showAlertWithMessage(alertMessage: self.foodModelObj.alertMessage)
                        self.present(Helper.globalAlertView(with: LOGIN_CONSTANT.ALERT_HEADER_MESSAGE_KEY, message: self.foodModelObj.alertMessage), animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    
    
    
    @IBAction func orderServingButtonTapped(_ sender: Any) {
        
        if foodModelObj.orderOfServing.count == 0 {
            self.showAlertWithMessage(alertMessage: "Available is Empty, Out of stock.")
        } else {
            pickerBool = false
            let indexPath = IndexPath(row: 1, section: 0)
            let cell: RecipeDetailTableViewCell = self.foodTableview.cellForRow(at: indexPath) as! RecipeDetailTableViewCell
            PickerView.tag = 2
            PickerView.reloadAllComponents()
            PickerView.selectRow(selectedOrderValue, inComponent: 0, animated: false)

            //PickerView.selectedRow(inComponent: selectedOrderValue)
            cell.orderServingTextfield.becomeFirstResponder()
        }
    }
    
    
    @IBAction func spiceLevelButtonTapped(_ sender: UIButton) {
        pickerBool = true
        let indexPath = IndexPath(row: 1, section: 0)
        let cell: RecipeDetailTableViewCell = self.foodTableview.cellForRow(at: indexPath) as! RecipeDetailTableViewCell
        PickerView.tag = 1
        PickerView.reloadAllComponents()
        PickerView.selectRow(selectedSpiceValue, inComponent: 0, animated: false)
        //PickerView.selectedRow(inComponent: selectedSpiceValue)
        cell.spiceLevelTextfield.becomeFirstResponder()
    }
    
    
    
    // MARK: Order Button :- Use for Order Recipe and also use for edit recipe dish
    // Infromation : Button tag => 2 use for edit recipe, 5 use for order recipe.
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 23 2017
    // Input Parameters :   N/A.
    // Purpose          :   Use for edit and order recipe.
    //>---------------------------------------------------------------------------------------------------
    
    @IBAction func orderButtonTapped(_ sender: RoundedButton) {
        //2
        print(sender.tag)
        Singleton.instance.editRecipe = false
        
        if sender.tag == 1 {
            
            Singleton.instance.ingredientCheck = String(sender.tag)
            let addRecipeViewController = self.storyboard?.instantiateViewController(withIdentifier: "addRecipeID") as! AddRecipeVC
            self.present(addRecipeViewController, animated: true)
            
        } else if sender.tag == 2 {
            
            print("Edit Recipe")
            Singleton.instance.ingredientCheck = String(sender.tag)
            Singleton.instance.editRecipe = true
            let addRecipeViewController = self.storyboard?.instantiateViewController(withIdentifier: "addRecipeID") as! AddRecipeVC
            addRecipeViewController.isRecipeEditable = true
            addRecipeViewController.recipeId = recipeId
            self.present(addRecipeViewController, animated: true)
            
            
        } else if sender.tag == 7 {
            //For Cancel
            
        } else if sender.tag == 8 {
            //For Book the cook slot.
            self.performSegue(withIdentifier: "toCookAvailableIdentifier", sender: nil)
            
        } else if sender.tag == 4 {
            //Add To cart
            
        } else if sender.tag == 5 {
            // For Order
            
            Singleton.instance.ingredientCheck = String(sender.tag)
            //For Cook/ Customer
            if spiceLevel.isEmpty || orderServing.isEmpty {
                showAlertWithMessage(alertMessage: "Spice Level and Order Serving cannot be blank.")
            } else if Helper.getUserDefaultValue(key: "orderType")! == "0" {
                self.performSegue(withIdentifier: "orderFoodId", sender: nil)
            }
        }
        
    }
    
    
    // MARK: Profile Button
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 23 2017
    // Input Parameters :   N/A.
    // Purpose          :   Navigate to profile Screen.
    //>---------------------------------------------------------------------------------------------------
    @IBAction func profileButtonTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "profileID", sender: nil)
    }
    
    
    
    // MARK: PrepareForSegue
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 23 2017
    // Input Parameters :   N/A.
    // Purpose          :   Identify the segue with identifier and send data to other screen if needed.
    //>---------------------------------------------------------------------------------------------------
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "profileID" {
            
            let destinationVC = segue.destination as! ProfileVC
            destinationVC.profileId = (foodModelObj.profile[ID_KEY]?.stringValue)!
            destinationVC.backButtonBool = true
            
        } else if segue.identifier == "orderFoodId" {
            
            let destinationVC = segue.destination as! OrderFoodSummaryVC
            destinationVC.recipeId = (foodModelObj.recipeDetailData[ID_KEY]?.stringValue)!
            //destinationVC.profileImage = self.foodModelObj.recipeDetailData["MediaObjects"]![0][IMAGE_URL_KEY].stringValue
            //destinationVC.recipeNameStr = (self.foodModelObj.recipeDetailData["dishName"]?.stringValue)!
            destinationVC.spiceLevel = spiceLevel
            destinationVC.cookId = foodModelObj.cookId
            destinationVC.orderServing = orderServing
            destinationVC.singleOrder = true
            
        } else if segue.identifier == "toCookAvailableIdentifier" {
            
            let destination = segue.destination as! CookAvailabilityCalendar
            destination.cookId = foodModelObj.cookId
            destination.recipeId = foodModelObj.recipeId
            
        } else if segue.identifier == "deleteRecipeSegue" {
            
            let destination = segue.destination as! OrderVC
            destination.tableviewCellIndex = tableViewIndex
            destination.collectionViewCellIndex = collectionViewIndex
            destination.flagValue = Int(Helper.getUserDefaultValue(key: "orderType")!)! + 1
            
        }
    }
    
    
    // MARK: Back Button
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 23 2017
    // Input Parameters :   N/A.
    // Purpose          :   Back to previous screen.
    //>---------------------------------------------------------------------------------------------------
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func tapToSeeMoreIngredient(_ sender: Any) {
        
    }
    
    
    
    // MARK: FavourateButton
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 23 2017
    // Input Parameters :   N/A.
    // Purpose          :   Mark recipe to favourate.
    //>---------------------------------------------------------------------------------------------------
    @IBAction func favourateButtonTapped(_ sender: UIButton) {
        
        print(sender.tag)
        
        //Calculate which cell to be update for like functionality
        let tableviewCell = sender.tag / 10
        let collectionviewCell = sender.tag % 10
        var recipeID  = String()
        
        //getting recipe id.
        if tableviewCell == 6 {
            recipeID = foodModelObj.cookRecipeData[collectionviewCell][ID_KEY].stringValue
        } else if tableviewCell == 7 {
            recipeID = foodModelObj.similarRecipeData[collectionviewCell][ID_KEY].stringValue
        } else {
            recipeID = (foodModelObj.recipeDetailData[ID_KEY]?.stringValue)!
        }
        
        
        
        if Helper.getUserDefaultValue(key: GUEST_KEY) == "1" {
            //For Guest User
            Helper.removeUserDefault(key: TOKEN_KEY)
        } else {
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
            
            
            favourateModelObj.favourateRecipeData(recipeId: recipeID) { (success) in
                if success {
                    
                    if self.favourateModelObj.favorite {
                        
                        if tableviewCell == 6 {
                            self.foodModelObj.cookRecipeData[collectionviewCell]["favorite"] = true
                            
                            let indexPath = IndexPath(row: tableviewCell, section: 0)
                            let cell: CookRecipeTableViewCell = self.foodTableview.cellForRow(at: indexPath) as! CookRecipeTableViewCell
                            let collectionViewindexPath = IndexPath(row: collectionviewCell, section: 0)
                            cell.cookRecipeCollectionview.reloadItems(at: [collectionViewindexPath])
                            
                        } else if tableviewCell == 7 {
                            self.foodModelObj.similarRecipeData[collectionviewCell]["favorite"] = true
                            
                            let indexPath = IndexPath(row: tableviewCell, section: 0)
                            let cell: SimilarRecipeTableViewCell = self.foodTableview.cellForRow(at: indexPath) as! SimilarRecipeTableViewCell
                            let collectionViewindexPath = IndexPath(row: collectionviewCell, section: 0)
                            cell.similarCollectionView.reloadItems(at: [collectionViewindexPath])
                            
                        } else {
                            //For indexpath 1
                            self.foodModelObj.favorite = true
                            let indexPath = IndexPath(item: 1, section: 0)
                            self.foodTableview.reloadRows(at: [indexPath], with: .automatic)
                            self.foodTableview.reloadData()
                        }
                        
                    }else{
                        self.foodModelObj.favorite = false
                        
                        if tableviewCell == 6 {
                            
                            self.foodModelObj.cookRecipeData[collectionviewCell]["favorite"] = false
                            
                            let indexPath = IndexPath(row: tableviewCell, section: 0)
                            let cell: CookRecipeTableViewCell = self.foodTableview.cellForRow(at: indexPath) as! CookRecipeTableViewCell
                            let collectionViewindexPath = IndexPath(row: collectionviewCell, section: 0)
                            cell.cookRecipeCollectionview.reloadItems(at: [collectionViewindexPath])
                            
                        } else if tableviewCell == 7 {
                            
                            self.foodModelObj.similarRecipeData[collectionviewCell]["favorite"] = false
                            
                            let indexPath = IndexPath(row: tableviewCell, section: 0)
                            let cell: SimilarRecipeTableViewCell = self.foodTableview.cellForRow(at: indexPath) as! SimilarRecipeTableViewCell
                            let collectionViewindexPath = IndexPath(row: collectionviewCell, section: 0)
                            cell.similarCollectionView.reloadItems(at: [collectionViewindexPath])
                            
                        }else {
                            //For indexpath 1
                            let indexPath = IndexPath(item: 1, section: 0)
                            self.foodTableview.reloadRows(at: [indexPath], with: .automatic)
                            self.foodTableview.reloadData()
                        }
                        
                        
                    }
                }else {
                    print("recipe like not Successful")
                }
            }
        }
    }
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 23 2017
    // Input Parameters :   Message String.
    // Purpose          :   Show alert when error occur.
    //>---------------------------------------------------------------------------------------------------
    func showAlertWithMessage(alertMessage:String )
    {
        let alertController = UIAlertController(title:ALERT_TITLE.APP_NAME, message:alertMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action:UIAlertAction!) in
          
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    @IBAction func seeAllButtonTapped(_ sender: UIButton) {
        
        if sender.tag == 1 {
            
        } else {
            
        }
    }
    
    @IBAction func preparationMethodSeeMore(_ sender: UIButton) {
        
        
        let indexPath = IndexPath(row: 3, section: 0)
        let cell: PreparationMethodTableViewCell = self.foodTableview.cellForRow(at: indexPath) as! PreparationMethodTableViewCell

        
        if cell.seeMoreButtonOutlet.tag == 1 {
            seeMoreCheckPreparation = 8
            foodTableview.reloadRows(at: [indexPath], with: .automatic)
        } else {
            seeMoreCheckPreparation = 3
            foodTableview.reloadRows(at: [indexPath], with: .automatic)
        }
    }
}





extension FoodDetailVC: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print(foodModelObj.tableviewArrayCount)
        return foodModelObj.tableviewArrayCount
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("IndexPath value\(indexPath.row)")
        
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "recipeImageCell", for: indexPath) as! RecipeImageTableviewCell
            
            //Create ImageSlider
            for (i, element) in foodModelObj.imageArray.enumerated(){
                let imageView = UIImageView()
                let recipeType = UIImageView()
                
                imageView.sd_setImage(with: URL(string: element[IMAGE_URL_KEY].stringValue), placeholderImage:UIImage(named: "recipePlaceholder"), options: .refreshCached)
                
                let xPosition = self.view.frame.width * CGFloat(i)
                //cell.RecipeImageScrollview.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
                //imageView.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
                imageView.contentMode = .scaleToFill
                imageView.frame = CGRect(x: xPosition, y: 0, width: UIScreen.main.bounds.size.width, height: cell.RecipeImageScrollview.frame.size.height)
                
                cell.RecipeImageScrollview.contentSize.width = cell.RecipeImageScrollview.frame.width * CGFloat(i + 1)
                cell.RecipeImageScrollview.addSubview(imageView)
                
                recipeType.frame = CGRect(x: (self.view.frame.width - 24), y: cell.RecipeImageScrollview.frame.size.height - 24, width: 20, height: 20)
                
                if foodModelObj.foodType == "Non-Veg" {
                     recipeType.image = #imageLiteral(resourceName: "non-veg")
                } else {
                     recipeType.image = #imageLiteral(resourceName: "veg")
                }
               
                imageView.addSubview(recipeType)
                
            }
            
            //cell.scrollviewHeightConstraint.constant = UIScreen.main.bounds.size.height * 0.407
            cell.RecipeImageScrollview.isPagingEnabled = true
            cell.contentView.layoutSubviews()
            return cell
        }
            
            
            
        else if indexPath.row == 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "recipeDetailCell", for: indexPath) as! RecipeDetailTableViewCell
            
          
            cell.collectionviewHeight.constant = UIScreen.main.bounds.size.height * 0.150
            cell.profielImageview.contentMode = .scaleAspectFill
            
            DispatchQueue.main.async {
                // Asynchronous code running on the main queue
                cell.backgroundViewOutlet.layer.cornerRadius =  cell.backgroundViewOutlet.bounds.size.height / 2
                cell.profielImageview.layer.cornerRadius =  cell.profielImageview.bounds.size.height / 2
            }
            
            cell.backgroundViewOutlet.setNeedsLayout()
            cell.backgroundViewOutlet.layoutIfNeeded()
            
            cell.profielImageview.setNeedsLayout()
            cell.profielImageview.layoutIfNeeded()
            
            cell.profielImageview.sd_setImage(with: URL(string: (self.foodModelObj.profile["profileUrl"]?.stringValue)!), placeholderImage:UIImage(named: "recipePlaceholder"), options: .refreshCached)
            
            //cell.profielImageview.layer.shadowColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            cell.profielImageview.layer.shadowOpacity = 1
            cell.profielImageview.layer.shadowOffset = CGSize(width: -1 , height: 0)
            cell.profielImageview.layer.shadowRadius = 20
            cell.profielImageview.layer.shadowPath = UIBezierPath(rect: cell.profielImageview.bounds).cgPath
            cell.profielImageview.layer.shouldRasterize = false
            
            
            cell.starRatingView.halfRatings = true
            cell.starRatingView.rating = (self.foodModelObj.recipeDetailData["rating"]?.floatValue)!
            cell.recipeNameLabel.text = self.foodModelObj.recipeDetailData["dishName"]?.stringValue
            cell.cookNameLabel.text = self.foodModelObj.profile["fullName"]?.stringValue
            
          
            //For favourite
            if self.foodModelObj.favorite {
                cell.favouriteButtonOutlet.tintColor = #colorLiteral(red: 0.8859999776, green: 0.172999993, blue: 0.1689999998, alpha: 1)
            } else {
                cell.favouriteButtonOutlet.tintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            }
           
            print(Helper.getUserDefaultValue(key: "orderType")!)
            
            if Helper.getUserDefaultValue(key: "orderType")! == "0" {
                //unhide
                cell.stackviewHeightConstraint.constant = 43
                //cell.stackVerticalHeightConstraint.constant = 15
                //cell.spiceLevelTextfield.isHidden  = false
                //cell.orderServingTextfield.isHidden  = false
                cell.downArrowImageview.isHidden = false
                cell.orderDownArrow.isHidden = false

            } else if Helper.getUserDefaultValue(key: "orderType")! == "1" {
                //hide
                cell.stackviewHeightConstraint.constant = 0
//                cell.stackVerticalHeightConstraint.constant = 0
//                cell.spiceLevelTextfield.isHidden  = true
//                cell.orderServingTextfield.isHidden  = true
                cell.downArrowImageview.isHidden = true
                 cell.orderDownArrow.isHidden = true
            }
            
            
            
            //Creating Picker For Selection.
            //Toolbar for pickerview
            let toolbar = UIToolbar()
            let cancelButton = UIBarButtonItem (barButtonSystemItem: .cancel, target: nil, action: #selector(pickerCancelPressed))
            let doneButton = UIBarButtonItem (barButtonSystemItem: .done, target: nil, action: #selector(pickerDonePressed))
            let flexButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            toolbar.setItems([cancelButton,flexButton, doneButton], animated: true)
            
            doneButton.tintColor = #colorLiteral(red: 0.8862745098, green: 0.1725490196, blue: 0.168627451, alpha: 1)
            cancelButton.tintColor = #colorLiteral(red: 0.8862745098, green: 0.1725490196, blue: 0.168627451, alpha: 1)
            toolbar.sizeToFit()
            
            cell.spiceLevelTextfield.inputAccessoryView = toolbar
            cell.spiceLevelTextfield.inputView = PickerView
            cell.spiceLevelTextfield.tag = 1
            cell.orderServingTextfield.inputAccessoryView = toolbar
            cell.orderServingTextfield.inputView = PickerView
            
            //collection view part.
            cell.collectionViewType.delegate = self
            cell.collectionViewType.dataSource = self
            cell.collectionViewType.reloadData()
            
            self.foodTableview.layoutIfNeeded()
            return cell
        }
            
            
            
        else if indexPath.row == 2 {
            
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "viewIngredientCell", for: indexPath) as! ViewIngredientsTableViewCell
            
            if ingredientCellCheck {
                
                ingredientCellCheck = false
                
                for (_, element) in self.foodModelObj.ingredientArray.enumerated() {
                    
                    let textLabel = UILabel()
                    let unitFullName    = element["Unit"]["unitName"].stringValue
                    let unitFullNameArr = unitFullName.components(separatedBy: " ")
                    
                    textLabel.text  = element["qty"].stringValue + " " + unitFullNameArr[0]
                    textLabel.textAlignment = .left
                    
                    let textLabel2 = UILabel()
                    textLabel2.text  = element["name"].stringValue
                    textLabel2.textAlignment = .left
                    
                    let child1stackView   = UIStackView()
                    child1stackView.axis  = .horizontal
                    child1stackView.distribution  = .fillEqually
                    child1stackView.alignment = .center
                    child1stackView.spacing   = 5.0
                    
                    child1stackView.addArrangedSubview(textLabel)
                    child1stackView.addArrangedSubview(textLabel2)
                    
                    
                    //let seperatorView = UIView()
                    //seperatorView.translatesAutoresizingMaskIntoConstraints = false
                    //seperatorView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                    //seperatorView.topAnchor.constraint(equalTo: child1stackView.bottomAnchor, constant: 0).isActive = true
                    //seperatorView.leadingAnchor.constraint(equalTo: child1stackView.leadingAnchor, constant: 0).isActive = true
                    //seperatorView.trailingAnchor.constraint(equalTo: child1stackView.trailingAnchor, constant: 0).isActive = true
                    //seperatorView.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
                    cell.parentStackview.addArrangedSubview(child1stackView)
                    
                    
                    // MARK: Edit Recipe Ingredient List
                    //creating Singleton Ingredient Array for edit dish
                    var tempDictionary = [String: String]()
                    tempDictionary["name"] = element["name"].stringValue
                    tempDictionary["qty"] = element["qty"].stringValue
                    tempDictionary["sortName"] = element["Unit"]["sortName"].stringValue
                    tempDictionary["cost"] = element["cost"].stringValue
                    tempDictionary["unitId"] = element["Unit"][ID_KEY].stringValue
                    Singleton.instance.ingredientArray.append(tempDictionary)

                }
            }
            
            
            
            return cell
        }
            
            
        else if indexPath.row == 3 {
            
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "preparationMethodCell", for: indexPath) as! PreparationMethodTableViewCell
            
            /*
            let tempArray = ["Heat a pan with oil. Add bay leaf, cinnamon and cardamoms. Saute for a minute.",
                            "Add ginger garlic paste and saute on a low heat till the raw smell goes away. This takes about 2 to 3 mins."
                            ] */
            
            if preperationCellCheck {
                
                preperationCellCheck = false
                
                print(self.foodModelObj.preperationMethod)
                
                for (index, element) in self.foodModelObj.preperationMethod.enumerated() {
                    
                    let textLabel = UILabel()
                    textLabel.numberOfLines = 0
                    textLabel.textAlignment = NSTextAlignment.justified
                    textLabel.text =  String(index + 1) + "." + " " + element["method"].stringValue
                    cell.preperationStackView.addArrangedSubview(textLabel)
                    
                    if (index + 1) == seeMoreCheckPreparation {
                        //preperationCellCheck = false
                        break
                    }
                }
            }
            
            return cell
        }
            
            
        else if indexPath.row == 4 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "preparationTimeCell", for: indexPath) as! PreparationTimeTableViewCell
            cell.preperationTimeLabel.text = foodModelObj.preparationTime
            cell.cookTimeLabel.text =  foodModelObj.cookTime
            cell.serveLabel.text = foodModelObj.serve
            
            return cell
        }
            
            
        else if indexPath.row == 5 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "nutritionInfoCell", for: indexPath) as! NutritionInfoTableViewCell
            
            /*
            
            // Protein......
            if foodModelObj.totalDaily["PROCNT"] == nil {
                cell.proteinLabelOutlet.text = "Protein :" + "0 %"
            }else {
                cell.proteinLabelOutlet.text =  "Protein : " + String(format: "%.2f", foodModelObj.totalDaily["PROCNT"]!["quantity"].floatValue) + foodModelObj.totalDaily["PROCNT"]!["unit"].stringValue
            }
            
            // Carbohydats.......
            if foodModelObj.totalDaily["CHOCDF"] == nil {
                
                cell.carbohydratesLabelOutlet.text = "Carbohydrates :" + "0 %"
            }else {
                cell.carbohydratesLabelOutlet.text = "Carbohydrates : " + String(format: "%.2f", foodModelObj.totalDaily["CHOCDF"]!["quantity"].floatValue ) + foodModelObj.totalDaily["PROCNT"]!["unit"].stringValue
            }
          
            
            //calories
            cell.caloriesLabelOutlet.text = "Calories : " +  "0 %"
            
            
            //fat
            if foodModelObj.totalDaily["FAT"] == nil {
                
                 cell.fatLabelOutlet.text = "Fat : " + "0 %"
            }else {
                 cell.fatLabelOutlet.text = "Fat : " + String( format: "%.2f", foodModelObj.totalDaily["FAT"]!["quantity"].floatValue) + foodModelObj.totalDaily["PROCNT"]!["unit"].stringValue
            }
            
            //Other
            cell.otherLabelOutlet.text =  "" */
            
            return cell
        }
            
        else if indexPath.row == 6 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cookRecipeCell", for: indexPath) as! CookRecipeTableViewCell
            
            cell.titleNameTextLabel.text = foodModelObj.cookName + "'s" + " " + "Kitchen"
            cell.contentView.layoutIfNeeded()
            
            if Helper.getUserDefaultValue(key: "orderType")! == "0" {
                //unhide
                cell.collectionviewHeightConstraint.constant = UIScreen.main.bounds.size.height * 0.4248

            } else if Helper.getUserDefaultValue(key: "orderType")! == "1" {
                //hide
                cell.collectionviewHeightConstraint.constant = UIScreen.main.bounds.size.height * 0.3359
            }
            
            
            cell.cookRecipeCollectionview.tag = 1
            cell.cookRecipeCollectionview.delegate = self
            cell.cookRecipeCollectionview.dataSource = self
            cell.cookRecipeCollectionview.reloadData()
            
            return cell
        }
            
            
        else if indexPath.row == 7 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "similarRecipeCell", for: indexPath) as! SimilarRecipeTableViewCell
         
            if Helper.getUserDefaultValue(key: "orderType")! == "0" {
                //unhide
               cell.similarCollectionviewHeightConstraint.constant = UIScreen.main.bounds.size.height * 0.4248
                
            } else if Helper.getUserDefaultValue(key: "orderType")! == "1" {
                //hide
                cell.similarCollectionviewHeightConstraint.constant = UIScreen.main.bounds.size.height * 0.3359
            }
            
            cell.similarCollectionView.tag = 2
            cell.similarCollectionView.delegate = self
            cell.similarCollectionView.dataSource = self
            cell.similarCollectionView.reloadData()
            return cell
        }
        
        
        return UITableViewCell()
    }
    
    

    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 4 {
            if Helper.getUserDefaultValue(key: "orderType")! == "0" {
                return 0.0
            } else {
                return UITableViewAutomaticDimension
            }
            
        } else {
            return UITableViewAutomaticDimension
        }

    }
    
    
    
    @objc func pickerDonePressed() {
        
        let indexPath = IndexPath(row: 1, section: 0)
        let cell: RecipeDetailTableViewCell = self.foodTableview.cellForRow(at: indexPath) as! RecipeDetailTableViewCell
        
        if pickerBool {
            print("Spice Level\(SPICE_LEVEL)")
            cell.spiceLevelTextfield.text = SPICE_LEVEL[selectedSpiceValue]
            spiceLevel = cell.spiceLevelTextfield.text!
        }else {
            
            let serveValue = String(foodModelObj.orderOfServing[selectedOrderValue])
            cell.orderServingTextfield.text = serveValue + " " + "Serve"
            orderServing =  cell.orderServingTextfield.text!
        }
        
        self.view.endEditing(true)
        
    }
    
    
    @objc func pickerCancelPressed() {
        self.view.endEditing(true)
    }
   
}



extension FoodDetailVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    
    // MARK: Collectionview delegate tha datasource method.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView.tag == 1 {
             return foodModelObj.cookRecipeData.count
        }  else if collectionView.tag == 3 {
            return foodModelObj.details.count
        } else {
            return foodModelObj.similarRecipeData.count
        }
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if let cell: CookRecipeCollectionviewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CookRecipeCollectionviewCell  {
            
            cell.recipeImageView.contentMode = .scaleAspectFill
            cell.recipeImageView.sd_setImage(with: URL(string: foodModelObj.cookRecipeData[indexPath.row]["MediaObjects"][0][IMAGE_URL_KEY].stringValue), placeholderImage:UIImage(named: "recipePlaceholder"), options: .refreshCached)
            cell.recipeNameLabel.text = foodModelObj.cookRecipeData[indexPath.row]["dishName"].stringValue
            cell.costPerServingLabel.text =  foodModelObj.cookRecipeData[indexPath.row]["currencySymbol"].stringValue + foodModelObj.cookRecipeData[indexPath.row]["costPerServing"].stringValue + " " + "Per Serving"
           
            Helper.saveUserDefaultValue(key: CURRENCY_SYMBOL_KEY, value: foodModelObj.cookRecipeData[indexPath.row]["currencySymbol"].stringValue)
            
            //Tagging for favourate button.
            cell.cookfavourateButtonOutlet.tag = 6*10 + indexPath.row
            
            //Rating
            cell.ratingView.halfRatings = true
            cell.ratingView.rating = foodModelObj.cookRecipeData[indexPath.row]["rating"].floatValue
            
            //Favourite
            if foodModelObj.cookRecipeData[indexPath.row]["favorite"].boolValue {
                cell.cookfavourateButtonOutlet.tintColor = #colorLiteral(red: 0.8859999776, green: 0.172999993, blue: 0.1689999998, alpha: 1)
            } else {
                cell.cookfavourateButtonOutlet.tintColor = #colorLiteral(red: 0.8196078431, green: 0.8196078431, blue: 0.8196078431, alpha: 1)
            }
            
            // foodType
            
            if foodModelObj.cookRecipeData[indexPath.row]["foodType"].stringValue == "Veg" {
                cell.foodTypeImage.image = #imageLiteral(resourceName: "veg")
            } else {
                cell.foodTypeImage.image = #imageLiteral(resourceName: "non-veg")
            }

            //OrderDateTime
            cell.orderDateLabel.text = "Order By: " + Helper.getDate(date: foodModelObj.cookRecipeData[indexPath.row]["orderByDateTime"].stringValue)
            
            print(Helper.getUserDefaultValue(key: "orderType")!)
            
            //For Hide and Unhide
            if Helper.getUserDefaultValue(key: "orderType")! == "0" {
                
                //unhide
                cell.orderDateHeightConstraint.constant = 17
                cell.verticalHeigthConstraint.constant = 8
                cell.priceLableHeightConstraint.constant = 19
                cell.imageviewHeightConstraint.constant = collectionView.frame.size.height * 0.52
                
            } else if Helper.getUserDefaultValue(key: "orderType")! == "1" {
                
                //hide
                cell.orderDateHeightConstraint.constant = 0
                cell.verticalHeigthConstraint.constant = 0
                cell.priceLableHeightConstraint.constant = 0
                cell.imageviewHeightConstraint.constant = collectionView.frame.size.height * 0.64
                
            }
            
            
            
            
            return cell
        }
         
            
       else if let cell: DetailstypeCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? DetailstypeCollectionViewCell  {
            
            cell.detailsCellImageView.image = foodModelObj.details[indexPath.row]["imagetype"] as? UIImage
            cell.detailsTextLabel.text = foodModelObj.details[indexPath.row]["typeText"] as? String
            cell.detailTypeTextLabel.text = foodModelObj.details[indexPath.row][TYPE_KEY] as? String
            
            return cell
            
        }
        
        
        else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? SimilarCollectionViewCell
            cell?.recipeImageView.contentMode = .scaleAspectFill
            cell?.recipeImageView.sd_setImage(with: URL(string: foodModelObj.similarRecipeData[indexPath.row]["MediaObjects"][0][IMAGE_URL_KEY].stringValue), placeholderImage:UIImage(named: "recipePlaceholder"), options: .refreshCached)
            cell?.recipeNameLabel.text = foodModelObj.similarRecipeData[indexPath.row]["dishName"].stringValue
            cell?.costPerServingLabel.text = foodModelObj.similarRecipeData[indexPath.row]["costPerServing"].stringValue + " " + "Per Serving"
            
            //Tagging for favourate button
            cell?.similarFavouratebuttonTapped.tag = 7*10 + indexPath.row
            
            //Favourite
            if foodModelObj.similarRecipeData[indexPath.row]["favorite"].boolValue {
                cell?.similarFavouratebuttonTapped.tintColor = #colorLiteral(red: 0.8859999776, green: 0.172999993, blue: 0.1689999998, alpha: 1)
            } else {
                cell?.similarFavouratebuttonTapped.tintColor = #colorLiteral(red: 0.8196078431, green: 0.8196078431, blue: 0.8196078431, alpha: 1)
            }
            
            //OrderDateTime
            let orderDateTime    = foodModelObj.similarRecipeData[indexPath.row]["orderByDateTime"].stringValue
            let orderDateTimeArr = orderDateTime.components(separatedBy: " ")
            cell?.orderDateLabel.text = "Order By:" + orderDateTimeArr[0]
            
            
            if foodModelObj.similarRecipeData[indexPath.row]["foodType"].stringValue == "Veg" {
                cell?.foodTypeImage.image = #imageLiteral(resourceName: "veg")
            } else {
                cell?.foodTypeImage.image = #imageLiteral(resourceName: "non-veg")
            }
            
              
            //For Hide and Unhide
            if Helper.getUserDefaultValue(key: "orderType")! == "0" {
                
                //unhide
                cell?.orderDateHeightConstraint.constant = 17
                cell?.verticalHeightConstraint.constant = 8
                cell?.priceLabelHeightConstraint.constant = 19
                cell?.imageviewHeightConstraint.constant = collectionView.frame.size.height * 0.52
                
            } else if Helper.getUserDefaultValue(key: "orderType")! == "1" {
                
                //hide
                cell?.orderDateHeightConstraint.constant = 0
                cell?.verticalHeightConstraint.constant = 0
                cell?.priceLabelHeightConstraint.constant = 0
                cell?.imageviewHeightConstraint.constant = collectionView.frame.size.height * 0.64
                
            }
            
            return cell!
        }
        
        
     
       
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let foodVC: FoodDetailVC = self.storyboard!.instantiateViewController(withIdentifier: self.restorationIdentifier!) as! FoodDetailVC
        
        if collectionView.tag == 1 {
            foodVC.recipeId = foodModelObj.cookRecipeData[indexPath.row][ID_KEY].stringValue
            self.navigationController?.pushViewController(foodVC, animated: true)
        } else if collectionView.tag == 2 {
            foodVC.recipeId = foodModelObj.similarRecipeData[indexPath.row][ID_KEY].stringValue
            self.navigationController?.pushViewController(foodVC, animated: true)
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //for tableview index 1
        if collectionView.tag == 3 {
             return CGSize(width: UIScreen.main.bounds.size.width * 0.231 , height: UIScreen.main.bounds.size.height * 0.125);
        } else {
            return CGSize(width: UIScreen.main.bounds.size.width * 0.375 , height: collectionView.bounds.size.height);
        }
    }
}





extension FoodDetailVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerBool {
             return SPICE_LEVEL.count
        } else {
            return foodModelObj.orderOfServing.count
        }
       
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerBool {
            return SPICE_LEVEL[row]
        } else {
            return String(foodModelObj.orderOfServing[row])
        }
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            selectedSpiceValue = row
        } else {
            selectedOrderValue = row
        }
    }
}



