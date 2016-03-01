//
//  Items+CoreDataProperties.swift
//  ShopME
//
//  Created by Paul McDonald  on 2/29/16.
//  Copyright © 2016 Paul McDonald . All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Items {

    @NSManaged var title: String?
    @NSManaged var category: String?
    @NSManaged var price: NSNumber?
    @NSManaged var quantity: NSNumber?

}
