//
//  CategoryViewController.swift
//  Venture
//
//  Created by Anthony Williams on 6/21/15.
//  Copyright (c) 2015 Anthony Williams. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var distanceLabel = UILabel()
    var distanceSlider = UISlider()
    var distanceValue: Float = Float(3.10)
    
    var categoryArray = NSArray()
    
    var tableView = UITableView()
    
    
    override func viewDidLoad() {
//        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.blackColor()
        
        var image = UIImage(named: "VentureLogo")
        var logoImageView = UIImageView(frame: CGRectMake(0, 0, self.view.frame.size.width-120, self.view.frame.size.height/4))
        logoImageView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/4)
        logoImageView.image = image
        self.view.addSubview(logoImageView)
        
        // Meters Away: Label
        distanceLabel.frame = CGRectMake(0, self.view.frame.size.height/2, self.view.frame.size.width, 30)
        distanceLabel.textAlignment = .Center
        distanceLabel.text = "3.10 Miles"
        distanceLabel.textColor = UIColor.whiteColor()
        distanceLabel.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        distanceLabel.backgroundColor = UIColor.clearColor()
        self.view.addSubview(distanceLabel)
        
        // Distance
        distanceSlider.frame = CGRectMake(20, distanceLabel.frame.origin.y+40, self.view.frame.size.width-40, 30)
        distanceSlider.minimumValue = 500.0 * 0.000621371
        distanceSlider.maximumValue = 10000.0 * 0.000621371
        distanceSlider.continuous = true
        distanceSlider.value = 5000.0 * 0.000621371
        distanceSlider.backgroundColor = UIColor.clearColor()
        distanceSlider.setThumbImage(UIImage(named: "SliderLogo"), forState: .Normal)
        distanceSlider.addTarget(self, action: "sliderAction:", forControlEvents: .ValueChanged)
        self.view.addSubview(distanceSlider)
        
        // Initialize array with preset categories
        categoryArray = ["Amusement", "Bar", "Beach", "Coffee", "Desserts", "Food", "Museum", "Park", "Shopping"]
        
        self.tableView.frame = CGRectMake(0, distanceSlider.frame.origin.y+50, self.view.frame.size.width, self.view.frame.size.height/3)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.bounces = false
        self.tableView.rowHeight = 50
        self.tableView.separatorColor = UIColor( red: CGFloat(190/255.0), green: CGFloat(50/255.0), blue: CGFloat(0/255.0), alpha: CGFloat(0.7))
        self.tableView.backgroundColor = UIColor.clearColor()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(self.tableView)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    
    func sliderAction(sender: UISlider){
        distanceValue = sender.value
        var distanceString : String = String(format: "%.2f", distanceValue)
        distanceLabel.text = "\(distanceString) Miles"
    }
    
    // MARK: Table View Data Source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        
        cell.selectionStyle = .None
        
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.textLabel?.textAlignment = .Center
        cell.backgroundColor = UIColor( red: CGFloat(0), green: CGFloat(0.5), blue: CGFloat(0.7), alpha: CGFloat(1.0))
        cell.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 22)
        cell.textLabel?.text = categoryArray[indexPath.row] as? String
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let viewController = ViewController()
        viewController.keyword = categoryArray[indexPath.row] as! NSString
        viewController.radius = Int(distanceValue/0.000621371)
        var cell = tableView.cellForRowAtIndexPath(indexPath)
        
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            cell!.center = CGPointMake(2*self.view.frame.size.width, cell!.frame.origin.y+25)
        }) { (finished: Bool) -> Void in
            self.navigationController?.pushViewController(viewController, animated: true)
            self.tableView.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        //1. Setup the CATransform3D structure
        var rotation = CATransform3D()
        var angle = CGFloat((90*M_PI)/180)
        var x = CGFloat(0)
        var y = CGFloat(0.7)
        var z = CGFloat(0.4)
        rotation = CATransform3DMakeRotation(angle, x, y, z)
        rotation.m34 = -1.0/600
        
        //2. Define the initial state (Before the animation)
        cell.layer.shadowColor = UIColor.blackColor().CGColor
        cell.layer.shadowOffset = CGSizeMake(10, 10)
        cell.alpha = 0
        cell.layer.transform = rotation
        cell.layer.anchorPoint = CGPointMake(0, 0.5)
        
        //3. Define the final state (After the animation) and commit the animation
        UIView.beginAnimations("rotation", context: nil)
        UIView.setAnimationDuration(0.4)
        cell.layer.transform = CATransform3DIdentity
        cell.alpha = 1
        cell.layer.shadowOffset = CGSizeMake(0, 0)
        UIView.commitAnimations()
    }
}
