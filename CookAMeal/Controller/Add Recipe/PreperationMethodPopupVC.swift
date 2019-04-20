//
//  PreperationMethodPopupVC.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 16/02/18.
//  Copyright © 2018 Cynoteck. All rights reserved.
//

import UIKit
import JGProgressHUD
import SwiftyJSON

class PreperationMethodPopupVC: UIViewController {
    
    var flag = Bool()
    var index = Int()
    var isEdit = Bool()
    var indexValue = String()
    let preparationModelObj = PreparationMethodModel()
    
    @IBOutlet weak var textviewOutlet: UITextviewX!
    @IBOutlet weak var stepLabelOutlet: UILabel!
    @IBOutlet weak var subViewOutlet: UIViewX!
     let hud = JGProgressHUD(style: .light)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        textviewOutlet.layer.borderWidth = 1
        textviewOutlet.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        self.showAnimate()
        
        
        if isEdit {
            isEdit = false
            
            textviewOutlet.text = indexValue
            Singleton.instance.prepartionMethodStrArray[index]["method"] = textviewOutlet.text
        }
        
        
        
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        flag = false
        let count  =   Singleton.instance.prepartionMethodStrArray.count
        stepLabelOutlet.text =  "Step: " + String(count + 1)
    }

    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        flag = false
        removeAnimate()
    }
    
    
    
    @IBAction func crossButtonTapped(_ sender: RoundedButton) {
         flag = true
        self.removeAnimate()
    }
    
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    
    func removeAnimate()
    {
        
        if !self.flag {
            if self.textviewOutlet.text == "" {
                
                self.subViewOutlet.transform = CGAffineTransform(translationX: 20, y: 0)
                UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                    self.subViewOutlet.transform = CGAffineTransform.identity
                }, completion: nil)
                
            } else {
                
                if Singleton.instance.editRecipe {
                    
                    let step =  String(Singleton.instance.prepartionMethodStrArray.count)
                    hud.show(in: self.view)
                    hud.textLabel.text = "Loading"
                    preparationModelObj.addPreparationMethod(step: step, method: self.textviewOutlet.text!, recipeId: Singleton.instance.preparationRecipeId) { (response, success) in
                        
                     
                        self.hud.dismiss()
                        if success {
                            
                            print(response)
                            
                            let temp = [
                                "method": self.textviewOutlet.text!,
                                "id": response["data"]["preparationMethod"]["id"].stringValue
                            ]
                            
                            Singleton.instance.prepartionMethodStrArray.append(temp)
                            UIView.animate(withDuration: 0.25, animations: {
                                self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                                self.view.alpha = 0.0;
                            }, completion:{(finished : Bool)  in
                                if (finished)
                                {
                                    self.view.removeFromSuperview()
                                    NotificationCenter.default.post(name: Notification.Name("refreshData"), object: nil)
                                }
                            });
                            
                        } else {
                            
                        }
                    }
                    
                    
                } else {
                    
                    let temp = [
                        "method": self.textviewOutlet.text!
                    ]
                    
                    Singleton.instance.prepartionMethodStrArray.append(temp)
                    UIView.animate(withDuration: 0.25, animations: {
                        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                        self.view.alpha = 0.0;
                    }, completion:{(finished : Bool)  in
                        if (finished)
                        {
                            self.view.removeFromSuperview()
                            NotificationCenter.default.post(name: Notification.Name("refreshData"), object: nil)
                        }
                    });
                    
                }
            }
        } else {
            UIView.animate(withDuration: 0.25, animations: {
                self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                self.view.alpha = 0.0;
            }, completion:{(finished : Bool)  in
                if (finished)
                {
                    self.view.removeFromSuperview()
                }
            });
        }
    
    }
}
