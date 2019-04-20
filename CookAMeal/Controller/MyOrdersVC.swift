//
//  MyOrdersVC.swift
//  CookAMeal
//
//  Created by Cynoteck on 17/04/18.
//  Copyright © 2018 Cynoteck. All rights reserved.
//

import UIKit
import JGProgressHUD


class MyOrdersVC: UIViewController {

    let myOrderObj : MyOrdersModel = MyOrdersModel()
    var orderId = String()
    let hud = JGProgressHUD(style: .light)
    var type = String()
    private let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var myOrderTableview: UITableView!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var orderTypeSegment: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        type = "1"
        myOrderTableview.delegate = self
        myOrderTableview.dataSource = self
        self.revealViewController().delegate = self
        
        self.myOrderTableview.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)

        
    }
    
    
    @objc private func refreshData(_ sender: Any) {
       getOrderData(refresh: true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 80
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        menuButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
    
        getOrderData(refresh: false)
       
    }
    
    
   
    
    func getOrderData(refresh: Bool) {
        
        hud.show(in: self.view)
        hud.textLabel.text = "Loading"
        Singleton.instance.isSimpleGetRequest = true
        myOrderObj.getOrderData(refresh: refresh, type: type) { (success) in
            self.hud.dismiss()
            self.refreshControl.endRefreshing()
            if success {
                if self.myOrderObj.myOrderData.count == 0 {
                    self.myOrderTableview.isHidden = true
                    self.alertLabel.isHidden = false
                    self.myOrderTableview.reloadData()
                }else {
                    self.myOrderTableview.isHidden = false
                    self.alertLabel.isHidden = true
                    self.myOrderTableview.reloadData()
                }
            } else {
                //self.showAlertWithMessage(alertMessage: self.myOrderObj.alertMessage)
                 self.present(Helper.globalAlertView(with: LOGIN_CONSTANT.ALERT_HEADER_MESSAGE_KEY, message: self.myOrderObj.alertMessage), animated: true, completion: nil)
            }
        }
    }
    
    
    @IBAction func orderTypeSegmentAction(_ sender: Any) {
        switch orderTypeSegment.selectedSegmentIndex {
        case 0:
            type = "1"
            getOrderData(refresh: false)
        case 1:
            type = "2"
            getOrderData(refresh: false)
        case 2:
            type = "3"
            getOrderData(refresh: false)
        default:
            print("default")
        }
    }
    
    
    
    func showAlertWithMessage(alertMessage:String)
    {
        let alertController = UIAlertController(title:ALERT_TITLE.APP_NAME, message:alertMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func unwindToMyOrder(segue:UIStoryboardSegue) { }
    
    
}


extension MyOrdersVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if myOrderObj.myOrderData.count != 0 {
            return myOrderObj.myOrderData.count
        } else {
            return 2
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyOrderTableViewCell
        
        if myOrderObj.myOrderData.count != 0 {
            
            cell.hideSkeletonsViews()
            
            cell.cookNameLabel.text = myOrderObj.myOrderData[indexPath.row]["profile"]["fullName"].stringValue
            
            cell.cookImageView.sd_setImage(with: URL(string: myOrderObj.myOrderData[indexPath.row]["profile"]["profileUrl"].stringValue), placeholderImage:UIImage(named: "recipePlaceholder"), options: .refreshCached)
            
            cell.dateLabel.text =  "Date: " + UTCToLocal(date: myOrderObj.myOrderData[indexPath.row]["createdAt"].stringValue, fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: "dd/MM/yyyy")
            
            cell.timeLabel.text = "Time: " + UTCToLocal(date: myOrderObj.myOrderData[indexPath.row]["createdAt"].stringValue, fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: "hh:mm a")
            
            cell.orderTypeLabelOutlet.text = myOrderObj.myOrderData[indexPath.row]["orderType"].stringValue
            
            if myOrderObj.myOrderData[indexPath.row]["orderByMe"].boolValue {
                cell.orderByMeLabelOutlet.text = "Order by me"
            } else {
                cell.orderByMeLabelOutlet.text = "Order for me"
                
            }
            
            if myOrderObj.myOrderData[indexPath.row]["profile"]["userRole"].stringValue == "1" {
                cell.orderByLabelOutlet.text = "Cook"
            } else {
                cell.orderByLabelOutlet.text = "Customer"
            }
        }
        
      
        
        if type == "3" {
            
            if myOrderObj.myOrderData.count != 0 {
                cell.statusStackView.isHidden = false
                cell.statusLabelOutlet.text = myOrderObj.myOrderData[indexPath.row]["orderState"].stringValue //orderState
                
                if myOrderObj.myOrderData[indexPath.row]["orderState"].stringValue == "CANCELLED" || myOrderObj.myOrderData[indexPath.row]["orderState"].stringValue == "REJECTED" {
                    cell.statusLabelOutlet.textColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
                } else {
                    cell.statusLabelOutlet.textColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
                }
            }
            
            
        } else {
            cell.statusStackView.isHidden = true
        }
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        orderId = myOrderObj.myOrderData[indexPath.row]["id"].stringValue
        self.performSegue(withIdentifier: "toOrdersToOrderDetails", sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toOrdersToOrderDetails" {
            let destinationVC = segue.destination as! OrderDetailsViewController
            destinationVC.orderId = orderId
            destinationVC.type = type
        }
    }
    
  
    func getDate(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"//this your string date format
        var localTimeZoneAbbreviation: String { return TimeZone.current.abbreviation() ?? "" }
        
        dateFormatter.timeZone = NSTimeZone(name: localTimeZoneAbbreviation) as TimeZone?
        let date = dateFormatter.date(from: date)
        
        dateFormatter.dateFormat = "dd-MM-yyyy"///this is what you want to convert format
        dateFormatter.timeZone = NSTimeZone(name: localTimeZoneAbbreviation) as TimeZone?
        
        if let newDate = date {
             return dateFormatter.string(from: newDate)
        } else {
            return "Invalid Date"
        }
        
       
    }
    
    func getTime(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"//this your string date format
        var localTimeZoneAbbreviation: String { return TimeZone.current.abbreviation() ?? "" }
        
        dateFormatter.timeZone = NSTimeZone(name: localTimeZoneAbbreviation) as TimeZone?
        let date = dateFormatter.date(from: date)
        
        dateFormatter.dateFormat = "hh:mm a"///this is what you want to convert format
        dateFormatter.timeZone = NSTimeZone(name: localTimeZoneAbbreviation) as TimeZone?
        if let newDate = date {
            return dateFormatter.string(from: newDate)
        } else {
            return "Invalid Date"
        }
    }
    
    
    func UTCToLocal(date:String, fromFormat: String, toFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormat
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = toFormat
        
        if let date = dt {
            return dateFormatter.string(from: date)
        } else {
            return "Invalid Date"
        }
    }
    
}

extension MyOrdersVC: SWRevealViewControllerDelegate {
    
    func revealController(_ revealController: SWRevealViewController!, willMoveTo position: FrontViewPosition) {
        if(position == FrontViewPosition.left) {
            self.myOrderTableview.isUserInteractionEnabled = true
            self.orderTypeSegment.isUserInteractionEnabled = true
        } else {
            self.myOrderTableview.isUserInteractionEnabled = false
            self.orderTypeSegment.isUserInteractionEnabled = false
        }
    }
    
    
    func revealController(_ revealController: SWRevealViewController!, didMoveTo position: FrontViewPosition) {
        if(position == FrontViewPosition.left) {
            self.myOrderTableview.isUserInteractionEnabled = true
            self.orderTypeSegment.isUserInteractionEnabled = true
        } else {
            self.myOrderTableview.isUserInteractionEnabled = false
            self.orderTypeSegment.isUserInteractionEnabled = false
        }
    }
}
