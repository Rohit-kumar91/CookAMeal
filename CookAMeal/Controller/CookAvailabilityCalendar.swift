//
//  CookAvailabilityCalendar.swift
//  CookAMeal
//
//  Created by Cynoteck on 30/04/18.
//  Copyright © 2018 Cynoteck. All rights reserved.
//

import UIKit
import JKCalendar
import SwiftyJSON
import JGProgressHUD
import BEMCheckBox


class CookAvailabilityTableViewCell: UITableViewCell {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var checkButtonOutlet: BEMCheckBox!
    
}


class CookAvailabilityCalendar: UIViewController, dateDelegate {
    var markColor = #colorLiteral(red: 0.4392156863, green: 0.8039215686, blue: 0.9803921569, alpha: 1)
    var selectDay: JKDay = JKDay(date: Date())
    let currentYear = JKDay(date: Date()).year
    let currentDay = JKDay(date: Date()).day
    let currentMonth = JKDay(date: Date()).month
    var cookId = String()
    var dateString = String()
    var eventId = String()
    var recipeId = String()
    
    
    var selectedDate = Date()
    var eventTagValue = Int()
    var startdays = [Date]()
    var hud = JGProgressHUD()
    var sectionArray = [String]()
    let cookCalendarModelObj : CookAvailabilityCalendarModel = CookAvailabilityCalendarModel()
    @IBOutlet weak var cookAvailableCalendar: JKCalendarTableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getCalenderData(date: Date())
        
    }
    
    func dateValue(update: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: update)
        dateFormatter.dateFormat = "MMM d,yyyy hh:mm a"
        let tempDate = dateFormatter.string(from: date!)
        let finalDate = dateFormatter.date(from: tempDate)
        getCalenderData(date: finalDate!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        Singleton.instance.loadCookKitchenData = false
        Singleton.instance.kitchenData.removeAll()
        Singleton.instance.cookBookingSlot.removeAll()
        self.cookAvailableCalendar.calendar.delegate = self
        self.cookAvailableCalendar.calendar.dataSource = self
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func getCalenderData(date: Date) {
        
        let currentDateFormatter = DateFormatter()
        currentDateFormatter.dateFormat = "yyyy-MM-dd"
        currentDateFormatter.locale = Locale(identifier: "en_US_POSIX")
        sectionArray.append("Available Time: \(currentDateFormatter.string(from: date))")
        
        hud.show(in: self.view)
        hud.textLabel.text = "Loading"
        cookCalendarModelObj.getCookDatesForCalendar(cookId: cookId, date: currentDateFormatter.string(from: date)) { (success) in
            self.hud.dismiss()
            if success {
                self.cookAvailableCalendar.calendar.reloadData()
                //Getting the cuurent date data.
                let newdateFormatter = DateFormatter()
                newdateFormatter.dateFormat = "yyyy-MM-dd"
                newdateFormatter.locale = Locale(identifier: "en_US_POSIX")
                self.dateString = newdateFormatter.string(from: date)
                print("current date\(date)")
                print(newdateFormatter.string(from: date))
                self.getCurrentDateAvailabilty(dateString: newdateFormatter.string(from: date))
                
            }else{
                //self.showAlertWithMessage(alertMessage: self.cookCalendarModelObj.alertMessage)
                self.present(Helper.globalAlertView(with: LOGIN_CONSTANT.ALERT_HEADER_MESSAGE_KEY, message: self.cookCalendarModelObj.alertMessage), animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func handleBackButtonClick(_ sender: Any) {
        let _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func csheckButtonTapped(_ sender: BEMCheckBox) {
        
        for (index, _) in cookCalendarModelObj.tableDate.enumerated() {
            if index == sender.tag {
                 eventId = cookCalendarModelObj.tableDate[index]["id"]!
                 cookCalendarModelObj.tableDate[index]["isCheck"] = "1"
            } else {
                 cookCalendarModelObj.tableDate[index]["isCheck"] = "0"
            }
        }
        cookAvailableCalendar.reloadData()
    }
    
    
    @IBAction func cookButtonTapped(_ sender: UIButton) {
        
        print(cookCalendarModelObj.tableDate)
        
        for tabledata in cookCalendarModelObj.tableDate {
            if tabledata["isCheck"] == "1" {
                dateString = getdate(date: tabledata["startTime"]!)
                self.performSegue(withIdentifier: "cookAvailabiltyIdentifier", sender: nil)
                break
            } else {
                self.showAlertWithMessage(alertMessage: "You have to select time slot.")
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cookAvailabiltyIdentifier" {
            let destinationVC = segue.destination as! CookAvailabilityVC
            destinationVC.dateString = dateString
            destinationVC.eventId = eventId
            destinationVC.cookId = cookId
            destinationVC.recipeId = recipeId
        }
    }
    
    
    func getdate(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"//this your string date format
        var localTimeZoneAbbreviation: String { return TimeZone.current.abbreviation() ?? "" }
        
        dateFormatter.timeZone = NSTimeZone(name: localTimeZoneAbbreviation) as TimeZone?
        let date = dateFormatter.date(from: date)
        
        dateFormatter.dateFormat = "yyyy-MM-dd"///this is what you want to convert format
        dateFormatter.timeZone = NSTimeZone(name: localTimeZoneAbbreviation) as TimeZone?
        
        if let date = date {
            return dateFormatter.string(from: date)
        } else {
            return "Invalid date"
        }
    }
    
    
}

extension CookAvailabilityCalendar : JKCalendarDelegate {
    func calendar(_ calendar: JKCalendar, didTouch day: JKDay){
        selectDay = day
        print(selectDay.date)
        selectedDate = selectDay.date
        
        let newdateFormatter = DateFormatter()
        newdateFormatter.dateFormat = "yyyy-MM-dd"
        newdateFormatter.locale = Locale(identifier: "en_US_POSIX")
        print(newdateFormatter.string(from: selectDay.date))
        
        
        
        
        self.hud = JGProgressHUD(style: .light)
        self.hud.textLabel.text = PROGRESS_HUD.HUD_LABEL_KEY
        self.hud.show(in: self.view)
        getCurrentDateAvailabilty(dateString: newdateFormatter.string(from: selectDay.date))
        
        calendar.focusWeek = day < calendar.month ? 0: day > calendar.month ? calendar.month.weeksCount - 1: day.weekOfMonth - 1
        calendar.reloadData()
    }
    
    func heightOfFooterView(in claendar: JKCalendar) -> CGFloat{
        return 10
    }
    
    func viewOfFooter(in calendar: JKCalendar) -> UIView?{
        let view = UIView()
        let line = UIView(frame: CGRect(x: 8, y: 9, width: calendar.frame.width - 16, height: 1))
        line.backgroundColor = UIColor.lightGray
        view.addSubview(line)
        return view
    }
    
    func getCurrentDateAvailabilty(dateString: String) {
        
        let newdateFormatter = DateFormatter()
        newdateFormatter.dateFormat = "yyyy-MM-dd"
        newdateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        sectionArray[0] = "Available Time: \(dateString)"
        
        cookCalendarModelObj.calendarTableData(date: dateString, currentdate: newdateFormatter.string(from: Date()), cookId: cookId) { (success) in
            self.hud.dismiss()
            if success{
                print(self.cookCalendarModelObj.tableDate.count)
                
                if self.cookCalendarModelObj.tableDate.count == 0 {
                    self.cookAvailableCalendar.reloadData()
                    //self.noAvailabilityHeader.isHidden = false
                    //self.noAvailabilitySubTitle.isHidden = false
                } else {
                    //self.noAvailabilityHeader.isHidden = true
                    //self.noAvailabilitySubTitle.isHidden = true
                    self.cookAvailableCalendar.reloadData()
                }
            } else {
                  self.present(Helper.globalAlertView(with: LOGIN_CONSTANT.ALERT_HEADER_MESSAGE_KEY, message: self.cookCalendarModelObj.alertMessage), animated: true, completion: nil)
            }
        }
    }
}

extension CookAvailabilityCalendar : JKCalendarDataSource {
    
    func calendar(_ calendar: JKCalendar, marksWith month: JKMonth) -> [JKCalendarMark]? {

        var marks: [JKCalendarMark] = []
        let todayDate: JKDay = JKDay(year: currentYear, month: currentMonth, day: currentDay)!
        
        
        if selectDay == month {
            let currentDayColor = #colorLiteral(red: 0.4392156863, green: 0.8039215686, blue: 0.9803921569, alpha: 1)
            marks.append(JKCalendarMark(type: .circle, day: todayDate, color: currentDayColor))
        }
        
        if selectDay == month{
            markColor =  #colorLiteral(red: 0.4392156863, green: 0.8039215686, blue: 0.9803921569, alpha: 1)
            marks.append(JKCalendarMark(type: .hollowCircle, day: selectDay, color: markColor))
        }
        
        for i in cookCalendarModelObj.dateData {
            
            if i["color"].stringValue == "warning" {
                markColor =  #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            } else  if i["color"].stringValue == "danger" {
                markColor =  #colorLiteral(red: 0.8862745098, green: 0.1725490196, blue: 0.168627451, alpha: 1)
            }
            
            
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            //yyyy-MM-dd'T'HH:mm:ss.SSSZ
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            print(i[START_TIME_KEY].stringValue)
            print(dateFormatter.date(from: i[START_TIME_KEY].stringValue))
            
            if let date = dateFormatter.date(from: i[START_TIME_KEY].stringValue) {
                
                let calendar = Calendar.current
                let year = calendar.component(.year, from: date)
                let month = calendar.component(.month, from: date)
                let day = calendar.component(.day, from: date)
                let firstMarkDay: JKDay = JKDay(year: year, month: month, day: day)!
                
                marks.append(JKCalendarMark(type: .hollowCircle, day: firstMarkDay, color: markColor))
            }
        }
        
        return marks
    }
}




extension CookAvailabilityCalendar :  UITableViewDelegate, UITableViewDataSource {
    
    func getTime(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"//this your string date format
        var localTimeZoneAbbreviation: String { return TimeZone.current.abbreviation() ?? "" }
        
        dateFormatter.timeZone = NSTimeZone(name: localTimeZoneAbbreviation) as TimeZone?
        let date = dateFormatter.date(from: date)
        
        dateFormatter.dateFormat = "hh:mm a"///this is what you want to convert format
        dateFormatter.timeZone = NSTimeZone(name: localTimeZoneAbbreviation) as TimeZone?
        
        return dateFormatter.string(from: date!)
        
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionArray[section]
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cookCalendarModelObj.tableDate.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cookAvailableCell", for: indexPath) as! CookAvailabilityTableViewCell
        
        cell.timeLabel.text = getTime(date: cookCalendarModelObj.tableDate[indexPath.row][START_TIME_KEY]!) + " to " +  getTime(date: cookCalendarModelObj.tableDate[indexPath.row][END_TIME_KEY]!)
        
        if cookCalendarModelObj.tableDate[indexPath.row]["isCheck"]! == "0" {
            cell.checkButtonOutlet.on = false
        } else {
            cell.checkButtonOutlet.on = true
        }
        
        cell.checkButtonOutlet.tag = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        eventId = cookCalendarModelObj.tableDate[indexPath.row]["id"]!
        print(eventId)
    }
    
    
    
    func showAlertWithMessage(alertMessage:String) {
        let alertController = UIAlertController(title:ALERT_TITLE.APP_NAME, message:alertMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
}

