//
//  ViewController.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 12/10/17.
//  Copyright © 2017 Cynoteck. All rights reserved.
//

import UIKit

class WelcomeVC: UIViewController {

    
    @IBOutlet weak var letsGetStartedOutlet: RoundedButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let network = NetworkManager.sharedInstance
        network.reachability.whenUnreachable = { reachability in
            self.showOfflinePage()
        }
        
    }
    
    private func showOfflinePage() -> Void {
        DispatchQueue.main.async {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "noNetworkIdentifierView") as! OfflineViewController
            self.present(vc, animated: true, completion: nil)
        }
    }

  
    @IBAction func letsGetStartedButtonTapped(_ sender: UIButton) {
        
//        letsGetStartedOutlet.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
//        //animate button and send to login screen.
//        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 6.0, options: .allowUserInteraction,
//                       animations: { [weak self] in
//                        self?.letsGetStartedOutlet.transform = .identity
//            },completion: { (true) in
//                 self.performSegue(withIdentifier: TO_LOGIN, sender: nil)
//        })
        
        
       self.performSegue(withIdentifier: TO_LOGIN, sender: nil)
       
        }
}

