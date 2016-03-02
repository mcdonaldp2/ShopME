//
//  Category.swift
//  ShopME
//
//  Created by Paul McDonald  on 2/25/16.
//  Copyright © 2016 Paul McDonald . All rights reserved.
//

import Foundation


class Category {
    
    var title: String
    var itemArray = [CategoryItem]()
    
    //initializer
    //based on title, sets the itemArray equal to arrays of CategoryItems corresponding to that title
    init(title: String){
        self.title = title
        
        switch title {
            
        case "Grocery":
            self.itemArray = [
                CategoryItem(title:"Tomatoes", imageTitle:"grocery-1-tomatoes", description: "a red vegetable, Yummy!", price: 0.69),
                CategoryItem(title: "Bananas", imageTitle: "grocery-2-bananas", description: "Yellow and delicious", price: 1.00),
                CategoryItem(title: "Gala Apples", imageTitle: "grocery-3-gala", description: "Delicious red apples!", price: 0.80),
                CategoryItem(title: "Lettuce", imageTitle: "grocery-4-lettuce", description: "Green leafy vegetable", price: 1.25),
                CategoryItem(title: "Broccoli", imageTitle: "grocery-5-broccoli", description: "Green bushy vegetable. Tasty.", price: 2.00),
                CategoryItem(title: "Milk", imageTitle: "grocery-6-milk", description: "From a cow", price: 3.50),
                CategoryItem(title: "Bread", imageTitle: "grocery-7-bread", description: "Fluffy golden buns", price: 4.00),
                CategoryItem(title: "Eggs", imageTitle: "grocery-8-eggs", description: "Unborn Chicken Babies", price: 5.00)
                ]
        case "Garden":
            self.itemArray = [
                CategoryItem(title: "Shovel", imageTitle: "garden-1-shovel", description: "dig stuff with it!", price: 35.00),
                CategoryItem(title: "Tomato Plant", imageTitle: "garden-2-tomato-plant", description: "grow Cage free organic Tomatoes with this plant!", price: 5.00),
                CategoryItem(title: "Lawnmower", imageTitle: "garden-3-mower", description: "Cut your grass with this", price: 150.00),
                CategoryItem(title: "Garden Soil", imageTitle: "garden-4-garden-soil", description: "Dirt for your tomato plant", price: 15.00),
                CategoryItem(title: "Fruit Tree", imageTitle: "garden-5-fruit-tree", description: "A tree that grows fruit", price: 23.75),
                CategoryItem(title: "Leaves Rake", imageTitle: "garden-6-leaves-rake", description: "Clear your lawn of those pesky leaves!", price: 44.85)
            ]
        case "Movies":
            self.itemArray = [
            CategoryItem(title: "Shawshank Redemption", imageTitle: "movies-1-shawshank", description: "A movie about prison and Morgan Freeman", price: 18.00),
            CategoryItem(title: "Lord of The Rings", imageTitle: "movies-2-lord-of-the-rings", description: "a movie that is mostly walking", price: 19.00),
            CategoryItem(title: "The Godfather", imageTitle: "movies-3-godfather", description: "Italian Mob Movie", price: 16.00),
            CategoryItem(title: "Talladega Nights", imageTitle: "movies-4-talladega", description: "If you're not first, your last", price: 15.00),
            CategoryItem(title: "Star Wars", imageTitle: "movies-5-star-wars", description: "awesome sci-fi saga", price: 25.00)
            ]
        case "Clothing":
            self.itemArray = [
            CategoryItem(title: "T Shirt", imageTitle: "clothing-1-t-shirt", description: "A very blue shirt", price: 45.00),
            CategoryItem(title: "Dress", imageTitle: "clothing-2-dress", description: "a black dress", price: 400.00),
            CategoryItem(title: "Socks", imageTitle: "clothing-3-socks", description: "black Nike socks", price: 30.00),
            CategoryItem(title: "Jacket", imageTitle: "clothing-4-jacket", description: "a black warm jacket", price: 300.00),
            CategoryItem(title: "Jeans", imageTitle: "clothing-5-jeans", description: "blue jeans", price: 65.00)
            ]
        case "Electronics":
            self.itemArray = [
            CategoryItem(title: "Iphone", imageTitle: "electronics-1-iphone", description: "great touchscreen phone from apple", price: 500.00),
            CategoryItem(title: "Headphones", imageTitle: "electronics-2-headphones", description: "beautiful sounding headphones to listen to music", price: 100.00),
            CategoryItem(title: "Kindle", imageTitle: "electronics-3-kindle", description: "an e-reader to read all of your books", price: 55.00),
            CategoryItem(title: "Ipad", imageTitle: "electronics-4-ipad", description: "essentially an oversized iphone", price: 800.00),
            CategoryItem(title: "Digital Camera", imageTitle: "electronics-5-camera", description: "capture all your best moments", price: 300.00)
            ]
        case "Books":
            self.itemArray = [
            CategoryItem(title: "The Revenant", imageTitle: "books-1-the-revenant", description: "a story of revenge", price: 10.00),
            CategoryItem(title: "2001: a Space Odyssey", imageTitle: "books-2-2001", description: "a story about space travel", price: 15.00),
            CategoryItem(title: "The Martian", imageTitle: "books-3-the-martian", description: "a story of an astronaut stranded on Mars", price: 16.00),
            CategoryItem(title: "The Hobbit", imageTitle: "books-4-the-hobbit", description: "one ring to rule them all", price: 14.00),
            CategoryItem(title: "Dune", imageTitle: "books-5-dune", description: "The spice must flow", price: 30.00)
            ]
        case "Appliances":
            self.itemArray = [
            CategoryItem(title: "Washer", imageTitle: "appliances-1-washer", description: "wash your clothes with this", price: 350),
            CategoryItem(title: "Dryer", imageTitle: "appliances-2-dryer", description: "dry your wet clothes with this", price: 350),
            CategoryItem(title: "Dishwasher", imageTitle: "appliances-3-dishwasher", description: "wash your dishes with this appliance", price: 300),
            CategoryItem(title: "Hot Water Heater", imageTitle: "appliances-4-hot-water-heater", description: "Creates hot water for your house", price: 800),
            CategoryItem(title: "Furnace", imageTitle: "appliances-5-furnace", description: "heat your house with this", price: 5000)
            ]
        case "Toys":
            self.itemArray = [
            CategoryItem(title: "Legos", imageTitle: "toys-1-legos", description: "lego building blocks", price: 2.50),
            CategoryItem(title: "RC Car", imageTitle: "toys-2-rc-car", description: "electronic racing car", price: 30.00),
            CategoryItem(title: "Xbox One", imageTitle: "toys-3-xbox-one", description: "Top line gaming console", price: 350.00),
            CategoryItem(title: "Hot Wheels Car", imageTitle: "toys-4-hot-wheels-car", description: "plastic toy car", price: 3.50),
            CategoryItem(title: "SuperMan Action Figure", imageTitle: "toys-5-superman-action-figure", description: "a plastic superman doll", price: 5.00)
            ]
        default:
            break
            
        }
    }
    
    //returns the Category's item array
    func getItemArray() -> [CategoryItem]{
        return self.itemArray
    }
    
}
