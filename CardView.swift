//
//  CardView.swift
//  Venture
//
//  Created by Anthony Williams on 6/21/15.
//  Copyright (c) 2015 Anthony Williams. All rights reserved.
//

import UIKit

class CardView: UIView {
    
    var placeImage = UIImageView()
    
    override init(frame: CGRect){
        super.init(frame: frame)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCard(name: NSString, rating: NSString, price: NSString, distance: NSString){
        var nameLabel = UILabel(frame: CGRectMake(0, 0, self.frame.size.width, 30))
        nameLabel.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2)
        nameLabel.textAlignment = .Center
        nameLabel.text = "\(name)"
        nameLabel.textColor = UIColor.blackColor()
        nameLabel.backgroundColor = UIColor.clearColor()
        nameLabel.font = UIFont (name: "HelveticaNeue-Medium", size: 22)
        self.addSubview(nameLabel)
        
        var ratingLabel = UILabel(frame: CGRectMake(0, 0, self.frame.size.width, 30))
        ratingLabel.center = CGPointMake(self.frame.size.width/2, nameLabel.frame.origin.y+40)
        ratingLabel.textAlignment = .Center
        if(rating.isEqualToString("")){
            ratingLabel.text = "Rating: Unknown"
        } else{
            ratingLabel.text = "Rating: \(rating)/5"
        }
        ratingLabel.textColor = UIColor.blackColor()
        ratingLabel.font = UIFont (name: "HelveticaNeue-Light", size: 15)
        ratingLabel.backgroundColor = UIColor.clearColor()
        self.addSubview(ratingLabel)
        
        var priceLabel = UILabel(frame: CGRectMake(0, 0, self.frame.size.width, 30))
        priceLabel.center = CGPointMake(self.frame.size.width/2, ratingLabel.frame.origin.y+40)
        priceLabel.textAlignment = .Center
        if(price.isEqualToString("")){
            priceLabel.text = "Price: Unknown"
        } else{
            priceLabel.text = "Price: \(price)/5"
        }
        priceLabel.textColor = UIColor.blackColor()
        priceLabel.font = UIFont (name: "HelveticaNeue-Light", size: 15)
        priceLabel.backgroundColor = UIColor.clearColor()
        self.addSubview(priceLabel)
        
        var distanceLabel = UILabel(frame: CGRectMake(0, 0, self.frame.size.width, 60))
        distanceLabel.center = CGPointMake(self.frame.size.width/2, ratingLabel.frame.origin.y+60)
        distanceLabel.textAlignment = .Center
        distanceLabel.text = "\(distance) Miles"
        distanceLabel.textColor = UIColor.blackColor()
        distanceLabel.font = UIFont(name: "HelveticaNeue-Light", size: 17)
        distanceLabel.backgroundColor = UIColor.clearColor()
        self.addSubview(distanceLabel)
        
        placeImage = UIImageView(frame: CGRectMake(0, 0, self.frame.size.width/3+20, self.frame.size.width/3+20))
        placeImage.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/4)
        placeImage.layer.masksToBounds = true
        placeImage.layer.cornerRadius = 10.0
        placeImage.layer.borderWidth = 1.0
        placeImage.layer.borderColor = UIColor.blackColor().CGColor
        placeImage.image = UIImage(named: "VentureLogo")
        self.addSubview(placeImage)
    }
    
    func setupCardImage(data: NSData){
        placeImage.image = UIImage(data: data)
    }
}
