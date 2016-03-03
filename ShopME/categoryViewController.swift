//
//  categoryViewController.swift
//  ShopME
//
//  Created by Paul McDonald  on 2/24/16.
//  Copyright © 2016 Paul McDonald . All rights reserved.
//

import UIKit
import CoreData

class categoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var categoryStr: String = ""
    
    var category: Category!
    var itemArray =  [CategoryItem]()
    
    @IBOutlet weak var itemTableView: UITableView!
    @IBOutlet weak var cartButton: UIBarButtonItem!
    @IBOutlet weak var cartQuantityLabel: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        category = Category(title: categoryStr)
        itemArray = category.getItemArray()
        
        navigationItem.title = categoryStr
        
        var image = UIImage(named: "cart")
        
        image = image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        
        cartButton.image = image
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return itemArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("tableCell") as! ShoppingItemCell
        
        cell.itemImageView.image = UIImage(named: itemArray[indexPath.row].imageTitle)
        cell.itemTitle.text = itemArray[indexPath.row].title
        
        let formatter = NSNumberFormatter()
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.minimumIntegerDigits = 1
        
        cell.itemPrice.text = "$" + formatter.stringFromNumber(itemArray[indexPath.row].price)!
        cell.itemDescription.text = itemArray[indexPath.row].description
        
        switch categoryStr {
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

    
    //handles the button click inside the cell to add the item to the cart
    @IBAction func addItem(sender: AnyObject?) {
        let button = sender as? UIButton
        if let superview = button!.superview {
            if let cell = superview.superview as? ShoppingItemCell {
                var priceText = cell.itemPrice.text!
                priceText = priceText.substringWithRange(Range<String.Index>(start: priceText.startIndex.advancedBy(1), end:priceText.endIndex))
                let priceDouble = Double(priceText)
                
                getFetchRequestAndUpdateOrSave(cell.itemTitle.text!, price: priceDouble!,category:determineCategory(cell.tag))
                cartQuantityLabel.title = String(Int(cartQuantityLabel.title!)! + 1)
            }
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
    
    //fetches data from the core data model, checks if the item to add already exists or not
    // if it exists, it updates the quantity of that item in the cart
    // if it doesn't exist, adds a new item to the entity
    func getFetchRequestAndUpdateOrSave(title : String, price: Double, category: String)  {
        
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Items")
        let predicate = NSPredicate(format: "title == %@", title)
        fetchRequest.predicate = predicate
        
        do {
            let fetchResults = try managedContext.executeFetchRequest(fetchRequest) as? [Items]

            // if the item already exists in the cart, add 1 to the quantity
            if fetchResults!.count > 0 {
                // update quantity of item in the cart
                let itemToChange = fetchResults![0]
                itemToChange.quantity = Int(itemToChange.quantity!) + 1
                
                try managedContext.save()
                
            } // else add a new item to the entity Items
            else {
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
    
    
    //fetches the objects in the entity Items, and finds the sum of every objects quantity, used in viewWillAppear
    func determineCartQuantity(){
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Items")
        
        do {
        let results = try managedContext.executeFetchRequest(fetchRequest) as! [Items]
            for var i = 0; i < results.count; i++ {
                cartQuantityLabel.title = String(Int(results[i].quantity!) + Int(cartQuantityLabel.title!)!)
            }
        } catch {
            print("error")
        }
        
    }
    
    //used to set the cartQuantitylabel to the total quantity of the cart every time the view appears
    override func viewWillAppear(animated: Bool) {
        cartQuantityLabel.title = "0"
        determineCartQuantity()
    }

}
