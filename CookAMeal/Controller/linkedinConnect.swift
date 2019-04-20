//
//  linkedinConnect.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 07/11/17.
//  Copyright © 2017 Cynoteck. All rights reserved.
//

import UIKit

class linkedinConnect: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

//    @IBAction func linkdinConnect(_ sender: UIButton) {
//        LISDKSessionManager.createSession(withAuth: [LISDK_BASIC_PROFILE_PERMISSION], state: nil, showGoToAppStoreDialog: true, successBlock: { (success) in
//            let url = "https://api.linkedin.com/v1/people/~"
//            if(LISDKSessionManager.hasValidSession()) {
//                LISDKAPIHelper.sharedInstance().getRequest(url, success: { (response) in
//
//                    let dict = self.stringToDictionary(text: (response?.data)!)
//                    print("Response\(String(describing: response))")
//                    print("Dictionary\(String(describing: dict))")
//                    print("your last name is\(String(describing: dict?["lastName"]!))")
//
//                }, error: { (error) in
//                    print(error!)
//                })
//            }
//        }) { (error) in
//            print("error\(String(describing: error))")
//        }
//
//    }
    
    
    func stringToDictionary(text: String)-> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return (try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any])!
            } catch {
                print(error.localizedDescription)
            }
        }
        
        return nil
    
    }
    

}
