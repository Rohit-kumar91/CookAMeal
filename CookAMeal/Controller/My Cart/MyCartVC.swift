//
//  MyCartVC.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 14/02/18.
//  Copyright © 2018 Cynoteck. All rights reserved.
//

import UIKit
import JGProgressHUD
import SwiftyJSON
import CRNotifications


class MyCartVC: UIViewController {

    @IBOutlet weak var myCartTableview: UITableView!
    @IBOutlet weak var menuButtonOutlet: UIButton!
  
    @IBOutlet weak var emptyMessageStackview: UIStackView!
    @IBOutlet weak var viewRecipeButtonOutlet: UIButton!
    @IBOutlet weak var checkOutButtonOutlet: RoundedButton!
    @IBOutlet weak var seperatorViewOutlet: UIView!
    @IBOutlet weak var totalPriceLabelOutlet: UILabel!
    @IBOutlet weak var priceCountItemLabelOutlet: UILabel!
    @IBOutlet weak var deliveryCharges: UILabel!
    @IBOutlet weak var priceStackview: UIStackView!
    
    let myModelObj: MyCartModel = MyCartModel()
    var recipeId = String()
    var flagCount = Int()
    var tempServingCount = 1
    let currencySymbol = Helper.getUserDefaultValue(key: CURRENCY_SYMBOL_KEY)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Singleton.instance.goBackToCart = true
        
        self.revealViewController().delegate = self
        self.myCartTableview.dataSource = self
        self.myCartTableview.delegate = self
        self.myCartTableview.estimatedRowHeight =  118
        self.myCartTableview.rowHeight = UITableViewAutomaticDimension
        
        deliveryCharges.text = "(excluding delivery charge " + Helper.getUserDefaultValue(key: CURRENCY_SYMBOL_KEY)! + myModelObj.maxDeliveryFee + " )"
        getCartRecipedata()
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 80
        menuButtonOutlet.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
    }
    
    
     @IBAction func unwindToCancelOrder(segue:UIStoryboardSegue) { }
    
    
    func getCartRecipedata() {
        let hud = JGProgressHUD(style: .light)
        hud.show(in: self.view)
        hud.textLabel.text = "Loading"
        
        myModelObj.getCartRecipe { (success) in
            hud.dismiss()
            if success {
                
                if self.myModelObj.newJSONData.count == 0 {
                    self.myCartTableview.isHidden = true
                    self.emptyMessageStackview.isHidden = false
                    self.viewRecipeButtonOutlet.isHidden = false
                    self.seperatorViewOutlet.isHidden = true
                    self.totalPriceLabelOutlet.isHidden = true
                    self.deliveryCharges.isHidden = true
                    self.priceCountItemLabelOutlet.isHidden = true
                    self.checkOutButtonOutlet.isHidden = true
                    self.priceStackview.isHidden = true
                    
                    
                } else {
                    self.myCartTableview.isHidden = false
                    self.emptyMessageStackview.isHidden = true
                    self.viewRecipeButtonOutlet.isHidden = true
                    self.seperatorViewOutlet.isHidden = false
                    self.totalPriceLabelOutlet.isHidden = false
                    self.priceCountItemLabelOutlet.isHidden = false
                    self.checkOutButtonOutlet.isHidden = false
                    self.deliveryCharges.isHidden = false
                    self.priceStackview.isHidden = false
                    
                    self.totalPriceLabelOutlet.text = Helper.getUserDefaultValue(key: CURRENCY_SYMBOL_KEY)! + self.myModelObj.totalPrice
                    self.priceCountItemLabelOutlet.text = "Price of " + self.myModelObj.totalItem +  "items."
                    self.deliveryCharges.text = "(excluding delivery charge " + Helper.getUserDefaultValue(key: CURRENCY_SYMBOL_KEY)! + self.myModelObj.maxDeliveryFee + " )"
                    self.myCartTableview.reloadData()
                }
               
                
            } else {
                
                if self.myModelObj.statusCode == "200" {
                    if self.myModelObj.newJSONData.count == 0 {
                        self.myCartTableview.isHidden = true
                        self.emptyMessageStackview.isHidden = false
                        self.viewRecipeButtonOutlet.isHidden = false
                        self.seperatorViewOutlet.isHidden = true
                        self.totalPriceLabelOutlet.isHidden = true
                        self.deliveryCharges.isHidden = true
                        self.priceCountItemLabelOutlet.isHidden = true
                        self.checkOutButtonOutlet.isHidden = true
                        self.priceStackview.isHidden = true
                        
                        
                    }
                } else {
                    self.present(Helper.globalAlertView(with: "DomesticEat", message: self.myModelObj.alertMessage), animated: true, completion: nil)
                }
                
                
                
                
                
            }
        }
    }
    
    @IBAction func unwindToMyCartVC(segue:UIStoryboardSegue) { }
    
    @IBAction func checkoutButtonTapped(_ sender: Any) {
        //self.performSegue(withIdentifier: "toDeliveryAddressSegue", sender: nil)
        //toOrderSuumaryFood
        
        
        print(myModelObj.totalPrice)
        self.performSegue(withIdentifier: "toOrderSuumaryFood", sender: nil)
    }
    
    
    
    @IBAction func orderFoodButtonTapped(_ sender: RoundedButton) {
        Helper.saveUserDefaultValue(key: "orderType", value: "0") //1 for Order
        self.performSegue(withIdentifier: "cartToDashboardSegue", sender: nil)
    }
    
    
    
    
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   MAR, 23 2018
    // Input Parameters :   N/A.
    // Purpose          :   Increase the serving Count Logic and wedservice implementation.
    //>--------------------------------------------------------------------------------------------------
    @IBAction func servingCountButton(_ sender: UIButton) {
        
        sender.pulsate()
        let section = (sender as AnyObject).tag % 1000
        let row = (sender as AnyObject).tag / 1000
        flagCount = myModelObj.sections[section].cartItemsData[row]["recipeDetails"]["availableServings"].intValue
        let cartId = myModelObj.sections[section].cartItemsData[row][ID_KEY].stringValue
        let recipeId = myModelObj.sections[section].cartItemsData[row]["recipeDetails"][ID_KEY].stringValue
        tempServingCount = myModelObj.sections[section].cartItemsData[row]["noOfServing"].intValue
        
        if sender.titleLabel?.text == "+" {
            print("Plus Tabbed")
            if tempServingCount < flagCount {
                tempServingCount = tempServingCount + 1
                print(tempServingCount)
                servingCounts(cartId: cartId, noOfServing: String(tempServingCount), recipeId: recipeId, section: section, row: row)
            }
        } else {
            print("mius Tabbed")
            if tempServingCount > 1 {
                tempServingCount = tempServingCount - 1
                print(tempServingCount)
                servingCounts(cartId: cartId, noOfServing: String(tempServingCount), recipeId: recipeId, section: section, row: row)
            }
        }
    }
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   MAR, 23 2018
    // Input Parameters :   N/A.
    // Purpose          :   Handle Webserice Part And Data Part.
    //>--------------------------------------------------------------------------------------------------
    func servingCounts(cartId: String, noOfServing: String, recipeId: String, section: Int, row: Int) {
        
        let hud = JGProgressHUD(style: .light)
        hud.show(in: self.view)
        hud.textLabel.text = "Loading"
        
        myModelObj.addServingLevel(cartId: cartId, recipeId: recipeId, noOfServing: noOfServing) { (success) in
            hud.dismiss()
            if success {
                self.myModelObj.newJSONData[section]["CartItems"][row][ID_KEY] = self.myModelObj.noOfServing[ID_KEY]
                self.myModelObj.newJSONData[section]["CartItems"][row]["spiceLevel"] = self.myModelObj.noOfServing["spiceLevel"]
                self.myModelObj.newJSONData[section]["CartItems"][row]["noOfServing"] = self.myModelObj.noOfServing["noOfServing"]
               // self.myModelObj.newJSONData[section]["CartItems"][row]["price"] = self.myModelObj.noOfServing["price"]
                
                print(self.myModelObj.totalPrice)
                self.totalPriceLabelOutlet.text = Helper.getUserDefaultValue(key: CURRENCY_SYMBOL_KEY)! + self.myModelObj.totalPrice
                
                self.myModelObj.sections.removeAll()
                for cart in  self.myModelObj.newJSONData {
                    self.myModelObj.sections.append(Section(genre: cart["fullName"].stringValue,
                                                            profileImage: cart["profileUrl"].stringValue,
                                                            cartItemsData: cart["CartItems"].arrayValue,
                                                            radiocheck: cart["genderFull"].stringValue,
                                                            expanded: true))
                }
                
                let indexPath = IndexPath(item: row, section: section)
                self.myCartTableview.reloadRows(at: [indexPath], with: .none)
                
            }else{
                CRNotifications.showNotification(type: CRNotifications.error, title: "No. of Serving!", message: self.myModelObj.alertMessage, dismissDelay: 3)
            }
        }
    }
    
    
    
  
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   MAR, 23 2018
    // Input Parameters :   N/A.
    // Purpose          :   Change Spice Level.
    //>--------------------------------------------------------------------------------------------------
    @IBAction func spiceLevelButtonOutlet(_ sender: RoundedButton) {
        
        sender.pulsate()
        let section = (sender as AnyObject).tag % 1000
        let row = (sender as AnyObject).tag / 1000
        let spiceLevelStr =  myModelObj.sections[section].cartItemsData[row]["spiceLevel"].stringValue
        var indexNumber = SPICE_LEVEL.index(of: spiceLevelStr)
        let totalCount = SPICE_LEVEL.count
        let cartId = myModelObj.sections[section].cartItemsData[row][ID_KEY].stringValue
        let recipeId = myModelObj.sections[section].cartItemsData[row]["recipeDetails"][ID_KEY].stringValue
        
        if sender.titleLabel?.text == "+" {
            print("Plus Tabbed")
            
            if indexNumber! < totalCount - 1 {
                indexNumber = indexNumber! + 1
                print(SPICE_LEVEL[indexNumber!])
                spiceLevelType(cartId: cartId, spiceLevel: SPICE_LEVEL[indexNumber!], recipeId: recipeId, section: section, row: row)
            }
        } else {
            print("mius Tabbed")
            if indexNumber! >= 0 {
                if indexNumber! != 0 {
                    indexNumber = indexNumber! - 1
                    print(SPICE_LEVEL[indexNumber!])
                    spiceLevelType(cartId: cartId, spiceLevel: SPICE_LEVEL[indexNumber!], recipeId: recipeId, section: section, row: row)
                }
            }
        }
    }
    
    
    
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   MAR, 23 2018
    // Input Parameters :   N/A.
    // Purpose          :   Handle Webservice par of the spice level..
    //>--------------------------------------------------------------------------------------------------
    func spiceLevelType(cartId: String, spiceLevel: String, recipeId: String, section: Int, row: Int) {

       
        let hud = JGProgressHUD(style: .light)
        hud.show(in: self.view)
        hud.textLabel.text = "Loading"
        
        myModelObj.addSpiceLevel(cartId: cartId, recipeId: recipeId, spiceLevel: spiceLevel) { (success) in
            hud.dismiss()
            if success {
                self.myModelObj.newJSONData[section]["CartItems"][row][ID_KEY] = self.myModelObj.spiceLevelData[ID_KEY]
                self.myModelObj.newJSONData[section]["CartItems"][row]["spiceLevel"] = self.myModelObj.spiceLevelData["spiceLevel"]
                self.myModelObj.newJSONData[section]["CartItems"][row]["noOfServing"] = self.myModelObj.spiceLevelData["noOfServing"]
                // self.myModelObj.newJSONData[section]["CartItems"][row]["price"] = self.myModelObj.noOfServing["price"]
                
                print(self.myModelObj.totalPrice)
                self.totalPriceLabelOutlet.text = Helper.getUserDefaultValue(key: CURRENCY_SYMBOL_KEY)! + self.myModelObj.totalPrice
                
                self.myModelObj.sections.removeAll()
                for cart in  self.myModelObj.newJSONData {
                    self.myModelObj.sections.append(Section(genre: cart["fullName"].stringValue,
                                                            profileImage: cart["profileUrl"].stringValue,
                                                            cartItemsData: cart["CartItems"].arrayValue,
                                                            radiocheck: cart["genderFull"].stringValue,
                                                            expanded: true))
                }
                
                let indexPath = IndexPath(item: row, section: section)
                self.myCartTableview.reloadRows(at: [indexPath], with: .none)
                
            }else{
                CRNotifications.showNotification(type: CRNotifications.error, title: "No. of Serving!", message: self.myModelObj.alertMessage, dismissDelay: 3)
            }
        }
        
        
        
        
    }
    
    
    
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   MAR, 23 2018
    // Input Parameters :   N/A.
    // Purpose          :   Navigate to the recipe details screen.
    //>--------------------------------------------------------------------------------------------------
    @IBAction func viewDetailsButtonTapped(_ sender: UIButton) {
        
        let section = (sender as AnyObject).tag % 1000
        let row = (sender as AnyObject).tag / 1000
        recipeId = myModelObj.sections[section].cartItemsData[row]["recipeDetails"][ID_KEY].stringValue
        print(recipeId)
        self.performSegue(withIdentifier: "fromAddToCartToRecipeDetails", sender: nil)
    }
    
    
    
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   MAR, 23 2018
    // Input Parameters :   N/A.
    // Purpose          :   Delete the recipe from the cart (Webservice Implementation).
    //>---------------------------------------------------------------------------------------------------
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        
        
        let alertController = UIAlertController(title:ALERT_TITLE.APP_NAME, message: "Are you sure you want to remove recipe from cart?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action:UIAlertAction!) in
            
            let section = (sender as AnyObject).tag % 1000
            let row = (sender as AnyObject).tag / 1000
            
            let recipeId = self.myModelObj.sections[section].cartItemsData[row][ID_KEY].stringValue
            let hud = JGProgressHUD(style: .light)
            hud.show(in: self.view)
            hud.textLabel.text = "Loading"
            self.myModelObj.deleteRecipeFromCart(id: recipeId) { (success) in
                hud.dismiss()
                if success {
                    
                    var data =  self.myModelObj.newJSONData[section]["CartItems"].arrayValue
                    data.remove(at: row)
                    print("Data\(data)")
                    
                    if data.count > 0 {
                        self.myModelObj.newJSONData[section]["CartItems"] = JSON(data)
                    } else {
                        self.myModelObj.newJSONData[section]["CartItems"] = JSON(data)
                        self.myModelObj.newJSONData.remove(at: section)
                    }
                    
                    self.myModelObj.sections.removeAll()
                    
                    for cart in  self.myModelObj.newJSONData {
                        self.myModelObj.sections.append(Section(genre: cart["fullName"].stringValue,
                                                                profileImage: cart["profileUrl"].stringValue,
                                                                cartItemsData: cart["CartItems"].arrayValue,
                                                                radiocheck: cart["genderFull"].stringValue,
                                                                expanded: true))
                    }
                    
                    print(self.myModelObj.newJSONData)
                    self.myCartTableview.reloadData()
                    
                    if self.myModelObj.newJSONData.count == 0 {
                        self.myCartTableview.isHidden = true
                        self.emptyMessageStackview.isHidden = false
                        self.viewRecipeButtonOutlet.isHidden = false
                        self.seperatorViewOutlet.isHidden = true
                        self.totalPriceLabelOutlet.isHidden = true
                        self.priceCountItemLabelOutlet.isHidden = true
                        self.checkOutButtonOutlet.isHidden = true
                        self.deliveryCharges.isHidden = true
                    }
                    
                    
                    
                    //self.priceCountItemLabelOutlet.text = "Price of " + String(self.myModelObj.sections[section].cartItemsData[row].count) +  "items."
                    
                    self.totalPriceLabelOutlet.text = Helper.getUserDefaultValue(key: CURRENCY_SYMBOL_KEY)! +  self.myModelObj.deleteJSON["price"].stringValue
                    
                    //                self.myCartTableview.beginUpdates()
                    //                for i in 0 ..< self.myModelObj.sections[section].cartItemsData.count {
                    //                    self.myCartTableview.reloadRows(at: [IndexPath(row: i, section: section)], with: .automatic)
                    //                }
                    //                self.myCartTableview.endUpdates()
                    
                } else {
                    //Error Message
                }
            }
            
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action:UIAlertAction!) in
        }))
        
        self.present(alertController, animated: true, completion: nil)
        

    }
    
    
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   MAR, 23 2018
    // Input Parameters :   N/A.
    // Purpose          :   Segue Method.
    //>---------------------------------------------------------------------------------------------------
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "fromAddToCartToRecipeDetails" {
            
            Helper.saveUserDefaultValue(key: "orderType", value: "0")
            let destinationVC = segue.destination as! FoodDetailVC
            destinationVC.recipeId = recipeId
            
        } else if segue.identifier == "toOrderSuumaryFood" {
            
            print("Cook id\(myModelObj.cookId)")
            print("CartId\(myModelObj.cartId)")
            
            let destinationVC = segue.destination as! OrderFoodSummaryVC
            destinationVC.cookId = myModelObj.cookId
            destinationVC.cartId =  myModelObj.cartId
            destinationVC.serviceCallCheck = true
            
            print(myModelObj.totalPrice)
            destinationVC.price = Double(myModelObj.totalPrice)!
            
        } else if segue.identifier == "cartToDashboardSegue" {
           let destinationVC = segue.destination as! DashboardVC
           destinationVC.cartCheckForMenuSelection = true
            
        }
    }
    
    
    @IBAction func readMoreButtonTapped(_ sender: UIButton) {
        
        let section = (sender as AnyObject).tag % 1000
        let row = (sender as AnyObject).tag / 1000
        
        myModelObj.newJSONData[section]["CartItems"][row]["recipeId"] = "1"
        self.myModelObj.sections.removeAll()
        
        for cart in  self.myModelObj.newJSONData {
            self.myModelObj.sections.append(Section(genre: cart["fullName"].stringValue,
                                                    profileImage: cart["profileUrl"].stringValue,
                                                    cartItemsData: cart["CartItems"].arrayValue,
                                                    radiocheck: cart["genderFull"].stringValue,
                                                    expanded: true))
        }
        let indexPath = IndexPath(item: row, section: section)
        self.myCartTableview.reloadRows(at: [indexPath], with: .automatic)
        
    }
    
    
   
    @IBAction func readLessButtonTapped(_ sender: UIButton) {
        let section = (sender as AnyObject).tag % 1000
        let row = (sender as AnyObject).tag / 1000
        
        myModelObj.newJSONData[section]["CartItems"][row]["recipeId"] = "0"
        self.myModelObj.sections.removeAll()
        
        for cart in  self.myModelObj.newJSONData {
            self.myModelObj.sections.append(Section(genre: cart["fullName"].stringValue,
                                                    profileImage: cart["profileUrl"].stringValue,
                                                    cartItemsData: cart["CartItems"].arrayValue,
                                                    radiocheck: cart["genderFull"].stringValue,
                                                    expanded: true))
        }
        let indexPath = IndexPath(item: row, section: section)
        self.myCartTableview.reloadRows(at: [indexPath], with: .automatic)
        
    }
}




extension MyCartVC: UITableViewDataSource, UITableViewDelegate, ExpandableHeaderViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return myModelObj.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myModelObj.sections[section].cartItemsData.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        print(myModelObj.sections[indexPath.section].cartItemsData[indexPath.row]["recipeId"].stringValue)
        if myModelObj.sections[indexPath.section].cartItemsData[indexPath.row]["recipeId"].stringValue == "0" {
            return 140
        } else {
            return 313
        }
        
        
//        if (myModelObj.sections[indexPath.section].expanded) {
//            return 267
//        } else {
//            return 0
//        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = ExpandableHeaderView()
        header.customInit(title: myModelObj.sections[section].genre, section: section, profileImage: myModelObj.sections[section].profileImage, radioCheck: myModelObj.sections[section].radiocheck, delegate: self)
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cartCell") as! MyCartCell
        //cell.textLabel?.text = sections[indexPath.section].cartItemsData[indexPath.row]
        
        let currencySymbol =  Helper.getUserDefaultValue(key: CURRENCY_SYMBOL_KEY)!
        
        cell.recipeNameLabel.text = myModelObj.sections[indexPath.section].cartItemsData[indexPath.row]["recipeDetails"]["dishName"].stringValue
        
        cell.availableLabel.text =  myModelObj.sections[indexPath.section].cartItemsData[indexPath.row]["recipeDetails"]["availableServings"].stringValue
        
        cell.categoryLabel.text =  myModelObj.sections[indexPath.section].cartItemsData[indexPath.row]["recipeDetails"]["categoryName"].stringValue
        
        cell.costPerServingLabel.text = currencySymbol + myModelObj.sections[indexPath.section].cartItemsData[indexPath.row]["recipeDetails"]["costPerServing"].stringValue
        
        cell.deliveryFeeLabel.text = currencySymbol + myModelObj.sections[indexPath.section].cartItemsData[indexPath.row]["recipeDetails"]["deliveryFee"].stringValue
        
        
        cell.spiceLabel.text = myModelObj.sections[indexPath.section].cartItemsData[indexPath.row]["spiceLevel"].stringValue
        
        cell.sevringLabel.text =  myModelObj.sections[indexPath.section].cartItemsData[indexPath.row]["noOfServing"].stringValue
        
        cell.recipeImage.sd_setImage(with: URL(string: myModelObj.sections[indexPath.section].cartItemsData[indexPath.row]["recipeDetails"]["MediaObjects"][0]["imageUrl"].stringValue), placeholderImage:UIImage(named: "recipePlaceholder"), options: .refreshCached)
        
        cell.priceLabel.text =  currencySymbol + myModelObj.sections[indexPath.section].cartItemsData[indexPath.row]["price"].stringValue
        
        
        
       
        if myModelObj.sections[indexPath.section].cartItemsData[indexPath.row]["recipeId"].stringValue == "1" {
            cell.readmoreButtonOutlet.isHidden = true
            cell.readlessButtonOutlet.isHidden = false
        } else {
            cell.readmoreButtonOutlet.isHidden = false
            cell.readlessButtonOutlet.isHidden = true
        }
        
        
        print(myModelObj.sections)
        if myModelObj.sections[indexPath.section].radiocheck == "0" {
            print("0")
            cell.readmoreButtonOutlet.isUserInteractionEnabled = false
            cell.readlessButtonOutlet.isUserInteractionEnabled = false
        } else {
            print("1")
            cell.readmoreButtonOutlet.isUserInteractionEnabled = true
            cell.readlessButtonOutlet.isUserInteractionEnabled = true
        }
        
        
        
        cell.increaseSpiceLevel.tag = indexPath.row * 1000 + indexPath.section
        cell.decreaseSpiceLevel.tag = indexPath.row * 1000 + indexPath.section
        
        cell.decreaseServingLevel.tag = indexPath.row * 1000 + indexPath.section
        cell.increaseServingLevel.tag = indexPath.row * 1000 + indexPath.section
        
        cell.viewDetailButton.tag = indexPath.row * 1000 + indexPath.section
        cell.deleteButton.tag = indexPath.row * 1000 + indexPath.section
        
        cell.readmoreButtonOutlet.tag = indexPath.row * 1000 + indexPath.section
        cell.readlessButtonOutlet.tag = indexPath.row * 1000 + indexPath.section
        

        //isDeleted
        if myModelObj.sections[indexPath.section].cartItemsData[indexPath.row]["recipeDetails"]["isDeleted"].boolValue {
            cell.recipeNotExist.isHidden = false
            cell.recipeDeleted.isHidden = false
            cell.readmoreButtonOutlet.isHidden  = true
        } 
        

        return cell
    }
    
    
    
    
    func toggleSection(header: ExpandableHeaderView, section: Int) {
        
        print(section)
        
        var tempNewJson = [JSON]()
       
        
        for (index, var response) in  myModelObj.newJSONData.enumerated() {
            print(response)
            if index == section {
                response["genderFull"] = "1"
                tempNewJson.append(response)
            }else {
                response["genderFull"] = "0"
                tempNewJson.append(response)
            }
        }
        
        myModelObj.newJSONData.removeAll()
        myModelObj.newJSONData = tempNewJson
        
        myModelObj.sections.removeAll()
        for cart in  myModelObj.newJSONData {
            
            if cart["genderFull"].stringValue == "1"{
                myModelObj.totalPrice = cart["price"].stringValue
                myModelObj.totalItem = cart["item"].stringValue
                myModelObj.cookId = cart[ID_KEY].stringValue
                
                self.totalPriceLabelOutlet.text = Helper.getUserDefaultValue(key: CURRENCY_SYMBOL_KEY)! + myModelObj.totalPrice
                self.priceCountItemLabelOutlet.text = "Price of " + myModelObj.totalItem +  "items."
                
            }
           
            myModelObj.sections.append(Section(genre: cart["fullName"].stringValue,
                                         profileImage: cart["profileUrl"].stringValue,
                                         cartItemsData: cart["CartItems"].arrayValue,
                                         radiocheck: cart["genderFull"].stringValue,
                                         expanded: true))
           
           }
        
        
        
        
        
//        myModelObj.sections[section].expanded = !myModelObj.sections[section].expanded
//        myCartTableview.beginUpdates()
//        for i in 0 ..< myModelObj.sections[section].cartItemsData.count {
//            myCartTableview.reloadRows(at: [IndexPath(row: i, section: section)], with: .automatic)
//        }
//        myCartTableview.endUpdates()

        
//        let sectionToReload = section
//        let indexSet: IndexSet = [sectionToReload]
//        self.myCartTableview.reloadSections(indexSet, with: .automatic)
          self.myCartTableview.reloadData()
        
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.section)
        print(indexPath.row)
        print(myModelObj.sections[indexPath.section].cartItemsData[indexPath.row])
        
        
        //let simpleVC = SimpleVC()
        //simpleVC.customInit(imageName: sections[indexPath.section].cartItemsData[indexPath.row])
        //tableView.deselectRow(at: indexPath, animated: true)
        //self.navigationController?.pushViewController(simpleVC, animated: true)
    }
}




extension UIButton {
    func pulsate() {
        //Button Animation.
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.6
        pulse.fromValue = 0.95
        pulse.toValue = 1.0
        pulse.autoreverses = true
        pulse.repeatCount = 1
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0
        layer.add(pulse, forKey: "pulse")
    }
}




extension MyCartVC: SWRevealViewControllerDelegate {
    
    func revealController(_ revealController: SWRevealViewController!, willMoveTo position: FrontViewPosition) {
        if(position == FrontViewPosition.left) {
            self.myCartTableview.isUserInteractionEnabled = true;
        } else {
            self.myCartTableview.isUserInteractionEnabled = false;
        }
    }
    
    
    func revealController(_ revealController: SWRevealViewController!, didMoveTo position: FrontViewPosition) {
        if(position == FrontViewPosition.left) {
            self.myCartTableview.isUserInteractionEnabled = true;
        } else {
            self.myCartTableview.isUserInteractionEnabled = false;
        }
    }
}










