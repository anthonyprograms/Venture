//
//  LikesViewController.swift
//  Venture
//
//  Created by Anthony Williams on 6/22/15.
//  Copyright (c) 2015 Anthony Williams. All rights reserved.
//

import UIKit
import CoreData

class LikesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView = UITableView()
    var Likes = [NSManagedObject]()
    var likesArray = NSMutableArray()

    override func viewDidLoad() {
//        super.viewDidLoad()
        
        self.loadLikes()
        
        self.title = "Likes"
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = UIColor.clearColor()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(self.tableView)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.likesArray.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: cellIdentifier)
            
//            cell!.contentView.backgroundColor = UIColor.clearColor()
//            var roundedCornerView = UIView(frame: CGRectMake(0, 100, self.view.frame.size.width, 10))
//            roundedCornerView.backgroundColor = UIColor.blackColor()
//            roundedCornerView.layer.masksToBounds = true
//            roundedCornerView.layer.shadowOffset = CGSizeMake(-1, 1)
//            roundedCornerView.layer.shadowOpacity = 0.5
//            cell!.contentView.addSubview(roundedCornerView)
//            cell!.contentView.sendSubviewToBack(roundedCornerView)
        }
                
        cell!.textLabel?.text = self.likesArray[indexPath.row].valueForKey("name") as? String
        cell!.textLabel?.textColor = UIColor(red: 0, green: 0.5, blue: 0.8, alpha: 1.0)
        cell!.textLabel?.numberOfLines = 2
        cell!.textLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 20)
        cell!.textLabel?.textAlignment = .Center
        
        cell!.detailTextLabel?.text = self.likesArray[indexPath.row].valueForKey("address") as? String
        cell!.detailTextLabel?.textColor = UIColor.blackColor()
        cell!.detailTextLabel?.numberOfLines = 4
        cell!.detailTextLabel?.font = UIFont(name: "HelveticaNeue-light", size: 12)
        cell!.detailTextLabel?.textAlignment = .Center
        
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let inviteViewController = InviteViewController()
        inviteViewController.nameOfPlace = self.likesArray[indexPath.row].valueForKey("name") as! String
        inviteViewController.ratingOfPlace = self.likesArray[indexPath.row].valueForKey("rating") as! String
        inviteViewController.priceOfPlace = self.likesArray[indexPath.row].valueForKey("price") as! String
        inviteViewController.latitudeOfPlace = self.likesArray[indexPath.row].valueForKey("lat") as! String
        inviteViewController.longitudeOfPlace = self.likesArray[indexPath.row].valueForKey("lng") as! String
        inviteViewController.addressOfPlace = self.likesArray[indexPath.row].valueForKey("address") as! String
        self.navigationController?.pushViewController(inviteViewController, animated: true)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        deleteLike(self.likesArray[indexPath.row].valueForKey("name") as! String)
        self.likesArray.removeObjectAtIndex(indexPath.row)
        self.tableView.reloadData()
    }
    
    func loadLikes(){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        let request = NSFetchRequest(entityName: "Like")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        
        var error: NSError?
        var result = managedContext.executeFetchRequest(request, error: &error)!
        self.likesArray.addObjectsFromArray(result)
        self.tableView.reloadData()
    }
    
    func deleteLike(name: String){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        let request = NSFetchRequest(entityName: "Like")
        
        var predicate = NSPredicate(format: "name = %@", name)
        request.predicate = predicate
        
        var error: NSError?
        var temp = NSArray(array:managedContext.executeFetchRequest(request, error: &error)!)
        var managedObject: AnyObject = temp[0]
        managedContext.deleteObject(managedObject as! NSManagedObject)
        managedContext.save(&error)
    }
}
