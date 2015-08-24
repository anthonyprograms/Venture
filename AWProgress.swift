//
//  AWProgress.swift
//  Venture
//
//  Created by Anthony Williams on 6/29/15.
//  Copyright (c) 2015 Anthony Williams. All rights reserved.
//

import UIKit

class AWProgress: UIView {

    var load = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.borderColor = UIColor.blueColor().CGColor
        self.layer.borderWidth = 1.0
        
        load.frame = CGRectMake(0, 2, 0, self.frame.size.height-4)
        load.backgroundColor = UIColor.blueColor()
        self.addSubview(load)
        
//        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
//        let delayTime2 = dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC)))
//        let delayTime3 = dispatch_time(DISPATCH_TIME_NOW, Int64(3 * Double(NSEC_PER_SEC)))
//        let delayTime4 = dispatch_time(DISPATCH_TIME_NOW, Int64(4 * Double(NSEC_PER_SEC)))
//        dispatch_after(delayTime, dispatch_get_main_queue()) {
//            self.setQuarter()
//        }
//        
//        dispatch_after(delayTime2, dispatch_get_main_queue()) {
//            self.setTwoThirds()
//        }
//        
//        dispatch_after(delayTime3, dispatch_get_main_queue()) {
//            self.setThreeQuarters()
//        }
//        
//        dispatch_after(delayTime4, dispatch_get_main_queue()) {
//            self.setFull()
//        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setQuarter(){
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.load.frame = CGRectMake(2, 2, self.frame.size.width/4-3, self.frame.size.height-4)
        })
    }
    
    func setTwoThirds(){
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.load.frame = CGRectMake(2, 2, 2*self.frame.size.width/3-3, self.frame.size.height-4)
        })
    }
    
    func setThreeQuarters(){
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.load.frame = CGRectMake(2, 2, 3*self.frame.size.width/4-3, self.frame.size.height-4)
        })
    }
    
    func setFull(){
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.load.frame = CGRectMake(2, 2, self.frame.size.width-3, self.frame.size.height-4)
        })
    }
    
    func setComplete(){
        
    }


}
