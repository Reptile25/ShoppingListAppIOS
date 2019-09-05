//
//  Shopping.swift
//  DBShoppingList
//
//  Created by Milan Petrovic on 6/11/18.
//  Copyright © 2018 Milan Petrovic. All rights reserved.
//

import Foundation
public class Shopping {
    public var item: String
    public var price: Double
    public var type: String
    public var qty: Int
    
    public init() {
        self.item = ""
        self.price = 0
        self.type = ""
        self.qty = 0
    }
    
    public init(item: String, price: Double, type: String, qty: Int) {
        self.item = item
        self.price = price
        self.type = type
        self.qty = qty
    }
    
    public func toString() -> String {
        return "Type: " + self.type + " Price: " + String(format: "%.2f", self.price) + " Qty: " + String(format: "%d", self.qty)
    }
}
