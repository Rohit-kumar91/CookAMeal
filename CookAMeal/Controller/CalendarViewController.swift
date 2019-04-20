//
//  CalendarViewController.swift
//  CookAMeal
//
//  Created by CYNOMAC001 on 04/04/18.
//  Copyright © 2018 Cynoteck. All rights reserved.
//

import UIKit
import JKCalendar
import SwiftyJSON
import JGProgressHUD

class CalendarCell: UITableViewCell {
    
    
    @IBOutlet weak var identificationLabel: UILabel!
    @IBOutlet weak var dateLabelOutlet: UILabel!
    @IBOutlet weak var nameLabelOutlet: UILabel!
    @IBOutlet weak var orderDateLabelOutlet: UILabel!
    @IBOutlet weak var orderStatusOutlet: UILabel!
    @IBOutlet weak var stackViewOutlet: UIStackView!
    @IBOutlet weak var calendarImageView: UIImageView!
    @IBOutlet weak var timeStackView: UIStackView!
    @IBOutlet weak var backgroundImageView: UIView!
    @IBOutlet weak var heightConstraintTopLabel: NSLayoutConstraint!
    @IBOutlet weak var priceLabelOutlet: UILabel!
    
    
    @IBOutlet weak var imageViewHeightCondtraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewWidthConstraint: NSLayoutConstraint!
    
    
    
}



class CalendarViewController: UIViewController, dateDelegate {
    
    var markColor = #colorLiteral(red: 0.4392156863, green: 0.8039215686, blue: 0.9803921569, alpha: 1)
    var selectDay: JKDay = JKDay(date: Date())
    let currentYear = JKDay(date: Date()).year
    let currentDay = JKDay(date: Date()).day
    let currentMonth = JKDay(date: Date()).month
    
    var selectedDate = Date()
    var eventTagValue = Int()
    var startdays = [Date]()
    let hud = JGProgressHUD(style: .light)
    var editButton = Bool()
    var calendarData = [JSON]()
   
    var dateStringValue = String()

    let calendarModelObj : CalendarModel = CalendarModel()
    @IBOutlet weak var  menuButton: UIButton!
    @IBOutlet weak var  noAvailabilityHeader: UILabel!
    @IBOutlet weak var  noAvailabilitySubTitle: UILabel!
    @IBOutlet weak var calendarTableView: JKCalendarTableView!
    @IBOutlet weak var addButtonOutlet: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    
        calendarTableView.rowHeight = UITableViewAutomaticDimension
        calendarTableView.estimatedRowHeight = 160
        self.revealViewController().delegate = self

        
        //register the tableview cell.
        
        var nib1 = UINib.init(nibName: "TimeAvailabilityCell", bundle: nil)
        self.calendarTableView.register(nib1, forCellReuseIdentifier: "TimeAvailabilityCell")
        
        
        nib1 = UINib.init(nibName: "DetialOrderTableViewCell", bundle: nil)
        self.calendarTableView.register(nib1, forCellReuseIdentifier: "DetialOrderTableViewCell")
        
        
        
        //Revealview Controller.
        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 80
        menuButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        self.revealViewController().frontViewShadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3131710123)
        self.revealViewController().frontViewShadowRadius = 2
        self.revealViewController().frontViewShadowOffset = CGSize(width: 0.0, height: 1.5)
        self.revealViewController().frontViewShadowOpacity = 0.8
        
        //User Role
        //2 - customer
        //1 - cook
        
        if Helper.getUserDefaultValue(key: USER_ROLE_KEY) == "2" {
            addButtonOutlet.isHidden = true
            hud.textLabel.text = PROGRESS_HUD.HUD_LABEL_KEY
            hud.show(in: self.view)
            getCalenderCustomerData(date: Date())
        } else if Helper.getUserDefaultValue(key: USER_ROLE_KEY) == "1" {
            hud.textLabel.text = PROGRESS_HUD.HUD_LABEL_KEY
            hud.show(in: self.view)
            addButtonOutlet.isHidden = false
            getCalenderCookData(date: Date())
        }
    }
    
    

    func dateValue(update: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: update)
        dateFormatter.dateFormat = "MMM d,yyyy hh:mm a"
        let tempDate = dateFormatter.string(from: date!)
        let finalDate = dateFormatter.date(from: tempDate)
        getCalenderCookData(date: finalDate!)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.calendarTableView.calendar.delegate = self
        self.calendarTableView.calendar.dataSource = self
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    
    func getCalenderCookData(date: Date) {
        
        let currentDate =  Date()
        
        if date < currentDate {
            print("Previous date is selcted.")
        }
        
        calendarModelObj.getCookDatesForCalendar { (success) in
            self.hud.dismiss()
            if success {
                self.calendarTableView.calendar.reloadData()
                //Getting the cuurent date data.
                let newdateFormatter = DateFormatter()
                newdateFormatter.dateFormat = "yyyy-MM-dd"
                newdateFormatter.locale = Locale(identifier: "en_US_POSIX")
                
                print("current date\(date)")
                print(newdateFormatter.string(from: date))
                self.dateStringValue = newdateFormatter.string(from: date)
                self.getCurrentDateAvailabilty(dateString: newdateFormatter.string(from: date))
                
            }else{
                //self.showAlertWithMessage(alertMessage: self.calendarModelObj.alertMessage)
                self.present(Helper.globalAlertView(with: LOGIN_CONSTANT.ALERT_HEADER_MESSAGE_KEY, message: self.calendarModelObj.alertMessage), animated: true, completion: nil)
            }
        }
    }
    
    func getCalenderCustomerData(date: Date) {
        
        calendarModelObj.getCustomerDatesForCalendar { (success) in
            self.hud.dismiss()
            if success {
                self.calendarTableView.calendar.reloadData()
                //Getting the cuurent date data.
                let newdateFormatter = DateFormatter()
                newdateFormatter.dateFormat = "yyyy-MM-dd"
                newdateFormatter.locale = Locale(identifier: "en_US_POSIX")
                
                print("current date\(date)")
                print(newdateFormatter.string(from: date))
                self.dateStringValue = newdateFormatter.string(from: date)
                self.getCurrentDateAvailabiltyForCustomer(dateString: newdateFormatter.string(from: date))
                
            }else{
                //self.showAlertWithMessage(alertMessage: self.calendarModelObj.alertMessage)
                self.present(Helper.globalAlertView(with: LOGIN_CONSTANT.ALERT_HEADER_MESSAGE_KEY, message: self.calendarModelObj.alertMessage), animated: true, completion: nil)
            }
        }
    }
    
    
    @IBAction func handleBackButtonClick(_ sender: Any) {
        let _ = navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func addEventButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "addAvailabilityIdentifier", sender: nil)
    }
    
    
    @IBAction func editEventButtonTapped(_ sender: UIButton) {
        print(self.calendarModelObj.tableDate[sender.tag])
        eventTagValue = sender.tag
        editButton = true
        self.performSegue(withIdentifier: "addAvailabilityIdentifier", sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "addAvailabilityIdentifier" {
            let destinationVC = segue.destination as! AddavailabilityViewController

            if editButton {
                
                print(self.calendarModelObj.tableDate[eventTagValue][START_TIME_KEY].stringValue)
                editButton = false
                destinationVC.isEditEvent = true
                let dateFormatter = DateFormatter()

                
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                let convertedDate = dateFormatter.date(from: self.calendarModelObj.tableDate[eventTagValue][START_TIME_KEY].stringValue)
                dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss.SSS"
                let tempConvertedDate = dateFormatter.string(from: convertedDate!)
                let finalConvertedDate = dateFormatter.date(from: tempConvertedDate)
                //2018-04-18 00:00:00 +0000
                destinationVC.selectdDate = finalConvertedDate!
                destinationVC.startTime = getTime(date: self.calendarModelObj.tableDate[eventTagValue][START_TIME_KEY].stringValue)
                destinationVC.endTime = getTime(date: self.calendarModelObj.tableDate[eventTagValue][END_TIME_KEY].stringValue)
                destinationVC.eventId = self.calendarModelObj.tableDate[eventTagValue][ID_KEY].stringValue
                destinationVC.delegate = self
                
                
            } else {
                destinationVC.selectdDate = selectedDate
                destinationVC.delegate = self
            }
        }
    }
    
    
    func compareDate(date1:Date, date2:Date) -> Bool {
        let order = NSCalendar.current.compare(date1, to: date2, toGranularity: .day)
        
        switch order {
        case .orderedSame:
            return true
            
        case .orderedDescending:
            return true
            
        case .orderedAscending:
            return false
            
        default:
            return false
        }
    }
    
}



extension CalendarViewController: JKCalendarDelegate{
    
    func calendar(_ calendar: JKCalendar, didTouch day: JKDay){
        selectDay = day
        print(selectDay.date)
        selectedDate = selectDay.date

        let newdateFormatter = DateFormatter()
        newdateFormatter.dateFormat = "yyyy-MM-dd"
        newdateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateStringValue = newdateFormatter.string(from: selectDay.date)
        
        
        //User Role
        //2 - customer
        //1 - cook
        
        if !compareDate(date1: selectDay.date, date2: Date()) {
            self.addButtonOutlet.isHidden = true
            //self.showAlertWithMessage(alertMessage: "You cannot select the previous date.")
        } else {
            
            if Helper.getUserDefaultValue(key: USER_ROLE_KEY) == "2" {
                addButtonOutlet.isHidden = true
            } else if Helper.getUserDefaultValue(key: USER_ROLE_KEY) == "1" {
                addButtonOutlet.isHidden = false
            }
        }
        
            self.calendarData.removeAll()
            self.calendarTableView.reloadData()
        
            self.hud.textLabel.text = PROGRESS_HUD.HUD_LABEL_KEY
            self.hud.show(in: self.view)
            
            if Helper.getUserDefaultValue(key: USER_ROLE_KEY) == "2" {
                getCurrentDateAvailabiltyForCustomer(dateString: newdateFormatter.string(from: selectDay.date))
            } else if Helper.getUserDefaultValue(key: USER_ROLE_KEY) == "1" {
                getCurrentDateAvailabilty(dateString: newdateFormatter.string(from: selectDay.date))
            }
            
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
        
        calendarModelObj.calendarTableData(date: dateString) { (success) in
            self.hud.dismiss()
            if success {
                
                self.calendarModelObj.getTableBookDatesDataForCalendar(date: dateString, completion: { (Success) in
                    if success {
                        
                        self.calendarData = self.calendarModelObj.tableDate
                        
                        if self.calendarData.count == 0 && self.calendarModelObj.dateTimeArray.count == 0 {
                            self.calendarTableView.reloadData()
                            self.noAvailabilityHeader.isHidden = false
                            self.noAvailabilitySubTitle.isHidden = false
                            
                            self.noAvailabilityHeader.text = "No Order Available."
                            self.noAvailabilitySubTitle.text = "Customer needs to place the order."
                            
                        } else {
                            self.calendarTableView.reloadData()
                            self.noAvailabilityHeader.isHidden = true
                            self.noAvailabilitySubTitle.isHidden = true
                        }
                        
                    } else {
                        self.noAvailabilityHeader.isHidden = true
                        self.noAvailabilitySubTitle.isHidden = true
                        self.calendarTableView.reloadData()
                    }
                })
               
            } else {
               //self.showAlertWithMessage(alertMessage: self.calendarModelObj.alertMessage)
                self.present(Helper.globalAlertView(with: LOGIN_CONSTANT.ALERT_HEADER_MESSAGE_KEY, message: self.calendarModelObj.alertMessage), animated: true, completion: nil)
            }
        }
    }
    
    
    func getCurrentDateAvailabiltyForCustomer(dateString: String) {
        
        self.calendarModelObj.getTableBookDatesDataForCalendar(date: dateString, completion: { (success) in
            self.hud.dismiss()
            if success {
               
                self.calendarData = self.calendarModelObj.tableDate
                
                if self.calendarData.count == 0 && self.calendarModelObj.dateTimeArray.count == 0 {
                    self.noAvailabilityHeader.isHidden = false
                    self.noAvailabilitySubTitle.isHidden = false

                } else {
                    self.calendarTableView.reloadData()
                    self.noAvailabilityHeader.isHidden = true
                    self.noAvailabilitySubTitle.isHidden = true
                }
                
               
            } else {
                self.noAvailabilityHeader.isHidden = true 
                self.noAvailabilitySubTitle.isHidden = true
                self.calendarTableView.reloadData()
            }
        })
    }
    
    
}

extension CalendarViewController: JKCalendarDataSource{
    
    
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
        
        for i in calendarModelObj.dateData {
            
            if i["color"].stringValue == "warning" {
                markColor =  #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            } else  if i["color"].stringValue == "danger" {
                markColor =  #colorLiteral(red: 0.8862745098, green: 0.1725490196, blue: 0.168627451, alpha: 1)
            }
            
            
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            print(i[START_TIME_KEY].stringValue)
            //let date = dateFormatter.date(from: i[START_TIME_KEY].stringValue)
            
            //print("date=====\(date)")
            
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



extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {
    
    func getTime(date: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"//this your string date format
        var localTimeZoneAbbreviation: String { return TimeZone.current.abbreviation() ?? "" }
        
        dateFormatter.timeZone = NSTimeZone(name: localTimeZoneAbbreviation) as TimeZone?
        let date = dateFormatter.date(from: date)
        
        dateFormatter.dateFormat = "hh:mm a"///this is what you want to convert format
        dateFormatter.timeZone = NSTimeZone(name: localTimeZoneAbbreviation) as TimeZone?
       
        if date != nil {
            return dateFormatter.string(from: date!)
        } else {
            return "Invalid Date Format"
        }
        
    }
    
    func getDate(date: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"//this your string date format   yyyy-MM-dd'T'HH:mm:ssZ
        var localTimeZoneAbbreviation: String { return TimeZone.current.abbreviation() ?? "" }
        
        dateFormatter.timeZone = NSTimeZone(name: localTimeZoneAbbreviation) as TimeZone?
        let date = dateFormatter.date(from: date)
        
        dateFormatter.dateFormat = "dd/MM/yyyy"///this is what you want to convert format
        dateFormatter.timeZone = NSTimeZone(name: localTimeZoneAbbreviation) as TimeZone?
        
        if date != nil {
            return dateFormatter.string(from: date!)
        } else {
            return "Invalid Date Format"
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
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if Helper.getUserDefaultValue(key: USER_ROLE_KEY) == "2" {
            return self.calendarData.count
        } else {
            
            if self.calendarData.count != 0 {
                return self.calendarData.count + 1
            } else {
                return self.calendarModelObj.dateTimeArray.count
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if Helper.getUserDefaultValue(key: USER_ROLE_KEY) == "2" {
            //Customer
             let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CalendarCell
            
            DispatchQueue.main.async {
                // Asynchronous code running on the main queue
                cell.backgroundImageView.layer.cornerRadius =  cell.backgroundImageView.bounds.size.height / 2
                cell.calendarImageView.layer.cornerRadius =  cell.calendarImageView.bounds.size.height / 2
            }
            
            cell.dateLabelOutlet.text = "   Order Date: " + dateStringValue
            
            
            if indexPath.row != 0 {
                cell.heightConstraintTopLabel.constant = 1
                cell.dateLabelOutlet.text = ""
            }
            
           
            
            cell.calendarImageView.sd_setImage(with: URL(string: self.calendarData[indexPath.row]["profile"]["profileUrl"].stringValue), placeholderImage:UIImage(named: "recipePlaceholder"), options: .refreshCached)
            cell.nameLabelOutlet.text = self.calendarData[indexPath.row]["profile"]["fullName"].string
            
            
            cell.identificationLabel.layer.cornerRadius = 4.0
            //cell.identificationLabel.layer.borderWidth = 1.0
            //®cell.identificationLabel.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            cell.identificationLabel.layer.masksToBounds = true
            cell.identificationLabel.text = " " + self.calendarData[indexPath.row]["profile"]["tag"].string! + " "
            
            cell.orderDateLabelOutlet.text = "Date: " +  UTCToLocal(date: self.calendarData[indexPath.row]["createdAt"].string!, fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: "dd/MM/yyyy")
            
            cell.orderStatusOutlet.layer.cornerRadius = 4
            cell.orderStatusOutlet.layer.masksToBounds = true
            cell.orderStatusOutlet.text =  self.calendarData[indexPath.row]["orderState"].stringValue

            
            let recipeArray = self.calendarData[indexPath.row]["recipes"].arrayValue
            
            cell.priceLabelOutlet.text = self.calendarData[indexPath.row]["currencySymbol"].stringValue + " " + self.calendarData[indexPath.row]["totalAmount"].stringValue
            
            for element in cell.stackViewOutlet.arrangedSubviews {
                element.isHidden = true
                cell.stackViewOutlet.removeArrangedSubview(element)
            }
            
            
            for (index,element) in recipeArray.enumerated() {
                let textLabel = UILabel()
                textLabel.textAlignment = .left
                //"● " +
                textLabel.text = String(index + 1) + "." + " " + element["dishName"].stringValue
                textLabel.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                textLabel.font = UIFont(name: "HelveticaNeue", size: 15)
                cell.stackViewOutlet.addArrangedSubview(textLabel)
            }
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CalendarCell
            
            
            DispatchQueue.main.async {
                // Asynchronous code running on the main queue
                cell.backgroundImageView.layer.cornerRadius =  cell.backgroundImageView.bounds.size.height / 2
                cell.calendarImageView.layer.cornerRadius =  cell.calendarImageView.bounds.size.height / 2
            }
            
            if indexPath.row == 0 {
                cell.dateLabelOutlet.text = "   My Availability on: " + dateStringValue
                cell.identificationLabel.isHidden = true
                
                if calendarModelObj.dateTimeArray.count != 0 {
                    
                    for element in cell.timeStackView.arrangedSubviews {
                        element.isHidden = true
                        cell.timeStackView.removeArrangedSubview(element)
                    }
                    
                    print(calendarModelObj.dateTimeArray)
                    
                    for element in calendarModelObj.dateTimeArray {
                        let textLabel = UILabel()
                        textLabel.textAlignment = .left
                        //"● " +
                        textLabel.text = "● " + self.getTime(date: element["startTime"].stringValue) + " To " + self.getTime(date: element["endTime"].stringValue)
                        textLabel.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                        textLabel.font = UIFont(name: "HelveticaNeue", size: 15)
                        cell.timeStackView.addArrangedSubview(textLabel)
                    }
                } else {
                    
                    for element in cell.timeStackView.arrangedSubviews {
                        element.isHidden = true
                        cell.timeStackView.removeArrangedSubview(element)
                    }
                    
                    let textLabel = UILabel()
                    textLabel.textAlignment = .left
                    //"● " +
                    textLabel.text = "● No time availability added by you."
                    textLabel.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    textLabel.font = UIFont(name: "HelveticaNeue", size: 15)
                    cell.timeStackView.addArrangedSubview(textLabel)
                }
                
                
                cell.imageViewWidthConstraint.constant = 0
                cell.imageViewHeightCondtraint.constant = 0
                
                cell.nameLabelOutlet.text = ""
                cell.orderDateLabelOutlet.text = ""
                cell.orderStatusOutlet.text = ""
                cell.priceLabelOutlet.text = ""
                
                
            } else {
                
                print(indexPath.row)
                
               
                
                
                if self.calendarData.count > 0 {
                    
                    cell.dateLabelOutlet.isHidden = false
                    cell.identificationLabel.isHidden = false
                    
                    if indexPath.row == 1 {
                        cell.heightConstraintTopLabel.constant = 24
                        cell.dateLabelOutlet.text = "   Order Date: " + dateStringValue
                    } else {
                        cell.heightConstraintTopLabel.constant = 1
                        cell.dateLabelOutlet.text = ""
                    }
                    
                    print(self.calendarData)
                    
                    cell.calendarImageView.sd_setImage(with: URL(string: self.calendarData[indexPath.row - 1]["profile"]["profileUrl"].stringValue), placeholderImage:UIImage(named: "recipePlaceholder"), options: .refreshCached)
                    cell.nameLabelOutlet.text = self.calendarData[indexPath.row - 1]["profile"]["fullName"].string
                    
                    cell.orderDateLabelOutlet.text = getDate(date: self.calendarData[indexPath.row - 1]["createdAt"].string!)
                    cell.orderStatusOutlet.layer.cornerRadius = 2
                    cell.orderStatusOutlet.text = self.calendarData[indexPath.row - 1]["orderState"].stringValue
                    cell.priceLabelOutlet.text = self.calendarData[indexPath.row - 1]["currencySymbol"].stringValue + " " + self.calendarData[indexPath.row - 1]["totalAmount"].stringValue
                    
                    
                    cell.identificationLabel.layer.cornerRadius = 4.0
                    cell.identificationLabel.layer.masksToBounds = true
                    cell.identificationLabel.text = " " + self.calendarData[indexPath.row - 1]["profile"]["tag"].string! + " "
                    
                    
                    let recipeArray = self.calendarData[indexPath.row - 1]["recipes"].arrayValue
                    
                    for element in cell.stackViewOutlet.arrangedSubviews {
                        element.isHidden = true
                        cell.stackViewOutlet.removeArrangedSubview(element)
                    }
                    
                    
                    for (index,element) in recipeArray.enumerated() {
                        let textLabel = UILabel()
                        textLabel.textAlignment = .left
                        //"● " +
                        textLabel.text = String(index + 1) + "." + " " + element["dishName"].stringValue
                        textLabel.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                        textLabel.font = UIFont(name: "HelveticaNeue", size: 15)
                        cell.stackViewOutlet.addArrangedSubview(textLabel)
                    }
                } else {
                    cell.imageViewWidthConstraint.constant = 0
                    cell.imageViewHeightCondtraint.constant = 0
                    
                    cell.nameLabelOutlet.text = ""
                    cell.orderDateLabelOutlet.text = ""
                    cell.orderStatusOutlet.text = ""
                    cell.priceLabelOutlet.text = ""
                    cell.dateLabelOutlet.isHidden = true
                    cell.identificationLabel.isHidden = true
                }
                
            }
            
            return cell
            
        }
        
    }
    

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
           let eventId = calendarModelObj.tableDate[indexPath.row][ID_KEY].stringValue
            calendarModelObj.deleteEvent(eventId: eventId) { (success) in
                if success {
                    self.calendarModelObj.tableDate.remove(at: indexPath.row)
                    self.calendarTableView.deleteRows(at: [indexPath], with: .automatic)
                    
                    //Show error label.
                    if self.calendarModelObj.tableDate.count == 0 {
                        self.calendarTableView.reloadData()
                        self.noAvailabilityHeader.isHidden = false
                        self.noAvailabilitySubTitle.isHidden = false
                    }
                    
                    if Helper.getUserDefaultValue(key: USER_ROLE_KEY) == "2" {
                        self.addButtonOutlet.isHidden = true
                        self.getCalenderCustomerData(date: Date())
                    } else if Helper.getUserDefaultValue(key: GUEST_KEY) == "1" {
                        self.addButtonOutlet.isHidden = false
                        self.getCalenderCookData(date: Date())
                    }
                    
                    
                    //User Role
                    //2 - customer
                    //1 - cook
                    
                    if Helper.getUserDefaultValue(key: USER_ROLE_KEY) == "2" {
                        self.getCalenderCustomerData(date: Date())
                    } else if Helper.getUserDefaultValue(key: USER_ROLE_KEY) == "1" {
                        //Get calendar data.
                        self.getCalenderCookData(date: Date())
                    }
                    
                } else {
                    //self.showAlertWithMessage(alertMessage: self.calendarModelObj.alertMessage)
                    self.present(Helper.globalAlertView(with: LOGIN_CONSTANT.ALERT_HEADER_MESSAGE_KEY, message: self.calendarModelObj.alertMessage), animated: true, completion: nil)
                }
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    func showAlertWithMessage(alertMessage:String) {
        let alertController = UIAlertController(title:ALERT_TITLE.APP_NAME, message:alertMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}


extension CalendarViewController: SWRevealViewControllerDelegate {
    
    func revealController(_ revealController: SWRevealViewController!, willMoveTo position: FrontViewPosition) {
        if(position == FrontViewPosition.left) {
            self.calendarTableView.isUserInteractionEnabled = true;
        } else {
            self.calendarTableView.isUserInteractionEnabled = false;
        }
    }
    
    
    func revealController(_ revealController: SWRevealViewController!, didMoveTo position: FrontViewPosition) {
        if(position == FrontViewPosition.left) {
            self.calendarTableView.isUserInteractionEnabled = true;
        } else {
            self.calendarTableView.isUserInteractionEnabled = false;
        }
    }
}
