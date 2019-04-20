//
//  SearchableTagsVC.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 05/12/17.
//  Copyright © 2017 Cynoteck. All rights reserved.
//

import UIKit

class SearchableTagsVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    

    var searchableTagModelObj: SearchableTagsModel = SearchableTagsModel()
    @IBOutlet weak var tagsTableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tagsTableview.delegate = self
        tagsTableview.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if Singleton.instance.searchableTagsArray.count == 0 {
           Singleton.instance.searchableTagsArray = searchableTagModelObj.tagsArray
        }
       
        tagsTableview.reloadData()
        
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Singleton.instance.searchableTagsArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SearchableTagsTableviewCell
        cell.tagsTextfield.text = Singleton.instance.searchableTagsArray[indexPath.row]
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return (UIScreen.main.bounds.size.height * 7.04) / 100
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            if !(Singleton.instance.searchableTagsArray.count == 1) {
                Singleton.instance.searchableTagsArray.remove(at: indexPath.row)
                self.tagsTableview.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        
        var count = 0
        for (index, _) in Singleton.instance.searchableTagsArray.enumerated() {
            
            let indexPath = IndexPath(row: index, section: 0)
            let cell: SearchableTagsTableviewCell = self.tagsTableview.cellForRow(at: indexPath) as! SearchableTagsTableviewCell
            
            if  !(cell.tagsTextfield.text?.isEmpty)! {
                Singleton.instance.searchableTagsArray[count] = cell.tagsTextfield.text!
                count = count + 1
            } else if (cell.tagsTextfield.text?.isEmpty)!{
                //removimg empty value
                 Singleton.instance.searchableTagsArray.remove(at: count)
            }
        }
        
        print("Final Array\(Singleton.instance.searchableTagsArray)")
        
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    @IBAction func addMoreTagsButtonTapped(_ sender: Any) {
        var count = 0
        let tempStr: String = ""
        
        for (index, _) in Singleton.instance.searchableTagsArray.enumerated() {
            
            let indexPath = IndexPath(row: index, section: 0)
            let cell: SearchableTagsTableviewCell = self.tagsTableview.cellForRow(at: indexPath) as! SearchableTagsTableviewCell
            
            if  !(cell.tagsTextfield.text?.isEmpty)! {
                Singleton.instance.searchableTagsArray[count] = cell.tagsTextfield.text!
                count = count + 1
            }
        }
        

        //Add empty field in the tableview.
        let indexPath = IndexPath(row: Singleton.instance.searchableTagsArray.count - 1 , section: 0)
        let cell: SearchableTagsTableviewCell = self.tagsTableview.cellForRow(at: indexPath) as! SearchableTagsTableviewCell
        
        if !(cell.tagsTextfield.text?.isEmpty)! {
            Singleton.instance.searchableTagsArray.append(tempStr)
        }
        
        tagsTableview.reloadData()
    }
    
    
    @IBAction func tapGestureAction(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    
}
