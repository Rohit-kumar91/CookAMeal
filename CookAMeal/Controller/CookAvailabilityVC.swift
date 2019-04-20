//  CookAvailabilityVC.swift
//  CookAMeal
//  Created by Cynoteck on 30/04/18.
//  Copyright © 2018 Cynoteck. All rights reserved.

import UIKit
import SwiftDate
import SwiftyJSON
import JGProgressHUD

class CookAvailabilityVC: UIViewController, WeekViewDataSource, WeekViewDelegate, WeekViewStyler {

    @IBOutlet weak var scrollViewUIView: UIView!
    @IBOutlet weak var startTimeTextfield: ImageTextfield!
    @IBOutlet weak var endTimeTextfield: ImageTextfield!
    @IBOutlet weak var dateLabelOutlet: UILabel!
    @IBOutlet weak var weekScrollView: UIScrollView!
    @IBOutlet weak var hireNowButtonOutlet: RoundedButton!
    @IBOutlet weak var addMoreButtonOutlet: RoundedButton!
    
    
    //var weekHours = [[String: String]]()
    var startDatePickerTime = UIDatePicker()
    var endDatePickerTime = UIDatePicker()
    var textfieldType = Bool()
    var dateString = String()
    let eventDetailLauncher = EventDetailLauncher()
    let cookAvailbilityObj: CookAvailabilityModel = CookAvailabilityModel()
    
    var recipeId = String()
    var eventId = String()
    var cookId = String()
    var count = Int()
    
    var startHour = String()
    var endHour = String()
    
    var endHourDate = String()
    
    var selectedStartHour = String()
    var selectedEndHour = String()
    
    
    var weekView: WeekView = WeekView()
    var loadDataInWeekViewCheck = Bool()
    var weekData = [[String: String]]()
    var handleWeekDataCheck = Bool()
    let hud = JGProgressHUD(style: .light)

    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var selectBookTimeLabel: UILabel!
    @IBOutlet weak var startAndEndTimeStackview: UIStackView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var mainviewHeightConstrint: NSLayoutConstraint!
    
    /*
    lazy var weekView: WeekView = {
        let bump: CGFloat = 10
        let frame: CGRect = CGRect(x: 0, y: bump, width: self.view.frame.width, height: (60 * 24)) //self.view.frame.height - bump
        //let weekView = WeekView(frame: frame, visibleDays: 1)
        
        let dateFormatter = DateFormatter()
        let date = "2018-04-27T13:06:00.000Z"
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = NSTimeZone.local
        
        let dateInRegion: DateInRegion = DateInRegion.init(absoluteDate: dateFormatter.date(from: date)!)
        let weekView = WeekView(frame: frame, visibleDays: 1, date: dateInRegion, startHour: startHour, endHour: endHour , colorTheme: .light, nowLineEnabled: true, nowLineColor: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1))
        weekView.dataSource = self
        weekView.delegate = self
        weekView.styler = self
       
        return weekView
    }()
    */
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Hide Buttons")
        count = 0
        
        print(dateString)
        var dateStr = String()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: dateString)
        dateFormatter.dateFormat = "dd MMMM yyyy"
        if let date = date {
            dateStr = dateFormatter.string(from: date)
        }
        
        
        dateLabelOutlet.text = dateStr
        Singleton.instance.recipeId = recipeId
        loadDataInWeekViewCheck = true
        
        addMoreButtonOutlet.isUserInteractionEnabled = false
        addMoreButtonOutlet.alpha = 0.5
        
        //self.view.addSubview(weekView)
        //weekView.isUserInteractionEnabled = false
        //self.scrollViewUIView.addSubview(weekView)
        //weekView.setGestureRecognizer(gestureRecognizerType: UITapGestureRecognizer())
        
        gettingCookData()
        setUIViews(status: true)
        heightConstraint.constant = 0
        mainviewHeightConstrint.constant = 0
        
    
    }
    
    func setUIViews(status: Bool) {
        mainStackView.isHidden = status
        selectBookTimeLabel.isHidden = status
        startAndEndTimeStackview.isHidden = status
        mainView.isHidden = status
        noteLabel.isHidden = status
        bottomView.isHidden = status
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        
        
        if Singleton.instance.cookBookingSlot.count != 0 && Singleton.instance.notUpdateTimeSlot {
            
           print("Show Buttons")
            addMoreButtonOutlet.isUserInteractionEnabled = true
            addMoreButtonOutlet.alpha = 1.0
            
            print(Singleton.instance.cookBookingSlot)
            if let element = Singleton.instance.cookBookingSlot.last {
                
                startTimeTextfield.text = element["startTime"]
                //endTimeTextfield.text = element["endTime"]
                //print(element["endTime"])
                //Seperate hour/Min
                
                print(Singleton.instance.cookBookingSlot)
                
                let timeString = element["endTime"]
                let timeArr = timeString?.components(separatedBy: ":")
                let hour: String = timeArr![0]
                let min: String = timeArr![1]
                
                var totalCalculatedHour = Int(hour)! + 2
                
                if totalCalculatedHour > 24 {
                    showAlertWithMessage(alertMessage: "Time Slot is not avaialable to book the cook.")
                } else {
                    
                    if totalCalculatedHour == 24 {
                        totalCalculatedHour = 00
                        endTimeTextfield.text = ""
                    }
                    
                    let timeString = String(totalCalculatedHour) + ":" + min
                    let startDateTime = dateTime(date: dateString, time: element["endTime"] ?? "00:00")
                    endTimeTextfield.text = timeString
                    let endDateTime = dateTime(date: dateString, time: timeString)
                    
                    print("Start Time", startDateTime)
                    print("End Time", endDateTime)
                    
                    
                    let tempStartAndTime = [
                        "recipeId": Singleton.instance.recipeId,
                        "startTime" : element["endTime"]!,
                        "endTime" : endTimeTextfield.text!
                    ]
                    
                    
                    validateHireACookTimeSlot(startDateTime: startDateTime, endDateTime: endDateTime, eventId: eventId) { (success, message) in
                        if success {
                            Singleton.instance.cookBookingSlot.append(tempStartAndTime)
                            self.weekData.append(tempStartAndTime)
                            //self.weekData.append(tempStartAndTime)
                            self.weekView.dataSource = self
                            self.weekView.delegate = self
                        } else {
                            //self.showAlertWithMessage(alertMessage: message)
                            //Singleton.instance.cookBookingSlot.append(tempStartAndTime)
                            self.present(Helper.globalAlertView(with: LOGIN_CONSTANT.ALERT_HEADER_MESSAGE_KEY, message: message), animated: true, completion: nil)
                        }
                    }
                    
                }
                
                startTimeTextfield.isUserInteractionEnabled = false
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        //Singleton.instance.addMoreRecipeTimeSlot = false
    }
    
    
    @IBAction func addMoreButtonTapped(_ sender: RoundedButton) {
        
        self.performSegue(withIdentifier: "cookAvailabiltyToCookKitchen", sender: nil)
    }

    @IBAction func addToCartButtonTapped(_ sender: RoundedButton) {
        
    }
    
    
    func gettingCookData() {
        
        hud.show(in: self.view)
        hud.textLabel.text = "Loading"
        cookAvailbilityObj.getCookTimeAvailbility(eventId: eventId, cookId: cookId, date: dateString) { (success) in
            self.hud.dismiss()
            if success {
                
                if self.cookAvailbilityObj.data != JSON.null {
                    
                    //self.addMoreButtonOutlet.isUserInteractionEnabled = true
                    self.hireNowButtonOutlet.isUserInteractionEnabled = true
                    
                    if self.cookAvailbilityObj.canBook {
                        self.hireNowButtonOutlet.isUserInteractionEnabled = true
                        self.addMoreButtonOutlet.isUserInteractionEnabled = true
                        self.hireNowButtonOutlet.alpha = 1.0
                        //self.addMoreButtonOutlet.alpha = 1.0
                        self.mainStackView.isHidden = false
                        self.selectBookTimeLabel.isHidden = false
                        self.startAndEndTimeStackview.isHidden = false
                        self.mainView.isHidden = false
                        self.noteLabel.isHidden = true
                        self.bottomView.isHidden = true
                        self.heightConstraint.constant = 40
                        self.mainviewHeightConstrint.constant = 0
                    } else{
                        self.hireNowButtonOutlet.isUserInteractionEnabled = false
                        self.addMoreButtonOutlet.isUserInteractionEnabled = false
                        self.hireNowButtonOutlet.alpha = 0.5
                        //self.addMoreButtonOutlet.alpha = 0.5
                        self.mainStackView.isHidden = true
                        self.selectBookTimeLabel.isHidden = true
                        self.startAndEndTimeStackview.isHidden = true
                        self.mainView.isHidden = true
                        self.noteLabel.isHidden = false
                        self.bottomView.isHidden = false
                        self.heightConstraint.constant = 0
                        self.mainviewHeightConstrint.constant = 70
                    }
                    
                    
                    self.startHour = self.getTime(date: self.cookAvailbilityObj.data["startTime"].stringValue)
                    self.endHour = self.getTime(date: self.cookAvailbilityObj.data["endTime"].stringValue)
                    
                    print(self.cookAvailbilityObj.data["endTime"].stringValue)
                    self.endHourDate = self.cookAvailbilityObj.data["endTime"].stringValue
                    print("rohit Date",self.endHourDate)
                    
                    self.createTimePicker()
                    var startHourArr = self.startHour.components(separatedBy: ":")
                    var endHourArr = self.endHour.components(separatedBy: ":")
                    let calendarComponents : Set<Calendar.Component> = [.hour]
                    let formatter = DateFormatter()
                    formatter.dateFormat = "HH:mm"
                    
                    let startTime = formatter.date(from: self.startHour)
                    let endTime = formatter.date(from: self.endHour)
                    
                    let difference = Calendar.current.dateComponents(calendarComponents, from: startTime!, to: endTime!)
                    let formattedString = difference.hour!
                    self.setUpWeekView(startHour: Int(startHourArr[0])!, endHour: Int(endHourArr[0])!, totalHours: CGFloat(formattedString))
                    
                } else {
                    self.showAlertWithMessage(alertMessage: "Data is not in correct format.")
                    self.addMoreButtonOutlet.isUserInteractionEnabled = false
                    self.hireNowButtonOutlet.isUserInteractionEnabled = false
                }
                
            } else {
                self.present(Helper.globalAlertView(with: LOGIN_CONSTANT.ALERT_HEADER_MESSAGE_KEY, message: self.cookAvailbilityObj.alertMessage), animated: true, completion: nil)
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
    
    
    func getTime(date: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"//this your string date format
        var localTimeZoneAbbreviation: String { return TimeZone.current.abbreviation() ?? "" }
        
        dateFormatter.timeZone = NSTimeZone(name: localTimeZoneAbbreviation) as TimeZone?
        let date = dateFormatter.date(from: date)
        
        dateFormatter.dateFormat = "HH:mm"///this is what you want to convert format
        dateFormatter.timeZone = NSTimeZone(name: localTimeZoneAbbreviation) as TimeZone?
        
        if date != nil {
            return dateFormatter.string(from: date!)
        } else {
            return ""
        }
        
    }
    
    
    
    func setUpWeekView(startHour: Int, endHour: Int, totalHours: CGFloat) {
        
        let bump: CGFloat = 10
        let frame: CGRect = CGRect(x: 0, y: bump, width: self.view.frame.size.width, height: (60 * totalHours)) //self.view.frame.height - bump
        //let weekView = WeekView(frame: frame, visibleDays: 1)
        weekScrollView.contentSize = CGSize(width: self.view.frame.size.width, height: (60 * totalHours) + 50)
        
        let dateFormatter = DateFormatter()
        let date = dateString + "T13:06:00.000Z"                 //T13:06:00.000Z
        print( dateString + "T13:06:00.00Z")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"  //  yyyy-MM-dd'T'HH:mm:ssZ     yyyy-MM-dd'T'HH:mm:ss.SSSZ
        dateFormatter.timeZone = NSTimeZone.local
        
        let dateInRegion: DateInRegion = DateInRegion.init(absoluteDate: dateFormatter.date(from: date)!)
        weekView = WeekView(frame: frame, visibleDays: 1, date: dateInRegion, startHour: startHour, endHour: endHour , colorTheme: .light, nowLineEnabled: true, nowLineColor: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1))
        
        self.scrollViewUIView.addSubview(weekView)
        
        weekView.isUserInteractionEnabled = false
        weekView.dataSource = self
        weekView.delegate = self
        weekView.styler = self
    }
    
    
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    func weekViewGenerateEvents(_ weekView: WeekView, date: DateInRegion, eventCompletion: @escaping ([WeekViewEvent]) -> Void) -> [WeekViewEvent] {
       
        if loadDataInWeekViewCheck {
            //loadDataInWeekViewCheck = false
            weekData = cookAvailbilityObj.bookedSlots
        } else {
            
//            if handleWeekDataCheck {
//                handleWeekDataCheck = false
//                print(weekData)
//                //weekData = Singleton.instance.cookBookingSlot
//                weekData.append(Singleton.instance.cookBookingSlot.last!)
//                print(weekData)
//
//            }
        }
        
        print(weekData)
        print(Singleton.instance.cookBookingSlot)
       
            /*
            for element in cookAvailbilityObj.data["BookedTimeSlots"].arrayValue {
                
                let startTime = self.getTime(date: element["startTime"].stringValue)
                let endTime = self.getTime(date: element["endTime"].stringValue)
                
                var startTimeArr = startTime.components(separatedBy: ":")
                var endTimeArr = endTime.components(separatedBy: ":")
                
                let start1 = date.atTime(hour: Int(startTimeArr[0])!, minute: Int(startTimeArr[1])!, second: 0)!
                let end1 = date.atTime(hour: Int(endTimeArr[0])!, minute: Int(endTimeArr[1])! * (date.day % 2), second: 0)!
                
                //let end1 = date.atTime(hour: Int(endTimeArr![0])!, minute: 30 * (date.day % 2), second: 0)!
                print(date.day)
                let event: WeekViewEvent = WeekViewEvent(title: "Event \(date.day)", start: start1, end: end1)
                
                // let start: DateInRegion = date.atTime(hour: 13, minute: 0, second: 0)!
                // let end: DateInRegion = date.atTime(hour: 14, minute: 30, second: 0)!
                // let lunch: WeekViewEvent = WeekViewEvent(title: "Lunch A " + String(date.day), start: start, end: end)
                
                DispatchQueue.global(qos: .background).async {
                    eventCompletion([event])
                }
            }
       
        */
        
        
      
        for element in weekData {
            
            let startTime = element["startTime"]
            let endTime = element["endTime"]
            
            var startTimeArr = startTime?.components(separatedBy: ":")
            var endTimeArr = endTime?.components(separatedBy: ":")
            
            let start1 = date.atTime(hour: Int(startTimeArr![0])!, minute: Int(startTimeArr![1])!, second: 0)!
            let end1 = date.atTime(hour: Int(endTimeArr![0])!, minute: Int(endTimeArr![1])! * (date.day % 2), second: 0)!
            
            
            //let end1 = date.atTime(hour: Int(endTimeArr![0])!, minute: 30 * (date.day % 2), second: 0)!
            //print(date.day)
            let event: WeekViewEvent = WeekViewEvent(title: "Time slot added.", start: start1, end: end1)
            
            // let start: DateInRegion = date.atTime(hour: 13, minute: 0, second: 0)!
            // let end: DateInRegion = date.atTime(hour: 14, minute: 30, second: 0)!
            // let lunch: WeekViewEvent = WeekViewEvent(title: "Lunch A " + String(date.day), start: start, end: end)
            
            DispatchQueue.global(qos: .background).async {
                eventCompletion([event])
            }
        }
        
        return []
    }
    
    
    func weekViewGestureForInteraction(_ weekView: WeekView) -> UIGestureRecognizer {
        return UITapGestureRecognizer(target: self, action: #selector(clickedWeekView))
    }
    
    
    func weekViewDidClickOnEvent(_ weekView: WeekView, event: WeekViewEvent, view: WeekViewEventView) {
        eventDetailLauncher.event = event
        eventDetailLauncher.present()
    }
    
    
    @objc func clickedWeekView() {
        print("Custom target for clicking on event")
    }
    
    
    func weekViewStylerEventView(_ weekView: WeekView, eventContainer: CGRect, event: WeekViewEvent) -> WeekViewEventView {
        
        let eventLeftBorder: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: eventContainer.size.height))
        eventLeftBorder.backgroundColor = UIColor.blue
        
        let eventText: UITextView = UITextView(frame: CGRect(x: 3, y: 0, width: eventContainer.size.width - 3, height: eventContainer.size.height))
        eventText.text = event.description
        eventText.backgroundColor = .clear
        eventText.font = weekView.getFont()
        eventText.textColor = weekView.getColorTheme().eventTextColor
        eventText.isEditable = false
        eventText.isSelectable = false
        
        let eventView = WeekViewEventView(frame: eventContainer)
        eventView.backgroundColor = UIColor(red: 0, green: 0, blue: 1, alpha: 0.6)
        eventView.addSubview(eventLeftBorder)
        eventView.addSubview(eventText)
        return eventView
    }
    
    
    
    @IBAction func hireNowButtonTapped(_ sender: RoundedButton) {
        
        if weekData.count == 0 || Singleton.instance.cookBookingSlot.count == 0 {
            self.showAlertWithMessage(alertMessage: "Please select the time-slot for hiring a cook.")
        } else {
            self.performSegue(withIdentifier: "toCookAvailabilityToCheckOut", sender: nil)
        }
        
    }
  
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toCookAvailabilityToCheckOut" {
            let destinationVC = segue.destination as! CheckOutVC
            destinationVC.recipeId = recipeId
            destinationVC.cookId = cookId
            destinationVC.startTime = startHour
            destinationVC.endTime = endHour
            destinationVC.date = dateString
            destinationVC.eventId = eventId

        } else if segue.identifier == "cookAvailabiltyToCookKitchen" {
            let destination = segue.destination as! CookKitchenRecipeVC
            destination.cookId = cookId
            destination.eventId = eventId
            destination.dateString = dateString
        }
    }
}



extension CookAvailabilityVC: UITextFieldDelegate {
    
    
    func createTimePicker() {
        
        let toolbar = UIToolbar()
        let cancelButton = UIBarButtonItem (barButtonSystemItem: .cancel, target: nil, action: #selector(pickerCancelPressed))
        let doneButton = UIBarButtonItem (barButtonSystemItem: .done, target: nil, action: #selector(pickerTimeDonePressed))
        let flexButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([cancelButton,flexButton, doneButton], animated: true)
        
        doneButton.tintColor = #colorLiteral(red: 0.8862745098, green: 0.1725490196, blue: 0.168627451, alpha: 1)
        cancelButton.tintColor = #colorLiteral(red: 0.8862745098, green: 0.1725490196, blue: 0.168627451, alpha: 1)
        toolbar.sizeToFit()
        
        let calendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let dateComponents = NSDateComponents()
        
        //2018-07-09 10:11:26
        
        let startDateTimeString = dateString + " " + startHour
        let endDateTimeString = dateString + " " + endHour
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd HH:mm"
        let startDate = dateformatter.date(from: startDateTimeString)
        let endDate = dateformatter.date(from: endDateTimeString)
        
        print(dateString)
        print(startDate)
        print(endDate)
        
        let minDate = calendar.date(byAdding: dateComponents as DateComponents, to: startDate! , options: NSCalendar.Options(rawValue: 0))
        //dateComponents.month = 3 //or you can change month = day(90)
        
        let maxDate = calendar.date(byAdding: dateComponents as DateComponents, to: endDate!, options: NSCalendar.Options(rawValue: 0))
        self.startDatePickerTime.datePickerMode = .time
        self.endDatePickerTime.datePickerMode = .time
        
        self.startDatePickerTime.minuteInterval = 30
        self.endDatePickerTime.minuteInterval = 30
        
        self.startDatePickerTime.maximumDate = maxDate
        self.startDatePickerTime.minimumDate = minDate
        self.startTimeTextfield.inputAccessoryView = toolbar
        self.startTimeTextfield.inputView = startDatePickerTime
        self.endTimeTextfield.inputAccessoryView = toolbar
        self.endTimeTextfield.inputView = endDatePickerTime
        
    }
    
    
    
//    func createTimePicker(){
//
//
//        startDatePickerTime.datePickerMode = .time
//        startDatePickerTime.locale = Locale.init(identifier: "NL")
//
//        startTimeTextfield.inputAccessoryView = toolbar
//        startTimeTextfield.inputView = startDatePickerTime
//
//        endDatePickerTime.datePickerMode = .time
//        endDatePickerTime.locale = Locale.init(identifier: "NL")
//
//        endTimeTextfield.inputAccessoryView = toolbar
//        endTimeTextfield.inputView = endDatePickerTime
//
//    }
    
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 01 2017
    // Input Parameters :   N/A.
    // Purpose          :   Picker toobar done action for dismiss picker.
    //>--------------------------------------------------------------------------------------------------
    @objc func pickerCancelPressed() {
        self.view.endEditing(true)
    }
    
    
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 01 2017
    // Input Parameters :   N/A.
    // Purpose          :   Picker toobar done action for dismiss picker.
    //>--------------------------------------------------------------------------------------------------
    @objc func pickerTimeDonePressed() {
        
        
        print(startDatePickerTime.date)
        print(endHourDate)
        
        handleWeekDataCheck = true
        loadDataInWeekViewCheck = false
        
        //format date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        if textfieldType {
            startTimeTextfield.text = dateFormatter.string(from: startDatePickerTime.date)
            print(startDatePickerTime.date)
            endDatePickerTime.minimumDate = startDatePickerTime.date
        } else{
            endTimeTextfield.text = dateFormatter.string(from: endDatePickerTime.date)
        }
        self.view.endEditing(true)
        
        
        if startTimeTextfield.text != "" && endTimeTextfield.text != "" {
            
            if !calculateTotalHours(startTime: startTimeTextfield.text!, endTime: endTimeTextfield.text!) {
               self.showAlertWithMessage(alertMessage: "You cannot select the time less than 2 hour.")
            } else {
                //SetUp the week view from our values.
                 self.startHour = startTimeTextfield.text!
                self.endHour = endTimeTextfield.text!
                let tempStartAndTime = [
                    "recipeId": Singleton.instance.recipeId,
                    "startTime" : startTimeTextfield.text!,
                    "endTime" : endTimeTextfield.text!
                ]
                
                
                //weekHours.removeAll()
                //This temp variable help to add the new value in the singleton array.
                var tempBool = false
                
                //Only add the value first time
                if Singleton.instance.cookBookingSlot.count == 0 {
                    //Checking the timeSlot.
                    let startDateTime = dateTime(date: dateString, time: startTimeTextfield.text!)
                    let endDateTime = dateTime(date: dateString, time: endTimeTextfield.text!)
                    
                    
                    //Check the slot you added is correct or not.
                    print("Start Date", convertUTCDateToLocalDate(dateToConvertString: startDateTime))
                    print("End Date", convertUTCDateToLocalDate(dateToConvertString: endDateTime))
                    
                   
                    
//                    hud.show(in: self.view)
//                    hud.textLabel.text = "Loading"
                    validateHireACookTimeSlot(startDateTime: startDateTime, endDateTime: endDateTime, eventId: eventId) { (success, message) in
                        self.hud.dismiss()
                        if success {
                            
                            self.addMoreButtonOutlet.isUserInteractionEnabled = true
                            self.addMoreButtonOutlet.alpha = 1.0
                            Singleton.instance.cookBookingSlot.append(tempStartAndTime)
                            self.weekData.append(tempStartAndTime)
                            //self.endTimeTextfield.text = ""
                            self.weekView.dataSource = self
                            self.weekView.delegate = self
                            
                        } else {
                            //self.showAlertWithMessage(alertMessage: message)
                            //Singleton.instance.cookBookingSlot.append(tempStartAndTime)
                            self.present(Helper.globalAlertView(with: LOGIN_CONSTANT.ALERT_HEADER_MESSAGE_KEY, message: message), animated: true, completion: nil)
                        }
                    }
                    
                    
                    
                    
                } else {
                    
                    print(Singleton.instance.addMoreRecipeTimeSlot)
                    if Singleton.instance.addMoreRecipeTimeSlot {
                        Singleton.instance.addMoreRecipeTimeSlot = false
                        //Append new value
                        let tempStartAndTime = [
                            "recipeId": Singleton.instance.recipeId,
                            "startTime" : startTimeTextfield.text!,
                            "endTime" : endTimeTextfield.text!
                        ]
                        
                        let startDateTime = dateTime(date: dateString, time: startTimeTextfield.text!)
                        let endDateTime = dateTime(date: dateString, time: endTimeTextfield.text!)
                        
                        print("Start Date", convertUTCDateToLocalDate(dateToConvertString: startDateTime))
                        print("End Date", convertUTCDateToLocalDate(dateToConvertString: endDateTime))
                        
                        
                        validateHireACookTimeSlot(startDateTime: startDateTime, endDateTime: endDateTime, eventId: eventId) { (success, message) in
                            if success {
                                
                                self.addMoreButtonOutlet.isUserInteractionEnabled = true
                                self.addMoreButtonOutlet.alpha = 1.0
                                
                                Singleton.instance.cookBookingSlot.append(tempStartAndTime)
                                self.weekData.append(tempStartAndTime)
                                //self.weekData.append(tempStartAndTime)
                                self.weekView.dataSource = self
                                self.weekView.delegate = self
                            } else {
                                //self.showAlertWithMessage(alertMessage: message)
                                //Singleton.instance.cookBookingSlot.append(tempStartAndTime)
                                self.present(Helper.globalAlertView(with: LOGIN_CONSTANT.ALERT_HEADER_MESSAGE_KEY, message: message), animated: true, completion: nil)
                            }
                        }
                        
                    } else {
                        //This will help the to update the index of singleton array.
                        for (index, recipeWithTimeSlot) in Singleton.instance.cookBookingSlot.enumerated() {
                            
                            print(Singleton.instance.cookBookingSlot)
                            let element = Singleton.instance.cookBookingSlot.last
                            
                            if element!["recipeId"] == recipeWithTimeSlot["recipeId"] {
                                
                                tempBool = true
                                
                                let tempStartAndTime = [
                                    "recipeId": recipeId,
                                    "startTime" : startTimeTextfield.text!,
                                    "endTime" : endTimeTextfield.text!
                                ]
                                
                                let startDateTime = dateTime(date: dateString, time: startTimeTextfield.text!)
                                let endDateTime = dateTime(date: dateString, time: endTimeTextfield.text!)
                                
                                print("Start Date", convertUTCDateToLocalDate(dateToConvertString: startDateTime))
                                print("End Date", convertUTCDateToLocalDate(dateToConvertString: endDateTime))
                                
                                if convertUTCDateToLocalDate(dateToConvertString: endDateTime) > endHourDate {
                                    print("Greater date selected.")
                                }
                                
                                validateHireACookTimeSlot(startDateTime: startDateTime, endDateTime: endDateTime, eventId: eventId) { (success, message) in
                                    if success {
                                        
                                        self.addMoreButtonOutlet.isUserInteractionEnabled = true
                                        self.addMoreButtonOutlet.alpha = 1.0
                                        Singleton.instance.cookBookingSlot[index] = tempStartAndTime
                                        let lastIndex = self.weekData.endIndex
                                        
                                        print(tempStartAndTime)
                                        print(lastIndex)
                                        print(self.weekData)
                                        self.weekData[lastIndex-1] = tempStartAndTime
                                        //self.endTimeTextfield.text = ""
                                        
                                        print(self.weekData)
                                        self.weekView.dataSource = self
                                        self.weekView.delegate = self
                                    } else {
                                        //self.showAlertWithMessage(alertMessage: message)
                                        //Singleton.instance.cookBookingSlot.append(tempStartAndTime)
                                        self.present(Helper.globalAlertView(with: LOGIN_CONSTANT.ALERT_HEADER_MESSAGE_KEY, message: message), animated: true, completion: nil)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    
    //>------------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 01 2017
    // Input Parameters :   N/A.
    // Purpose          :   This functions help the user to add the time availability in Week calendar view.
    //>-------------------------------------------------------------------------------------------------------
    
    func validateHireACookTimeSlot(startDateTime: String, endDateTime: String, eventId: String, completion: @escaping (_ success: Bool, _ message: String)->Void) {
        
        
        let firstDate = stringToDate(str: convertUTCDateToLocalDate(dateToConvertString: endDateTime))
        let secondDate = stringToDate(str: convertUTCDateToLocalDate(dateToConvertString: endHourDate))
        
        
        
        if firstDate > secondDate {
            print("Greater date selected.")
            showAlertWithMessage(alertMessage: "Time Should be selected only available time slot.")
        } else {
            //"2018-07-17T08:47:00.000+0530"
            //"2018-07-17T09:47:00.000+0530"
            hud.show(in: self.view)
            hud.textLabel.text = "Loading"
            cookAvailbilityObj.addAvailabilityToWeekViewCalendar(eventId: eventId, startDateTime: startDateTime, endDateTime: endDateTime) { (success) in
                self.hud.dismiss()
                if success {
                    completion(true, "")
                } else{
                    completion(false, self.cookAvailbilityObj.successMessage)
                }
            }
        }
        
       
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 1 {
            textfieldType = true
        } else if textField.tag == 2 {
            textfieldType = false
        }
        return true
    }
}



extension CookAvailabilityVC {
    
    //>------------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 01 2017
    // Input Parameters :   N/A.
    // Purpose          :   Convert date and time in date time string.
    //>-------------------------------------------------------------------------------------------------------
    
    func dateTime(date: String, time: String)  -> String {
        let dateTime = date + " " + time
        let dateFormatter = DateFormatter()
        var localTimeZoneAbbreviation: String { return TimeZone.current.abbreviation() ?? "" }
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        dateFormatter.timeZone = NSTimeZone(name: localTimeZoneAbbreviation) as TimeZone?
        let finaldatetime = dateFormatter.date(from: dateTime)
        
        //print(finaldatetime)
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.timeZone = NSTimeZone.local
        return dateFormatter.string(from: finaldatetime!)
    }
    
    
    
    func calculateTotalHours(startTime: String, endTime: String) -> Bool {
        let timeformatter = DateFormatter()
        timeformatter.dateFormat = "HH:mm"
        
        let time1 = timeformatter.date(from: startTime)
        let time2 = timeformatter.date(from: endTime)
        
        //You can directly use from here if you have two dates
        let interval = time2?.timeIntervalSince(time1!)
        let hour = interval! / 3600;
        let minute = interval!.truncatingRemainder(dividingBy: 3600) / 60
        //let intervalInt = Int(interval!)
        //"\(intervalInt < 0 ? "-" : "+") \(Int(hour)) Hours \(Int(minute)) Minutes"
        print("\(Int(hour)) Hours \(Int(minute)) Minutes")
        
        if Int(hour) < 2 {
            return false
        } else {
            return true
        }
    }
    
    
    func convertUTCDateToLocalDate(dateToConvertString: String) -> String {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let convertToDate = format.date(from: dateToConvertString)
        format.timeZone = TimeZone.current
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let localDateStr = format.string(from: convertToDate!)
        return localDateStr
    }
    
    func stringToDate(str: String) -> Date  {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "HH:mm:ss"
        
        let date = dateFormatterGet.date(from: str)
        return date!
        
    }
    
}

