//
//  CategoryItem.swift
//  ShopME
//
//  Created by Paul McDonald  on 2/25/16.
//  Copyright © 2016 Paul McDonald . All rights reserved.
//

import Foundation


// class used to hold a category's objects
class CategoryItem{
    
    var title:String
    var imageTitle: String
    var description: String
    var price: Double
    

    init(title: String, imageTitle: String, description: String, price: Double) {
        
        self.title = title
        self.imageTitle = imageTitle
        self.description = description
        self.price = price
    
    }
}
