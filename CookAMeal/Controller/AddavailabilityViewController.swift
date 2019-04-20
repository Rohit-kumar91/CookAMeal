//
//  AddavailabilityViewController.swift
//  CookAMeal
//
//  Created by CYNOMAC001 on 04/04/18.
//  Copyright © 2018 Cynoteck. All rights reserved.
//

import UIKit
import JGProgressHUD
import CRNotifications
import SwiftyJSON


protocol dateDelegate {
    func dateValue(update : String)
}

class AddavailabilityViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var addEventButtonOutlet: RoundedButton!
    @IBOutlet weak var selectDateTextfield: UITextField!
    @IBOutlet weak var startTimeTextfield: UITextField!
    @IBOutlet weak var endTimeTextfield: UITextField!
    
    let datePicker = UIDatePicker()
    let timePicker = UIDatePicker()
    var timeString = String()
    var startTimeString = String()
    var endTimeString = String()
    let calendarModelObj : CalendarModel = CalendarModel()
    var selectedDateByPicker = String()
    var startAvailableDateTime = String()
    var endAvailableDateTime = String()
    
    var selectdDate = Date()
    var startTime = String()
    var endTime = String()
    var isEditEvent = Bool()
    var eventId = String()
    
    
    // working
    var todayDate:Date? = Date()
    var selectedDate:Date? = Date()
    var delegate : dateDelegate! = nil
    var currentDate = Date()
    
    //Formatters
    let formatedStringForServer = "yyyy-MM-dd'T'HH:mm:ssZ"
    let requiredDateFormat = "MMM d,yyyy"
    let requiredDateTimeFormat = "MMM d,yyyy hh:mm a"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentDate = convertedCurrentDate(date: Date())
        
        if isEditEvent {
            addEventButtonOutlet.setTitle("Edit", for : .normal)
            calendarModelObj.eventId = eventId
        } else {
            addEventButtonOutlet.setTitle("Add", for  : .normal)
        }
        
        if startTime != "" {
            startTimeTextfield.text = startTime
            startTimeString = startTime
        }
        
        if endTime != "" {
            endTimeTextfield.text = endTime
            endTimeString = endTime
        }
        
        
        selectedDate = selectdDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM-d-yyyy"
        selectDateTextfield.text = dateFormatter.string(from: selectdDate)
        let convertedDate = dateFormatter.date(from: selectDateTextfield.text!)
        dateFormatter.dateFormat = requiredDateFormat
        selectedDateByPicker = dateFormatter.string(from: convertedDate!)
        
        // Do any additional setup after loading the view.
        createDatePicker()
        startTimeTextfield.tag = 2
        endTimeTextfield.tag = 3
        
    }
    
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func createDatePicker() {
        
        let toolbar = UIToolbar()
        let cancelButton = UIBarButtonItem (barButtonSystemItem: .cancel, target: nil, action: #selector(pickerCancelPressed))
        let doneButton = UIBarButtonItem (barButtonSystemItem: .done, target: nil, action: #selector(pickerDonePressed))
        let flexButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([cancelButton,flexButton, doneButton], animated: true)
        
        doneButton.tintColor = #colorLiteral(red: 0.8862745098, green: 0.1725490196, blue: 0.168627451, alpha: 1)
        cancelButton.tintColor = #colorLiteral(red: 0.8862745098, green: 0.1725490196, blue: 0.168627451, alpha: 1)
        toolbar.sizeToFit()
        
        let calendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        //let currentDate = NSDate()
        let dateComponents = NSDateComponents()
        let minDate = calendar.date(byAdding: dateComponents as DateComponents, to: selectdDate as Date, options: NSCalendar.Options(rawValue: 0))
        
        dateComponents.month = 3 //or you can change month = day(90)
        
        let maxDate = calendar.date(byAdding: dateComponents as DateComponents, to: selectdDate as Date, options: NSCalendar.Options(rawValue: 0))
        self.datePicker.maximumDate = maxDate
        self.datePicker.minimumDate = minDate
        todayDate = minDate // this is because we will compare it with selected date.
        
        datePicker.datePickerMode = .date
        selectDateTextfield.inputAccessoryView = toolbar
        selectDateTextfield.inputView = datePicker
        selectDateTextfield.tag = 1
        
    }
    
    
    
    func createTimePicker(textFieldTag : Int) {
        
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
        let minDate = calendar.date(byAdding: dateComponents as DateComponents, to: selectdDate as Date, options: NSCalendar.Options(rawValue: 0))
        
        dateComponents.month = 3 //or you can change month = day(90)
        let maxDate = calendar.date(byAdding: dateComponents as DateComponents, to: selectdDate as Date, options: NSCalendar.Options(rawValue: 0))
        
        // working. here I am changing the date for compare.
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let userSelectedDate = formatter.string(from: selectedDate!)
        let todayDeviceDate = formatter.string(from: todayDate!)
        
        if userSelectedDate.compare(todayDeviceDate) == .orderedSame {
            if textFieldTag == 2 {
                // start text field
                self.startTimeTextfield.text = nil
            }else{
                self.endTimeTextfield.text = nil
            }
            
            self.timePicker.maximumDate = maxDate
            self.timePicker.minimumDate = minDate
        }
        else {
            
            if textFieldTag == 3 {
                startAvailableDateTime =  dateTime(date: selectedDateByPicker, time: startTimeString)
                self.timePicker.maximumDate = nil
                self.timePicker.minimumDate = startEndDateTime(dateInString: startAvailableDateTime)
            }else{
                self.timePicker.maximumDate = nil
                self.timePicker.minimumDate = nil
            }
        }
        
        timePicker.datePickerMode = .time
        timePicker.minuteInterval = 30
        startTimeTextfield.inputAccessoryView = toolbar
        startTimeTextfield.inputView = timePicker
        startTimeTextfield.tag = 2
        
        endTimeTextfield.inputAccessoryView = toolbar
        endTimeTextfield.inputView = timePicker
        endTimeTextfield.tag = 3
        
    }
    
    
    @objc func pickerCancelPressed() {
        self.view.endEditing(true)
    }
    
    
    @objc func pickerDonePressed() {
        //format date
        
        selectedDate = datePicker.date
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM-d-yyyy"
        selectDateTextfield.text = dateFormatter.string(from: datePicker.date)
        startTimeTextfield.text = ""
        endTimeTextfield.text = ""
        
        let convertedDate = dateFormatter.date(from: selectDateTextfield.text!)
        dateFormatter.dateFormat = "MMM d, yyyy"
        selectedDateByPicker = dateFormatter.string(from: convertedDate!)
        self.view.endEditing(true)
    }
    
    
    //Adding time by 30 for picker time selction if current time will be less than 30.
    func convertedCurrentDate(date: Date) -> Date {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        let formattedDateString = dateFormatter.string(from: date)
        let formatedStringDate = dateFormatter.date(from: formattedDateString)
        
        let calendar = Calendar.current
        var comp = calendar.dateComponents([.hour, .minute], from: formatedStringDate!)
        let minute = comp.minute
        var tempDate = Date()
        
        if let min = minute, min > 0 && min < 30 {
            tempDate =  calendar.date(bySetting: .minute, value: 30, of: formatedStringDate!)!
        }else{
           let addedMin = 60 - minute!
            tempDate =  calendar.date(byAdding: .minute, value: addedMin, to: formatedStringDate!)!
        }

        return tempDate

    }
    
    
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 23 2017
    // Purpose          :   Picker Done Action.
    //>--------------------------------------------------------------------------------------------------
    @objc func pickerTimeDonePressed() {
        
        //format date
        let dateFormatter = DateFormatter()
        //dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
        let calendar = Calendar.current
        var comp = calendar.dateComponents([.hour, .minute], from: timePicker.date)
        //let hour   = comp.hour
        let minute = comp.minute
        //let calendartest = Calendar.current
        //let date = calendartest.date(byAdding: .minute, value: 0, to: timePicker.date)
        
        if let min = minute, min < 30 {

          
            comp.minute = 0
            
            dateFormatter.dateFormat = "hh:00 a"
            timeString = dateFormatter.string(from: timePicker.date)
            
           
            //let date = calendar.date(byAdding: .minute, value: 5, to: startDate)
           // let roundedDate = Calendar.current.date(bySetting: .minute, value: 30, of: timePicker.date)
           // print(roundedDate!)

//            print(dateFormatter.string(from: comp.from(date: roundedDate!)!) )

//            let date = timePicker.date
//            let roundedDate = Calendar.current.date(bySetting: .minute, value: 0, of: timePicker.date)
//            print(dateFormatter.string(from: comp.from(date: roundedDate!)!) )

        } else {
            
            comp.minute = 30
            dateFormatter.dateFormat = "hh:30 a"
            timeString = dateFormatter.string(from: timePicker.date)
            //let roundedDate = Calendar.current.date(bySetting: .hour, value: hour!, of: timePicker.date)
            //print(dateFormatter.string(from: comp.from(date: roundedDate!)!) )

        }
        
        self.view.endEditing(true)
    }
    
    
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 23 2017
    // Input Parameters :   UIButton.
    // Purpose          :   Add the availability in the calendar.
    //>--------------------------------------------------------------------------------------------------
    @IBAction func addButtonTapped(_ sender: UIButton) {
        
        calendarModelObj.avialableDate = selectDateTextfield.text
        calendarModelObj.startTime = startTimeTextfield.text
        calendarModelObj.endTime = endTimeTextfield.text
        
        if !calendarModelObj.validateAvailableDate(){
            self.present(Helper.globalAlertView(with: LOGIN_CONSTANT.ALERT_HEADER_MESSAGE_KEY, message: calendarModelObj.alertMessage), animated: true, completion: nil)
        }else if !calendarModelObj.validateStartTime(){
            self.present(Helper.globalAlertView(with: LOGIN_CONSTANT.ALERT_HEADER_MESSAGE_KEY, message: calendarModelObj.alertMessage), animated: true, completion: nil)
        }else if !calendarModelObj.validateEndTime(){
            self.present(Helper.globalAlertView(with: LOGIN_CONSTANT.ALERT_HEADER_MESSAGE_KEY, message: calendarModelObj.alertMessage), animated: true, completion: nil)
        }else {
            
            startAvailableDateTime =  dateTime(date: selectedDateByPicker, time: startTimeString)
            endAvailableDateTime =  dateTime(date: selectedDateByPicker, time: endTimeString)
            
            // this is for getting diff of dates....
            let startDateTime = startEndDateTime(dateInString: startAvailableDateTime)
            let endDateTime = startEndDateTime(dateInString: endAvailableDateTime)

            let dayHourMinuteSecond: Set<Calendar.Component> = [.day, .hour, .minute, .second]
            let difference = NSCalendar.current.dateComponents(dayHourMinuteSecond, from: startDateTime, to: endDateTime);

            
            if difference.hour! < 2 {
                showAlertWithMessage(alertMessage: "You can not select time difference less then 2 hours")
                endTimeTextfield.text = nil

            }else{
                
                calendarModelObj.addAvialabilty(isEdit: isEditEvent, date: date(date: selectedDateByPicker), startTime: startAvailableDateTime, endTime: endAvailableDateTime) { (success) in
                    
                    let hud = JGProgressHUD(style: .light)
                    hud.textLabel.text = PROGRESS_HUD.HUD_LABEL_KEY
                    hud.show(in: self.view)
                    
                    if success {
                        hud.dismiss()
                        CRNotifications.showNotification(type: CRNotifications.success, title: "Success!", message: "You have successfully mark date in calendar.", dismissDelay: 3)
                        self.delegate.dateValue(update: self.dateTime(date: self.selectedDateByPicker, time: self.endTimeString)) //self.selectedDateByPicker
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        hud.dismiss()
                        self.present(Helper.globalAlertView(with: LOGIN_CONSTANT.ALERT_HEADER_MESSAGE_KEY, message: self.calendarModelObj.alertMessage), animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 23 2017
    // Input Parameters :   String.
    // Purpose          :   Local Alert.
    //>--------------------------------------------------------------------------------------------------
    func showAlertWithMessage(alertMessage:String) {
        let alertController = UIAlertController(title:ALERT_TITLE.APP_NAME, message:alertMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    // MARK: Textfield Delegate Method
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField.tag == 2 {
            self.createTimePicker(textFieldTag: 2)
        } else if textField.tag == 3 {
            self.createTimePicker(textFieldTag: 3)
        }
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField.tag == 2 {
            startTimeTextfield.text =  timeString
            startTimeString = timeString
            
        } else {
            endTimeTextfield.text =  timeString
            endTimeString = timeString
         }
    }
    
    
    
    // MARK: Method for date convertion
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 23 2017
    // Input Parameters :   Date Time String Format.
    // Purpose          :   Convert the date time to another(Required) time format.
    //>--------------------------------------------------------------------------------------------------
    
    func dateTime(date: String, time: String)  -> String{
        let dateTime = date + " " + time
        let dateFormatter = DateFormatter()
        var localTimeZoneAbbreviation: String { return TimeZone.current.abbreviation() ?? "" }
        dateFormatter.dateFormat = requiredDateTimeFormat
        dateFormatter.timeZone = NSTimeZone(name: localTimeZoneAbbreviation) as TimeZone?
        let finaldatetime = dateFormatter.date(from: dateTime)
        dateFormatter.dateFormat = formatedStringForServer  // yyyy-MM-dd'T'HH:mm:ss.SSSZ
        dateFormatter.timeZone = NSTimeZone.local
        
        if let finalDate = finaldatetime {
            return dateFormatter.string(from: finalDate)
        } else {
            return ""
        }
        
    }
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 23 2017
    // Input Parameters :   String to Date.
    // Purpose          :   Convert the String to another(Required) time format.
    //>--------------------------------------------------------------------------------------------------
    func startEndDateTime(dateInString: String) -> Date {
        let dateFormatter = DateFormatter()
        var localTimeZoneAbbreviation: String { return TimeZone.current.abbreviation() ?? "" }
        dateFormatter.dateFormat = formatedStringForServer
        dateFormatter.timeZone = NSTimeZone.local
        return dateFormatter.date(from: dateInString)!
    }
    
    
    //>---------------------------------------------------------------------------------------------------
    // Author Name      :   Rohit Kumar
    // Date             :   Nov, 23 2017
    // Input Parameters :   String to Date.
    // Purpose          :   Convert the date time to another(Required) time format.
    //>--------------------------------------------------------------------------------------------------
    func date(date: String)  -> String{
        let dateTime = date
        let dateFormatter = DateFormatter()
        var localTimeZoneAbbreviation: String { return TimeZone.current.abbreviation() ?? "" }
        dateFormatter.dateFormat = requiredDateFormat
        dateFormatter.timeZone = NSTimeZone(name: localTimeZoneAbbreviation) as TimeZone?
        let finaldatetime = dateFormatter.date(from: dateTime)
        dateFormatter.dateFormat = formatedStringForServer  // yyyy-MM-dd'T'HH:mm:ss.SSSZ
        dateFormatter.timeZone = NSTimeZone.local
        
        if let finalDate = finaldatetime {
            return dateFormatter.string(from: finalDate)
        } else {
            return ""
        }
    }
    
}




