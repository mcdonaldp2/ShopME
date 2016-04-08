//
//  recentOrderViewController.swift
//  ShopME
//
//  Created by Paul McDonald  on 3/1/16.
//  Copyright © 2016 Paul McDonald . All rights reserved.
//

import UIKit
import CoreData

class recentOrderViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {

    
    //initialization for fetchedResultsController
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let ordersFetchRequest = NSFetchRequest(entityName: "RecentOrders")
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        ordersFetchRequest.sortDescriptors = [sortDescriptor]
        ordersFetchRequest.fetchLimit = 10
        
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let frc = NSFetchedResultsController(
            fetchRequest: ordersFetchRequest,
            managedObjectContext: appDelegate.managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        frc.delegate = self
        
        return frc
    }()

    
    @IBOutlet weak var recentOrderTableView: UITableView!
    
    //everytime view loads, fetchedResultsController performs fetch
    //button on right side of nav bar set to editButtonItem
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        do {
        try fetchedResultsController.performFetch()
        } catch{
            print("error")
        }
        
        navigationItem.rightBarButtonItem = self.editButtonItem()
        
    }
    
    //gets number of recent orders
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fetchedResultsController.fetchedObjects!.count
    }
    
    //creates cell for each recent order
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("recentOrderCell") as! recentOrderTableCell
        
        let order = fetchedResultsController.objectAtIndexPath(indexPath) as! RecentOrders
        
        
        let priceFormatter = NSNumberFormatter()
        priceFormatter.minimumFractionDigits = 2
        priceFormatter.maximumFractionDigits = 2
        priceFormatter.minimumIntegerDigits = 1
        
        cell.itemAndPriceLabel.text = String(order.quantity!) + " items ($" + priceFormatter.stringFromNumber(order.price!)! + ")"
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.FullStyle
        formatter.timeStyle = .ShortStyle
    
        cell.dateLabel.text = formatter.stringFromDate(order.date!)
        
        
        
        return cell
    }
    
    // makes each cell editable
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    
    //handles the deletion of the recent order cell and updates the coredata
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == .Delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            let order = self.fetchedResultsController.objectAtIndexPath(indexPath) as! NSManagedObject
            self.fetchedResultsController.managedObjectContext.deleteObject(order)
            do {
            try self.fetchedResultsController.managedObjectContext.save()
            try self.fetchedResultsController.performFetch()
            } catch {
                print("error")
            }
            self.recentOrderTableView.reloadData()
        }
    }
    
    //sets editing bool on the editButtonItem click
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.recentOrderTableView.setEditing(editing, animated: animated)
    }

}
