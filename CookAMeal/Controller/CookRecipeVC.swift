//
//  CookRecipeVC.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 02/02/18.
//  Copyright © 2018 Cynoteck. All rights reserved.
//

import UIKit
import SwiftyJSON
import JGProgressHUD
import CRNotifications
import SkeletonView

class CookRecipeVC: UIViewController {
    
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    let cookRecipeModelObj: CookRecipeModel = CookRecipeModel()
    @IBOutlet weak var menuButtonOutlet: UIButton!
    
    @IBOutlet weak var recipeTableview: UITableView!
    @IBOutlet weak var stackView: UIStackView!
    let hud = JGProgressHUD(style: .light)
    var recipeId = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.recipeTableview.contentInset = UIEdgeInsetsMake(-40, 0, 0, 0)
        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 80
        menuButtonOutlet.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        self.recipeTableview.delegate = self
        self.recipeTableview.dataSource =  self
        

        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.recipeTableview.isHidden = false
        self.navigationBar.topItem?.title = Helper.getUserDefaultValue(key: FULL_NAME_KEY)! + " Kitchen"
        
//        hud.show(in: self.view)
//        hud.textLabel.text = "Loading"
        cookRecipeModelObj.getCookRecipe { (success) in
            Singleton.instance.isSimpleGetRequest = true
            if success {
               // self.hud.dismiss()
                if self.cookRecipeModelObj.recipeArray.count == 0 {
                    self.stackView.isHidden =  false
                    self.recipeTableview.isHidden = true

                } else {
                    self.recipeTableview.isHidden = false
                    self.stackView.isHidden =  true
                    self.recipeTableview.reloadData()
                }

            } else {
                //self.hud.dismiss()
                self.present(Helper.globalAlertView(with: LOGIN_CONSTANT.ALERT_HEADER_MESSAGE_KEY, message: self.cookRecipeModelObj.alertMessage), animated: true, completion: nil)
            }
        }
        
    }
    
    
    
    @IBAction func addRecipeButton(_ sender: RoundedButton) {
        let addRecipeViewController = self.storyboard?.instantiateViewController(withIdentifier: "addRecipeID") as! AddRecipeVC
        self.present(addRecipeViewController, animated: true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
         if segue.identifier == "toCookRecipeToFoodDetail" {
            let destinationVC = segue.destination as! FoodDetailVC
            destinationVC.recipeId = recipeId
            destinationVC.isCommingFromAllRecipe = true
        }
    }
    
}






extension CookRecipeVC: UITableViewDelegate, UITableViewDataSource {
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if cookRecipeModelObj.recipeArray.count != 0 {
            return cookRecipeModelObj.recipeArray.count
        } else {
            return 2
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CookAddedRecipeTableViewCell
        
        if cookRecipeModelObj.recipeArray.count != 0 {
            
            cell.hideSkeletonViews()
            
            cell.recipeImageview.sd_setImage(with: URL(string: cookRecipeModelObj.recipeArray[indexPath.row]["MediaObjects"][0][IMAGE_URL_KEY].stringValue ), placeholderImage:UIImage(named: "recipePlaceholder"), options: .refreshCached)
            
            cell.recipeNameLabel.text = cookRecipeModelObj.recipeArray[indexPath.row]["dishName"].stringValue
            
            cell.categoryNameLabel.text = cookRecipeModelObj.recipeArray[indexPath.row]["categoryName"].stringValue  + ", " + cookRecipeModelObj.recipeArray[indexPath.row]["subCategoryName"].stringValue
    
            cell.createdDateLabel.text = UTCToLocal(date: cookRecipeModelObj.recipeArray[indexPath.row]["createdAt"].stringValue, fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: "dd/MM/yyyy")
    
            
            if cookRecipeModelObj.recipeArray[indexPath.row]["costPerServing"].stringValue == "" {
                cell.priceLabelOutlet.isHidden = true
            } else {
                cell.priceLabelOutlet.isHidden = false
                cell.priceLabelOutlet.text = cookRecipeModelObj.recipeArray[indexPath.row]["currencySymbol"].stringValue + cookRecipeModelObj.recipeArray[indexPath.row]["costPerServing"].stringValue
            }
            
            
    
            cell.ratingViewOutlet.halfRatings = true
            
            cell.ratingViewOutlet.rating = cookRecipeModelObj.recipeArray[indexPath.row]["Rating"].floatValue
    
            if cookRecipeModelObj.recipeArray[indexPath.row]["foodType"].stringValue == "Veg" {
                cell.foodTypeImageView.image = #imageLiteral(resourceName: "veg")
            } else {
                cell.foodTypeImageView.image = #imageLiteral(resourceName: "non-veg")
            }
        }
        
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        recipeId = cookRecipeModelObj.recipeArray[indexPath.row][ID_KEY].stringValue
        self.performSegue(withIdentifier: "toCookRecipeToFoodDetail", sender: nil)

    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {

            let alertController = UIAlertController(title:"Delete Recipe.", message:"Are you sure you want to delete the menu item?", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action:UIAlertAction!) in
                
                let itemID = self.cookRecipeModelObj.recipeArray[indexPath.row][ID_KEY].stringValue
                let hud = JGProgressHUD(style: .light)
                hud.textLabel.text = PROGRESS_HUD.HUD_LABEL_KEY
                hud.show(in: self.view)
                self.cookRecipeModelObj.deleteRecipeFromCookKitchen(id: itemID) { (success) in
                    hud.dismiss()
                    if success {
                        
                        self.cookRecipeModelObj.recipeArray.remove(at: indexPath.row)
                        self.recipeTableview.deleteRows(at: [indexPath], with: .automatic)
                        
                    } else {
                        CRNotifications.showNotification(type: CRNotifications.error, title: "Error" , message: self.cookRecipeModelObj.alertMessage, dismissDelay: 3)
                    }
                }
            }))
            
            
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action:UIAlertAction!) in
            }))
            
            self.present(alertController, animated: true, completion: nil)
        
        }
    }
    
    
    
    func UTCToLocal(date:String, fromFormat: String, toFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormat
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = toFormat
        
        if let date = dt {
            return dateFormatter.string(from: date)
        } else {
            return "Invalid Date"
        }
    }
    
    }


