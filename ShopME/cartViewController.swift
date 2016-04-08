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
   
    @IBOutlet weak var homeButton: UIBarButtonItem!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var totalQuantityLabel: UILabel!
    
    var totalPrice: Double!
    var totalQuantity: Int!

    var items = [Items]()
    
    //initialization of the fetchedResultsController
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
    
    //when home button is clicked in navbar an  unwind segue happens
    @IBAction func homeButton(sender: AnyObject) {

        self.performSegueWithIdentifier("unwindToHome", sender: nil)
    }
    
    
    // when the up arrow is pressed in the cell, the quantity of that item is increased and coredata is updated
    @IBAction func increaseQuantity(sender: quantityButton) {
        let button = sender 
        if let superview = button.superview {
            if let cell = superview.superview as? cartTableCell{
                cell.quantityLabel.text = String(Int(cell.quantityLabel.text!)! + 1)
                
                cell.priceLabel.text = String(cell.itemPrice * Double(cell.quantityLabel.text!)!)
                
                let formatter = NSNumberFormatter()
                formatter.minimumFractionDigits = 2
                formatter.maximumFractionDigits = 2
                formatter.minimumIntegerDigits = 1
                
                cell.priceLabel.text = formatter.stringFromNumber(Double(cell.priceLabel.text!)!)
            
                
                getFetchRequestAndUpdate(cell.titleLabel.text!, price: Double(cell.priceLabel.text!)!, category: determineCategory(cell.tag), quantity: Int(cell.quantityLabel.text!)!)
                
            }
        }
        updateTotalQuantityAndPrice()
        
    }
    
    // when the down arrow is pressed in the cell, the quantity of that item is decreased by 1 and coredata is updated
    // if the quantity becomes 0, the item is deleted from the table and from coredata
    @IBAction func decreaseQuantity(sender: quantityButton) {
        let button = sender
        if let superview = button.superview {
            if let cell = superview.superview as? cartTableCell{
                if(Int(cell.quantityLabel.text!) > 0) {
                    cell.quantityLabel.text = String(Int(cell.quantityLabel.text!)! - 1)
                    cell.priceLabel.text = String(cell.itemPrice * Double(cell.quantityLabel.text!)!)
                    
                    let formatter = NSNumberFormatter()
                    formatter.minimumFractionDigits = 2
                    formatter.maximumFractionDigits = 2
                    formatter.minimumIntegerDigits = 1
                    
                    cell.priceLabel.text = formatter.stringFromNumber(Double(cell.priceLabel.text!)!)
                    
                    getFetchRequestAndUpdate(cell.titleLabel.text!, price: Double(cell.priceLabel.text!)!, category: determineCategory(cell.tag), quantity: Int(cell.quantityLabel.text!)!)
                    if (Double(cell.quantityLabel.text!)! == 0) {
                        do {
                            try  fetchedResultsController.performFetch()
                            self.cartTableView.reloadData()
                        } catch {
                            print("error")
                        }
                    }
                }
            }
        }
        updateTotalQuantityAndPrice()
    }
    
    //deletes all objects in the Items entity in coredata, and tableview is reloaded if the total quantity is greater than 0
    @IBAction func emptyCart(sender: AnyObject) {
       
        if (totalQuantity > 0) {
        
        // Create the alert controller
        let alertController = UIAlertController(title: "EMPTY CART", message: "Are you sure you want to empty your cart?", preferredStyle: .Alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) {
            UIAlertAction in

            self.deleteAllData("Items")
            do {
            try self.fetchedResultsController.performFetch()
            self.cartTableView.reloadData()
            } catch {
                print("something went wrong")
            }
            
            self.totalPrice = 0
            self.totalQuantity = 0
            
            self.totalPriceLabel.text = "$" + String(self.totalPrice)
            self.totalQuantityLabel.text = String(self.totalQuantity)
        
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
            UIAlertAction in

        }
        
        // Add the actions
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        // Present the controller
        self.presentViewController(alertController, animated: true, completion: nil)
            
        }
        updateTotalQuantityAndPrice()
    }
    
    // deletes all data from a given entity
    func deleteAllData(entity: String)
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.deleteObject(managedObjectData)
            }
        } catch let error as NSError {
            print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
        }
    }
    
    // deletes all data from Items entity, and the total price and quantity and date of the order is recorded in the RecentOrders entity in CoreData
    @IBAction func buyCart(sender: AnyObject) {
        if (totalQuantity > 0) {
        // Create the alert controller
        let alertController = UIAlertController(title: "PAYMENT", message: "Your card will be charged " + totalPriceLabel.text!+".", preferredStyle: .Alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "Place Order", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext
            let entity =  NSEntityDescription.entityForName("RecentOrders",
                inManagedObjectContext:managedContext)
            
            let item = NSManagedObject(entity: entity!,
                insertIntoManagedObjectContext: managedContext)
            
            let currentDate = NSDate()
            
            item.setValue(self.totalQuantity, forKey: "quantity")
            item.setValue(self.totalPrice, forKey: "price")
            item.setValue(currentDate, forKey: "date")
            
            do {
                try managedContext.save()
                
                //clear the cart since items have been ordered
                self.deleteAllData("Items")
                
                //refetches from coredata and reloads the tableview
                try self.fetchedResultsController.performFetch()
                self.cartTableView.reloadData()

            } catch {
                print("Could not save \(error)")
            }
            
            

            self.performSegueWithIdentifier("unwindToHome", sender: nil)
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
            UIAlertAction in

        }
        
        // Add the actions
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        // Present the controller
        self.presentViewController(alertController, animated: true, completion: nil)
        }
        updateTotalQuantityAndPrice()
    }
    
    //everytime view loads, fetchedResultsController performs fetch,
    // totalPrice, totalQuantity are set to 0
    // labels for both those items are set to 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        do {
            try fetchedResultsController.performFetch()
            cartTableView.reloadData()
        } catch {
            print("An error occurred")
        }
        
        
        updateTotalQuantityAndPrice()
        
        var image = UIImage(named: "homeButton")
        
        image = image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        
        homeButton.image = image
        
    }

    
    // updates coredata  when quantity is changed
    // used in the buyCart and emptyCart methods
    func getFetchRequestAndUpdate(title : String, price: Double, category: String, quantity: Int){
        
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Items")
        let predicate = NSPredicate(format: "title == %@", title)
        fetchRequest.predicate = predicate
        
        do {
            var fetchResults = try managedContext.executeFetchRequest(fetchRequest) as? [Items]
            // if the item already exists in the cart, add 1 to the quantity
            if fetchResults!.count > 0 {
                // update quantity of item in the cart
                let itemToChange = fetchResults![0]
                itemToChange.quantity = quantity
                
                if (itemToChange.quantity == 0) {
                    managedContext.deleteObject(itemToChange)
                }
                try managedContext.save()
                
            } // else add a new item to the entity Items
            else{
                
                let entity =  NSEntityDescription.entityForName("Items",
                    inManagedObjectContext:managedContext)
                
                let item = NSManagedObject(entity: entity!,
                    insertIntoManagedObjectContext: managedContext)
                
                item.setValue(title, forKey: "title")
                item.setValue(price, forKey: "price")
                item.setValue(category, forKey: "category")
                item.setValue(1, forKey: "quantity")
                
                
                do {
                    try managedContext.save()
                } catch {
                    print("Could not save \(error)")
                }
                
            }
        } catch {
            print("error")
        }
        
    }

    // determines the category based on the cells tag
    func determineCategory(tag: Int) -> String {
        switch tag {
        case 0:
            return "Grocery"
        case 1:
            return "Clothing"
        case 2:
            return "Movies"
        case 3:
            return "Garden"
        case 4:
            return "Electronics"
        case 5:
            return "Books"
        case 6:
            return "Appliances"
        case 7:
            return "Toys"
        default:
            return "Something is Wrong"
        }
    }
    
    //returns number of categories in coredata
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let sections = fetchedResultsController.sections {
            
            return sections.count
        }
        return 0
    }
    
    //returns number of items in each category in coredata
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if let sections = fetchedResultsController.sections {
            let currentSection = sections[section]
            
            return currentSection.numberOfObjects
        }
        
        return 0
    }
    
    //creates a cell for each item in each section
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("tableCell") as! cartTableCell
        
        let item = fetchedResultsController.objectAtIndexPath(indexPath) as! Items
        
        cell.increaseButton.tag = indexPath.row
        cell.decreaseButton.tag = indexPath.row
        
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
    
    // sets the title for each section to the current section's name from fetchedResultsController
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let sections = fetchedResultsController.sections {
            let currentSection = sections[section]
            return currentSection.name
        }
        
        return nil
    }
    
    
    //updates the total quantity and price form core data
    func updateTotalQuantityAndPrice() {
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Items")
        
        totalPrice = 0
        totalQuantity = 0
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest) as! [Items]
            for var i = 0; i < results.count; i++ {
                totalPrice = (Double(results[i].price!) * Double(results[i].quantity!)) + totalPrice
                totalQuantity =  totalQuantity + Int(results[i].quantity!)
            }
        } catch {
            print("error")
        }
        
        totalQuantityLabel.text = String(totalQuantity)
        
        
        let formatter = NSNumberFormatter()
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.minimumIntegerDigits = 1
        
        totalPriceLabel.text = "$" + formatter.stringFromNumber(totalPrice)!

    }

}
