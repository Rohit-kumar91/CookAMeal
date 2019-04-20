//
//  ProfileVC.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 18/12/17.
//  Copyright © 2017 Cynoteck. All rights reserved.
//

import UIKit
import SwiftyJSON
import JGProgressHUD

class ProfileVC: UIViewController {

    @IBOutlet weak var profileTableview: UITableView!
    @IBOutlet weak var menuButtonOutlet: UIButton!
    
    var backButtonBool = Bool()
    var profileId = String()
    let profileVCObj: ProfileModel = ProfileModel()
    var recipeId = String()
    var favouriteModelObj: FavourateModel = FavourateModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.profileTableview.delegate = self
        self.profileTableview.dataSource = self
        
        
        self.profileTableview.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
        self.profileTableview.estimatedRowHeight =  self.profileTableview.rowHeight
        self.profileTableview.rowHeight = UITableViewAutomaticDimension
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
       
        
        if backButtonBool {
            menuButtonOutlet.setImage(UIImage(named: "back_icon"), for: .normal)
            menuButtonOutlet.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
            
        } else {
            //Menu Button
            //Revealview Controller.
            self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 80
            menuButtonOutlet.setImage(UIImage(named: "menu_icon"), for: .normal)
            menuButtonOutlet.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
        
        
        
        let hud = JGProgressHUD(style: .light)
        hud.show(in: self.view)
        hud.textLabel.text = "Loading"
        
        profileVCObj.getProfileData(profileId: profileId) { (success) in
             hud.dismiss()
            if success {
                self.profileTableview.reloadData()
            } else {
               
            }
        }
    }
    
    

    @objc func backButtonTapped(sender: UIButton!) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "cookRecipeId" {
            
            let destinationVC = segue.destination as! FoodDetailVC
            destinationVC.recipeId = recipeId
            
        }
    }
    
    
    
    @IBAction func markFavourateCook(_ sender: UIButton) {
        
        print(sender.tag)
        
        print(profileVCObj.profileDetailData[DATA_KEY]["cookProfile"][ID_KEY].stringValue)
        
        profileVCObj.markFavorite(profileId: profileVCObj.profileDetailData[DATA_KEY]["cookProfile"][ID_KEY].stringValue) { (success) in
            if success {
                
                if self.profileVCObj.fovouriteCheck {
                    self.profileVCObj.profileDetailData[DATA_KEY]["cookProfile"]["favorite"] = true
                    let indexPath = IndexPath(item: sender.tag, section: 0)
                    self.profileTableview.reloadRows(at: [indexPath], with: .none)
                } else {
                    self.profileVCObj.profileDetailData[DATA_KEY]["cookProfile"]["favorite"] = false
                    let indexPath = IndexPath(item: sender.tag, section: 0)
                    self.profileTableview.reloadRows(at: [indexPath], with: .none)
                }
                
            } else {
               
            }
        }
    }
    
    
    
    @IBAction func favourateButtonTapped(_ sender: UIButton) {
        
        print(sender.tag)
        //Calculate which cell to be update for like functionality
        let tableviewCell = (sender.tag / 10) - 1
        let collectionviewCell = sender.tag % 10
        let recipeID  =  profileVCObj.recipesArrayValues[tableviewCell][collectionviewCell][ID_KEY].stringValue
        
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
            
            
            favouriteModelObj.favourateRecipeData(recipeId: recipeID) { (success) in
                if success {
                    
                    if self.favouriteModelObj.favorite {
                        
                        self.profileVCObj.recipesArrayValues[tableviewCell][collectionviewCell]["favorite"] = true
                        let indexPath = IndexPath(row: tableviewCell + 3, section: 0)
                        let cell: UserProfileRecipeTableViewCell = self.profileTableview.cellForRow(at: indexPath) as! UserProfileRecipeTableViewCell
                        let collectionViewindexPath = IndexPath(row: collectionviewCell, section: 0)
                        cell.recipeCollectionViewOutlet.reloadItems(at: [collectionViewindexPath])
                       
                    }else{
                        
                        self.profileVCObj.recipesArrayValues[tableviewCell][collectionviewCell]["favorite"] = false
                        let indexPath = IndexPath(row: tableviewCell + 3, section: 0)
                        let cell: UserProfileRecipeTableViewCell = self.profileTableview.cellForRow(at: indexPath) as! UserProfileRecipeTableViewCell
                        let collectionViewindexPath = IndexPath(row: collectionviewCell, section: 0)
                        cell.recipeCollectionViewOutlet.reloadItems(at: [collectionViewindexPath])
                    }
                    
                }else {
                    print("recipe like not Successful")
                }
            }
        }
    }
}


extension ProfileVC: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileVCObj.totalTableViewIndex
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "wallCell", for: indexPath) as? WallImageTableViewCell
           
            cell?.wallImageView.sd_setImage(with: URL(string: profileVCObj.profileDetailData[DATA_KEY]["cookProfile"]["coverPhotoUrl"].stringValue), placeholderImage:UIImage(named: "recipePlaceholder"), options: .refreshCached)
            cell?.wallImageView.contentMode = .scaleAspectFill
            
            return cell!
        }
            
        else if indexPath.row == 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileDetailCell", for: indexPath) as? ProfileDetailsTableViewCell
            
            
            DispatchQueue.main.async {
                // Asynchronous code running on the main queue
                cell?.profileImageView.layer.cornerRadius =  (cell?.profileImageView.frame.size.height)! / 2
            }
            
            cell?.favouriteButtonOutlet.tag = indexPath.row
            cell?.profileNameLabelOutlet.text = profileVCObj.profileDetailData[DATA_KEY]["cookProfile"]["fullName"].stringValue
            cell?.ratingView.rating = profileVCObj.profileDetailData[DATA_KEY]["cookProfile"]["rating"].floatValue
            cell?.profileImageView.sd_setImage(with: URL(string: profileVCObj.profileDetailData[DATA_KEY]["cookProfile"]["profileUrl"].stringValue), placeholderImage:UIImage(named: "recipePlaceholder"), options: .refreshCached)
            cell?.profileImageView.clipsToBounds = true
            cell?.profileImageView.contentMode = .scaleAspectFill
            cell?.aboutTextLabelOutlet.text = "About "  + profileVCObj.profileDetailData[DATA_KEY]["cookProfile"][FIRST_NAME_KEY].stringValue
            
            if profileVCObj.profileDetailData[DATA_KEY]["cookProfile"]["favorite"].boolValue {
                cell?.favouriteButtonOutlet.tintColor = #colorLiteral(red: 0.8859999776, green: 0.172999993, blue: 0.1689999998, alpha: 1)
            } else {
                cell?.favouriteButtonOutlet.tintColor = #colorLiteral(red: 0.8196078431, green: 0.8196078431, blue: 0.8196078431, alpha: 1)
            }
            
            return cell!
        }
        
        else if indexPath.row == 2 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "descriptionCell", for: indexPath) as? ProfileDescriptionTableViewCell
            cell?.profileDescriptionTextviewOutlet.translatesAutoresizingMaskIntoConstraints = false
            cell?.profileDescriptionTextviewOutlet.isScrollEnabled = false
            
            if profileVCObj.profileDetailData[DATA_KEY]["cookProfile"]["description"].stringValue == "" {
                
                cell?.profileDescriptionTextviewOutlet.text = "No information available about " + profileVCObj.profileDetailData[DATA_KEY]["cookProfile"][FIRST_NAME_KEY].stringValue
                
            } else {
                cell?.profileDescriptionTextviewOutlet.text =  profileVCObj.profileDetailData[DATA_KEY]["cookProfile"]["description"].stringValue
            }
            return cell!
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "userRecipeCell", for: indexPath) as? UserProfileRecipeTableViewCell
            
            if Helper.getUserDefaultValue(key: "orderType")! == "0" {
                //unhide
                cell?.collectionViewHeightConstraint.constant = UIScreen.main.bounds.size.height * 0.4248
                
            } else if Helper.getUserDefaultValue(key: "orderType")! == "1" {
                //hide
                cell?.collectionViewHeightConstraint.constant = UIScreen.main.bounds.size.height * 0.3659
            }
            
            
            cell?.recipeTitleLabelText.text = profileVCObj.recipeCategoryName[indexPath.row - 3]
            cell?.recipeCollectionViewOutlet.tag = indexPath.row - 3
            cell?.recipeCollectionViewOutlet.dataSource = self
            cell?.recipeCollectionViewOutlet.delegate = self
            cell?.recipeCollectionViewOutlet.reloadData()
            
            return cell!
            
        }
    }
}



extension ProfileVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return profileVCObj.recipesArrayValues[collectionView.tag].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ProfileRecipeCollectionViewCell
        
        cell?.recipeImageView.sd_setImage(with: URL(string: profileVCObj.recipesArrayValues[collectionView.tag][indexPath.row]["MediaObjects"][0][IMAGE_URL_KEY].stringValue), placeholderImage:UIImage(named: "recipePlaceholder"), options: .refreshCached)
        
        cell?.recipeNameLabelOutlet.text = profileVCObj.recipesArrayValues[collectionView.tag][indexPath.row]["dishName"].stringValue
        
        //currencySymbol
        cell?.perServingPriceLabelOutlet.text = profileVCObj.recipesArrayValues[collectionView.tag][indexPath.row]["currencySymbol"].stringValue + profileVCObj.recipesArrayValues[collectionView.tag][indexPath.row]["costPerServing"].stringValue + " per Serving"

        cell?.ratingView.halfRatings = true
        
        cell?.ratingView.rating = profileVCObj.recipesArrayValues[collectionView.tag][indexPath.row]["rating"].floatValue
        
        cell?.favouriteButtonOutlet.tag = (((collectionView.tag + 1) * 10) + indexPath.row)
        
        
        //Favourite
        if profileVCObj.recipesArrayValues[collectionView.tag][indexPath.row]["favorite"].boolValue {
            cell?.favouriteButtonOutlet.tintColor = #colorLiteral(red: 0.8859999776, green: 0.172999993, blue: 0.1689999998, alpha: 1)
        } else {
            cell?.favouriteButtonOutlet.tintColor = #colorLiteral(red: 0.8196078431, green: 0.8196078431, blue: 0.8196078431, alpha: 1)
        }
        
        
        //Constraint hide/unhide.
        if Helper.getUserDefaultValue(key: "orderType")! == "0" {
            
            //unhide
            cell?.orderByDateHeightConstraint.constant = 17
            cell?.priceLabelHeightConstraint.constant = 19
            cell?.imageviewHeightConstraint.constant = collectionView.frame.size.height * 0.52
            
        } else if Helper.getUserDefaultValue(key: "orderType")! == "1" {
            
            //hide
            cell?.orderByDateHeightConstraint.constant = 0
            cell?.priceLabelHeightConstraint.constant = 0
            cell?.imageviewHeightConstraint.constant = collectionView.frame.size.height * 0.64
            
        }
        
        return cell!
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("collection view tag....\(collectionView.tag)")
        print("collection view array -----\(profileVCObj.recipesArrayValues[collectionView.tag ][indexPath.row])")
        recipeId = profileVCObj.recipesArrayValues[collectionView.tag][indexPath.row][ID_KEY].stringValue
        self.performSegue(withIdentifier: "cookRecipeId", sender: nil)
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width * 0.375 , height: collectionView.bounds.size.height);
    }
    
}




