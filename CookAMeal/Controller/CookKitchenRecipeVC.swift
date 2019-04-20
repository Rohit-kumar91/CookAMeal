//
//  CookKitchenRecipeVC.swift
//  CookAMeal
//
//  Created by Cynoteck on 06/07/18.
//  Copyright © 2018 Cynoteck. All rights reserved.
//

import UIKit
import JGProgressHUD


class CookKitchenRecipeVC: UIViewController {

    @IBOutlet weak var kitchenRecipeCollectionView: UICollectionView!
    
    let cookKitchenObj: CookKitchenRecipeModel = CookKitchenRecipeModel()
    var cookId = String()
    var recipeId = String()
    var eventId = String()
    var dateString = String()
    let hud = JGProgressHUD(style: .light)
 
    override func viewDidLoad() {
        super.viewDidLoad()

        Singleton.instance.addMoreRecipeTimeSlot = true
        Singleton.instance.notUpdateTimeSlot = true
        
        hud.textLabel.text = PROGRESS_HUD.HUD_LABEL_KEY
        hud.show(in: self.view)
        
        if !Singleton.instance.loadCookKitchenData {
            cookKitchenObj.kitchenData(cookId: cookId) { (success) in
                self.hud.dismiss()
                if success {
                    print(self.cookKitchenObj.kitchenData)
                    Singleton.instance.loadCookKitchenData = true
                    self.kitchenRecipeCollectionView.reloadData()
                } else {
                    self.kitchenRecipeCollectionView.reloadData()
                }
            }
        } else {
            self.hud.dismiss()
        }
    }
    
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addToMenuButtonTapped(_ sender: RoundedButton) {
        
        //Here we use avaialable String as to mark the recipe to Add to Menu
        //If available string is 0001 its means that you add the recipe to menu.
        
        Singleton.instance.kitchenData[sender.tag]["availableServings"] = "0001"
        //self.performSegue(withIdentifier: "cookKitchenToCookAvailability", sender: nil)
        Singleton.instance.recipeId = Singleton.instance.kitchenData[sender.tag]["id"].stringValue
        self.navigationController?.popViewController(animated: true)
    }
    
    
}



extension CookKitchenRecipeVC : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Singleton.instance.kitchenData.count
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? KitchenRecipeCell
        
        cell?.recipeImageView.contentMode = .scaleAspectFill
        cell?.recipeImageView.sd_setImage(with: URL(string: Singleton.instance.kitchenData[indexPath.row]["MediaObjects"][0]["imageUrl"].stringValue), placeholderImage:UIImage(named: "recipePlaceholder"), options: .refreshCached)
        cell?.recipeNameLabel.text = Singleton.instance.kitchenData[indexPath.row]["dishName"].stringValue
        cell?.addToMenuOutlet.tag = indexPath.row
        
        if Singleton.instance.kitchenData[indexPath.row]["availableServings"].stringValue == "0001" {
            cell?.addToMenuOutlet.setTitle("Added", for: .normal)
            cell?.addToMenuOutlet.isUserInteractionEnabled = false
            cell?.addToMenuOutlet.alpha = 0.5
        } else {
            cell?.addToMenuOutlet.setTitle("Add To Menu", for: .normal)
            cell?.addToMenuOutlet.isUserInteractionEnabled = true
        }
        
        return cell!
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width * 0.41062, height: UIScreen.main.bounds.size.height * 0.4360);  // base iphone 5
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //self.performSegue(withIdentifier: "kitchenToBookSlot", sender: nil)
       // recipeId = cookKitchenObj.kitchenData[indexPath.row]["id"].stringValue
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "cookKitchenToCookAvailability" {
//            
//            let destinationVC = segue.destination as! CookAvailabilityVC
//            destinationVC.recipeId = recipeId
//            destinationVC.eventId = eventId
//            destinationVC.cookId = cookId
//            destinationVC.dateString = dateString
//        }
    }
    
    
    
    
    
}
