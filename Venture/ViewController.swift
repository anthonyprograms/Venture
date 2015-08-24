//
//  ViewController.swift
//  Venture
//
//  Created by Anthony Williams on 6/21/15.
//  Copyright (c) 2015 Anthony Williams. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import SwiftyJSON
import CoreData

class ViewController: UIViewController, CLLocationManagerDelegate {
    var activityIndicator = UIActivityIndicatorView()
    var APIKey = "AIzaSyDCSnhS1bZXkjTYPV-Zao6YT2gDnLvZKMc"
//    var APIKey = "AIzaSyCExIeMne5yL1N4gLyHsV4GtlYD5-MXMe4"
    
    // Location
    var locationManager = CLLocationManager()
    var latitude = NSString()
    var longitude = NSString()
    
    // Data Arrays
    var deckArray = NSMutableArray()
    var nameArray = NSMutableArray()
    var ratingArray = NSMutableArray()
    var priceLevelArray = NSMutableArray()
    var photoArray = NSMutableArray()
    var latitudeArray = NSMutableArray()
    var longitudeArray = NSMutableArray()
    var addressArray = NSMutableArray()
    var distanceArray = NSMutableArray()
    
    // View Buttons
    var likeButton = UIButton()
    var dislikeButton = UIButton()
    
    // Category
    var keyword = NSString()
    var radius = Int()
    
    // Core Data
    var Likes = [NSManagedObject]()
    
    override func viewDidLoad() {
//        super.viewDidLoad()
        
        self.title = "Venture"
        self.view.backgroundColor = UIColor.whiteColor()
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0, green: 0.5, blue: 0.8, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.setupButtons()
        
        
        var likesViewButton = UIBarButtonItem(title: "❤︎", style: UIBarButtonItemStyle.Plain, target: self, action: "likesViewButtonPressed")
        self.navigationItem.rightBarButtonItem = likesViewButton
        
        self.activityIndicator.activityIndicatorViewStyle = .Gray
        self.activityIndicator.frame = CGRectMake(0, 0, 100, 100);
        self.activityIndicator.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2-30)
        self.activityIndicator.startAnimating()
        self.view.addSubview(self.activityIndicator)
        
        if (CLLocationManager.locationServicesEnabled()) {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.startUpdatingLocation()
        } else {
            var alert = UIAlertView(title: "Location", message: "Location must be enabled for this application to work", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        self.locationManager.stopUpdatingLocation()
        
        var locationArray = locations as NSArray
        var locationObj = locationArray.lastObject as! CLLocation
        var coord = locationObj.coordinate
        latitude = NSString(format: "%f", coord.latitude)
        longitude = NSString(format: "%f", coord.longitude)
        
        self.accessPlaces()
    }
    
    func accessPlaces(){
        var endpoint = NSURL(string: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(latitude),\(longitude)&radius=\(radius)&keyword=\(keyword)&opennow=true&key=\(APIKey)")
        var data = NSData(contentsOfURL: endpoint!)
        
        if(self.nameArray.count < 1){
            let json = JSON(data: data!)
            let results = json["results"]
            println(results)
            
            if results[0] == nil {
                var alert = UIAlertController(title: "Sorry", message: "Venture only searches things that are currently open. This search has no results, try a new search or larger distance", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            
            for var i = 0; i < results.count; i++ {
                self.nameArray.addObject(results[i]["name"].stringValue)
                self.ratingArray.addObject(results[i]["rating"].stringValue)
                self.priceLevelArray.addObject(results[i]["price_level"].stringValue)
                self.photoArray.addObject(results[i]["photos"][0]["photo_reference"].stringValue)
                self.latitudeArray.addObject(results[i]["geometry"]["location"]["lat"].stringValue)
                self.longitudeArray.addObject(results[i]["geometry"]["location"]["lng"].stringValue)
                self.getAddressFromCoordinates(self.latitudeArray[i].doubleValue, longitude: self.longitudeArray[i].doubleValue)
                self.distanceArray.addObject(self.getDistanceFromLocation(self.latitude.doubleValue, longitude1: self.longitude.doubleValue, latitude2: self.latitudeArray[i].doubleValue, longitude2: self.longitudeArray[i].doubleValue))
            }
            
            self.createDeck(self.nameArray.count)
        }
    }
    
    // MARK: UI
    
    func setupButtons(){
        self.likeButton.frame = CGRectMake(0, 0, self.view.frame.size.width/4, self.view.frame.size.width/4)
        self.likeButton.center = CGPointMake(3*self.view.frame.size.width/4-20, self.view.frame.size.height-100)
        self.likeButton.setTitle("✓", forState: .Normal)
        self.likeButton.backgroundColor = UIColor.greenColor()
        self.likeButton.titleLabel?.font = UIFont (name: "HelveticaNeue-UltraLight", size: 45)
        self.likeButton.layer.cornerRadius = self.likeButton.frame.size.height/2
        self.likeButton.layer.masksToBounds = true
        self.likeButton.addTarget(self, action: "likeButtonPressed", forControlEvents: .TouchUpInside)
        self.view.addSubview(self.likeButton)
        
        self.dislikeButton.frame = CGRectMake(0, 0, self.view.frame.size.width/4, self.view.frame.size.width/4)
        self.dislikeButton.center = CGPointMake(self.view.frame.size.width/4+20, self.view.frame.size.height-100)
        self.dislikeButton.setTitle("✕", forState: .Normal)
        self.dislikeButton.titleLabel?.font = UIFont (name: "HelveticaNeue-UltraLight", size: 45)
        self.dislikeButton.backgroundColor = UIColor.redColor()
        self.dislikeButton.layer.cornerRadius = self.dislikeButton.frame.size.height/2
        self.dislikeButton.layer.masksToBounds = true
        self.dislikeButton.addTarget(self, action: "dislikeButtonPressed", forControlEvents: .TouchUpInside)
        self.view.addSubview(self.dislikeButton)
    }
    
    func likeButtonPressed(){
        if(self.deckArray.count > 0){
            saveLike(self.nameArray[self.deckArray.count-1] as! String, rating: self.ratingArray[self.deckArray.count-1] as! String, price: self.priceLevelArray[self.deckArray.count-1] as! String, lat: self.latitudeArray[self.deckArray.count-1] as! String, lng: self.longitudeArray[self.deckArray.count-1] as! String, address: self.addressArray[self.deckArray.count-1] as! String)
            
            if self.deckArray.count == 0 {
                labelForEmptyDeck()
            }
            
            cardAnimation(self.likeButton, view: self.deckArray[self.deckArray.count-1] as! UIView, yPosition: self.deckArray[self.deckArray.count-1].frame.origin.y)
        }
    }
    
    func dislikeButtonPressed(){
        if(self.deckArray.count > 0){
            cardAnimation(self.dislikeButton, view: self.deckArray[self.deckArray.count-1] as! UIView, yPosition: self.deckArray[self.deckArray.count-1].frame.origin.y)
            
            if self.deckArray.count == 0 {
                labelForEmptyDeck()
            }
        }
    }
    
    func likesViewButtonPressed(){
        let likesViewController = LikesViewController()
        self.navigationController?.pushViewController(likesViewController, animated: true)
    }
    
    // MARK: Animations
    
    func cardAnimation(button: UIButton, view: UIView, yPosition: CGFloat){
        var xPosition = CGFloat(3*self.view.frame.size.width/2)
        
        if(button == self.dislikeButton){
            xPosition = CGFloat(-self.view.frame.size.width/2)
        }
        
        UIView.animateWithDuration(NSTimeInterval(0.3), delay: NSTimeInterval(0), options: UIViewAnimationOptions.CurveEaseInOut,
            animations: {
                (view as UIView!).center = CGPointMake(xPosition, yPosition)
                return
            },
            completion:  { (finished: Bool) in
                self.deckArray[self.deckArray.count-1].removeFromSuperview()
                
                if(button == self.likeButton){
                    let inviteViewController = InviteViewController()
                    inviteViewController.nameOfPlace = "\(self.nameArray[self.deckArray.count-1])"
                    inviteViewController.ratingOfPlace = "\(self.ratingArray[self.deckArray.count-1])"
                    inviteViewController.priceOfPlace = "\(self.priceLevelArray[self.deckArray.count-1])"
                    inviteViewController.latitudeOfPlace = "\(self.latitudeArray[self.deckArray.count-1])"
                    inviteViewController.longitudeOfPlace = "\(self.longitudeArray[self.deckArray.count-1])"
                    inviteViewController.addressOfPlace = "\(self.addressArray[self.deckArray.count-1])"
                    self.navigationController?.pushViewController(inviteViewController, animated: true)
                }
                
                self.deckArray.removeObjectAtIndex(self.deckArray.count-1)
            }
        )
    }
    
    // MARK: Deck
    
    func getAddressFromCoordinates(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        // Get address from coordinates
        var geocoder = CLGeocoder()
        var location = CLLocation(latitude: latitude, longitude: longitude)
        
        geocoder.reverseGeocodeLocation(location!, completionHandler: { (placemark, error) -> Void in
            var place = CLPlacemark(placemark: placemark[0] as! CLPlacemark)
            self.addressArray.addObject(place.addressDictionary["FormattedAddressLines"]!.componentsJoinedByString(", "))
        })
        
    }
    
    func createDeck(cards: Int){
        self.activityIndicator.stopAnimating()
        
        let shadowView = UIView(frame: CGRectMake(25, 70, self.view.frame.size.width-50, self.view.frame.size.height/2+20))
        
        for var i = 0; i < cards; i++ {
            let card = CardView(frame: CGRectMake(30, 80, self.view.frame.size.width-60, self.view.frame.size.height/2))
            var pan = UIPanGestureRecognizer(target: self, action: "panGestureOnCard:")
            card.addGestureRecognizer(pan)
            card.backgroundColor = UIColor.whiteColor()
            card.layer.cornerRadius = 25.0
            card.layer.borderWidth = 1.0
            card.layer.borderColor = UIColor( red: CGFloat(0), green: CGFloat(0.5), blue: CGFloat(0.7), alpha: CGFloat(1.0)).CGColor
            card.layer.masksToBounds = true
            var pictureAPICall = NSURL(string: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=\(photoArray[i])&key=\(APIKey)")
            var pictureData = NSData(contentsOfURL: pictureAPICall!)
            card.setupCard(self.nameArray[i] as! NSString, rating: self.ratingArray[i] as! NSString, price: self.priceLevelArray[i] as! NSString, distance: self.distanceArray[i] as! NSString)
            if(pictureData != nil){
                card.setupCardImage(pictureData!)
            }
            card.addSubview(shadowView)
            self.view.addSubview(card)
            self.deckArray.addObject(card)
        }
    }
    
    func labelForEmptyDeck(){
        var emptyLabel = UILabel(frame: CGRectMake(30, 80, self.view.frame.size.width-60, self.view.frame.size.height/2))
        emptyLabel.text = "There are no more cards left, try a new category or a larger distance"
        emptyLabel.textColor = UIColor.blackColor()
        emptyLabel.font = UIFont(name: "HelveticaNeue", size: 25)
        emptyLabel.numberOfLines = 4
        self.view.addSubview(emptyLabel)
    }
    
    // MARK: Core Data
    
    func saveLike(name: String, rating: String, price: String, lat: String, lng: String, address: String){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        let entity = NSEntityDescription.entityForName("Like", inManagedObjectContext: managedContext)
        
        let like = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        like.setValue(name, forKey: "name")
        like.setValue(rating, forKey: "rating")
        like.setValue(price, forKey: "price")
        like.setValue(lat, forKey: "lat")
        like.setValue(lng, forKey: "lng")
        like.setValue(address, forKey: "address")
        
        var error: NSError?
        if !managedContext.save(&error){
            println("Could not save \(error), \(error?.userInfo)")
        }
        
        Likes.append(like)
    }
    
    // MARK: Pan Gesture for Card
    
    func panGestureOnCard(gestureRecognizer: UIPanGestureRecognizer){
        if gestureRecognizer.state == UIGestureRecognizerState.Began || gestureRecognizer.state == UIGestureRecognizerState.Changed {
            
            let translation = gestureRecognizer.translationInView(self.view)
            
            gestureRecognizer.view!.center = CGPointMake(gestureRecognizer.view!.center.x + translation.x, gestureRecognizer.view!.center.y + translation.y)
            gestureRecognizer.setTranslation(CGPointMake(0,0), inView: self.view)
        }
        
        if gestureRecognizer.state == UIGestureRecognizerState.Ended {
            if gestureRecognizer.view!.center.x <= self.view.frame.size.width/5 {
                dislikeButtonPressed()
            }
            else if gestureRecognizer.view!.center.x >= 4*self.view.frame.size.width/5 {
                likeButtonPressed()
            }
            else {
                UIView.animateWithDuration(NSTimeInterval(0.2), animations: { () -> Void in
                    gestureRecognizer.view!.frame = CGRectMake(30, 80, self.view.frame.size.width-60, self.view.frame.size.height/2)
                })
            }
        }
    }
    
    // MARK: Latitude/Longitude to Distance
    
    func getDistanceFromLocation(latitude1: CLLocationDegrees, longitude1: CLLocationDegrees, latitude2: CLLocationDegrees, longitude2: CLLocationDegrees) -> String{
        var location1 = CLLocation(latitude: latitude1, longitude: longitude1)
        var location2 = CLLocation(latitude: latitude2, longitude: longitude2)
        var distance = location1.distanceFromLocation(location2) * 0.000621371
        var distanceString : String = String(format: "%.2f", distance)
        
        return distanceString
    }
}

