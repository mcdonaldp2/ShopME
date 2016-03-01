//
//  cartTableCell.swift
//  ShopME
//
//  Created by Paul McDonald  on 2/28/16.
//  Copyright © 2016 Paul McDonald . All rights reserved.
//

import UIKit
import CoreData



class cartTableCell: UITableViewCell {

    @IBOutlet weak var increaseQuantityButton: quantityButton!
    @IBOutlet weak var decreaseQuantityButton: quantityButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    
    var itemPrice: Double!
    
    
    @IBAction func increaseQuantity(sender: AnyObject) {
        quantityLabel.text = String(Int(quantityLabel.text!)! + 1)
        priceLabel.text = String(itemPrice * Double(quantityLabel.text!)!)
        
        getFetchRequestAndUpdate(titleLabel.text!, price: itemPrice!, category: determineCategory(self.tag), quantity: Int(quantityLabel.text!)!)
        
        
    }
    
    @IBAction func decreaseQuantity(sender: AnyObject) {
        if (Int(quantityLabel.text!) > 0) {
            quantityLabel.text = String(Int(quantityLabel.text!)! - 1)
            priceLabel.text = String(itemPrice * Double(quantityLabel.text!)!)
            
            getFetchRequestAndUpdate(titleLabel.text!, price: Double(priceLabel.text!)!, category: determineCategory(self.tag), quantity: Int(quantityLabel.text!)!)

        } else {
            
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
        case 7:
            return "Appliances"
        case 8:
            return "Toys"
        default:
            return "Something is Wrong"
        }
    }
    
    func getFetchRequestAndUpdate(title : String, price: Double, category: String, quantity: Int) -> NSFetchRequest {
        
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
        
        return fetchRequest
    }
    
    func setItemPrice(price: Double) {
        itemPrice = price
    }
}
class quantityButton: UIButton {
    weak var myTable: UITableView?
    weak var myCell:  cartTableCell?
}
