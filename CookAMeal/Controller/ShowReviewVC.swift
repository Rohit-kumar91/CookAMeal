//
//  ShowReviewVC.swift
//  CookAMeal
//
//  Created by Cynoteck on 08/06/18.
//  Copyright © 2018 Cynoteck. All rights reserved.
//

import UIKit
import FloatRatingView
import JGProgressHUD



class ShowReviewCell: UITableViewCell {
    
    @IBOutlet weak var recipeNameLabelOutlet: UILabel!
    @IBOutlet weak var dateLabelOutlet: UILabel!
    @IBOutlet weak var descriptionLabelOutlet: UILabel!
    @IBOutlet weak var tasteRatingOutlet: FloatRatingView!
    @IBOutlet weak var quantityValueRatingOutlet: FloatRatingView!
    @IBOutlet weak var reviewImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        recipeNameLabelOutlet.showAnimatedSkeleton()
        dateLabelOutlet.showAnimatedSkeleton()
        descriptionLabelOutlet.showAnimatedSkeleton()
        tasteRatingOutlet.showAnimatedSkeleton()
        quantityValueRatingOutlet.showAnimatedSkeleton()
        reviewImageView.showAnimatedSkeleton()
    }
    
    
    func hideSkeletonViews() {
        recipeNameLabelOutlet.hideSkeleton()
        dateLabelOutlet.hideSkeleton()
        descriptionLabelOutlet.hideSkeleton()
        tasteRatingOutlet.hideSkeleton()
        quantityValueRatingOutlet.hideSkeleton()
        reviewImageView.hideSkeleton()
    }
    
}


class ShowReviewVC: UIViewController {
    
    @IBOutlet weak var showReviewTableview: UITableView!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    let showReviewObj: ShowReviewModel = ShowReviewModel()
    let hud = JGProgressHUD(style: .light)

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 80
        menuButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        self.revealViewController().delegate = self

        
        hud.textLabel.text = PROGRESS_HUD.HUD_LABEL_KEY
        //hud.show(in: self.view)
        self.showReviewTableview.dataSource = self
        
        showReviewObj.getReviewDataToShow(userType: "1") { (success) in
            //self.hud.dismiss()
            if success {
                
                if self.showReviewObj.reviewArray.count == 0 {
                    self.errorMessageLabel.isHidden = false
                    self.showReviewTableview.isHidden = true
                    
                } else {
                    self.errorMessageLabel.isHidden = true
                    self.showReviewTableview.reloadData()
                }
               
            } else {
                //self.showAlertWithMessage(alertMessage: self.showReviewObj.alertMessage)
                 self.present(Helper.globalAlertView(with: LOGIN_CONSTANT.ALERT_HEADER_MESSAGE_KEY, message: self.showReviewObj.alertMessage), animated: true, completion: nil)
            }
        }
    }
    
    
    func showAlertWithMessage(alertMessage:String )
    {
        let alertController = UIAlertController(title:ALERT_TITLE.APP_NAME, message:alertMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action:UIAlertAction!) in
           
        }))
        self.present(alertController, animated: true, completion: nil)
    }
}



extension ShowReviewVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if showReviewObj.reviewArray.count != 0 {
            return showReviewObj.reviewArray.count
        } else {
            return 2
        }
        
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ShowReviewCell
        
        if showReviewObj.reviewArray.count != 0  {
            
            cell.hideSkeletonViews()
            
            cell.recipeNameLabelOutlet.text = showReviewObj.reviewArray[indexPath.row]["profile"]["fullName"].stringValue
            
            cell.dateLabelOutlet?.text = Helper.getDate(date: showReviewObj.reviewArray[indexPath.row]["createdAt"].stringValue) + " "
            
            cell.descriptionLabelOutlet?.text = showReviewObj.reviewArray[indexPath.row]["comments"].stringValue
            
            cell.tasteRatingOutlet.rating = showReviewObj.reviewArray[indexPath.row]["rating"]["taste"].floatValue
            
            cell.quantityValueRatingOutlet.rating = showReviewObj.reviewArray[indexPath.row]["rating"]["quantityValue"].floatValue
            
            cell.reviewImageView.sd_setImage(with: URL(string: showReviewObj.reviewArray[indexPath.row]["profile"]["profileUrl"].stringValue), placeholderImage:UIImage(named: "recipePlaceholder"), options: .refreshCached)
        }
        
        return cell
    }
    
    
    func getTime(date: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"//this your string date format
        var localTimeZoneAbbreviation: String { return TimeZone.current.abbreviation() ?? "" }
        
        dateFormatter.timeZone = NSTimeZone(name: localTimeZoneAbbreviation) as TimeZone?
        let date = dateFormatter.date(from: date)
        
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm a"///this is what you want to convert format
        dateFormatter.timeZone = NSTimeZone(name: localTimeZoneAbbreviation) as TimeZone?
        return dateFormatter.string(from: date!)
    }
    
    func getDate(date: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"//this your string date format 
        var localTimeZoneAbbreviation: String { return TimeZone.current.abbreviation() ?? "" }
        
        dateFormatter.timeZone = NSTimeZone(name: localTimeZoneAbbreviation) as TimeZone?
        let date = dateFormatter.date(from: date)
        
        dateFormatter.dateFormat = "dd/MM/yyyy"///this is what you want to convert format
        dateFormatter.timeZone = NSTimeZone(name: localTimeZoneAbbreviation) as TimeZone?
        return dateFormatter.string(from: date!)
    }
}

extension ShowReviewVC: SWRevealViewControllerDelegate {
    
    func revealController(_ revealController: SWRevealViewController!, willMoveTo position: FrontViewPosition) {
        if(position == FrontViewPosition.left) {
            self.showReviewTableview.isUserInteractionEnabled = true;
        } else {
            self.showReviewTableview.isUserInteractionEnabled = false;
        }
    }
    
    
    func revealController(_ revealController: SWRevealViewController!, didMoveTo position: FrontViewPosition) {
        if(position == FrontViewPosition.left) {
            self.showReviewTableview.isUserInteractionEnabled = true;
        } else {
            self.showReviewTableview.isUserInteractionEnabled = false;
        }
    }
}

