//
//  CookContainerViewController.swift
//
//
//  Created by Aaqib Hussain on 03/08/2015.
//  Copyright (c) 2015 Kode Snippets. All rights reserved.
//

import UIKit

open class CookContainerViewController: UIViewController {
    //Manipulating container views
    fileprivate weak var viewController : UIViewController!
    //Keeping track of containerViews
    fileprivate var containerViewObjects = Dictionary<String,UIViewController>()
    
    /** Specifies which ever container view is on the front */
    open var currentViewController : UIViewController{
        get {
            return self.viewController
            
        }
    }
    
    
    fileprivate var segueIdentifier : String!
    
    /*Identifier For First Container SubView*/
    @IBInspectable internal var firstLinkedSubView : String!
    
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        if let identifier = firstLinkedSubView{
                self.segueIdentifierReceivedFromParent(identifier)
        }
        
    }
    
//    open override func viewDidAppear(_ animated: Bool) {
//        if let identifier = firstLinkedSubView{
//
//            self.segueIdentifierReceivedFromParent(identifier)
//
//        }
//    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func segueIdentifierReceivedFromParent(_ identifier: String){
        
       
            // do something
            self.segueIdentifier = identifier
            self.performSegue(withIdentifier: self.segueIdentifier, sender: nil)
       
       
        
    }
    
    
    
    
    override open func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
       
        if segue.identifier == segueIdentifier{
            
            
            //Remove Container View
            if viewController != nil{
                
                viewController.view.removeFromSuperview()
                viewController = nil
                
              
                
            }
            //Add to dictionary if isn't already there
            if ((self.containerViewObjects[self.segueIdentifier] == nil)){
                viewController = segue.destination
                self.containerViewObjects[self.segueIdentifier] = viewController
                
            }else{
                for (key, value) in self.containerViewObjects{
                    
                    if key == self.segueIdentifier{
                        
                        viewController = value
                        
                    }
                    
                }
                
                
            }
            
            
            DispatchQueue.main.async {
                self.addChildViewController(self.viewController)
                self.viewController.view.frame = CGRect(x: 0,y: 0, width: self.view.frame.width,height: self.view.frame.height)
                self.view.addSubview(self.viewController.view)
                self.viewController.didMove(toParentViewController: self)
            }
            
           
            
        }
        
    }
    
    
}
