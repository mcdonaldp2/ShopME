//
//  ViewController.swift
//  ShopME
//
//  Created by Paul McDonald  on 2/23/16.
//  Copyright © 2016 Paul McDonald . All rights reserved.
//

import UIKit
import CoreData
class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var titleArray = [String]()
    var imageArray = [UIImage]()
    var categoryToPass:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageArray = [UIImage(named: "category-1-recent")!, UIImage(named: "category-2-cart")!, UIImage(named: "category-3-grocery")!, UIImage(named: "category-4-clothing")!, UIImage(named: "category-5-movies")!, UIImage(named: "category-6-garden")!, UIImage(named: "category-7-electronics")!, UIImage(named: "category-8-books")!, UIImage(named: "category-9-appliances")!, UIImage(named: "category-10-toys")!]
        
        titleArray = ["Recent Orders", "Cart", "Grocery", "Clothing", "Movies", "Garden", "Electronics", "Books", "Appliances", "Toys"]
       
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "ShopME", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)

        // Do any additional setup after loading the view, typically from a nib.
       
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    // 2
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: CategoryCell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CategoryCell
        cell.label.text = titleArray[indexPath.row]
        cell.imageView.image = imageArray[indexPath.row]
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
       
        if (segue.identifier == "toCategoryPageSegue") {
       
            if let svc = segue.destinationViewController as? categoryViewController{

            svc.categoryStr = categoryToPass
            }
        }
        
        
        
        
    }
    // 3
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let selection = indexPath.row
        
        
        switch selection {
        case 0:
            print("go to recent items")
        case 1:
            //print("go to the cart")
            performSegueWithIdentifier("toCartSegue", sender: nil)
        case 2:
            categoryToPass = "Grocery"
            performSegueWithIdentifier("toCategoryPageSegue", sender: nil)
        case 3:
            categoryToPass = "Clothing"
            performSegueWithIdentifier("toCategoryPageSegue", sender: nil)
        case 4:
            categoryToPass = "Movies"
            performSegueWithIdentifier("toCategoryPageSegue", sender: nil)
        case 5:
            categoryToPass = "Garden"
            performSegueWithIdentifier("toCategoryPageSegue", sender: nil)
        case 6:
            categoryToPass = "Electronics"
            performSegueWithIdentifier("toCategoryPageSegue", sender: nil)
        case 7:
            categoryToPass = "Books"
            performSegueWithIdentifier("toCategoryPageSegue", sender: nil)
        case 8:
            categoryToPass = "Appliances"
            performSegueWithIdentifier("toCategoryPageSegue", sender: nil)
        case 9:
            categoryToPass = "Toys"
            performSegueWithIdentifier("toCategoryPageSegue", sender: nil)

        default:
            break
            
        }
    }
    
}

