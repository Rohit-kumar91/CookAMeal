//
//  SearchVC.swift
//  CookAMeal
//
//  Created by Cynoteck on 16/05/18.
//  Copyright © 2018 Cynoteck. All rights reserved.
//

import UIKit
import SwiftyJSON

class SearchTableCell : UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var img: UIImageViewX!
    
    
}


class SearchVC: UIViewController, UITableViewDataSource, UISearchBarDelegate, UITableViewDelegate{
    

    @IBOutlet weak var searchTableview: UITableView!
    @IBOutlet weak var searchBarOutlet: UISearchBar!
    @IBOutlet weak var alertLabel: UILabel!
    
    var filterArray = [JSON]()
    let searchObj: SearchModel = SearchModel()
    var Id = String()
    
    
    var currentAnimalArray = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        // Do any additional setup after loading the view.
        searchBarOutlet.setShowsCancelButton(true, animated: true)
        searchBarOutlet.becomeFirstResponder()
        
    }
    
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return filterArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? SearchTableCell else {
            return UITableViewCell()
        }
        
        cell.name.text = filterArray[indexPath.row]["name"].stringValue
        if filterArray[indexPath.row]["isProfile"].boolValue {
            cell.category.text = "Profile"
        } else {
            cell.category.text = "Recipe"
        }
        
        cell.img?.sd_setImage(with: URL(string: filterArray[indexPath.row]["imageUrl"].stringValue), placeholderImage:UIImage(named: "recipePlaceholder"), options: .refreshCached)
        
        return cell
    }
    
   
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if filterArray[indexPath.row]["isProfile"].boolValue {
            //cell.category.text = "Profile"
            //searchToProfileVC
            Id = filterArray[indexPath.row]["id"].stringValue
            self.performSegue(withIdentifier: "searchToProfileVC", sender: nil)
            
        } else {
            //cell.category.text = "Recipe"
            Id = filterArray[indexPath.row]["id"].stringValue
            self.performSegue(withIdentifier: "searchToFoodDetails", sender: nil)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchToFoodDetails" {
            let destinationVC = segue.destination as! FoodDetailVC
            destinationVC.recipeId = Id
        } else if segue.identifier == "searchToProfileVC" {
            let destinationVC = segue.destination as! ProfileVC
            destinationVC.backButtonBool = true
            destinationVC.profileId = Id
        }
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
       
        searchObj.getSearchdata(searchText: searchBar.text!) { (success) in
            if success {
                
                print(self.searchObj.searchArray)
                
                self.filterArray = self.searchObj.searchArray
                
                if self.filterArray.count == 0 {
                    self.alertLabel.isHidden = false
                } else {
                    self.alertLabel.isHidden = true
                }
                
                self.searchTableview.reloadData()
            }
        }
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        self.view.endEditing(true)
        self.dismiss(animated: false, completion: nil)
    }
    

}
