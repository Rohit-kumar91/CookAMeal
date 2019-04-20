//
//  ReviewVC.swift
//  Review
//
//  Created by Cynoteck on 24/05/18.
//  Copyright © 2018 Cynoteck. All rights reserved.
//

import UIKit
import FloatRatingView
import SwiftyJSON
import JGProgressHUD

class ReviewCell: UICollectionViewCell {
    
    @IBOutlet weak var recipeImageview: UIImageView!
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var tasteRatingView: FloatRatingView!
    @IBOutlet weak var quantityValueRatingView: FloatRatingView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        recipeImageview.showAnimatedSkeleton()
        recipeNameLabel.showAnimatedSkeleton()
        tasteRatingView.showAnimatedSkeleton()
        quantityValueRatingView.showAnimatedSkeleton()
        
    }
    
    func hideSkeletonViews() {
        recipeImageview.hideSkeleton()
        recipeNameLabel.hideSkeleton()
        tasteRatingView.hideSkeleton()
        quantityValueRatingView.hideSkeleton()
    }
    
    
}

class ReviewVC: UIViewController {

    @IBOutlet weak var reviewCollectionView: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var cookImageView: UIImageView!
    @IBOutlet weak var cookNameLabelOutlet: UILabel!
    @IBOutlet weak var kitchenOutlet: UILabel!
    @IBOutlet weak var comments: UITextviewX!
    
    var orderID = String()
    let reviewObj: ReviewModel = ReviewModel()
    let hud = JGProgressHUD(style: .light)
    var flag = Bool()
    var placeholderLabel : UILabel!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        reviewCollectionView.delegate = self
        reviewCollectionView.dataSource = self
        
        
        
        comments.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = ""
        placeholderLabel.font = UIFont.italicSystemFont(ofSize: (comments.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        comments.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (comments.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !comments.text.isEmpty
        
        
        hud.textLabel.text = PROGRESS_HUD.HUD_LABEL_KEY
        hud.show(in: self.view)
        reviewObj.getReviewData(orderId: orderID) { (success) in
            self.hud.dismiss()
            if success {
                
                self.cookImageView.sd_setImage(with: URL(string: self.reviewObj.reviewData["cookDetails"]["profileUrl"].stringValue), placeholderImage:UIImage(named: "recipePlaceholder"), options: .refreshCached)
                
                self.cookNameLabelOutlet.text = self.reviewObj.reviewData["cookDetails"]["fullName"].stringValue
                self.kitchenOutlet.text =  "Kitchen : " + self.reviewObj.reviewData["kitchen"].stringValue
                self.reviewCollectionView.reloadData()
                
            } else {
                //self.showAlertWithMessage(alertMessage: self.reviewObj.alertMessage)
                 self.present(Helper.globalAlertView(with: LOGIN_CONSTANT.ALERT_HEADER_MESSAGE_KEY, message: self.reviewObj.alertMessage), animated: true, completion: nil)
            }
        }
    }
    
    
    
    
    override func viewDidLayoutSubviews() {
        //scrollView.contentSize = CGSize(width: UIScreen.main.bounds.size.width , height: UIScreen.main.bounds.size.height - 128)
    }
    
    
    
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    @IBAction func submitButtonTapped(_ sender: RoundedButton) {
        
        hud.textLabel.text = PROGRESS_HUD.HUD_LABEL_KEY
        reviewObj.comment = comments.text

        if reviewObj.comment != "" {
            //hud.show(in: self.view)
            reviewObj.giveReviewToRecipe(orderId: orderID) { (success) in
                //self.hud.dismiss()
                if success {
                    self.flag = true
                    self.showAlertWithMessage(alertMessage: self.reviewObj.alertMessage)
                    
                } else {
                    //self.showAlertWithMessage(alertMessage: self.reviewObj.alertMessage)
                    self.present(Helper.globalAlertView(with: LOGIN_CONSTANT.ALERT_HEADER_MESSAGE_KEY, message: self.reviewObj.alertMessage), animated: true, completion: nil)
                }
            }
        } else {
            self.showAlertWithMessage(alertMessage: "Comment cannnot be blank.")
        }
    }
    
    
    
    func showAlertWithMessage(alertMessage:String )
    {
        let alertController = UIAlertController(title:ALERT_TITLE.APP_NAME, message:alertMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action:UIAlertAction!) in
            if self.flag {
                self.flag = false
                self.performSegue(withIdentifier: "reviewToDashboard", sender: nil)
            }
        }))
        self.present(alertController, animated: true, completion: nil)
    }
 }



extension ReviewVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if self.reviewObj.orderItemData.count != 0 {
             return self.reviewObj.orderItemData.count
        } else {
             return 2
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ReviewCell
        
        if self.reviewObj.orderItemData.count != 0 {
            
            cell.hideSkeletonViews()
            
            cell.recipeImageview.sd_setImage(with: URL(string: (self.reviewObj.orderItemData[indexPath.row]["imageUrl"]?.stringValue)!), placeholderImage:UIImage(named: "recipePlaceholder"), options: .refreshCached)
            cell.recipeNameLabel.text =  self.reviewObj.orderItemData[indexPath.row]["dishName"]?.stringValue
            
            cell.tasteRatingView.tag = indexPath.row
            cell.quantityValueRatingView.tag = indexPath.row
            
            cell.tasteRatingView.delegate = self
            cell.quantityValueRatingView.delegate = self
            
        }
        
        return cell
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width * 0.74666667, height: collectionView.bounds.size.height * 0.28485757);
    }
}

extension ReviewVC : FloatRatingViewDelegate {
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Float) {
        print("Rating")
        let indexPath = IndexPath(row: ratingView.tag, section: 0)
        let cell: ReviewCell = self.reviewCollectionView.cellForItem(at: indexPath) as! ReviewCell
       
        self.reviewObj.orderItemData[indexPath.row]["tasteRating"] = JSON(String(format: "%.2f", cell.tasteRatingView.rating))
        self.reviewObj.orderItemData[indexPath.row]["quantityValue"] = JSON(String(format: "%.2f", cell.quantityValueRatingView.rating))
        
        print(self.reviewObj.orderItemData)
    }
}

extension ReviewVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !comments.text.isEmpty
    }
}
