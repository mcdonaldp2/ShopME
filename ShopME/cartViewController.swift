//
//  cartViewController.swift
//  ShopME
//
//  Created by Paul McDonald  on 2/28/16.
//  Copyright © 2016 Paul McDonald . All rights reserved.
//

import UIKit
import CoreData

class cartViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var cartTableView: UITableView!

    var items = [Items]()
    var context: NSManagedObjectContext!
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let itemsFetchRequest = NSFetchRequest(entityName: "Items")
        let sortDescriptor = NSSortDescriptor(key: "category", ascending: true)
        itemsFetchRequest.sortDescriptors = [sortDescriptor]
        
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let frc = NSFetchedResultsController(
            fetchRequest: itemsFetchRequest,
            managedObjectContext: appDelegate.managedObjectContext,
            sectionNameKeyPath: "category",
            cacheName: nil)
        
        frc.delegate = self
        
        return frc
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("An error occurred")
        }
        // Do any additional setup after loading the view.
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let sections = fetchedResultsController.sections {
            
            return sections.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if let sections = fetchedResultsController.sections {
            let currentSection = sections[section]
            
            return currentSection.numberOfObjects
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("tableCell") as! cartTableCell
        
        let item = fetchedResultsController.objectAtIndexPath(indexPath) as! Items
        
        
        cell.increaseQuantityButton.myCell = cell
        cell.increaseQuantityButton.myTable = self.cartTableView
        
        cell.decreaseQuantityButton.myCell = cell
        cell.decreaseQuantityButton.myTable = self.cartTableView
        cell.titleLabel.text = item.title
        
       // print(cell.titleLabel.text)
        
        let formatter = NSNumberFormatter()
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.minimumIntegerDigits = 1
        
        
        cell.priceLabel.text = formatter.stringFromNumber(Double(item.price!) * Double(item.quantity!))
        
        cell.quantityLabel.text = String(item.quantity!)
        
        cell.setItemPrice(Double(item.price!))
        
        
        switch item.category! {
        case "Grocery":
            cell.tag = 0
        case "Clothing":
            cell.tag = 1
        case "Movies":
            cell.tag = 2
        case "Garden":
            cell.tag = 3
        case "Electronics":
            cell.tag = 4
        case "Books":
            cell.tag = 5
        case "Appliances":
            cell.tag = 6
        case "Toys":
            cell.tag = 7
        default:
            break
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let sections = fetchedResultsController.sections {
            let currentSection = sections[section]
            return currentSection.name
        }
        
        return nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
