//
//  MapVC.swift
//  CookAMeal
//
//  Created by cynoteck Mac Mini on 03/01/18.
//  Copyright © 2018 Cynoteck. All rights reserved.
//

import UIKit
import GoogleMaps
import SwiftyJSON
import JGProgressHUD
import SDWebImage

struct MyPlace {
    var name: String
    var lat: Double
    var long: Double
}


class MapVC: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var myMapView: GMSMapView!
    @IBOutlet weak var cookTableView: UITableView!
    
    
    let currentLocationMarker = GMSMarker()
    var locationManager = CLLocationManager()
    var chosenPlace: MyPlace?
    var profileId = String()

    
    let customMarkerWidth: Int = 50
    let customMarkerHeight: Int = 70
    
    let mapModelObj: MapModel = MapModel()
    let profileVCObj: ProfileModel = ProfileModel()
    //let previewDemoData = [(title: "The Polar Junction", img: #imageLiteral(resourceName: "cook") , price: 10), (title: "The Nifty Lounge", img: #imageLiteral(resourceName: "demo"), price: 8), (title: "The Lunar Petal", img: #imageLiteral(resourceName: "n-INDIAN-FOOD-628x314"), price: 12)]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.myMapView.delegate=self
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.locationManager.startMonitoringSignificantLocationChanges()

        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(true)
        loadMapDataAndCategoryData(lat: String(currentLocationLatitude), long: String(currentLocationLongitute))

    }
    
    func loadMapDataAndCategoryData(lat: String, long: String) {
        
        
       // myMapView.clear()

        let hud = JGProgressHUD(style: .light)
        hud.show(in: self.view)
        hud.textLabel.text = "Loading"
        //get intail data.
        mapModelObj.mapIntialValueOnViewLoad(lat: lat, long: long) { (success) in
            if success {
                
                hud.dismiss()
                
                self.mapModelObj.categoryWiseCookDetails(lat: lat, long: long, completion: { (success) in
//                    self.myMapView.delegate=self
//                    self.locationManager.delegate = self
//                    self.locationManager.requestWhenInUseAuthorization()
//                    self.locationManager.startUpdatingLocation()
//                    self.locationManager.startMonitoringSignificantLocationChanges()
                    self.cookTableView.reloadData()
                    
                    
                    self.showPartyMarkers(lat: 0.0000, long: 0.0000)

                    
//                    self.initGoogleMaps()
                })
                
            } else {
                
            }
        }
    }
    
    
    @IBAction func likeButtonTapped(_ sender: UIButton) {
        
        if Helper.getUserDefaultValue(key: GUEST_KEY) == "1" {
            //For Guest User
            Helper.removeUserDefault(key: TOKEN_KEY)
        } else {
            //For Cook and Customer
            
            let outerArrayIndex = sender.tag / 10
            let nestedInnerArrayIndex = sender.tag % 10
            
            //Button Animation.
            let pulse = CASpringAnimation(keyPath: "transform.scale")
            pulse.duration = 0.6
            pulse.fromValue = 0.95
            pulse.toValue = 1.2
            pulse.autoreverses = true
            pulse.repeatCount = 1
            pulse.initialVelocity = 0.5
            pulse.damping = 1.0
            sender.layer.add(pulse, forKey: "pulse")
            
            print(mapModelObj.CooksDealWithCategories[outerArrayIndex - 1][nestedInnerArrayIndex][ID_KEY].stringValue)
            
            //Calling Favourite API.
            profileVCObj.markFavorite(profileId: mapModelObj.CooksDealWithCategories[outerArrayIndex - 1][nestedInnerArrayIndex][ID_KEY].stringValue) { (success) in
                if success {
                    
                    if self.profileVCObj.fovouriteCheck {
                        self.profileVCObj.profileDetailData[outerArrayIndex - 1][nestedInnerArrayIndex]["cookProfile"]["favorite"] = true
                        let indexPath = IndexPath(row: outerArrayIndex - 1, section: 0)
                        let cell: OrderTableviewCell = self.cookTableView.cellForRow(at: indexPath) as! OrderTableviewCell
                        let collectionViewindexPath = IndexPath(row: nestedInnerArrayIndex, section: 0)
                        cell.recipeCollectionview.reloadItems(at: [collectionViewindexPath])
                    } else {
                        self.profileVCObj.profileDetailData[outerArrayIndex - 1][nestedInnerArrayIndex]["cookProfile"]["favorite"] = false
                        let indexPath = IndexPath(row: outerArrayIndex - 1, section: 0)
                        let cell: MapTableViewCell = self.cookTableView.cellForRow(at: indexPath) as! MapTableViewCell
                        let collectionViewindexPath = IndexPath(row: nestedInnerArrayIndex, section: 0)
                        cell.cookCollectionviewOutlet.reloadItems(at: [collectionViewindexPath])
                    }
                    
                    
                } else {
                    
                    self.mapModelObj.CooksDealWithCategories[outerArrayIndex - 1][nestedInnerArrayIndex]["cookProfile"]["favorite"] = false
                    let indexPath = IndexPath(row: outerArrayIndex - 1, section: 0)
                    let cell: MapTableViewCell = self.cookTableView.cellForRow(at: indexPath) as! MapTableViewCell
                    let collectionViewindexPath = IndexPath(row: nestedInnerArrayIndex, section: 0)
                    cell.cookCollectionviewOutlet.reloadItems(at: [collectionViewindexPath])
                    
                }
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mapVcToProfileVC" {
            let destinationVC = segue.destination as! ProfileVC
            destinationVC.profileId = profileId
            destinationVC.backButtonBool = true
        }
    }
    
    
    
    
    func initGoogleMaps() {
        let camera = GMSCameraPosition.camera(withLatitude: currentLocationLatitude, longitude: currentLocationLongitute, zoom: 17.0)
        self.myMapView.camera = camera
        self.myMapView.delegate = self
        self.myMapView.isMyLocationEnabled = true
    }
    
    
    
    // MARK: CLLocation Manager Delegate
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while getting location \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.delegate = nil
        locationManager.stopUpdatingLocation()
        let location = locations.last
        let lat = (location?.coordinate.latitude)!
        let long = (location?.coordinate.longitude)!
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 13.0)
        self.myMapView.animate(to: camera)
//        showPartyMarkers(lat: lat, long: long)
    }
    
    func showPartyMarkers(lat: Double, long: Double) {
        
        print("lat long data iss------\(mapModelObj.latLongData )")
        
        print(mapModelObj.mapData)
        print(mapModelObj.mapData.count)
        
        for mapData in mapModelObj.mapData {
            
            let latitude = mapData["profile"]["Address"]["latitude"].doubleValue
            
            
            print(latitude)
            let longitude = mapData["profile"]["Address"]["longitude"].doubleValue
            print(longitude)
            let userImageUrl = mapData["profile"]["profileUrl"].stringValue
            
            print(userImageUrl)
            
            let title = mapData["profile"]["fullName"].stringValue
            
            mapAnotationInMapView(locationCoordinate2D: CLLocationCoordinate2D(latitude: latitude,longitude: longitude),
                                  cameraLat: (latitude),
                                  cameraLong: (longitude),
                                  markerTitle: title,
                                  imageUrl: userImageUrl)

        }
    }
    
    
    func mapAnotationInMapView (locationCoordinate2D : CLLocationCoordinate2D, cameraLat : Double, cameraLong : Double, markerTitle: String, imageUrl: String) {

        self.myMapView.isMyLocationEnabled = true

//        let camera = GMSCameraPosition.camera(withLatitude: currentLocationLatitude, longitude: currentLocationLongitute, zoom: 9.0)
      //  myMapView.camera = camera
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        
        let imgView = UIImageView()
        imgView.frame=CGRect(x: 0, y: 0, width: 78, height: 78)
        imgView.image = #imageLiteral(resourceName: "marker128")
        imgView.contentMode = .center
        
        let userImage = UIImageView()
        userImage.frame = CGRect(x: 27, y: 20, width: 24, height: 24)
        userImage.layer.cornerRadius = 12
        userImage.clipsToBounds=true
        userImage.sd_setImage(with: URL(string: imageUrl), placeholderImage:UIImage(named: "profilePlaceholder"), options: .refreshCached)
        
        imgView.addSubview(userImage)
        
        marker.iconView = imgView
        marker.position = locationCoordinate2D
        let fullTitle = markerTitle.components(separatedBy: ",")
        let trimTitle    = fullTitle[0]
        marker.title = trimTitle
        marker.map = myMapView
        
    }
   
    
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        
        let outerSubView = UIView(frame: CGRect.init(x: 0, y: 0, width: 200, height: 60))
        outerSubView.backgroundColor = UIColor.clear

        let view = UIView(frame: CGRect.init(x: 0, y: 0, width: 200, height: 50))
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 4
        view.clipsToBounds=true

        let userImage = UIImageView()
        userImage.frame = CGRect(x: 0, y: 0, width: 50, height: 34)
        userImage.clipsToBounds=true
        userImage.image = #imageLiteral(resourceName: "carIcons")
        userImage.contentMode = .center
        userImage.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        
        let lblDistance = UILabel(frame: CGRect.init(x: 0, y: 25, width: 50, height: 25))
        lblDistance.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        lblDistance.font = UIFont.systemFont(ofSize: 14)
        lblDistance.text = "5 km"
        lblDistance.textAlignment = .center
        lblDistance.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        
        
        let userName = UILabel(frame: CGRect.init(x: userImage.frame.size.width + 5, y: 10, width: (200 - userImage.frame.size.width - 5), height: 30))
        userName.text =  marker.title
        userName.font = UIFont.systemFont(ofSize: 18)
        userName.textAlignment = .center;
        //userName.sizeToFit()

        
        // add to subview....
        let lblArrow = UILabel(frame: CGRect.init(x: 0, y: view.frame.size.height - 10 , width: 200, height: 15))
        lblArrow.text = "▾"
        lblArrow.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        lblArrow.font = UIFont.systemFont(ofSize: 44)
        lblArrow.textAlignment = .center
        
        view.addSubview(userImage)
        view.addSubview(userName)
        view.addSubview(lblDistance)
        
        outerSubView.addSubview(view)
        outerSubView.addSubview(lblArrow)
        
        return outerSubView
    }
    
    
    
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        mapView.clear()
        //let latitude = mapView.camera.target.latitude
        //let longitude = mapView.camera.target.longitude
        //self.drawCircle(position: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
        
    }
    
    
    
    func drawCircle(position: CLLocationCoordinate2D) {
        
        let circle = GMSCircle(position: position, radius: 3000)
        circle.strokeColor = UIColor.red
        circle.fillColor = UIColor(red: 255.0, green: 0, blue: 0, alpha: 0.05)
        circle.map = myMapView
        loadMapDataAndCategoryData(lat: String(position.latitude), long: String(position.longitude))

    }

    
    

    
    // MARK: GOOGLE MAP DELEGATE
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
       
        guard let customMarkerView = marker.iconView as? CustomMarkerView else { return false }
        let img = customMarkerView.img!
        let customMarker = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: customMarkerWidth, height: customMarkerHeight), image: img, borderColor: UIColor.white, tag: customMarkerView.tag)
        marker.iconView = customMarker
        
        return false
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoContents marker: GMSMarker) -> UIView? {
        guard let customMarkerView = marker.iconView as? CustomMarkerView else { return nil }
        let data = mapModelObj.previewDemoData[customMarkerView.tag]
        restaurantPreviewView.setData(title: (data["title"]?.stringValue)!, img: (data["img"]?.stringValue)!, price: 0)
        return restaurantPreviewView
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        guard let customMarkerView = marker.iconView as? CustomMarkerView else { return }
        let tag = customMarkerView.tag
        restaurantTapped(tag: tag)
    }
    
    func mapView(_ mapView: GMSMapView, didCloseInfoWindowOf marker: GMSMarker) {
        guard let customMarkerView = marker.iconView as? CustomMarkerView else { return }
        let img = customMarkerView.img!
        let customMarker = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: customMarkerWidth, height: customMarkerHeight), image: img, borderColor: UIColor.darkGray, tag: customMarkerView.tag)
        marker.iconView = customMarker
    }
    
    /*

    // subodh working
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        
        let lbl1 = UILabel(frame: CGRect.init(x: 8, y: 8, width: 200, height: 15))
        lbl1.text =  marker.title
        lbl1.textAlignment = .center;
        lbl1.sizeToFit()
        
        let view = UIView(frame: CGRect.init(x: 0, y: 0, width: lbl1.frame.size.width + 15, height: lbl1.frame.size.height + 15))
        view.backgroundColor = UIColor.white
        // view.layer.cornerRadius = 6
        
        let lbl2 = UILabel(frame: CGRect.init(x: lbl1.frame.origin.x , y: lbl1.frame.origin.y + lbl1.frame.size.height  , width: lbl1.frame.size.width , height: 1))
        lbl2.backgroundColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)
        
        // add to subview....
        view.addSubview(lbl1)
        view.addSubview(lbl2)
        
        return view
    }
    
    // end...
    
    func showPartyMarkers(lat: Double, long: Double) {
        myMapView.clear()
        
        print("lat long data iss------\(mapModelObj.latLongData )")
        
        for i in 0..<mapModelObj.latLongData.count {
           
            let latitude = mapModelObj.latLongData[i]["latitude"]?.doubleValue
            let longitude = mapModelObj.latLongData[i]["longitude"]?.doubleValue

            let camera = GMSCameraPosition.camera(withLatitude: 00.00000, longitude: 000.0000, zoom: 9.0)
            myMapView.camera = camera
            // Creates a marker in the center of the map.
            let marker = GMSMarker()
            
            var markerImage = UIImage()
            let markerView = UIImageView(image: markerImage)
            markerView.tintColor = UIColor.black
            marker.iconView = markerView
            
            marker.position = CLLocationCoordinate2D(latitude: latitude!,longitude: longitude!)
            
            let fullTitle = "Testing Subodh"
           // let trimTitle    = fullTitle[0]
            marker.title = fullTitle
            
            marker.map = myMapView

            
            /*
            //let randNum=Double(arc4random_uniform(30))/10000
            let marker=GMSMarker()
            
            let customMarker = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: customMarkerWidth, height: customMarkerHeight), image: (mapModelObj.previewDemoData[i]["img"]?.stringValue)!, borderColor: UIColor.darkGray, tag: i)
            
            marker.iconView=customMarker
            
            print((mapModelObj.latLongData[i][LONGITUDE_KEY]?.doubleValue)!)
            print((mapModelObj.latLongData[i][LATITUDE_KEY]?.doubleValue)!)
            
          
            marker.position = CLLocationCoordinate2D(latitude: (mapModelObj.latLongData[i][LATITUDE_KEY]?.doubleValue)! , longitude: (mapModelObj.latLongData[i][LONGITUDE_KEY]?.doubleValue)! )
            

            marker.map = self.myMapView
 
 */
        }
    }
    
*/
    
    @objc func restaurantTapped(tag: Int) {
//        let v=DetailsVC()
//        v.passedData = previewDemoData[tag]
//        self.navigationController?.pushViewController(v, animated: true)
    }
    
    
    
    
    var restaurantPreviewView: RestaurantPreviewView = {
        let v=RestaurantPreviewView()
        return v
    }()
    
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}



extension MapVC:  UITableViewDataSource, UITableViewDelegate  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mapModelObj.cookDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MapTableViewCell
        
        cell.categoryLabelOutlet.text = mapModelObj.cookDataArray[indexPath.row]["name"].stringValue
        cell.cookCollectionviewOutlet.tag = indexPath.row
        cell.collectionviewheightConstraint.constant = UIScreen.main.bounds.size.height * 0.36
        
        cell.cookCollectionviewOutlet.dataSource = self
        cell.cookCollectionviewOutlet.delegate = self
        cell.cookCollectionviewOutlet.reloadData()
        
        return cell
    }
    
}




extension MapVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mapModelObj.CooksDealWithCategories[collectionView.tag].count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CookCollectionViewCell
        
        cell?.cookImageview.contentMode = .scaleAspectFill
        cell?.cookImageview.sd_setImage(with: URL(string: mapModelObj.CooksDealWithCategories[collectionView.tag][indexPath.row]["Profile"]["MediaObjects"][0][IMAGE_URL_KEY].stringValue), placeholderImage:UIImage(named: "profilePlaceholder"), options: .refreshCached)
        cell?.likeButtonOutlet.tag = (((collectionView.tag + 1) * 10) + indexPath.row)
        cell?.recipeNameOutlet.text = mapModelObj.CooksDealWithCategories[collectionView.tag][indexPath.row]["Profile"]["fullName"].stringValue
        
        
        //Rating
        cell?.ratingViewOutlet.halfRatings = true
        cell?.ratingViewOutlet.rating = mapModelObj.CooksDealWithCategories[collectionView.tag][indexPath.row]["Profile"]["rating"].floatValue
        
        
        //Favourite
        if mapModelObj.CooksDealWithCategories[collectionView.tag][indexPath.row]["favorite"].boolValue {
            cell?.likeButtonOutlet.tintColor = #colorLiteral(red: 0.8859999776, green: 0.172999993, blue: 0.1689999998, alpha: 1)
        } else {
            cell?.likeButtonOutlet.tintColor = #colorLiteral(red: 0.8196078431, green: 0.8196078431, blue: 0.8196078431, alpha: 1)
        }
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       return CGSize(width: UIScreen.main.bounds.size.width * 0.375 , height: collectionView.bounds.size.height);
    }
    
    //mapToRecipeDetailsId
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("collection view tag....\(collectionView.tag)")
        print("collection view array -----\(mapModelObj.CooksDealWithCategories[collectionView.tag ][indexPath.row])")
        profileId = mapModelObj.CooksDealWithCategories[collectionView.tag][indexPath.row]["Profile"][ID_KEY].stringValue
        self.performSegue(withIdentifier: "mapVcToProfileVC", sender: nil)
    }

}


