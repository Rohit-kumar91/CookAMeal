//
//  SubCategoryVC.swift
//  CookAMeal
//
//  Created by Cynoteck on 02/07/18.
//  Copyright © 2018 Cynoteck. All rights reserved.
//

import UIKit
import JGProgressHUD

class SubCategoryCell: UITableViewCell {
    
    @IBOutlet weak var subCategoryNameLabel: UILabel!
    @IBOutlet weak var checkImageView: UIImageView!
    
}

class SubCategoryVC: UIViewController {
    
    let subCatgoryObj: SubCategoryModel = SubCategoryModel()
    let hud = JGProgressHUD(style: .light)

    
    @IBOutlet weak var subCategoryTableview: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subCategoryTableview.dataSource = self
        subCategoryTableview.delegate = self

        hud.textLabel.text = PROGRESS_HUD.HUD_LABEL_KEY
        hud.show(in: self.view)
        subCatgoryObj.getSubcategoryData { (success) in
            self.hud.dismiss()
            if success {
                self.subCategoryTableview.reloadData()
            } else {
                //self.showAlertWithMessage(alertMessage: self.subCatgoryObj.alertMessage)
                self.present(Helper.globalAlertView(with: LOGIN_CONSTANT.ALERT_HEADER_MESSAGE_KEY, message: self.subCatgoryObj.alertMessage), animated: true, completion: nil)
            }
        }
    }
    
    
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        
        for finalSubCategory in  subCatgoryObj.subCategoryFinalArray {
            if finalSubCategory["selected"] == "1" {
                Singleton.instance.subCategoryFilterArray.append(finalSubCategory["id"]!)
            }
        }
         self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
       
        self.navigationController?.popViewController(animated: true)
    }
    
}


extension SubCategoryVC: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subCatgoryObj.subCategoryFinalArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SubCategoryCell
        cell.subCategoryNameLabel.text = subCatgoryObj.subCategoryFinalArray[indexPath.row]["name"]
        cell.checkImageView.layer.borderWidth = 1
        cell.checkImageView.layer.borderColor = #colorLiteral(red: 0.8862745098, green: 0.1725490196, blue: 0.168627451, alpha: 1)
        cell.checkImageView.image = UIImage(named:"check_icon.png")
        cell.checkImageView.contentMode = .center
        
        if subCatgoryObj.subCategoryFinalArray[indexPath.row]["selected"] == "0" {
            cell.checkImageView.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        } else {
            cell.checkImageView.tintColor = #colorLiteral(red: 0.8862745098, green: 0.1725490196, blue: 0.168627451, alpha: 1)
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if subCatgoryObj.subCategoryFinalArray[indexPath.row]["selected"] == "0" {
            subCatgoryObj.subCategoryFinalArray[indexPath.row]["selected"] = "1"
        } else if subCatgoryObj.subCategoryFinalArray[indexPath.row]["selected"] == "1" {
            subCatgoryObj.subCategoryFinalArray[indexPath.row]["selected"] = "0"
        }
        self.subCategoryTableview.reloadData()
    }
    
}

extension SubCategoryVC {
    func showAlertWithMessage(alertMessage:String )
    {
        let alertController = UIAlertController(title:ALERT_TITLE.APP_NAME, message:alertMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action:UIAlertAction!) in
        }))
        self.present(alertController, animated: true, completion: nil)
    }
}
