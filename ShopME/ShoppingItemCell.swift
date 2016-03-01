//
//  ShoppingItemCell.swift
//  ShopME
//
//  Created by Paul McDonald  on 2/25/16.
//  Copyright © 2016 Paul McDonald . All rights reserved.
//

import UIKit
import CoreData

class ShoppingItemCell: UITableViewCell {
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemDescription: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    
    @IBAction func addItem(sender: AnyObject) {
        print("added" + itemTitle.text! + "to the cart " + itemPrice.text!)
        
        var priceText = itemPrice.text!
        priceText = priceText.substringWithRange(Range<String.Index>(start: priceText.startIndex.advancedBy(1), end:priceText.endIndex))
        let priceDouble = Double(priceText)
      // print(priceText)
        
        
        
        getFetchRequestAndUpdateOrSave(itemTitle.text!, price: priceDouble!,category:determineCategory(self.tag))
        
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
        case 7:
            return "Appliances"
        case 8:
            return "Toys"
        default:
            return "Something is Wrong"
        }
    }
    
    //fetches data from the core data model, checks if the item to add already exists or not
    // if it exists, it updates the quantity of that item in the cart
    // if it doesn't exist, adds a new item to the entity
    func getFetchRequestAndUpdateOrSave(title : String, price: Double, category: String) -> NSFetchRequest {
        
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Items")
        let predicate = NSPredicate(format: "title == %@", title)
        fetchRequest.predicate = predicate
        
        do {
            let fetchResults = try managedContext.executeFetchRequest(fetchRequest) as? [Items]
            print(fetchResults!.count)
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
        return fetchRequest
    }
    
    
    
}
