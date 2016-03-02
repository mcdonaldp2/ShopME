//
//  cartTableCell.swift
//  ShopME
//
//  Created by Paul McDonald  on 2/28/16.
//  Copyright © 2016 Paul McDonald . All rights reserved.
//

import UIKit
import CoreData


//custom table cell for the the cartTableView
class cartTableCell: UITableViewCell {

  
    @IBOutlet weak var increaseButton: quantityButton!
    @IBOutlet weak var decreaseButton: quantityButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    
    var itemPrice: Double!
    
    func setItemPrice(price: Double) {
        itemPrice = price
    }
}
class quantityButton: UIButton {
    weak var myCell:  cartTableCell?
}
