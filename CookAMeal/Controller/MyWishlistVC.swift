//
//  MyWishlistVC.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 19/03/18.
//  Copyright © 2018 Cynoteck. All rights reserved.
//

import UIKit
import SwiftyJSON
import JGProgressHUD
import CRNotifications

class MyWishlistVC: UIViewController {
    
    @IBOutlet weak var viewRecipeButtonOutlet: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var menuButtonOutlet: UIButton!
    @IBOutlet weak var wishListTableview: UITableView!
    @IBOutlet weak var wishListTypeForRecipe: UISegmentedControl!
    let myWishListObj: MyWishlistModel = MyWishlistModel()
    var recipeId = String()
    var isCook = Bool()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.wishListTableview.delegate = self
        self.wishListTableview.dataSource = self
        self.revealViewController().delegate = self

        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 80
        menuButtonOutlet.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())

        let hud = JGProgressHUD(style: .light)
        hud.textLabel.text = PROGRESS_HUD.HUD_LABEL_KEY
        //hud.show(in: self.view)
        myWishListObj.getfavoriteRecipe { (success) in
            //hud.dismiss()
            if success {
                
                if self.myWishListObj.orderRecipe.count == 0 {
                    self.stackView.isHidden = false
                    self.viewRecipeButtonOutlet.isHidden = false
                    self.wishListTableview.isHidden = true
                } else {
                    self.stackView.isHidden = true
                    self.viewRecipeButtonOutlet.isHidden = true
                    self.wishListTableview.isHidden = false
                    self.myWishListObj.commonRecipeArray = self.myWishListObj.orderRecipe
                    self.wishListTableview.reloadData()
                }
                
                
            } else {
                self.present(Helper.globalAlertView(with: "DomesticEat", message: self.myWishListObj.alertMessage), animated: true, completion: nil)
            }
        }
    }
    
   
    
    @IBAction func viewRecipeButtonTapped(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "favoriteToDashboard", sender: nil)
    }
    
    
    @IBAction func isEligibleForRecipeTypeSegment(_ sender: Any) {
        
        switch wishListTypeForRecipe.selectedSegmentIndex {
        case 0:
            print("For ORder")
            isCook = false
            let hud = JGProgressHUD(style: .light)
            hud.textLabel.text = PROGRESS_HUD.HUD_LABEL_KEY
            hud.show(in: self.view)
            myWishListObj.getfavoriteRecipe { (success) in
                hud.dismiss()
                if success {
                    if self.myWishListObj.orderRecipe.count == 0 {
                        self.stackView.isHidden = false
                        self.viewRecipeButtonOutlet.isHidden = false
                        self.wishListTableview.isHidden = true
                    } else {
                        self.stackView.isHidden = true
                        self.viewRecipeButtonOutlet.isHidden = true
                        self.wishListTableview.isHidden = false
                        self.myWishListObj.commonRecipeArray = self.myWishListObj.orderRecipe
                        self.wishListTableview.reloadData()
                    }
                    
                } else {
                     self.present(Helper.globalAlertView(with: "", message: self.myWishListObj.alertMessage), animated: true, completion: nil)
                }
            }
            
        case 1:
            print("For hire")
             isCook = true
            self.myWishListObj.commonRecipeArray.removeAll()
            let hud = JGProgressHUD(style: .light)
            hud.textLabel.text = PROGRESS_HUD.HUD_LABEL_KEY
            hud.show(in: self.view)
            
            myWishListObj.getfavoriteCook { (success) in
                hud.dismiss()
                if success {
                    if self.myWishListObj.orderRecipe.count == 0 {
                        self.stackView.isHidden = false
                        self.viewRecipeButtonOutlet.isHidden = false
                        self.wishListTableview.isHidden = true
                    } else {
                        self.stackView.isHidden = true
                        self.viewRecipeButtonOutlet.isHidden = true
                        self.wishListTableview.isHidden = false
                        self.myWishListObj.commonRecipeArray = self.myWishListObj.orderRecipe
                        self.wishListTableview.reloadData()
                    }
                    
                } else {
                    self.present(Helper.globalAlertView(with: "DomesticEat", message: self.myWishListObj.alertMessage), animated: true, completion: nil)
                }
            }
            
        default:
            print("default")
            
        }
    }
}






extension MyWishlistVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.myWishListObj.commonRecipeArray.count != 0 {
            return  self.myWishListObj.commonRecipeArray.count
        } else {
            return 2
        }
        
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WishlistTableViewCell
        
        if self.myWishListObj.commonRecipeArray.count != 0 {
            
            cell.hideSkeletonViews()
            
            if isCook {
                cell.recipeNameLabelOutlet.text = self.myWishListObj.commonRecipeArray[indexPath.row]["fullName"].stringValue
                cell.priceLabelOutlet.text = ""
            } else {
                cell.recipeNameLabelOutlet.text = self.myWishListObj.commonRecipeArray[indexPath.row]["dishName"].stringValue
                cell.priceLabelOutlet.text = self.myWishListObj.commonRecipeArray[indexPath.row]["currencySymbol"].stringValue + " " + self.myWishListObj.commonRecipeArray[indexPath.row]["costPerServing"].stringValue
            }
            
            
            
            cell.recipeImageviewOutlet.sd_setImage(with: URL(string: self.myWishListObj.commonRecipeArray[indexPath.row]["MediaObjects"][0]["imageUrl"].stringValue), placeholderImage:UIImage(named: "recipePlaceholder"), options: .refreshCached)
            
            cell.ratingViewOutlet.halfRatings = true
            cell.ratingViewOutlet.rating = self.myWishListObj.commonRecipeArray[indexPath.row]["Rating"].floatValue
            
            
            let isDeleted = self.myWishListObj.commonRecipeArray[indexPath.row]["isDeleted"].boolValue
            if isDeleted {
                cell.deletedButtonOutlet.isHidden = false
            } else {
                cell.deletedButtonOutlet.isHidden = true
            }
            
            
            if self.myWishListObj.commonRecipeArray[indexPath.row]["foodType"].stringValue == "Veg" {
                cell.foodTypeImageView.image = #imageLiteral(resourceName: "veg")
            } else {
                cell.foodTypeImageView.image = #imageLiteral(resourceName: "non-veg")
            }
            
        }
        
        return cell
       
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            print("Deleted")
            let itemID = self.myWishListObj.commonRecipeArray[indexPath.row]["Favorites"][0][ID_KEY].stringValue
            let hud = JGProgressHUD(style: .light)
            hud.textLabel.text = PROGRESS_HUD.HUD_LABEL_KEY
            hud.show(in: self.view)
            
            myWishListObj.deleteRecipeFromWishlist(id: itemID, isCook: isCook) { (success) in
                hud.dismiss()
                if success {
                    
                    self.myWishListObj.commonRecipeArray.remove(at: indexPath.row)
                    
                    if self.myWishListObj.commonRecipeArray.count == 0 {
                        self.stackView.isHidden = false
                        self.viewRecipeButtonOutlet.isHidden = false
                        self.wishListTableview.isHidden = true
                    }
                    
                    self.wishListTableview.deleteRows(at: [indexPath], with: .automatic)
                    
                } else {
                     CRNotifications.showNotification(type: CRNotifications.error, title: "Error" , message: self.myWishListObj.alertMessage, dismissDelay: 3)
                }
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        recipeId = self.myWishListObj.commonRecipeArray[indexPath.row]["id"].stringValue
        let isDeleted = self.myWishListObj.commonRecipeArray[indexPath.row]["isDeleted"].boolValue
        if isDeleted {
            //Nothing to do.
            showAlertWithMessage(alertMessage: "This recipe is not exist.")
        } else if isCook {
            //favouriteProfile
            self.performSegue(withIdentifier: "favouriteProfile", sender: nil)
           
        }else {
           
            self.performSegue(withIdentifier: "toFavoriteToFoodDetail", sender: nil)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toFavoriteToFoodDetail" {
            let destinationVC = segue.destination as! FoodDetailVC
            destinationVC.recipeId = recipeId
        } else if segue.identifier == "favouriteProfile" {
            let destinationVC = segue.destination as! ProfileVC
            destinationVC.profileId = recipeId
            destinationVC.backButtonBool = true
        }
    }
    
    func showAlertWithMessage(alertMessage:String )
    {
        let alertController = UIAlertController(title:ALERT_TITLE.APP_NAME, message:alertMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action:UIAlertAction!) in
        }))
        self.present(alertController, animated: true, completion: nil)
    }
}

extension MyWishlistVC: SWRevealViewControllerDelegate {
    
    func revealController(_ revealController: SWRevealViewController!, willMoveTo position: FrontViewPosition) {
        if(position == FrontViewPosition.left) {
            self.wishListTableview.isUserInteractionEnabled = true;
            self.wishListTypeForRecipe.isUserInteractionEnabled = true;
        } else {
            self.wishListTableview.isUserInteractionEnabled = false;
            self.wishListTypeForRecipe.isUserInteractionEnabled = false;
            
        }
    }
    
    
    func revealController(_ revealController: SWRevealViewController!, didMoveTo position: FrontViewPosition) {
        if(position == FrontViewPosition.left) {
            self.wishListTableview.isUserInteractionEnabled = true;
            self.wishListTypeForRecipe.isUserInteractionEnabled = true;
        } else {
            self.wishListTableview.isUserInteractionEnabled = false;
            self.wishListTypeForRecipe.isUserInteractionEnabled = false;
            
        }
    }
}

