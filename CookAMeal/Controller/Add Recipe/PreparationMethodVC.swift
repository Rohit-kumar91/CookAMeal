//
//  PreparationMethodVC.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 05/12/17.
//  Copyright © 2017 Cynoteck. All rights reserved.
//

import UIKit
import SwiftyJSON
import JGProgressHUD


class PreparationMethodVC: UIViewController {

    
    @IBOutlet weak var preperationTableview: UITableView!
    @IBOutlet weak var emptyLabelOutlet: UILabel!
    
    let preparationObj = PreparationMethodModel()
    let hud = JGProgressHUD(style: .light)
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.preperationTableview.delegate = self
        self.preperationTableview.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(PreparationMethodVC.reloadTableViewData), name: Notification.Name("refreshData"), object: nil)
        
        
        //preperationTableview.isEditing = !preperationTableview.isEditing
        
        if Singleton.instance.prepartionMethodStrArray.count == 0 {
            preperationTableview.isHidden = true
            emptyLabelOutlet.isHidden = false
        } else {
            preperationTableview.isHidden = false
            emptyLabelOutlet.isHidden = true
        }
        
       
    }
    
    
    @objc func reloadTableViewData() {
        
        if Singleton.instance.prepartionMethodStrArray.count == 0 {
            preperationTableview.isHidden = true
            emptyLabelOutlet.isHidden = false
        } else {
            preperationTableview.isHidden = false
            emptyLabelOutlet.isHidden = true
        }
        
      self.preperationTableview.reloadData()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if Singleton.instance.prepartionMethodStrArray.count != 0 {
            self.preperationTableview.reloadData()
        }
      
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("refreshData"), object: nil)
    }
    

    
    
    @IBAction func addPreperationMethodButtonTapped(_ sender: Any) {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "preparationMethodPopupId") as! PreperationMethodPopupVC
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
        
    }
    
    
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        //Singleton.instance.prepartionMethodStrArray.removeAll()
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func doneButtonTapped(_ sender: Any) {
       dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func tapGestureTapped(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func directionButtonTapped(_ sender: UIButton) {
        print("Direction")
        
    }
    
    @IBAction func preparationMethodTapped(_ sender: Any) {
        
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "preparationMethodPopupId") as! PreperationMethodPopupVC
        let indexValue = Int((sender as AnyObject).tag)
        print(indexValue)
        popOverVC.index = indexValue
        popOverVC.indexValue = Singleton.instance.prepartionMethodStrArray[indexValue]["method"]!
        popOverVC.isEdit = true
        
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
        
    }
}


extension PreparationMethodVC: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Singleton.instance.prepartionMethodStrArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PreperationMethodTableviewCell
        
        cell.textLabelOutlet.text = Singleton.instance.prepartionMethodStrArray[indexPath.row]["method"]
        cell.stepLabelOutlet.text = "Step: " + String(indexPath.row + 1)
        cell.preparationButtonOutlet.tag = indexPath.row
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            
            let alertController = UIAlertController(title:"Delete Preparation Method.", message:"Are you sure you want to delete?", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action:UIAlertAction!) in
                self.hud.show(in: self.view)
                self.hud.textLabel.text = "Loading"
                self.preparationObj.deletePreparationMethod(preparationId: Singleton.instance.prepartionMethodStrArray[indexPath.row]["id"]!, recipeId: Singleton.instance.preparationRecipeId) { (success) in
                    self.hud.dismiss()
                    if success {
                        Singleton.instance.prepartionMethodStrArray.remove(at: indexPath.row)
                        self.preperationTableview.deleteRows(at: [indexPath], with: .automatic)
                        self.preperationTableview.reloadData()
                    }
                }
            }))
            
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action:UIAlertAction!) in
            }))
            
            self.present(alertController, animated: true, completion: nil)
            
            
        }
    }
}

