//
//  OrderDetailsViewController.swift
//  CookAMeal
//
//  Created by Cynoteck on 18/04/18.
//  Copyright © 2018 Cynoteck. All rights reserved.
//

import UIKit
import SwiftyJSON
import CRNotifications
import JGProgressHUD
import GoogleMaps
import BraintreeDropIn
import Braintree
import MapKit



class OrderDetailsViewController: UIViewController {
    
    //constraint outlet
    @IBOutlet weak var mapHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var addressStackview: UIStackView!
    @IBOutlet weak var deliveryAddressStackview: UIStackView!
    @IBOutlet weak var bottomStackviewTop: NSLayoutConstraint!
    @IBOutlet weak var bottomStackviewBottom: NSLayoutConstraint!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var waitingForDeliverHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var deiveryDateTimeHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var deliveryAddressMapView: GMSMapView!
    @IBOutlet weak var imageView: UIImageViewX!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var orderIdLabel: UILabel!
    @IBOutlet weak var orderDateLabel: UILabel!
    @IBOutlet weak var stackviewOutlet: UIStackView!
    @IBOutlet weak var specialInstructionTextview: UITextView!
    @IBOutlet weak var deliveryTypeLabel: UILabel!
    @IBOutlet weak var deliveryFeeLabel: UILabel!
    @IBOutlet weak var totalTaxLabel: UILabel!
    @IBOutlet weak var stackViewHeightConstriant: NSLayoutConstraint!
    @IBOutlet weak var rejectButtonOutlet: RoundedButton!
    @IBOutlet weak var approveButtonOutlet: RoundedButton!
    
    @IBOutlet weak var streetAddressLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var deliveryLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    @IBOutlet weak var orderApprovalStackView: UIStackView!
    @IBOutlet weak var orderApproveStackView: UIStackView!
    @IBOutlet weak var deliveryDateTimeStackView: UIStackView!
    @IBOutlet weak var customerApprovalStackView: UIStackView!
    @IBOutlet weak var waitingForDeliveryStackView: UIStackView!
    @IBOutlet weak var orderApprovedDateLabel: UILabel!
    @IBOutlet weak var approvedTransactionLabel: UILabel!
    
    @IBOutlet weak var notReceiveOrderButtonOutlet: UIButton!
    @IBOutlet weak var cookDeliveryLabelOutlet: UILabel!
    @IBOutlet weak var deliveredTheOrderButtonOutlet: UIButton!
    
    @IBOutlet weak var waitingForDeliveryLabelOutlet: UILabel!
    @IBOutlet weak var estimationDeliveryDateTimeOutlet: UILabel!
    @IBOutlet weak var yesIRecieveOrder: UIButton!
    @IBOutlet weak var reviewOrderButtonOutlet: UIButton!
    @IBOutlet weak var orderRevceiveLabelOutlet: UILabel!
    
    @IBOutlet weak var orderCancellationStackview: UIStackView! 
    @IBOutlet weak var orderCancelTitleLabelOutlet: UILabel!
    @IBOutlet weak var dateLabelOutlet: UILabel!
    @IBOutlet weak var reasonLabelOutlet: UILabel!
    @IBOutlet weak var descriptionLabelOutlet: UILabel!
    
    @IBOutlet weak var cookServiceStatus: UIStackView!
    @IBOutlet weak var customerServiceStatus: UIStackView!
    @IBOutlet weak var deliveryCustomerStackview: UIStackView!
    
    @IBOutlet weak var specialInstructionLabelOutlet: UILabel!
    @IBOutlet weak var underlineView: UIView!
    @IBOutlet weak var specialInstructionHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var verticalConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var deliveryTypeStackview: UIStackView!
    @IBOutlet weak var deliveryFeeStackview: UIStackView!
    @IBOutlet weak var serviceDeliverSuccessLabel: UILabel!
    @IBOutlet weak var deliverServiceButtonOutlet: UIButton!
    @IBOutlet weak var heightConstriantForServiceStatusStackview: NSLayoutConstraint!
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var serviceDetailDateLabel: UILabel!
    @IBOutlet weak var serviceDetailStartTime: UILabel!
    @IBOutlet weak var serviceDetailEndTime: UILabel!
    @IBOutlet weak var cookApprovalStatusStackview: UIStackView!
    @IBOutlet weak var orderApprovalDateLabel: UILabel!
    @IBOutlet weak var TransactionIdLabelOutlet: UILabel!
    
    
    @IBOutlet weak var serviceDateStackview: UIStackView!
    @IBOutlet weak var serviceStartStackview: UIStackView!
    @IBOutlet weak var serviceEndStackview: UIStackView!
    @IBOutlet weak var hireOrderRecieve: UILabel!
    
    
    @IBOutlet weak var recieveServiceButtonOutlet: UIButton!
    @IBOutlet weak var notRecieveServiceOutlet: UIButton!
    @IBOutlet weak var reviewServiceOutlet: UIButton!
    
    @IBOutlet weak var bottomStackViewBottomConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var rePaymentButtonOutlet: RoundedButton!
    @IBOutlet weak var infromForRepayment: RoundedButton!
    @IBOutlet weak var cancelOrder: RoundedButton!
    @IBOutlet weak var directionButtonOutlet: UIButton!
    @IBOutlet weak var directionHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var cookDateTimeOfDelivery: UILabel!
    
    @IBOutlet weak var waitingForOrderToBeDeliver: UIStackView!
    @IBOutlet weak var waitingForCustomerToReceiveOrder: UILabel!
    @IBOutlet weak var customerReceiveOrderDateTime: UILabel!
    
    @IBOutlet weak var orderConfirmedLabelOutlet: UILabel!
    @IBOutlet weak var orderConfirmedDateTime: UILabel!
    @IBOutlet weak var backgroundViewForIdAndDate: UIView!
    @IBOutlet weak var orderTypeLabelOutlet: UILabel!
    @IBOutlet weak var deliveryAddressLabelOutlet: UILabel!
    
    let hud = JGProgressHUD(style: .light)
    var orderId = String()
    let orderDetailsObj : OrderDetailsModel = OrderDetailsModel()
    var rejectRepaymentObj : RejectRepaymentModel = RejectRepaymentModel()
    let orderFinalObj: OrderFinalScreenModel = OrderFinalScreenModel()
    
    var type = String()
    var isNotification = Bool()
    var notificationId = String()
    var notificationType = String()
    var orderType = String()
    var flagTypeToCheckcancellationType = Bool()
    var approveCheck = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        orderApprovalStackView.isHidden = true
        orderApproveStackView.isHidden = true
        deliveryDateTimeStackView.isHidden = true
        customerApprovalStackView.isHidden = true
        waitingForDeliveryStackView.isHidden = true
        orderCancellationStackview.isHidden = true
        cookServiceStatus.isHidden = true
        cookApprovalStatusStackview.isHidden = true
        customerServiceStatus.isHidden = true
        deliveryCustomerStackview.isHidden = true
        waitingForOrderToBeDeliver.isHidden = true
        
        //Set the background color of the view.
        if type == "3" {
            backgroundViewForIdAndDate.backgroundColor = #colorLiteral(red: 0, green: 0.3921568627, blue: 0.2392156863, alpha: 1)
        }
        
        
        //Hide the bottom button for the segment type 2(Approved) and type 3(Completed)
        if type == "2" || type == "3" {
            bottomStackviewTop.constant = 0
            bottomStackviewBottom.constant = 0
            heightConstraint.constant = 0
        }
        
       
        
        hud.textLabel.text = PROGRESS_HUD.HUD_LABEL_KEY
        hud.show(in: self.view)
        if isNotification {
            //For Notification Service
            orderDetailsObj.getOrderDetails(isNotification: isNotification, type: notificationId, orderId: orderId) { (success) in
                self.hud.dismiss()
                if success {
                    self.manageServiceDataToDisplay()
                } else {
                    
                    self.rejectButtonOutlet.isHidden = true
                    self.approveButtonOutlet.isHidden = true
                    self.bottomStackviewTop.constant = 0
                    self.bottomStackviewBottom.constant = 0
                    //self.showAlertWithMessage(alertMessage: self.orderDetailsObj.alertMessage)
                    self.present(Helper.globalAlertView(with: LOGIN_CONSTANT.ALERT_HEADER_MESSAGE_KEY, message: self.orderDetailsObj.alertMessage), animated: true, completion: nil)
                    
                }
            }
        } else{
            //To check the simple order details
            orderDetailsObj.getOrderDetails(isNotification: isNotification, type: type, orderId: orderId) { (success) in
                self.hud.dismiss()
                if success {
                    self.manageServiceDataToDisplay()
                } else {
                    self.rejectButtonOutlet.isHidden = true
                    self.approveButtonOutlet.isHidden = true
                    self.bottomStackviewTop.constant = 0
                    self.bottomStackviewBottom.constant = 0
                    self.present(Helper.globalAlertView(with: LOGIN_CONSTANT.ALERT_HEADER_MESSAGE_KEY, message: self.orderDetailsObj.alertMessage), animated: true, completion: nil)
                }
            }
        }
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
    }
    
    
    func manageServiceDataToDisplay() {
        
        if isNotification {
            
            if !self.orderDetailsObj.orderData["isApproved"].boolValue {
                self.rejectButtonOutlet.isHidden = false
                self.approveButtonOutlet.isHidden = false
                
                self.bottomStackviewTop.constant = 20
                self.bottomStackviewBottom.constant = 20
                self.heightConstraint.constant = 40
            }
            
            
        }
        
        
        if self.orderDetailsObj.orderData["orderState"].stringValue == "COMPLETE" {
            type = "3"
        } else if self.orderDetailsObj.orderData["orderState"].stringValue == "PENDING" {
            if self.orderDetailsObj.orderData["isApproved"].boolValue {
                type = "2"
            } else {
                type = "1"
            }
        }
        
        self.orderTypeLabelOutlet.text = self.orderDetailsObj.orderData["orderType"].stringValue
        self.mainView.isHidden = false
        
        if self.orderDetailsObj.orderData["orderType"].stringValue == "Hire-A-Cook" {
            orderType = "1"
        } else {
            orderType = "0"
        }
        
        self.imageView.sd_setImage(with: URL(string: self.orderDetailsObj.orderData["cookProfile"]["profileUrl"].stringValue), placeholderImage:UIImage(named: "recipePlaceholder"), options: .refreshCached)
        
        self.nameLabel.text = self.orderDetailsObj.orderData["cookProfile"]["fullName"].stringValue

        self.orderIdLabel.text = self.orderDetailsObj.orderData[ID_KEY].stringValue
        
        self.orderDateLabel.text = UTCToLocal(date: self.orderDetailsObj.orderData["createdAt"].stringValue, fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: "dd/MM/yyyy")
        
        self.specialInstructionTextview.text = self.orderDetailsObj.orderData["specialInstruction"].stringValue
        
        self.totalTaxLabel.text = self.orderDetailsObj.orderData["taxes"].stringValue + "%"
        
        self.streetAddressLabel.text = self.orderDetailsObj.orderData["deliveryAddress"]["street"].stringValue
        
        self.cityLabel.text = self.orderDetailsObj.orderData["deliveryAddress"]["city"].stringValue + ", " + self.orderDetailsObj.orderData["deliveryAddress"]["zipCode"].stringValue
        
        self.stateLabel.text = self.orderDetailsObj.orderData["deliveryAddress"]["state"].stringValue
        
        self.countryLabel.text = self.orderDetailsObj.orderData["deliveryAddress"]["country"].stringValue
        
        self.totalPriceLabel.text = self.orderDetailsObj.orderData["currencySymbol"].stringValue + self.orderDetailsObj.orderData["totalAmount"].stringValue
        
        self.imageView.sd_setImage(with: URL(string: self.orderDetailsObj.orderData["profile"]["profileUrl"].stringValue), placeholderImage:UIImage(named: "recipePlaceholder"), options: .refreshCached)
        
        self.nameLabel.text = self.orderDetailsObj.orderData["profile"]["fullName"].stringValue
        
        
        //Delivery type helps to show or hide the map on cook and customer end.
        //If delivery type = 1 means pickup-free so the maps shows only at the customer end.
        //If delivery type = 2 means the map shows on the customer end.
        if self.orderDetailsObj.orderData["deliveryType"].stringValue == "1" {
            self.deliveryTypeLabel.text = "Pick-Up Free"
            self.deliveryLabel.text = "Pick-Up Date/Time: "
            
            if notificationType == "Hire" {
                
            } else {
                //self.deliveryFeeLabel.text =  self.getTime(date: self.orderDetailsObj.orderData["pickUpTime"].stringValue)
                self.directionHeightConstraint.constant = 0
                self.directionButtonOutlet.isHidden = true
                
            }
            
        } else {
            
            self.deliveryTypeLabel.text = "Charge Delivery Amount"
            self.deliveryLabel.text = "Delivery Fee: "
            self.deliveryFeeLabel.text = Helper.getUserDefaultValue(key: CURRENCY_SYMBOL_KEY)! + self.orderDetailsObj.orderData["deliveryFee"].stringValue
        }
        
        
        
        // Checking the condition for cook and customer.
        if self.orderDetailsObj.orderData["userRole"].stringValue == "1" {
            
            deliveryAddressLabelOutlet.text = "Customer Address"
            //Cook
            //Now cook can be hire for a recipe or  also order the recipe for other cook available.
            if self.orderDetailsObj.orderData["orderType"].stringValue == "Hire-A-Cook" {
                
                approveButtonOutlet.isHidden = false
                rejectButtonOutlet.setTitle("Reject", for: .normal)
                
                //For hire a cook
                if self.orderDetailsObj.orderData["repayment"].boolValue ||  self.orderDetailsObj.orderData["paymentStatus"].stringValue == "FAILED"{
                    self.rePaymentButtonOutlet.isHidden = false
                    self.cancelOrder.isHidden = false
                    self.rejectButtonOutlet.isHidden = true
                    self.approveButtonOutlet.isHidden = true
                    
                    self.bottomStackviewTop.constant = 20
                    self.bottomStackviewBottom.constant = 20
                    self.heightConstraint.constant = 40
                    
                }
                
                specialInstructionLabelOutlet.text = ""
                underlineView.isHidden = true
                specialInstructionHeightConstraint.constant = 0
                
                self.deliveryTypeStackview.isHidden = true
                self.deliveryFeeStackview.isHidden = true
                
                
                serviceDetailDateLabel.text = self.orderDetailsObj.orderData["serviceDetails"]["date"].stringValue
                    //UTCToLocal(date: self.orderDetailsObj.orderData["serviceDetails"]["date"].stringValue, fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: "dd/MM/yyyy")
                serviceDetailStartTime.text =  self.getTime(date: self.orderDetailsObj.orderData["serviceDetails"]["startTime"].stringValue)
                serviceDetailEndTime.text =  self.getTime(date: self.orderDetailsObj.orderData["serviceDetails"]["endTime"].stringValue)
                
                
                
                if self.orderDetailsObj.orderData["orderByMe"].boolValue {
                    self.rejectButtonOutlet.isHidden = false
                    self.rejectButtonOutlet.setTitle("Cancel Order", for: .normal)
                    self.approveButtonOutlet.isHidden = true
                    self.infromForRepayment.isHidden = true
                    self.cancelOrder.isHidden = true
                    self.rePaymentButtonOutlet.isHidden = true
                }
                
                
                
                if self.orderDetailsObj.orderData["isApproved"].boolValue {
                    
                    self.cookApprovalStatusStackview.isHidden = false
                    
                    self.TransactionIdLabelOutlet.text = "Transaction Id: " + self.orderDetailsObj.orderData["transactionId"].stringValue
                    
                    self.orderApprovalDateLabel.text = "Date/Time: " +  UTCToLocal(date: self.orderDetailsObj.orderData["approvedDate"].stringValue, fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: "dd/MM/yyyy hh:mm a")
                    
                    if self.type == "2" {
                        
                        self.orderApprovalStackView.isHidden = true
                        
                        if !self.orderDetailsObj.orderData["orderByMe"].boolValue {
                            if self.orderDetailsObj.orderData["isCookDeliveredTheOrder"].boolValue {
                                self.waitingForOrderToBeDeliver.isHidden = true
                                self.deliveryDateTimeStackView.isHidden = false
                                self.cookDeliveryLabelOutlet.text = "■ Order has been delivered by the cook."
                                self.deiveryDateTimeHeightConstraint.constant = 100
                                self.deliveredTheOrderButtonOutlet.isHidden = true
                                self.cookDateTimeOfDelivery.isHidden = false
                                self.cookDateTimeOfDelivery.text = "Date/Time: " +  UTCToLocal(date: self.orderDetailsObj.orderData["cookDeliveryDateTime"].stringValue, fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: "dd/MM/yyyy hh:mm a") //cookDeliveryDateTime
                                
                                // waiting for customer to recieve the order.
                                if self.orderDetailsObj.orderData["isCustomerReceiveTheOrder"].boolValue {
                                    self.customerServiceStatus.isHidden = false
                                    self.waitingForCustomerToReceiveOrder.text = " ■ Customer receive the order."
                                    self.customerReceiveOrderDateTime.isHidden = false
                                    self.customerReceiveOrderDateTime.text = "Date/Time: " +  UTCToLocal(date: self.orderDetailsObj.orderData["customerReceiveTheOrderDate"].stringValue, fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: "dd/MM/yyyy hh:mm a")
                                } else {
                                    self.customerServiceStatus.isHidden = false
                                }
                                
                            } else {
                                
//                                self.deliveryDateTimeStackView.isHidden = false
//                                self.cookDeliveryLabelOutlet.text = "■ Waiting for recipe to be deliver."
//                                self.deiveryDateTimeHeightConstraint.constant = 130
//                                self.deliveredTheOrderButtonOutlet.isHidden = false
                                
                                self.deliveryDateTimeStackView.isHidden = false
                                self.cookDeliveryLabelOutlet.text = "■ Waiting for deliver the service."
                                
                                self.deliveredTheOrderButtonOutlet.setTitle("Yes, I have deliver the service.",for: .normal)
                                
                                self.deliveredTheOrderButtonOutlet.tag = 1
                                
                            }
                            
                        } else {
                            
                            //if Cook Order the recipe.
                            if self.orderDetailsObj.orderData["isCookDeliveredTheOrder"].boolValue {
                                
                                self.waitingForOrderToBeDeliver.isHidden = true
                                self.deliveryDateTimeStackView.isHidden = false
                                self.cookDeliveryLabelOutlet.text = "■ Order has been delivered by the cook."
                                self.deiveryDateTimeHeightConstraint.constant = 100
                                self.deliveredTheOrderButtonOutlet.isHidden = true
                                self.cookDateTimeOfDelivery.isHidden = false
                                self.cookDateTimeOfDelivery.text = "Date/Time: " +  UTCToLocal(date: self.orderDetailsObj.orderData["cookDeliveryDateTime"].stringValue, fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: "dd/MM/yyyy hh:mm a") //cookDeliveryDateTime
                                
                                //Unhide the stack view of recive delivery.
                                self.waitingForDeliveryStackView.isHidden = false
                                
                                
                                
                            } else {
                                
                                self.waitingForOrderToBeDeliver.isHidden = false
                                self.cookDeliveryLabelOutlet.text = "■ Waiting for deliver the service."
                                self.deliveredTheOrderButtonOutlet.setTitle("Yes, I have deliver the service.", for: .normal)
                                self.deliveredTheOrderButtonOutlet.tag = 1
                                
                            }
                        }
                    }
                    
                    else if self.type == "3" {
                        
                        
                        bottomStackviewTop.constant = 0
                        bottomStackviewBottom.constant = 0
                        heightConstraint.constant = 0
                        
                        //Cook Approved the order
                        if self.orderDetailsObj.orderData["isApproved"].boolValue {
                            self.orderApproveStackView.isHidden = false
                            self.approvedTransactionLabel.text = "Transaction Id : " + self.orderDetailsObj.orderData["transactionId"].stringValue
                            
                            self.orderApprovedDateLabel.text = "Date : " +   UTCToLocal(date: self.orderDetailsObj.orderData["approvedDate"].stringValue, fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: "dd/MM/yyyy hh:mm a")
                        }
                        
                        //Cook delivered the order
                        if self.orderDetailsObj.orderData["isCookDeliveredTheOrder"].boolValue {
                            
                            self.waitingForOrderToBeDeliver.isHidden = true
                            self.deliveryDateTimeStackView.isHidden = false
                            self.cookDeliveryLabelOutlet.text = "■ Order has been delivered by the cook."
                            self.deiveryDateTimeHeightConstraint.constant = 100
                            self.deliveredTheOrderButtonOutlet.isHidden = true
                            self.cookDateTimeOfDelivery.isHidden = false
                            self.cookDateTimeOfDelivery.text = "Date/Time: " +  UTCToLocal(date: self.orderDetailsObj.orderData["cookDeliveryDateTime"].stringValue, fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: "dd/MM/yyyy hh:mm a") //cookDeliveryDateTime
                            
                            //Unhide the stack view of recive delivery.
                            self.waitingForDeliveryStackView.isHidden = false
                            
                        }
                        
                        // Customer Recieve the order.
                        if self.orderDetailsObj.orderData["isCookDeliveredTheOrder"].boolValue {
                            self.waitingForCustomerToReceiveOrder.isHidden = false
                            self.yesIRecieveOrder.isHidden = true
                            self.notReceiveOrderButtonOutlet.isHidden = true
                            
                            self.orderConfirmedLabelOutlet.isHidden = false
                            self.orderConfirmedDateTime.isHidden = false
                            self.orderConfirmedDateTime.text = "Date/Time: " +  UTCToLocal(date: self.orderDetailsObj.orderData["customerNotReceiveTheOrderDate"].stringValue, fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: "dd/MM/yyyy hh:mm a")
                            
                            if  self.orderDetailsObj.orderData["isReviewed"].boolValue {
                                self.reviewOrderButtonOutlet.isHidden = true
                            } else {
                                self.reviewOrderButtonOutlet.isHidden = false
                            }
                        }
                    }
                    
                } else {
                    
                     if self.orderDetailsObj.orderData["orderState"].stringValue == "CANCELLED" {
                        if type == "3" {
                            bottomStackviewTop.constant = 0
                            bottomStackviewBottom.constant = 0
                            heightConstraint.constant = 0
                        }
                     } else {
                        bottomStackviewTop.constant = 20
                        bottomStackviewBottom.constant = 20
                        heightConstraint.constant = 40
                    }
                    
                    
                }
                
            } else if self.orderDetailsObj.orderData["orderType"].stringValue == "Order-Food" {
                
                //approveButtonOutlet.isHidden = false
                //rejectButtonOutlet.setTitle("Reject", for: .normal)
                
                serviceDateStackview.isHidden = true
                serviceStartStackview.isHidden = true
                serviceEndStackview.isHidden = true
                self.orderApprovalStackView.isHidden = true
                
                //For Rejection And Repayment (Order-Cook)
                if self.orderDetailsObj.orderData["repayment"].boolValue ||  self.orderDetailsObj.orderData["paymentStatus"].stringValue == "FAILED"{
                    
                    approveCheck = true
                    self.rejectButtonOutlet.isHidden = false
                    self.approveButtonOutlet.isHidden = true
                    self.infromForRepayment.isHidden = false
                    self.cancelOrder.isHidden = true
                    self.rePaymentButtonOutlet.isHidden = true
                    
                }
                
                
                //For ordering food (Order-Cook)
                if self.orderDetailsObj.orderData["isApproved"].boolValue {
                    
                    self.cookApprovalStatusStackview.isHidden = false
                    
                    self.TransactionIdLabelOutlet.text = "Transaction Id: " + self.orderDetailsObj.orderData["transactionId"].stringValue
                    
                    self.orderApprovalDateLabel.text = "Date/Time: " +  UTCToLocal(date: self.orderDetailsObj.orderData["approvedDate"].stringValue, fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: "dd/MM/yyyy hh:mm a")
                    
                    
                    if self.type == "2" {
                        
                        self.orderApprovalStackView.isHidden = true
                        
                        if !self.orderDetailsObj.orderData["orderByMe"].boolValue {
                            if self.orderDetailsObj.orderData["isCookDeliveredTheOrder"].boolValue {
                                self.waitingForOrderToBeDeliver.isHidden = true
                                self.deliveryDateTimeStackView.isHidden = false
                                self.cookDeliveryLabelOutlet.text = "■ Order has been delivered by the cook."
                                self.deiveryDateTimeHeightConstraint.constant = 100
                                self.deliveredTheOrderButtonOutlet.isHidden = true
                                self.cookDateTimeOfDelivery.isHidden = false
                                self.cookDateTimeOfDelivery.text = "Date/Time: " +  UTCToLocal(date: self.orderDetailsObj.orderData["cookDeliveryDateTime"].stringValue, fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: "dd/MM/yyyy hh:mm a") //cookDeliveryDateTime
                                
                                // waiting for customer to recieve the order.
                                if self.orderDetailsObj.orderData["isCustomerReceiveTheOrder"].boolValue {
                                    self.customerServiceStatus.isHidden = false
                                    self.waitingForCustomerToReceiveOrder.text = " ■ Customer receive the order."
                                    self.customerReceiveOrderDateTime.isHidden = false
                                    self.customerReceiveOrderDateTime.text = "Date/Time: " +  UTCToLocal(date: self.orderDetailsObj.orderData["customerReceiveTheOrderDate"].stringValue, fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: "dd/MM/yyyy hh:mm a")
                                } else {
                                    self.customerServiceStatus.isHidden = false
                                }
                                
                            } else {
                                
                                self.deliveryDateTimeStackView.isHidden = false
                                self.cookDeliveryLabelOutlet.text = "■ Waiting for recipe to be deliver."
                                self.deiveryDateTimeHeightConstraint.constant = 130
                                self.deliveredTheOrderButtonOutlet.isHidden = false
                              
                            }
                            
                        } else {
                            
                            //if Cook Order the recipe.
                            if self.orderDetailsObj.orderData["isCookDeliveredTheOrder"].boolValue {
                                
                                self.waitingForOrderToBeDeliver.isHidden = true
                                self.deliveryDateTimeStackView.isHidden = false
                                self.cookDeliveryLabelOutlet.text = "■ Order has been delivered by the cook."
                                self.deiveryDateTimeHeightConstraint.constant = 100
                                self.deliveredTheOrderButtonOutlet.isHidden = true
                                self.cookDateTimeOfDelivery.isHidden = false
                                self.cookDateTimeOfDelivery.text = "Date/Time: " +  UTCToLocal(date: self.orderDetailsObj.orderData["cookDeliveryDateTime"].stringValue, fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: "dd/MM/yyyy hh:mm a") //cookDeliveryDateTime
                                
                                //Unhide the stack view of recive delivery.
                                self.waitingForDeliveryStackView.isHidden = false
                                
                            } else {
                                
                                if self.orderDetailsObj.orderData["orderByMe"].boolValue {
                                    if self.orderDetailsObj.orderData["isCookDeliveredTheOrder"].boolValue {
                                        self.waitingForOrderToBeDeliver.isHidden = true
                                    } else{
                                        self.waitingForOrderToBeDeliver.isHidden = false
                                    }
                                }
                            }
                        }
                    }
                    
                    //Order-Cook
                    else if self.type == "3" {
                        
                        //Cook Approved the order
                        if self.orderDetailsObj.orderData["isApproved"].boolValue {
                            
                            self.cookApprovalStatusStackview.isHidden = false
                            
                            self.TransactionIdLabelOutlet.text = "Transaction Id: " + self.orderDetailsObj.orderData["transactionId"].stringValue
                            
                            self.orderApprovalDateLabel.text = "Date/Time: " +  UTCToLocal(date: self.orderDetailsObj.orderData["approvedDate"].stringValue, fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: "dd/MM/yyyy hh:mm a")
                        }
                        
                        
                        if self.orderDetailsObj.orderData["isCookDeliveredTheOrder"].boolValue {
                            
                            self.waitingForOrderToBeDeliver.isHidden = true
                            self.deliveryDateTimeStackView.isHidden = false
                            self.cookDeliveryLabelOutlet.text = "■ Order has been delivered by the cook."
                            self.deiveryDateTimeHeightConstraint.constant = 100
                            self.deliveredTheOrderButtonOutlet.isHidden = true
                            self.cookDateTimeOfDelivery.isHidden = false
                            self.cookDateTimeOfDelivery.text = "Date/Time: " +  UTCToLocal(date: self.orderDetailsObj.orderData["cookDeliveryDateTime"].stringValue, fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: "dd/MM/yyyy hh:mm a") //cookDeliveryDateTime
                            
                            //Unhide the stack view of recive delivery.
                            self.waitingForDeliveryStackView.isHidden = false
                            
                        }
                        
                        // Customer Recieve the order.
                        if self.orderDetailsObj.orderData["isCookDeliveredTheOrder"].boolValue {
                            self.waitingForCustomerToReceiveOrder.isHidden = false
                            self.yesIRecieveOrder.isHidden = true
                            self.notReceiveOrderButtonOutlet.isHidden = true
                            
                            self.orderConfirmedLabelOutlet.isHidden = false
                            self.orderConfirmedDateTime.isHidden = false
                            self.orderConfirmedDateTime.text = "Date/Time: " +  UTCToLocal(date: self.orderDetailsObj.orderData["cookDeliveryDateTime"].stringValue, fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: "dd/MM/yyyy hh:mm a")
                            
//                            if  self.orderDetailsObj.orderData["isReviewed"].boolValue {
//                                self.reviewOrderButtonOutlet.isHidden = true
//                            } else {
//                                self.reviewOrderButtonOutlet.isHidden = false
//                            }
                        }
                    }
                    
                } else {
                    
                    if self.orderDetailsObj.orderData["orderByMe"].boolValue {
                        approveButtonOutlet.isHidden = true
                        rejectButtonOutlet.setTitle("Cancel Order", for: .normal)
                    } else {
                        
                        if approveCheck {
                            approveCheck = false
                            approveButtonOutlet.isHidden = true
                        } else{
                            approveButtonOutlet.isHidden = false  //Rohit
                        }
                        
                        rejectButtonOutlet.setTitle("Reject", for: .normal)
                    }
                    
                    
                    if self.orderDetailsObj.orderData["orderState"].stringValue == "CANCELLED" {
                        bottomStackviewTop.constant = 0
                        bottomStackviewBottom.constant = 0
                        heightConstraint.constant = 0
                        
                        //Showing the rejection stackview
                        orderCancellationStackview.isHidden = false
                        dateLabelOutlet.text = "Date/Time: " +  UTCToLocal(date: self.orderDetailsObj.orderData["OrderStateMaster"]["createdAt"].stringValue, fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: "dd/MM/yyyy hh:mm a")
                        reasonLabelOutlet.text = "Reason: " + self.orderDetailsObj.orderData["OrderStateMaster"]["reason"].stringValue
                        descriptionLabelOutlet.text = "Description:" + self.orderDetailsObj.orderData["OrderStateMaster"]["description"].stringValue
                        orderCancelTitleLabelOutlet.text = "Order is Cancelled "
                        
                    }
                    
                    
                    if self.orderDetailsObj.orderData["orderState"].stringValue == "REJECTED" {
                        bottomStackviewTop.constant = 0
                        bottomStackviewBottom.constant = 0
                        heightConstraint.constant = 0
                        
                        //Showing the rejection stackview
                        orderCancellationStackview.isHidden = false
                        dateLabelOutlet.text = "Date/Time: " +  UTCToLocal(date: self.orderDetailsObj.orderData["OrderStateMaster"]["createdAt"].stringValue, fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: "dd/MM/yyyy hh:mm a")
                        reasonLabelOutlet.text = "Reason: " + self.orderDetailsObj.orderData["OrderStateMaster"]["reason"].stringValue
                        descriptionLabelOutlet.text = "Description:" + self.orderDetailsObj.orderData["OrderStateMaster"]["description"].stringValue
                        orderCancelTitleLabelOutlet.text = "Order is Rejected "
                        
                    }
                    
                    
                    
                }
                
                
                //Customer cancel the order.
                if self.orderDetailsObj.orderData["orderStateDetails"]["isCancelled"].boolValue {
                    
                    bottomStackviewTop.constant = 0
                    bottomStackviewBottom.constant = 0
                    heightConstraint.constant = 0
                    
                    orderCancellationStackview.isHidden = false
                    orderCancelTitleLabelOutlet.text = "Order Cancelled"
                    
                    dateLabelOutlet.text = "Date: " +  UTCToLocal(date: self.orderDetailsObj.orderData["orderStateDetails"]["createdAt"].stringValue, fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: "dd/MM/yyyy")
                    reasonLabelOutlet.text = "Reason: " + self.orderDetailsObj.orderData["orderStateDetails"]["reason"].stringValue
                    descriptionLabelOutlet.text = "Description :" + self.orderDetailsObj.orderData["orderStateDetails"]["description"].stringValue
                    
                }
                
                
            }
            
         /*
            else {
                
                approveButtonOutlet.isHidden = false
                rejectButtonOutlet.setTitle("Reject", for: .normal)
                
                serviceDateStackview.isHidden = true
                serviceStartStackview.isHidden = true
                serviceEndStackview.isHidden = true
                
                //For Rejection And Repayment
                if self.orderDetailsObj.orderData["repayment"].boolValue ||  self.orderDetailsObj.orderData["paymentStatus"].stringValue == "FAILED"{
                  
                    self.rejectButtonOutlet.isHidden = false
                    self.approveButtonOutlet.isHidden = true
                    self.infromForRepayment.isHidden = false
                    self.cancelOrder.isHidden = true
                    self.rePaymentButtonOutlet.isHidden = true
                   
                }
                
                
                
                //For ordering food
                if self.orderDetailsObj.orderData["isApproved"].boolValue {
                    
                    if self.type == "2" {
                        
                        if self.orderDetailsObj.orderData["isCookDeliveredTheOrder"].boolValue {
                            self.deliveryDateTimeStackView.isHidden = false
                            self.cookDeliveryLabelOutlet.text = "Order Succesfully Delivered."
                            self.deiveryDateTimeHeightConstraint.constant = 80
                            self.deliveredTheOrderButtonOutlet.isHidden = true
                        } else {
                            self.deliveryDateTimeStackView.isHidden = false
                            self.cookDeliveryLabelOutlet.text = "Waiting for recipe to be deliver."
                            self.deiveryDateTimeHeightConstraint.constant = 130
                            self.deliveredTheOrderButtonOutlet.isHidden = false
                        }
                    }
                    
                } else {
                    bottomStackviewTop.constant = 20
                    bottomStackviewBottom.constant = 20
                    heightConstraint.constant = 40
                }
                
                //Customer cancel the order.
                if self.orderDetailsObj.orderData["orderStateDetails"]["isCancelled"].boolValue {
                    
                    bottomStackviewTop.constant = 0
                    bottomStackviewBottom.constant = 0
                    heightConstraint.constant = 0
                    
                    orderCancellationStackview.isHidden = false
                    orderCancelTitleLabelOutlet.text = "Order Cancelled"
                    dateLabelOutlet.text = "Date: " + getDate(date: self.orderDetailsObj.orderData["orderStateDetails"]["createdAt"].stringValue)
                    reasonLabelOutlet.text = "Reason: " + self.orderDetailsObj.orderData["orderStateDetails"]["reason"].stringValue
                    descriptionLabelOutlet.text = self.orderDetailsObj.orderData["orderStateDetails"]["description"].stringValue
                    
                }
            }
*/
            //
            
        } else {
            
            //Customer
            approveButtonOutlet.isHidden = true
            rejectButtonOutlet.setTitle("Cancel Order", for: .normal)
            
            if self.orderDetailsObj.orderData["orderType"].stringValue == "Hire-A-Cook" {
                
                
                if self.orderDetailsObj.orderData["repayment"].boolValue ||  self.orderDetailsObj.orderData["paymentStatus"].stringValue == "FAILED"{
                    self.rePaymentButtonOutlet.isHidden = false
                    self.cancelOrder.isHidden = false
                    self.rejectButtonOutlet.isHidden = true
                    self.approveButtonOutlet.isHidden = true
                    
                    self.bottomStackviewTop.constant = 20
                    self.bottomStackviewBottom.constant = 20
                    self.heightConstraint.constant = 40
                    
                }
                
                
                //For Hire-A-Cook
                specialInstructionLabelOutlet.text = ""
                underlineView.isHidden = true
                specialInstructionHeightConstraint.constant = 0
                self.directionHeightConstraint.constant = 0
                self.directionButtonOutlet.isHidden = true
                
                deliveryFeeStackview.isHidden = true
                deliveryTypeStackview.isHidden = true
                
           
               
                serviceDetailDateLabel.text =  UTCToLocal(date: self.orderDetailsObj.orderData["serviceDetails"]["date"].stringValue, fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: "dd/MM/yyyy")
                serviceDetailStartTime.text = getTime(date: self.orderDetailsObj.orderData["serviceDetails"]["startTime"].stringValue)
                serviceDetailEndTime.text =  getTime(date: self.orderDetailsObj.orderData["serviceDetails"]["endTime"].stringValue)
                
                //Here the type indicate the Pending / Approved / Complete the order.
                //type = 1 pending
                if self.type == "1" {
                    //Cook Approved the order
                    if !self.orderDetailsObj.orderData["isApproved"].boolValue {
                        self.orderApprovalStackView.isHidden = false
                    }
                }
                
                
                if self.type == "2" {
                    //Cook Approved the order
//                    if self.orderDetailsObj.orderData["isApproved"].boolValue {
//
//                        self.cookApprovalStatusStackview.isHidden = false
//                        self.orderApprovalDateLabel.text = "Date: " +   UTCToLocal(date: self.orderDetailsObj.orderData["approvedDate"].stringValue, fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: "dd/MM/yyyy hh:mm a")
//                        self.TransactionIdLabelOutlet.text = "Transaction #: " + self.orderDetailsObj.orderData["transactionId"].stringValue
//                        self.deliveryCustomerStackview.isHidden = false
//
//                    }
                    
                    if self.orderDetailsObj.orderData["isApproved"].boolValue {
                        
                        self.cookApprovalStatusStackview.isHidden = false
                        self.orderApprovalStackView.isHidden = true
                        
                        self.TransactionIdLabelOutlet.text = "Transaction Id: " + self.orderDetailsObj.orderData["transactionId"].stringValue
                        
                        self.orderApprovalDateLabel.text = "Date/Time: " +  UTCToLocal(date: self.orderDetailsObj.orderData["approvedDate"].stringValue, fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: "dd/MM/yyyy hh:mm a")
                        
                        //Show stack of waiting for delivery if order is approved.
                        if self.orderDetailsObj.orderData["isCookDeliveredTheOrder"].boolValue {
                            
                            self.waitingForOrderToBeDeliver.isHidden = true
                            self.deliveryDateTimeStackView.isHidden = false
                            self.cookDeliveryLabelOutlet.text = "■ Order has been delivered by the cook."
                            self.deiveryDateTimeHeightConstraint.constant = 100
                            self.deliveredTheOrderButtonOutlet.isHidden = true
                            self.cookDateTimeOfDelivery.isHidden = false
                            self.cookDateTimeOfDelivery.text = "Date/Time: " +  UTCToLocal(date: self.orderDetailsObj.orderData["cookDeliveryDateTime"].stringValue, fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: "dd/MM/yyyy hh:mm a") //cookDeliveryDateTime
                            
                            //Unhide the stack view of recive delivery.
                            self.waitingForDeliveryStackView.isHidden = false
                            
                            self.yesIRecieveOrder.setTitle("Yes, I Recieved the service.", for: .normal)
                            self.yesIRecieveOrder.tag = 1
                            
                            self.notReceiveOrderButtonOutlet.setTitle("Not Receive the service.", for: .normal)
                            self.notReceiveOrderButtonOutlet.tag = 1
                            
                        } else {
                            self.waitingForOrderToBeDeliver.isHidden = false
                        }
                    }
                    
                    
                }
                
                
                if self.type == "3" {
                    
                    //Cook Approved the order
                    if self.orderDetailsObj.orderData["isApproved"].boolValue {
                        self.orderApproveStackView.isHidden = false
                        self.approvedTransactionLabel.text = "Transaction Id : " + self.orderDetailsObj.orderData["transactionId"].stringValue
                        
                        self.orderApprovedDateLabel.text = "Date : " +   UTCToLocal(date: self.orderDetailsObj.orderData["approvedDate"].stringValue, fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: "dd/MM/yyyy hh:mm a")
                    }
                    
                    //Cook delivered the order
                    if self.orderDetailsObj.orderData["isCookDeliveredTheOrder"].boolValue {
                        
                        self.waitingForOrderToBeDeliver.isHidden = true
                        self.deliveryDateTimeStackView.isHidden = false
                        self.cookDeliveryLabelOutlet.text = "■ Order has been delivered by the cook."
                        self.deiveryDateTimeHeightConstraint.constant = 100
                        self.deliveredTheOrderButtonOutlet.isHidden = true
                        self.cookDateTimeOfDelivery.isHidden = false
                        self.cookDateTimeOfDelivery.text = "Date/Time: " +  UTCToLocal(date: self.orderDetailsObj.orderData["cookDeliveryDateTime"].stringValue, fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: "dd/MM/yyyy hh:mm a") //cookDeliveryDateTime
                        
                        //Unhide the stack view of recive delivery.
                        self.waitingForDeliveryStackView.isHidden = false
                        
                    }
                    
                    // Customer Recieve the order.
                    if self.orderDetailsObj.orderData["isCookDeliveredTheOrder"].boolValue {
                        self.waitingForCustomerToReceiveOrder.isHidden = false
                        self.yesIRecieveOrder.isHidden = true
                        self.notReceiveOrderButtonOutlet.isHidden = true
                        
                        self.orderConfirmedLabelOutlet.isHidden = false
                        self.orderConfirmedDateTime.isHidden = false
                        self.orderConfirmedDateTime.text = "Date/Time: " +  UTCToLocal(date: self.orderDetailsObj.orderData["customerNotReceiveTheOrderDate"].stringValue, fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: "dd/MM/yyyy hh:mm a")
                        
                        if  self.orderDetailsObj.orderData["isReviewed"].boolValue {
                            self.reviewOrderButtonOutlet.isHidden = true
                        } else {
                            self.reviewOrderButtonOutlet.isHidden = false
                        }
                    } else {
                        
                        self.waitingForCustomerToReceiveOrder.isHidden = false
                        self.yesIRecieveOrder.isHidden = true
                        self.notReceiveOrderButtonOutlet.isHidden = true
                        
                        self.orderConfirmedLabelOutlet.isHidden = false
                        self.orderConfirmedLabelOutlet.text = "■ Order has been cancelled."
                        self.orderConfirmedDateTime.isHidden = false
                        self.orderConfirmedDateTime.text = "Date/Time: " +  UTCToLocal(date: self.orderDetailsObj.orderData["customerNotReceiveTheOrderDate"].stringValue, fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: "dd/MM/yyyy hh:mm a")
                        
                        if  self.orderDetailsObj.orderData["isReviewed"].boolValue {
                            self.reviewOrderButtonOutlet.isHidden = true
                        } else {
                            self.reviewOrderButtonOutlet.isHidden = false
                        }
                    }
                }
                
            } else {
                
                //Customer order-A-Food.
                self.serviceDateStackview.isHidden = true
                self.serviceStartStackview.isHidden = true
                self.serviceEndStackview.isHidden = true
                
                if self.orderDetailsObj.orderData["repayment"].boolValue ||  self.orderDetailsObj.orderData["paymentStatus"].stringValue == "FAILED" {
                    
                    self.rePaymentButtonOutlet.isHidden = false
                    self.cancelOrder.isHidden = false
                    self.rejectButtonOutlet.isHidden = true
                    self.approveButtonOutlet.isHidden = true
                    self.bottomStackviewTop.constant = 20
                    self.bottomStackviewBottom.constant = 20
                    self.heightConstraint.constant = 40
                    
                }
                
                
                //For Order-A-Food.
                if self.type == "1" {
                    //Cook Approved the order
                    if !self.orderDetailsObj.orderData["isApproved"].boolValue {
                        self.orderApprovalStackView.isHidden = false
                    }
                    
                    // Showing or Hiding Map button.
                    if self.orderDetailsObj.orderData["deliveryType"].stringValue == "1" {
                        self.directionHeightConstraint.constant = 40
                    } else {
                        self.directionHeightConstraint.constant = 0
                        self.directionButtonOutlet.isHidden = true
                    }
                    
                    
                } else if self.type == "2" {
                    
                    //For ordering food
                    if self.orderDetailsObj.orderData["isApproved"].boolValue {
                        
                        self.cookApprovalStatusStackview.isHidden = false
                        self.orderApprovalStackView.isHidden = true
                        self.TransactionIdLabelOutlet.text = "Transaction Id: " + self.orderDetailsObj.orderData["transactionId"].stringValue
                        
                        self.orderApprovalDateLabel.text = "Date/Time: " +  UTCToLocal(date: self.orderDetailsObj.orderData["approvedDate"].stringValue, fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: "dd/MM/yyyy hh:mm a")
                        
                        //Show stack of waiting for delivery if order is approved.
                        if self.orderDetailsObj.orderData["isCookDeliveredTheOrder"].boolValue {
                            
                            self.waitingForOrderToBeDeliver.isHidden = true
                            self.deliveryDateTimeStackView.isHidden = false
                            self.cookDeliveryLabelOutlet.text = "■ Order has been delivered by the cook."
                            self.deiveryDateTimeHeightConstraint.constant = 100
                            self.deliveredTheOrderButtonOutlet.isHidden = true
                            self.cookDateTimeOfDelivery.isHidden = false
                            self.cookDateTimeOfDelivery.text = "Date/Time: " +  UTCToLocal(date: self.orderDetailsObj.orderData["cookDeliveryDateTime"].stringValue, fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: "dd/MM/yyyy hh:mm a") //cookDeliveryDateTime
                            
                            //Unhide the stack view of recive delivery.
                            self.waitingForDeliveryStackView.isHidden = false
                            
                        } else {
                           self.waitingForOrderToBeDeliver.isHidden = false
                        }
                    }
                    
                    
                    ////////////////Cook Approved the order/////////////////////
                    /*
                    if self.orderDetailsObj.orderData["isApproved"].boolValue {
                        self.orderApproveStackView.isHidden = false
                        self.approvedTransactionLabel.text = "Transaction Id : " + self.orderDetailsObj.orderData["transactionId"].stringValue
                        
                        self.orderApprovedDateLabel.text = "Date : " + UTCToLocal(date: self.orderDetailsObj.orderData["approvedDate"].stringValue, fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: "dd/MM/yyyy hh:mm a")
                    } */
                    
                    
                    /////////////////Cook delivered the order/////////////////
                    /*
                    if self.orderDetailsObj.orderData["isCookDeliveredTheOrder"].boolValue {
                        
                        self.waitingForDeliveryStackView.isHidden = false
                        let date = self.getDate(date: self.orderDetailsObj.orderData["cookDeliveryDateTime"].stringValue)
                        let time = self.getTime(date: self.orderDetailsObj.orderData["cookDeliveryDateTime"].stringValue)
                        self.estimationDeliveryDateTimeOutlet.text = "Date/Time :" + date + " " + time
                        self.waitingForDeliverHeightConstraint.constant = 160
                        self.yesIRecieveOrder.isHidden = false
                        self.notReceiveOrderButtonOutlet.isHidden = false
                        
                    } else{
                        self.waitingForDeliveryStackView.isHidden = false
                        let date = self.getDate(date: self.orderDetailsObj.orderData["cookDeliveryDateTime"].stringValue)
                        let time = self.getTime(date: self.orderDetailsObj.orderData["cookDeliveryDateTime"].stringValue)
                        self.estimationDeliveryDateTimeOutlet.text = "Date/Time :" + date + " " + time
                        self.waitingForDeliverHeightConstraint.constant = 90
                        self.yesIRecieveOrder.isHidden = true
                        self.notReceiveOrderButtonOutlet.isHidden = true
                    } */
                    
                    
                    // Cook reject the order.
                    if self.orderDetailsObj.orderData["orderStateDetails"]["isRejected"].boolValue {
                        
                        bottomStackviewTop.constant = 0
                        bottomStackviewBottom.constant = 0
                        heightConstraint.constant = 0
                        
                        orderCancellationStackview.isHidden = false
                        waitingForDeliveryStackView.isHidden = false
                        orderCancelTitleLabelOutlet.text = "Order Cancelled"
                       
                        dateLabelOutlet.text = "Date: " +  UTCToLocal(date: self.orderDetailsObj.orderData["orderStateDetails"]["createdAt"].stringValue, fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: "dd/MM/yyyy")
                        reasonLabelOutlet.text = "Reason: " + self.orderDetailsObj.orderData["orderStateDetails"]["reason"].stringValue
                        descriptionLabelOutlet.text = self.orderDetailsObj.orderData["orderStateDetails"]["description"].stringValue
                        
                    }
                    
                    // Showing or Hiding Map.
                    if self.orderDetailsObj.orderData["deliveryType"].stringValue == "1" {
                        self.directionHeightConstraint.constant = 40
                    } else {
                        self.directionHeightConstraint.constant = 0
                        self.directionButtonOutlet.isHidden = true
                    }
                    
                } else if self.type == "3" {
                    
                   
                    
                    //Cook Approved the order
                    if self.orderDetailsObj.orderData["isApproved"].boolValue {
                        self.orderApproveStackView.isHidden = false
                        self.approvedTransactionLabel.text = "Transaction Id : " + self.orderDetailsObj.orderData["transactionId"].stringValue
                       
                        self.orderApprovedDateLabel.text = "Date : " +   UTCToLocal(date: self.orderDetailsObj.orderData["approvedDate"].stringValue, fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: "dd/MM/yyyy hh:mm a")
                    }
                    
                    //Cook delivered the order
                    if self.orderDetailsObj.orderData["isCookDeliveredTheOrder"].boolValue {
                        
                        self.waitingForOrderToBeDeliver.isHidden = true
                        self.deliveryDateTimeStackView.isHidden = false
                        self.cookDeliveryLabelOutlet.text = "■ Order has been delivered by the cook."
                        self.deiveryDateTimeHeightConstraint.constant = 100
                        self.deliveredTheOrderButtonOutlet.isHidden = true
                        self.cookDateTimeOfDelivery.isHidden = false
                        self.cookDateTimeOfDelivery.text = "Date/Time: " +  UTCToLocal(date: self.orderDetailsObj.orderData["cookDeliveryDateTime"].stringValue, fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: "dd/MM/yyyy hh:mm a") //cookDeliveryDateTime
                        
                        //Unhide the stack view of recive delivery.
                        self.waitingForDeliveryStackView.isHidden = false
                        
                    }
                    
                    // Customer Recieve the order.
                    if self.orderDetailsObj.orderData["isCookDeliveredTheOrder"].boolValue {
                        self.waitingForCustomerToReceiveOrder.isHidden = false
                        self.yesIRecieveOrder.isHidden = true
                        self.notReceiveOrderButtonOutlet.isHidden = true
                        
                        
                        self.orderConfirmedLabelOutlet.isHidden = false
                        self.orderConfirmedDateTime.isHidden = false
                        self.orderConfirmedDateTime.text = "Date/Time: " +  UTCToLocal(date: self.orderDetailsObj.orderData["customerNotReceiveTheOrderDate"].stringValue, fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: "dd/MM/yyyy hh:mm a")
                        
                        if  self.orderDetailsObj.orderData["isReviewed"].boolValue {
                            self.reviewOrderButtonOutlet.isHidden = true
                        } else {
                            self.reviewOrderButtonOutlet.isHidden = false
                        }
                    }
                }
            }
        }
        
        
        for recipeData in self.orderDetailsObj.recipeArray {
            self.setupViews(recipeData: recipeData)
        }
        
    }
    
    
    var customPreviewView: OrderDetailsView = {
        let v = OrderDetailsView()
        return v
    }()
    
    
    
    func setupViews(recipeData: JSON) {
        
        customPreviewView = OrderDetailsView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width - 36, height: 100))
        
        var spiceLevel = String()
        var serve = String()
        var price = String()
        var currencySymbol = String()
        
        if recipeData["spiceLevel"] == JSON.null {
            spiceLevel = ""
        } else {
            spiceLevel = "Spice Level: " + recipeData["spiceLevel"].stringValue
        }
        
        if recipeData["noOfServing"] == JSON.null {
            serve = ""
        } else {
            serve = "Serve: " + recipeData["noOfServing"].stringValue
        }
        
        if recipeData["costPerServing"] == JSON.null {
            price = ""
            currencySymbol = ""
        } else {
            price = recipeData["costPerServing"].stringValue
            currencySymbol = "Price: " + recipeData["currencySymbol"].stringValue
        }
        
        
        
        customPreviewView.setData(recipeName: recipeData["dishName"].stringValue, img: recipeData["imageUrl"].stringValue, spiceLevel: spiceLevel,   serve: serve, price: price,  currencySymbol: currencySymbol)
            stackviewOutlet.addArrangedSubview(customPreviewView)
    }
    
   
    
    override func viewDidLayoutSubviews() {
        var stackHeight = 0
        let count = orderDetailsObj.recipeArray.count
        for _ in 0..<count{
            stackHeight = stackHeight + 100
        }
        stackViewHeightConstriant.constant = CGFloat(stackHeight)
    }
    
    
    
    //AlertController.
    func showAlertWithMessage(alertMessage:String)
    {
        let alertController = UIAlertController(title:ALERT_TITLE.APP_NAME, message:alertMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action:UIAlertAction!) in
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func reviewButtonTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "reviewOrderID", sender: nil)
    }
    
    
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    // MARK: Approve Order
    @IBAction func approveButtonTapped(_ sender: RoundedButton) {
        
        let alertController = UIAlertController(title:ALERT_TITLE.APP_NAME, message: "Approve your order?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action:UIAlertAction!) in }))
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action:UIAlertAction!) in
            
            // 1 for hire
            // 0 For Order
            self.hud.textLabel.text = PROGRESS_HUD.HUD_LABEL_KEY
            self.hud.show(in: self.view)
            self.orderDetailsObj.approveOrder(orderType: self.orderType, orderId: self.orderId) { (success) in
                self.hud.dismiss()
                if success {
                    self.performSegue(withIdentifier: "approveRejectID", sender: nil)
                } else {
                    self.performSegue(withIdentifier: "orderDetailToApproveRejectSegueID", sender: nil)
                }
            }
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    // MARK: Deliver the order.
    @IBAction func deilveredOrderButtonTapped(_ sender: Any) {
        
        if (sender as AnyObject).tag == 1 {
            //Deliver the service
            
            hud.textLabel.text = PROGRESS_HUD.HUD_LABEL_KEY
            hud.show(in: self.view)
            self.orderDetailsObj.cookDeliverService(orderType: self.orderDetailsObj.orderData["orderType"].stringValue, orderId: self.orderId) { (success) in
                self.hud.dismiss()
                if success {
                    
                    self.cookDeliveryLabelOutlet.text = "■ Order has been delivered by the cook."
                    self.deiveryDateTimeHeightConstraint.constant = 80
                    self.deliveredTheOrderButtonOutlet.isHidden = true
                    self.customerServiceStatus.isHidden = false
                    
                } else {
                    
                    self.showAlertWithMessage(alertMessage: self.orderDetailsObj.alertMessage)
                    
                }
            }
            
        } else {
            //Deliver the order
            
            let alertController = UIAlertController(title:ALERT_TITLE.APP_NAME, message: "Have you actually delivered the order ?.", preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action:UIAlertAction!) in }))
            
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action:UIAlertAction!) in
                
                self.hud.textLabel.text = PROGRESS_HUD.HUD_LABEL_KEY
                self.hud.show(in: self.view)
                self.orderDetailsObj.deliveredOrder(orderId: self.orderId) { (success) in
                    self.hud.dismiss()
                    if success {
                        self.cookDeliveryLabelOutlet.text = "■ Order has been delivered by the cook."
                        self.deiveryDateTimeHeightConstraint.constant = 80
                        self.deliveredTheOrderButtonOutlet.isHidden = true
                        self.customerServiceStatus.isHidden = false
                    } else {
                        self.showAlertWithMessage(alertMessage: self.orderDetailsObj.alertMessage)
                    }
                }
            }))
            self.present(alertController, animated: true, completion: nil)
            
        }
        
        

        
    }
    
    
    // MARK: Recieve the order.
    @IBAction func receivedOrderButtonTapped(_ sender: UIButton) {
        
        if sender.tag == 1 {
            //Yes i recieve the service
            let alertController = UIAlertController(title:ALERT_TITLE.APP_NAME, message: "Have you received your order ?.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action:UIAlertAction!) in }))
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action:UIAlertAction!) in
                
                self.hud.textLabel.text = PROGRESS_HUD.HUD_LABEL_KEY
                self.hud.show(in: self.view)
                self.orderDetailsObj.customerRecieveTheService(orderType: self.orderDetailsObj.orderData["orderType"].stringValue, orderId: self.orderId) { (success) in
                    self.hud.dismiss()
                    if success {
                        self.notReceiveOrderButtonOutlet.isHidden = true
                        self.orderConfirmedLabelOutlet.isHidden = false
                        self.reviewOrderButtonOutlet.isHidden = false
                        self.yesIRecieveOrder.isHidden = true
                    } else {
                        self.showAlertWithMessage(alertMessage: self.orderDetailsObj.alertMessage)
                    }
                }
            }))
            
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            
            //yes i receive the order.
            let alertController = UIAlertController(title:ALERT_TITLE.APP_NAME, message: "Have you received your order ?.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action:UIAlertAction!) in }))
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action:UIAlertAction!) in
                
                self.hud.textLabel.text = PROGRESS_HUD.HUD_LABEL_KEY
                self.hud.show(in: self.view)
                self.orderDetailsObj.receiveOrder(orderId: self.orderId) { (success) in
                    self.hud.dismiss()
                    if success {
                        self.notReceiveOrderButtonOutlet.isHidden = true
                        self.orderConfirmedLabelOutlet.isHidden = false
                        self.reviewOrderButtonOutlet.isHidden = false
                        self.yesIRecieveOrder.isHidden = true
                    } else {
                        self.showAlertWithMessage(alertMessage: self.orderDetailsObj.alertMessage)
                    }
                }
            }))
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    
    @IBAction func recieveTheServiceButtonTapped(_ sender: UIButton) {
        
       
    }
    
    
    @IBAction func NotRecieveTheServiceButtonTapped(_ sender: Any) {
        
    }
    
    
    @IBAction func notReceivedButtonTapped(_ sender: UIButton) {
        
        let alertController = UIAlertController(title:ALERT_TITLE.APP_NAME, message: "Have you not received your order ?.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action:UIAlertAction!) in }))
        alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action:UIAlertAction!) in
            
            self.hud.textLabel.text = PROGRESS_HUD.HUD_LABEL_KEY
            self.hud.show(in: self.view)
            
            self.orderDetailsObj.customerNotRecieveOrder(orderType: self.orderDetailsObj.orderData["orderType"].stringValue, orderId: self.orderId) { (success) in
                self.hud.dismiss()
                if success {
                    self.orderConfirmedLabelOutlet.text = "■ Order has benn cancelled."
                    self.notReceiveOrderButtonOutlet.isHidden = true
                    self.orderConfirmedLabelOutlet.isHidden = false
                    self.reviewOrderButtonOutlet.isHidden = false
                    self.yesIRecieveOrder.isHidden = true
                } else {
                    self.showAlertWithMessage(alertMessage: self.orderDetailsObj.alertMessage)
                }
            }
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    // MARK: Deliver the service
    @IBAction func delivertheService(_ sender: UIButton) {
        
        let alertController = UIAlertController(title:ALERT_TITLE.APP_NAME, message: "Have you sure to deliver the service ?.", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action:UIAlertAction!) in }))
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action:UIAlertAction!) in
            
            self.hud.textLabel.text = PROGRESS_HUD.HUD_LABEL_KEY
            self.hud.show(in: self.view)
            self.orderDetailsObj.deliverTheService(orderId: self.orderId) { (success) in
                self.hud.dismiss()
                if success {
                    
                    self.deliverServiceButtonOutlet.isHidden = true
                    self.serviceDeliverSuccessLabel.isHidden = false
                    self.heightConstriantForServiceStatusStackview.constant = 90

                } else {
                    //self.showAlertWithMessage(alertMessage: self.orderDetailsObj.alertMessage)
                    self.present(Helper.globalAlertView(with: LOGIN_CONSTANT.ALERT_HEADER_MESSAGE_KEY, message: self.orderDetailsObj.alertMessage), animated: true, completion: nil)
                }
            }
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    
    // MARK: Reject Order
    @IBAction func rejectButtonTapped(_ sender: RoundedButton) {
        
       /*
        if sender.titleLabel?.text == "Cancel Order" {
            
            self.performSegue(withIdentifier: "orderDetailToOrderCancellation", sender: nil)
            
        } else if sender.titleLabel?.text == "Reject"{
            
        } */
        
        if sender.titleLabel?.text == "Reject" {
            flagTypeToCheckcancellationType = false
        } else {
            flagTypeToCheckcancellationType = true
        }
        
        let alertController = UIAlertController(title:ALERT_TITLE.APP_NAME, message: "Are you sure?", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action:UIAlertAction!) in }))
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action:UIAlertAction!) in
            self.performSegue(withIdentifier: "orderDetailToOrderCancellation", sender: nil)
        }))
        
        self.present(alertController, animated: true, completion: nil)
       
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "orderDetailToOrderCancellation" {
            
            let destinationVC = segue.destination as! OrderCancellationConfirmationVC
            destinationVC.orderId = self.orderDetailsObj.orderData[ID_KEY].stringValue
            
            destinationVC.orderDate = getDate(date: self.orderDetailsObj.orderData["pickUpTime"].stringValue)
            destinationVC.profileImage = self.orderDetailsObj.orderData["cookProfile"]["profileUrl"].stringValue
            destinationVC.totalAmount = self.orderDetailsObj.orderData["totalAmount"].stringValue
            destinationVC.cookName = self.orderDetailsObj.orderData["profile"]["fullName"].stringValue
            destinationVC.isCancellation = flagTypeToCheckcancellationType
            destinationVC.orderType = self.orderDetailsObj.orderData["orderType"].stringValue
            
        } else if segue.identifier == "reviewOrderID" {
            
            let destinationVC = segue.destination as! ReviewVC
            destinationVC.orderID = self.orderDetailsObj.orderData["id"].stringValue
            
        } else if segue.identifier == "approveRejectID" {
            
            let destinationVC = segue.destination as! ApproveRejectVC
            destinationVC.orderId = orderDetailsObj.approveOrderId
            
        } else if segue.identifier == "orderDetailToApproveRejectSegueID" {
            
            let destinationVC = segue.destination as! RejectRepaymentVC
            destinationVC.message = self.orderDetailsObj.alertMessage
            destinationVC.orderId = orderId
            
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
        
        if let date = date  {
            return dateFormatter.string(from: date)
        } else {
            return "Invalid Date"
        }
    }
    
    
    func getDate(date: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"//this your string date format
        var localTimeZoneAbbreviation: String { return TimeZone.current.abbreviation() ?? "" }
        
        dateFormatter.timeZone = NSTimeZone(name: localTimeZoneAbbreviation) as TimeZone?
        let date = dateFormatter.date(from: date)
        
        dateFormatter.dateFormat = "dd/MM/yyyy"///this is what you want to convert format
        dateFormatter.timeZone = NSTimeZone(name: localTimeZoneAbbreviation) as TimeZone?
        
        if date != nil {
             return dateFormatter.string(from: date!)
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
    
    
    
    
    @IBAction func rePaymentButtonTapped(_ sender: RoundedButton) {
        
        self.hud.textLabel.text = PROGRESS_HUD.HUD_LABEL_KEY
        self.hud.show(in: self.view)
        
        orderDetailsObj.rePayment(orderId: orderId) { (success) in
            self.hud.dismiss()
            if success {
                
                self.orderDetailsObj.getClientTokenOrderId(orderId: self.orderId, completion: { (success) in
                    if success {
                       self.showDropIn(clientTokenOrTokenizationKey: self.orderDetailsObj.clientToken)
                    } else {
                        //self.showAlertWithMessage(alertMessage: self.orderDetailsObj.alertMessage)
                        self.present(Helper.globalAlertView(with: LOGIN_CONSTANT.ALERT_HEADER_MESSAGE_KEY, message: self.orderDetailsObj.alertMessage), animated: true, completion: nil)
                    }
                })
               
            } else {
                //self.showAlertWithMessage(alertMessage: self.orderDetailsObj.alertMessage)
                self.present(Helper.globalAlertView(with: LOGIN_CONSTANT.ALERT_HEADER_MESSAGE_KEY, message: self.orderDetailsObj.alertMessage), animated: true, completion: nil)
            }
        }
    }
    
    
    
    @IBAction func infromForRePayment(_ sender: RoundedButton) {
        self.hud.textLabel.text = PROGRESS_HUD.HUD_LABEL_KEY
        self.hud.show(in: self.view)
        rejectRepaymentObj.rePaymentForOrder(orderId: orderId) { (success) in
            self.hud.dismiss()
            if success {
                 self.present(Helper.globalAlertView(with: LOGIN_CONSTANT.ALERT_HEADER_MESSAGE_KEY, message: self.rejectRepaymentObj.alertMessage), animated: true, completion: nil)
            } else {
                 self.present(Helper.globalAlertView(with: LOGIN_CONSTANT.ALERT_HEADER_MESSAGE_KEY, message: self.rejectRepaymentObj.alertMessage), animated: true, completion: nil)
            }
        }
    }
    
    
    
    func showDropIn(clientTokenOrTokenizationKey: String) {
        
        let request =  BTDropInRequest()
        let dropIn = BTDropInController(authorization: clientTokenOrTokenizationKey, request: request)
        { (controller, result, error) in
            if (error != nil) {
                self.showAlertWithMessage(alertMessage: (error?.localizedDescription)!)
            } else if (result?.isCancelled == true) {
                self.showAlertWithMessage(alertMessage: "Cancelled")
            } else if let result = result {
                self.makePayment(paymentNounce: String(describing: result.paymentMethod!.nonce))
            }
            controller.dismiss(animated: true, completion: nil)
        }
        self.present(dropIn!, animated: true, completion: nil)
    }
    
    
    
    func makePayment(paymentNounce: String){
        self.hud.textLabel.text = PROGRESS_HUD.HUD_LABEL_KEY
        self.hud.show(in: self.view)
        self.orderDetailsObj.makePayment(orderId: self.orderId, nonce: paymentNounce , amount: self.orderDetailsObj.rePaymentData["amount"].stringValue, completion: { (success) in
            self.hud.dismiss()
            if success {
                self.performSegue(withIdentifier: "approveRejectID", sender: nil)
            } else {
                //self.showAlertWithMessage(alertMessage: self.orderDetailsObj.alertMessage)
                self.present(Helper.globalAlertView(with: LOGIN_CONSTANT.ALERT_HEADER_MESSAGE_KEY, message: self.orderDetailsObj.alertMessage), animated: true, completion: nil)
            }
        })
    }
    
    
    
    
    @IBAction func getDirectionInMap(_ sender: Any) {
        
        //30.324312, 78.041869
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            UIApplication.shared.open(URL(string:"comgooglemaps://?center=\(currentLocationLatitude),\(currentLocationLongitute)&zoom=14&views=traffic&q=\((self.orderDetailsObj.orderData["deliveryAddress"]["latitude"].doubleValue)),\((self.orderDetailsObj.orderData["deliveryAddress"]["longitude"].doubleValue))")!, options: [:], completionHandler: nil)
        } else {
            print("Can't use comgooglemaps://")
            
            let source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: currentLocationLatitude, longitude: currentLocationLongitute)))
            source.name = "Source"
            
            let destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: (self.orderDetailsObj.orderData["deliveryAddress"]["latitude"].doubleValue), longitude: (self.orderDetailsObj.orderData["deliveryAddress"]["longitude"].doubleValue))))
            destination.name = "Destination"
            
            MKMapItem.openMaps(with: [source, destination], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
            
        }
    }
}




