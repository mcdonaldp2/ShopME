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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        category = Category(title: categoryStr)
        itemArray = category.getItemArray()
        
        
        navigationItem.title = categoryStr
        
       /* var image = UIImage(named: "cart")
        
        image = image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        
        cartButton.image = image*/
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
