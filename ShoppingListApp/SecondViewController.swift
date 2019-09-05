//
//  SecondViewController.swift
//  ShoppingListApp
//
//  Created by Milan Petrovic on 17/10/18.
//  Copyright © 2018 Milan Petrovic. All rights reserved.
//

import UIKit
import SQLite3

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.shoppingArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath)
        
        let shopping: Shopping = appDelegate.shoppingArray[indexPath.row]
        cell.textLabel!.text = shopping.item
        cell.detailTextLabel!.text = shopping.toString()
        return cell

    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCell.EditingStyle.delete)
        {
            let selectedItem: Shopping = appDelegate.shoppingArray[indexPath.row]
            let itemName: String = selectedItem.item
            deleteQuery(itemName: itemName)
            
            appDelegate.shoppingArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    

    @IBOutlet weak var shoppingTableView: UITableView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var db: OpaquePointer? = nil
    
    
    
    func selectQuery() {
        let selectQueryStatement = "SELECT * FROM shoppinglist"
        var queryStatement: OpaquePointer? = nil
        if(sqlite3_prepare_v2(db, selectQueryStatement, -1, &queryStatement, nil) == SQLITE_OK){
            print("Query Result: ")
            while (sqlite3_step(queryStatement) == SQLITE_ROW) {
                let shoppingId = sqlite3_column_int(queryStatement, 0)
                let itemField = sqlite3_column_text(queryStatement, 1)
                let itemName = String(cString: itemField!)
                let itemPrice = Double(sqlite3_column_double(queryStatement, 2))
                let typeField = sqlite3_column_text(queryStatement, 3)
                let itemType = String(cString: typeField!)
                let itemQty = Int(sqlite3_column_int(queryStatement, 4))
                
                print("\(shoppingId) | \(itemName)")
                let s = Shopping(item: itemName, price: itemPrice, type: itemType, qty: itemQty)
                appDelegate.shoppingArray.append(s)
            }
            
        }
        else
        {
            print("SELECT Statement could not be prepared", terminator: "")
        }
        sqlite3_close(db)
        sqlite3_finalize(queryStatement)
    }
    
    func deleteQuery(itemName: String) {
        let deleteSQL = "DELETE FROM shoppingList WHERE itemName = ('\(itemName)')"
        print(deleteSQL)
        var queryStatement: OpaquePointer? = nil
        if (sqlite3_open(appDelegate.getDBPath(), &db) == SQLITE_OK){
            print("Successfully opened connection to database ", terminator: "")
        
        if(sqlite3_prepare_v2(db, deleteSQL, -1, &queryStatement, nil) == SQLITE_OK)
        {
            if (sqlite3_step(queryStatement) == SQLITE_DONE) {
                print("Record Deleted!")
            }
            else {
                print("Fail to Delete")
            }
            sqlite3_finalize(queryStatement)
        }
    }
        else {
            print("DELETE Statement could not be prepared", terminator: "")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if sqlite3_open(appDelegate.getDBPath(), &db) == SQLITE_OK{
            print("Successfully opened connection to database ")
            selectQuery()
            
        }
        else {
            print("Unable to open Database")
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        shoppingTableView.reloadData()
        self.view.backgroundColor = Colour.sharedInstance.selectedColour
    }


}

