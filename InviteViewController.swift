//
//  InviteViewController.swift
//  Venture
//
//  Created by Anthony Williams on 6/21/15.
//  Copyright (c) 2015 Anthony Williams. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class InviteViewController: UIViewController {
    
    // Details of selection
    var nameOfPlace = NSString()
    var latitudeOfPlace = NSString()
    var longitudeOfPlace = NSString()
    var priceOfPlace = NSString()
    var ratingOfPlace = NSString()
    var addressOfPlace = NSString()
    
    // Buttons
    var inviteButton = UIButton()
    var facebookButton = UIButton()
    var mapButton = UIButton()
    
    override func viewDidLoad() {
//        super.viewDidLoad()
        
        self.title = "Invite"

        self.view.backgroundColor = UIColor.whiteColor()
        
        // Name
        var nameLabel = UILabel(frame: CGRectMake(0, 60, self.view.frame.size.width, 60))
        nameLabel.text = "\(nameOfPlace)"
        nameLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 25)
        nameLabel.textAlignment = .Center
        nameLabel.backgroundColor = UIColor.clearColor()
        nameLabel.numberOfLines = 2
        self.view.addSubview(nameLabel)
        
        // Rating
        var ratingLabel = UILabel(frame: CGRectMake(0, 120, self.view.frame.size.width, 30))
        if(ratingOfPlace.isEqualToString("")){
            ratingLabel.text = "Rating: Unknown"
        } else{
            ratingLabel.text = "Rating: \(ratingOfPlace)/5"
        }
        ratingLabel.font = UIFont(name: "HelveticaNeue-UltraLight", size: 20)
        ratingLabel.textAlignment = .Center
        ratingLabel.backgroundColor = UIColor.clearColor()
        self.view.addSubview(ratingLabel)

        // Price
        var priceLabel = UILabel(frame: CGRectMake(0, 150, self.view.frame.size.width, 30))
        if(priceOfPlace.isEqualToString("")){
            priceLabel.text = "Price: Unknown"
        } else{
            priceLabel.text = "Price: \(priceOfPlace)/5"
        }
        priceLabel.font = UIFont(name: "HelveticaNeue-UltraLight", size: 20)
        priceLabel.textAlignment = .Center
        priceLabel.backgroundColor = UIColor.clearColor()
        self.view.addSubview(priceLabel)
        
        // Address
        var addressLabel = UILabel(frame: CGRectMake(0, 180, self.view.frame.size.width, self.view.frame.size.height/2-180))
        addressLabel.text = "\(addressOfPlace)"
        addressLabel.font = UIFont(name: "HelveticaNeue-UltraLight", size: 23)
        addressLabel.textAlignment = .Center
        addressLabel.numberOfLines = 3
        addressLabel.backgroundColor = UIColor.clearColor()
        self.view.addSubview(addressLabel)
        
        // Invite friends from contacts
        self.inviteButton.frame = CGRectMake(0, self.view.frame.size.height/2, self.view.frame.size.width, self.view.frame.size.height/4)
        self.inviteButton.setTitle("Invite", forState: .Normal)
        self.inviteButton.backgroundColor = UIColor.blueColor()
        self.inviteButton.titleLabel?.font = UIFont (name: "HelveticaNeue-UltraLight", size: 70)
        self.inviteButton.addTarget(self, action: "contactsButtonPressed", forControlEvents: .TouchUpInside)
        self.view.addSubview(self.inviteButton)
        
        // Map
        self.mapButton.frame = CGRectMake(0, 3*self.view.frame.size.height/4, self.view.frame.size.width, self.view.frame.size.height/4)
        self.mapButton.setTitle("Let's Go", forState: .Normal)
        self.mapButton.backgroundColor = UIColor.purpleColor()
        self.mapButton.titleLabel?.font = UIFont (name: "HelveticaNeue-UltraLight", size: 70)
        self.mapButton.addTarget(self, action: "mapButtonPressed", forControlEvents: .TouchUpInside)
        self.view.addSubview(self.mapButton)
    }

    func contactsButtonPressed(){
        var share = ["Venture App Invitation: \(nameOfPlace). Rating: \(ratingOfPlace)/5. Price: \(priceOfPlace)/5. \(addressOfPlace)"]

        let activityViewController = UIActivityViewController(activityItems: share, applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivityTypeSaveToCameraRoll, UIActivityTypePostToVimeo]
        self.presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    func mapButtonPressed() {
        
        var latitute : CLLocationDegrees =  self.latitudeOfPlace.doubleValue
        var longitute : CLLocationDegrees =  self.longitudeOfPlace.doubleValue
        
        let regionDistance:CLLocationDistance = 10000
        var coordinates = CLLocationCoordinate2DMake(latitute, longitute)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        var options = [
            MKLaunchOptionsMapCenterKey: NSValue(MKCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(MKCoordinateSpan: regionSpan.span)
        ]
        var placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        var mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "\(self.nameOfPlace)"
        mapItem.openInMapsWithLaunchOptions(options)
        
    }
}
