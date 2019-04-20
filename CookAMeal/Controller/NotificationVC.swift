//
//  NotificationVC.swift
//  CookAMeal
//
//  Created by Cynoteck on 16/05/18.
//  Copyright © 2018 Cynoteck. All rights reserved.
//

import UIKit
import SwiftyJSON
import JGProgressHUD
import PagingTableView



class NotificationCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var newLabel: UILabel!
    @IBOutlet weak var notificationImage: UIImageViewX!
    
}

class NotificationVC: UIViewController {
    
    
    @IBOutlet weak var notificationTableView: PagingTableView!
    @IBOutlet weak var emptyNotificationLable: UILabel!
    @IBOutlet weak var menuButton: UIButton!
    let notificationObj: NotificationModel = NotificationModel()
    private let refreshControl = UIRefreshControl()
    let hud = JGProgressHUD(style: .light)
    var flagValue = Bool()
    var notificationId = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationTableView.pagingDelegate = self
        self.revealViewController().delegate = self
        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 80
        menuButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.notificationTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)

        
    }
    
    
    
    
    @objc private func refreshData(_ sender: Any) {
        getNotificationData(refresh: true, pageNumber: 0)
    }
    
    
    func getNotificationData(refresh: Bool, pageNumber: Int) {
        // Do any additional setup after loading the view.
        hud.textLabel.text = PROGRESS_HUD.HUD_LABEL_KEY
        
        if flagValue {
            print("In flag")
            self.hud.show(in: self.view)
        }
       
        notificationObj.getNotificationdata(refresh: refresh, pageNumber: pageNumber) { (success) in
            self.hud.dismiss()
            self.notificationTableView.isLoading = false
            if success {
                
                
                if self.notificationObj.notificationArray.count == 0 {
                    print(self.notificationObj.notificationArray.count)
                    //self.refreshControl.endRefreshing()
                    self.emptyNotificationLable.isHidden = false
                } else {
                    self.refreshControl.endRefreshing()
                    self.notificationTableView.isHidden = false
                    self.notificationTableView.reloadData()
                }
                
            } else {
                self.present(Helper.globalAlertView(with: LOGIN_CONSTANT.ALERT_HEADER_MESSAGE_KEY, message: self.notificationObj.alertMessage), animated: true, completion: nil)
            }
        }
    }
    
    
     override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        flagValue = true
       // getNotificationData(refresh: false, pageNumber: 0)
        
    }
}


extension NotificationVC: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return notificationObj.notificationArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NotificationCell
    
        
        let formattedString = NSMutableAttributedString()
        formattedString
            .bold(notificationObj.notificationArray[indexPath.row]["sender"].stringValue)
            .normal(notificationObj.notificationArray[indexPath.row]["title"].stringValue)
        
        cell.name.attributedText = formattedString
        cell.errorLabel.text = notificationObj.notificationArray[indexPath.row][MESSAGE_KEY].stringValue
        cell.timeLabel.text = notificationObj.notificationArray[indexPath.row]["time"].stringValue
        
        cell.notificationImage.sd_setImage(with: URL(string: notificationObj.notificationArray[indexPath.row]["senderProfileImageUrl"].stringValue), placeholderImage:UIImage(named: "recipePlaceholder"), options: .refreshCached)
        cell.notificationImage.contentMode = .scaleAspectFill
        cell.notificationImage.clipsToBounds = true
        
        
        if notificationObj.notificationArray[indexPath.row]["isNew"].boolValue {
            cell.newLabel.isHidden = false
        } else {
            cell.newLabel.isHidden = true

        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        notificationId = notificationObj.notificationArray[indexPath.row]["id"].stringValue
        
        notificationObj.orderId = notificationObj.notificationArray[indexPath.row]["orderId"].stringValue
        notificationObj.Id = notificationObj.notificationArray[indexPath.row]["id"].stringValue
        notificationObj.isNotification = true
        notificationObj.notificationType = notificationObj.notificationArray[indexPath.row]["notificationType"].stringValue
        
        print(notificationObj.notificationArray[indexPath.row]["isOrder"])
        
        if !notificationObj.notificationArray[indexPath.row]["isOrder"].boolValue {
            //go to admin detail screen
            self.performSegue(withIdentifier: "adminApprovedRequest", sender: nil)
        } else {
            if notificationObj.notificationArray[indexPath.row]["notificationType"].stringValue == "Hire" {
                Helper.saveUserDefaultValue(key: "orderType", value: "1")
            } else {
                Helper.saveUserDefaultValue(key: "orderType", value: "0")
            }
            
            notificationObj.seeNotificationDetails(id: notificationId) { (success) in
                if success {
                    self.performSegue(withIdentifier: "notificationToOrderDetails", sender: nil)
                } else {
                    //self.showAlertWithMessage(alertMessage: self.notificationObj.alertMessage)
                    self.present(Helper.globalAlertView(with: LOGIN_CONSTANT.ALERT_HEADER_MESSAGE_KEY, message: self.notificationObj.alertMessage), animated: true, completion: nil)
                }
            }
        }
    }
}

extension NSMutableAttributedString {
    @discardableResult func bold(_ text: String) -> NSMutableAttributedString {
        let attrs: [NSAttributedStringKey: Any] = [.font: UIFont(name: "Helvetica-Bold", size: 15)!]
        let boldString = NSMutableAttributedString(string:text + " ", attributes: attrs)
        append(boldString)
        return self
    }
    
    @discardableResult func normal(_ text: String) -> NSMutableAttributedString {
        let normal = NSAttributedString(string: text)
        append(normal)
        return self
    }
}


extension NotificationVC {
    
    func showAlertWithMessage(alertMessage:String )
    {
        let alertController = UIAlertController(title:ALERT_TITLE.APP_NAME, message:alertMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action:UIAlertAction!) in
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "notificationToOrderDetails" {
            
            let destinationVC = segue.destination as! OrderDetailsViewController
            destinationVC.type = "2"
            destinationVC.notificationId = notificationObj.Id
            destinationVC.orderId = notificationObj.orderId
            destinationVC.isNotification = notificationObj.isNotification
            destinationVC.notificationType = notificationObj.notificationType
            
        } else if segue.identifier == "adminApprovedRequest" {
            let destinationVC = segue.destination as! NotificationForAdmin
            destinationVC.notificationId = notificationId
        }
    }
}


extension NotificationVC: SWRevealViewControllerDelegate {
    
    func revealController(_ revealController: SWRevealViewController!, willMoveTo position: FrontViewPosition) {
        if(position == FrontViewPosition.left) {
            self.notificationTableView.isUserInteractionEnabled = true;
        } else {
            self.notificationTableView.isUserInteractionEnabled = false;
        }
    }
    
    func revealController(_ revealController: SWRevealViewController!, didMoveTo position: FrontViewPosition) {
        if(position == FrontViewPosition.left) {
            self.notificationTableView.isUserInteractionEnabled = true;
        } else {
            self.notificationTableView.isUserInteractionEnabled = false;
        }
    }
}


extension NotificationVC: PagingTableViewDelegate {
    
    func paginate(_ tableView: PagingTableView, to page: Int) {
       
        if page <= notificationObj.maximumPage {
            notificationTableView.isLoading = true
            flagValue = false
             getNotificationData(refresh: false, pageNumber: page)
        }
    }
    
}



