//
//  SellAllRecipeCategoryList.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 09/12/17.
//  Copyright © 2017 Cynoteck. All rights reserved.
//

import UIKit
import JGProgressHUD

class SeeAllRecipeCategoryList: UIViewController {
    
    @IBOutlet weak var categoryNameLabel: UILabel!
    var categoriesValue = [String: String]()
    let seeAllRecipeModelObj: SellAllRecipeCategoryModel = SellAllRecipeCategoryModel()
    let favourateModelObj: FavourateModel = FavourateModel()
    var otherThanSeeAllData = Bool()
    var recipeId = String()

    @IBOutlet weak var identificationLabelOutlet: UILabelX!
    @IBOutlet weak var allRecipeCollectionview: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(categoriesValue)
        // Do any additional setup after loading the view.
        
        identificationLabelOutlet.layer.cornerRadius = identificationLabelOutlet.frame.size.height / 2
        categoryNameLabel.text = categoriesValue["subCategoryName"]!
        
        
        
        let hud = JGProgressHUD(style: .light)
        hud.show(in: self.view)
        hud.textLabel.text = "Loading"
        
       //Getting data on the base of category and subcategory
        seeAllRecipeModelObj.getAllRecipeListOnBasesOfCategortAndSubcategory(categoryId: categoriesValue["categoryId"],subcategoryId: categoriesValue["subCategoryId"],completion: { (success) in
            hud.dismiss()
            if success {
                
               // self.categoryNameLabel.text =  self.seeAllRecipeModelObj.subCategoryName
                self.allRecipeCollectionview.dataSource = self
                self.allRecipeCollectionview.delegate = self
            } else {
                //self.showAlertWithMessage(alertMessage: self.seeAllRecipeModelObj.alertMessage)
                self.present(Helper.globalAlertView(with: LOGIN_CONSTANT.ALERT_HEADER_MESSAGE_KEY, message: self.seeAllRecipeModelObj.alertMessage), animated: true, completion: nil)
            }
        })
    }
    
    
    override func viewWillLayoutSubviews() {
        identificationLabelOutlet.layer.masksToBounds = true
        identificationLabelOutlet.layer.cornerRadius = identificationLabelOutlet.frame.size.height / 2
        identificationLabelOutlet.text = categoriesValue["categoryName"]!
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
    // Input Parameters :   Message String.
    // Purpose          :   Navigate Back to view.
    //>--------------------------------------------------------------------------------------------------
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func likeButtonTapped(_ sender: UIButton) {
        
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.6
        pulse.fromValue = 0.95
        pulse.toValue = 1.2
        pulse.autoreverses = true
        pulse.repeatCount = 1
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0
        sender.layer.add(pulse, forKey: "pulse")
        
        let recipeId = self.seeAllRecipeModelObj.seeAllCategoryData[sender.tag]["id"].stringValue
        
        favourateModelObj.favourateRecipeData(recipeId: recipeId) { (success) in
            if success {
                
               if self.favourateModelObj.favorite {
                self.seeAllRecipeModelObj.seeAllCategoryData[sender.tag]["Favorite"] = true
                let collectionViewindexPath = IndexPath(row: sender.tag, section: 0)
                self.allRecipeCollectionview.reloadItems(at: [collectionViewindexPath])
               }
               else {
                self.seeAllRecipeModelObj.seeAllCategoryData[sender.tag]["Favorite"] = false
                let collectionViewindexPath = IndexPath(row: sender.tag, section: 0)
                self.allRecipeCollectionview.reloadItems(at: [collectionViewindexPath])
              }
               
            } else {
                  print("recipe like not Successful")
            }
            
        }
    }
}



extension SeeAllRecipeCategoryList: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    
    // MARK: Collectionview delegate tha datasource method.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return seeAllRecipeModelObj.seeAllCategoryData.count
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? SeeAllRecipeCategoryCollectionViewCell
        
        cell?.recipeImageview.contentMode = .scaleAspectFill
          cell?.recipeImageview.sd_setImage(with: URL(string: seeAllRecipeModelObj.seeAllCategoryData[indexPath.row]["MediaObjects"][0][IMAGE_URL_KEY].stringValue), placeholderImage:UIImage(named: "recipePlaceholder"), options: .refreshCached)
        
        cell?.recipeNameLabel.text = seeAllRecipeModelObj.seeAllCategoryData[indexPath.row]["dishName"].stringValue
        cell?.likeButtonOutlet.tag = indexPath.row
        
        //Rating
        cell?.ratingViewOutlet.halfRatings = true
        cell?.ratingViewOutlet.rating = seeAllRecipeModelObj.seeAllCategoryData[indexPath.row]["Rating"].floatValue
        
        if seeAllRecipeModelObj.seeAllCategoryData[indexPath.row]["Favorite"].boolValue {
            cell?.likeButtonOutlet.tintColor = #colorLiteral(red: 0.8859999776, green: 0.172999993, blue: 0.1689999998, alpha: 1)
        } else {
            cell?.likeButtonOutlet.tintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        }
        
        
        if seeAllRecipeModelObj.seeAllCategoryData[indexPath.row]["foodType"].stringValue == "Veg" {
            cell?.foodDetailImage.image = #imageLiteral(resourceName: "veg")
        } else {
            cell?.foodDetailImage.image = #imageLiteral(resourceName: "non-veg")
        }
        
        
        //Constraint hide/unhide.
        if Helper.getUserDefaultValue(key: "orderType")! == "0" {
            
            //unhide
            cell?.orderDateHeightConstraint.constant = 17
            cell?.verticalLabelConstraint.constant = 8
            cell?.costPerServingHeightConstraint.constant = 19
            cell?.imageviewHeightConstraint.constant = collectionView.frame.size.height * 0.3
            
            cell?.orderByDateLabel.text =  "Order By: " + Helper.getDate(date: seeAllRecipeModelObj.seeAllCategoryData[indexPath.row]["orderByDateTime"].stringValue)
            
        } else if Helper.getUserDefaultValue(key: "orderType")! == "1" {
            
            //hide
            cell?.orderDateHeightConstraint.constant = 0
            cell?.verticalLabelConstraint.constant = 0
            cell?.costPerServingHeightConstraint.constant = 0
            cell?.imageviewHeightConstraint.constant = collectionView.frame.size.height * 0.3
            
        }
        
        return cell!
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        recipeId = seeAllRecipeModelObj.seeAllCategoryData[indexPath.row][ID_KEY].stringValue
        self.performSegue(withIdentifier: "fromSeeAllToFoodDetail", sender: nil)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width * 0.41062, height: UIScreen.main.bounds.size.height * 0.44);  // base iphone 5
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         let destinationVC = segue.destination as! FoodDetailVC
         destinationVC.recipeId =  recipeId
    }
    
}
